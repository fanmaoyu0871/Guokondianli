//
//  YLBPicker.m
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/23.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "YLBPicker.h"

#define AnimateY 250.0f

@interface  YLBPicker()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, copy)CompletionBlock leftBlock;
@property (nonatomic, copy)CompletionBlock rightBlock;
@property (nonatomic, copy)NSString *leftTitle;
@property (nonatomic, copy)NSString *rightTitle;

@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, strong)UIView *realView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end


@implementation YLBPicker

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        self.realView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, AnimateY)];
        [self addSubview:self.realView];
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44.0f)];
        topView.backgroundColor = [UIColor whiteColor];
        [self.realView addSubview:topView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, topView.fm_bottom - 1.0f, topView.fm_width, 1.0f)];
        line.backgroundColor = [UIColor colorWithHex:TableBackground_Color];
        [topView addSubview:line];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.leftBtn setTitleColor:[UIColor colorWithHex:NormalText_Color] forState:UIControlStateNormal];
        self.leftBtn.frame = CGRectMake(0, 0, 60, topView.fm_height);
        [topView addSubview:self.leftBtn];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.rightBtn setTitleColor:[UIColor colorWithHex:MainTheme_Color] forState:UIControlStateNormal];
        self.rightBtn.frame = CGRectMake(topView.fm_width - 60, 0, 60, topView.fm_height);
        [topView addSubview:self.rightBtn];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, topView.fm_bottom, frame.size.width, AnimateY - 44.0f)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.realView addSubview:self.pickerView];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArray[row];
}

-(void)setLeftTitle:(NSString *)leftTitle{
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
}

-(void)setRightTitle:(NSString *)rightTitle{
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

-(void)leftBtnAction{
    [UIView animateWithDuration:0.3f animations:^{
        self.realView.fm_y += AnimateY;
    } completion:^(BOOL finished) {
        if(self.leftBlock){
            NSInteger row = [self.pickerView selectedRowInComponent:0];
            self.leftBlock(row);
        }
        [self removeFromSuperview];
    }];
}

-(void)rightBtnAction{
    [UIView animateWithDuration:0.3f animations:^{
        self.realView.fm_y += AnimateY;
    } completion:^(BOOL finished) {
        if(self.rightBlock){
            NSInteger row = [self.pickerView selectedRowInComponent:0];
            self.rightBlock(row);
        }
        [self removeFromSuperview];
    }];
}

-(void)show{
    
    [self.pickerView reloadAllComponents];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.realView.fm_y -= AnimateY;
    }];
}

+(void)showData:(NSArray*)data leftTitle:(NSString*)leftTitle leftAction:(CompletionBlock)leftBlock rightTitle:(NSString*)rightTitle rightAction:(CompletionBlock)rightBlock {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    YLBPicker *picker = [[self alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    picker.dataArray = [data mutableCopy];
    picker.leftTitle = leftTitle;
    picker.rightTitle = rightTitle;
    picker.leftBlock = leftBlock;
    picker.rightBlock = rightBlock;
    [window addSubview:picker];
    
    [picker show];
}

@end
