//
//  GKHomeBottomView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/24.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKHomeBottomView.h"
#import "GKIntroView.h"
#import "GKAddressView.h"
#import "GKStatusView.h"

@implementation GKHomeBottomView
{
    GKIntroView *_introView;
    GKAddressView *_addressView;
    GKAddressView *_payView;
    GKStatusView *_statusView;
    
    void (^_leftBlock)(void);
    void (^_rightBlock)(void);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _introView = [[GKIntroView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 120)];
        [self addSubview:_introView];
        
        _addressView = [[GKAddressView alloc]initWithFrame:CGRectMake(0, _introView.fm_bottom, frame.size.width, 44)];
        [self addSubview:_addressView];
        
        _payView = [[GKAddressView alloc]initWithFrame:CGRectMake(0, _addressView.fm_bottom, frame.size.width, 44)];
        
        [self addSubview:_payView];
        
        _statusView = [[GKStatusView alloc]initWithFrame:CGRectMake(0, _payView.fm_bottom, frame.size.width, 44)];
        [self addSubview:_statusView];
        
        UIView *buttonView = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(MainTheme_Color)];
        buttonView.fm_size = CGSizeMake(frame.size.width, 49);
        buttonView.fm_leftBottom = CGPointMake(0, frame.size.height);
        [self addSubview:buttonView];
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:14 titleColor:[UIColor whiteColor] title:@"详情"];
        detailBtn.frame = CGRectMake(0, 0, buttonView.fm_width / 2, buttonView.fm_height);
        [detailBtn addTarget:self action:@selector(detailBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:detailBtn];
        
        UIView *line = [[UIView alloc]initWithBackgroundColor:[UIColor whiteColor]];
        line.fm_size = CGSizeMake(0.5f, 20);
        line.center = CGPointMake(detailBtn.fm_right, buttonView.fm_height / 2);
        [buttonView addSubview:line];
        
        UIButton *gpsBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:14 titleColor:[UIColor whiteColor] title:@"导航"];
        gpsBtn.frame = CGRectMake(buttonView.fm_width / 2 + 1, 0, buttonView.fm_width / 2, buttonView.fm_height);
        [gpsBtn addTarget:self action:@selector(gpsBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:gpsBtn];
    }
    return self;
}

-(void)configUI:(GKStateModel*)model leftBlock:(void (^)(void))leftBlock rightBlock:(void (^)(void))rightBlock {
    [_introView configUI:model rightBlock:nil];
    [_addressView configImage:[UIImage imageNamed:@"address_icon"] title:model.station_address];
//    [_payView configImage:[UIImage imageNamed:@"purse_icon"] title:model.pay_type];
    [_payView configImage:[UIImage imageNamed:@"purse_icon"] title:@"支付宝、账户余额、微信支付"];

    [_statusView configUI:model];
    
    _leftBlock = leftBlock;
    _rightBlock = rightBlock;
}

//详情按钮事件
-(void)detailBtnAction{
    if(_leftBlock){
        _leftBlock();
    }
}

//导航按钮事件
-(void)gpsBtnAction{
    if(_rightBlock){
        _rightBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
