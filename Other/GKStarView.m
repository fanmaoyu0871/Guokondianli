//
//  GKStarView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/30.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKStarView.h"

@interface GKStarView()
@property (nonatomic, strong)NSMutableArray *btnArray;
@property (nonatomic, strong)UILabel *leftLabel;
@end

@implementation GKStarView

-(NSMutableArray *)btnArray{
    if(_btnArray == nil){
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame type:(NSString*)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.leftLabel = [UILabel labelWithTitle:[type integerValue]==1?@"我的评分":@"点击评分" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:self.leftLabel];
        self.leftLabel.fm_left = 20;
        self.leftLabel.fm_centerY = frame.size.height / 2;
        
        CGFloat btnW = 40.0f;
        for(NSInteger i = 0; i < 5; i++){
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = CGRectMake(self.leftLabel.fm_right + 20 + i*btnW, 0, btnW, btnW);
            btn.fm_centerY = frame.size.height / 2;
            [btn setImage:[UIImage imageNamed:@"no-star"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateSelected];
            [self addSubview:btn];
            
            [self.btnArray addObject:btn];
        }
    }
    return self;
}

-(void)starAtIndex:(NSInteger)index type:(NSString*)type{
    for(NSInteger i = 0; i < self.btnArray.count; i++){
        UIButton *btn = self.btnArray[i];
        if(i < index){
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
        
        if([type integerValue] == 1){
            btn.userInteractionEnabled = NO;
        }else{
            btn.userInteractionEnabled = YES;
        }
    }
}

@end
