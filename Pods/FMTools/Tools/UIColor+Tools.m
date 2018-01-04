//
//  UIColor+Tools.m
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/18.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "UIColor+Tools.h"

@implementation UIColor (Tools)

+(UIColor*)colorWithHex:(NSInteger)hex{
    return [UIColor colorWithRed:(CGFloat)(((hex&0xFF0000)>>16) /255.0) green:(CGFloat)(((hex&0x00FF00)>>8) /255.0) blue:(CGFloat)((hex&0x0000FF) /255.0) alpha:1.0];
}

@end
