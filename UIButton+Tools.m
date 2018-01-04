//
//  UIButton+Tools.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/15.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "UIButton+Tools.h"

@implementation UIButton (Tools)

+(instancetype)buttonWithType:(UIButtonType)buttonType image:(UIImage*)image fontSize:(CGFloat)fontSize titleColor:(UIColor*)color title:(NSString*)title  {
    UIButton *btn = [UIButton buttonWithType:buttonType];
    
    if(title){
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    
    if(image){
        [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    if(color){
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    
    [btn sizeToFit];
    return btn;
}

@end
