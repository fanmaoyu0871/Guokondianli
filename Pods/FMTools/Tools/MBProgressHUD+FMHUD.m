//
//  MBProgressHUD+FMHUD.m
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/31.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "MBProgressHUD+FMHUD.h"

@implementation MBProgressHUD (FMHUD)

+(instancetype)showLoadingTo:(UIView*)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    return hud;
}

+(instancetype)showLoadingText:(NSString*)text detailText:(NSString*)detailText to:(UIView*)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    return hud;
}

+(instancetype)showLoadingText:(NSString*)text to:(UIView*)view{
    MBProgressHUD *hud = [self showLoadingText:text detailText:nil to:view];
    return hud;
}

+(instancetype)showCustomeView:(UIView*)customView text:(NSString*)text to:(UIView*)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = view;
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = text;
    
    [hud hideAnimated:YES afterDelay:3.0f];

    return hud;
}

+(instancetype)showText:(NSString*)text to:(UIView*)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
//    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:3.0f];

    return hud;
}

+(instancetype)showLoadingText:(NSString*)text buttonTitle:(NSString*)btnTtitle target:(NSObject*)target selector:(SEL)selector to:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = text;
    
    // Configure the button.
    [hud.button setTitle:btnTtitle forState:UIControlStateNormal];
    [hud.button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return hud;
}

+(void)showSystemIndicator:(BOOL)isShow
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = isShow;
}

@end
