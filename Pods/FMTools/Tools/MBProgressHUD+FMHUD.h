//
//  MBProgressHUD+FMHUD.h
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/31.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (FMHUD)
+(instancetype)showLoadingTo:(UIView*)view;

+(instancetype)showLoadingText:(NSString*)text detailText:(NSString*)detailText to:(UIView*)view;

+(instancetype)showLoadingText:(NSString*)text to:(UIView*)view;

+(instancetype)showCustomeView:(UIView*)customView text:(NSString*)text to:(UIView*)view;

+(instancetype)showText:(NSString*)text to:(UIView*)view;

+(instancetype)showLoadingText:(NSString*)text buttonTitle:(NSString*)btnTtitle target:(NSObject*)target selector:(SEL)selector to:(UIView *)view;

+(void)showSystemIndicator:(BOOL)isShow;

@end
