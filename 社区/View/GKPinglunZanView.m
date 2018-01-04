//
//  GKPinglunZanView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPinglunZanView.h"

@interface GKPinglunZanView()
{
    void (^_zanBlock)(void);
    void (^_pinglunBlock)(void);
}
@property (nonatomic, strong)UIButton *zanBtn;
@property (nonatomic, strong)UIButton *pinglunBtn;

@property (nonatomic, strong)UIView *line;
@end

@implementation GKPinglunZanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.zanBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"zan"] fontSize:12 titleColor:HEXCOLOR(0x2E5A9A) title:@"赞"];
        self.zanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        self.zanBtn.fm_size = CGSizeMake(50, 30);
        [self addSubview:self.zanBtn];
        [self.zanBtn addTarget:self action:@selector(zanBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.pinglunBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"pinglun"] fontSize:12 titleColor:HEXCOLOR(0x2E5A9A) title:@"评论"];
        self.pinglunBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
        self.pinglunBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 2, 0);
        self.pinglunBtn.fm_size = CGSizeMake(50, 30);
        [self addSubview:self.pinglunBtn];
        [self.pinglunBtn addTarget:self action:@selector(pinglunBtnAction) forControlEvents:UIControlEventTouchUpInside];

        
        self.line = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        [self addSubview:self.line];
    }
    return self;
}

-(void)zanBtnAction{
    if(_zanBlock){
        _zanBlock();
    }
}

-(void)pinglunBtnAction{
    if(_pinglunBlock){
        _pinglunBlock();
    }
}

-(void)configUI:(GKDynamicModel *)model zanBlock:(void (^)(void))zanBlock pinglunBlock:(void (^)(void))pinglunBlock{
    
    _zanBlock = zanBlock;
    _pinglunBlock = pinglunBlock;
    
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld", [model.nums_zan integerValue]] forState:UIControlStateNormal];
    [self.pinglunBtn setTitle:[NSString stringWithFormat:@"%ld", [model.nums_sub integerValue]] forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    self.pinglunBtn.fm_right = self.fm_width - 10;
    self.pinglunBtn.fm_top = 10;
    
    self.zanBtn.fm_right = self.pinglunBtn.fm_left - 1;
    self.zanBtn.fm_centerY = self.pinglunBtn.fm_centerY;
    
    self.line.fm_left = 60;
    self.line.fm_top = self.zanBtn.fm_bottom;
    self.line.fm_size = CGSizeMake(self.fm_width - self.line.fm_left, 1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
