//
//  FMDropToast.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMDropToast : UIView
+(instancetype)showText:(NSString*)text atView:(UIView*)view;
+(instancetype)showText:(NSString*)text atView:(UIView*)view offset:(CGPoint)point;
@end
