//
//  UILabel+Tools.m
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/18.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "UILabel+Tools.h"

@implementation UILabel (Tools)
+ (UILabel *)labelWithTitle:(NSString*)title fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor textWeight:(UIFontWeight)weight{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:fontSize weight:weight];
    label.textColor = textColor;
    label.text = title;
    [label sizeToFit];
    return label;
}
@end
