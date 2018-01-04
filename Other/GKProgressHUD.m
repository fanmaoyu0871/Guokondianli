//
//  GKProgressHUD.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/23.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKProgressHUD.h"

@implementation GKProgressHUD

+(instancetype)showAtView:(UIView*)view{
    GKProgressHUD *bgView = [[GKProgressHUD alloc]initWithFrame:view.bounds];
    bgView.opaque = NO;
    bgView.backgroundColor = [UIColor clearColor];
    [view addSubview:bgView];
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [bgView addSubview:logo];
    logo.center = bgView.fm_boundsCenter;
    
    UIImageView *rotate = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rotate"]];
    rotate.contentMode = UIViewContentModeScaleAspectFit;
    rotate.fm_size = CGSizeMake(25, 25);
    [bgView addSubview:rotate];
    rotate.center = bgView.fm_boundsCenter;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.fromValue = @(0);
    anim.toValue = @(M_PI*2);
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.4f;
    anim.fillMode = kCAFillModeForwards;
    [rotate.layer addAnimation:anim forKey:@"rotate"];
    
    return bgView;
}

-(void)hideHUD{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
