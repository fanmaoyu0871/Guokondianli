//
//  UIButton+Tools.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/15.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Tools)
+(instancetype)buttonWithType:(UIButtonType)buttonType image:(UIImage*)image fontSize:(CGFloat)fontSize titleColor:(UIColor*)color title:(NSString*)title;
@end
