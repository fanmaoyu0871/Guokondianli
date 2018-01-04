//
//  GKFilterView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/21.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKFilterView.h"
#import "GKFlowView.h"

@interface GKFilterView()
{
    NSArray *_titles;
    NSArray *_filterArray;
    CGFloat _totalY;
}

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)NSMutableDictionary *filterDict;
@end

@implementation GKFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.4f];
        
        _titles = @[@"充电接口类型", @"电站类型", @"充电方式", @"停车费用（元）"];
        _filterArray = @[@[@"新国标2017"], @[@"个人", @"公共"], @[@"快充", @"慢充"], @[@"免费", @"0-10", @"10以上"]];
        _filterDict = [NSMutableDictionary dictionaryWithDictionary:@{ @"only_show_free": @"0",   @"interface_type": @"0" ,@"station_type": @"0",               @"charging_method": @"0" ,@"parking_free": @"0"}];
        
        self.bgView = [[UIView alloc]initWithBackgroundColor:[UIColor whiteColor]];
        self.bgView.fm_width = frame.size.width;
        self.fm_leftTop = CGPointMake(0, 0);
        [self addSubview:self.bgView];
        
        
        UIView *switchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bgView.fm_width, 80)];
        [self.bgView addSubview:switchView];
        
        UIView *borderView = [[UIView alloc]init];
        borderView.layer.borderWidth = 1;
        borderView.layer.borderColor = HEXCOLOR(TableBackground_Color).CGColor;
        borderView.layer.cornerRadius = 5;
        borderView.fm_size = CGSizeMake(switchView.fm_width - 40, 40);
        borderView.center = switchView.fm_boundsCenter;
        [switchView addSubview:borderView];
        
        UILabel *label = [UILabel labelWithTitle:@"仅显示空闲站点" fontSize:14.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        [borderView addSubview:label];
        label.fm_left = 20;
        label.fm_centerY = borderView.fm_boundsCenter.y;
        
        UISwitch *switcher = [[UISwitch alloc]init];
        [switcher addTarget:self action:@selector(switcherValueChanged:) forControlEvents:UIControlEventValueChanged];
        [borderView addSubview:switcher];
        [switcher sizeToFit];
        switcher.fm_right = borderView.fm_width - 20;
        switcher.fm_centerY = borderView.fm_boundsCenter.y;
        
        WEAKSELf
        _totalY = borderView.fm_bottom;
        for(NSInteger i = 0; i < _titles.count; i++){
            UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, _totalY, frame.size.width, 30)];
            [self.bgView addSubview:titleView];
            UILabel *label = [UILabel labelWithTitle:_titles[i] fontSize:16.0f textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
            [titleView addSubview:label];
            label.fm_left = 10;
            label.fm_centerY = titleView.fm_boundsCenter.y;
            
            _totalY += 30;
            
            GKFlowView *flowView = [[GKFlowView alloc]initWithFrame:CGRectMake(0, _totalY, frame.size.width, 0) data:_filterArray[i] rowCount:3 itemSize:CGSizeMake(100, 30) lineSpace:10 block:^(NSInteger index, UIButton *btn) {
                [weakSelf addFilterByTitle:btn.currentTitle isCanceled:btn.isSelected?NO:YES];
            }];
            flowView.normalTitleColor = HEXCOLOR(MainTheme_Color);
            flowView.selectedTitleColor = HEXCOLOR(0xffffff);
            flowView.selectedBgColor = HEXCOLOR(MainTheme_Color);
            flowView.normalBgColor = HEXCOLOR(0xffffff);
            flowView.selectedBorderColor = HEXCOLOR(MainTheme_Color);
            flowView.normalBorderColor = HEXCOLOR(MainTheme_Color);
            [self.bgView addSubview:flowView];
            
            _totalY += flowView.fm_height;
        }
        
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, _totalY, self.bgView.fm_width, 80)];
        [self.bgView addSubview:btnView];
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16 titleColor:[UIColor whiteColor] title:@"完成"];
        [btnView addSubview:finishBtn];
        finishBtn.fm_size = CGSizeMake(180, 40);
        finishBtn.center = btnView.fm_boundsCenter;
        [finishBtn addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
        finishBtn.backgroundColor = HEXCOLOR(MainTheme_Color);
        finishBtn.layer.cornerRadius = 2;
        
        _totalY += 80;
    }
    return self;
}

-(void)switcherValueChanged:(UISwitch*)switcher{
    [self.filterDict setObject:switcher.isOn?@"1":@"0" forKey:@"only_show_free"];
}

-(void)addFilterByTitle:(NSString*)title isCanceled:(BOOL)isCanceled{
    WEAKSELf
    [_filterArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        NSArray *array = obj;
        if([array containsObject:title]){
            NSInteger i = [array indexOfObject:title];

            if(index == 0){
                [weakSelf.filterDict setObject:isCanceled?@"0":[NSString stringWithFormat:@"%ld", i+1] forKey:@"interface_type"];
            }else if (index == 1){
                [weakSelf.filterDict setObject:isCanceled?@"0":[NSString stringWithFormat:@"%ld", i+1] forKey:@"station_type"];
            }else if (index == 2){
                [weakSelf.filterDict setObject:isCanceled?@"0":[NSString stringWithFormat:@"%ld", i+1] forKey:@"charging_method"];
            }else if (index == 3){
                [weakSelf.filterDict setObject:isCanceled?@"0":[NSString stringWithFormat:@"%ld", i+1] forKey:@"parking_free"];
            }
        }
    }];
}

-(void)finishBtnAction{
    self.hidden = YES;
    
    if(self.finishBlock){
        self.finishBlock(self.filterDict);
    }
}

-(void)showAtY:(CGFloat)y toView:(UIView*)view{
    self.fm_top = y;
    [view addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.bgView.fm_height = _totalY;
    } completion:^(BOOL finished) {
        
    }];
}

@end
