//
//  UIView+Tools.h
//  JeeSea
//
//  Created by 范茂羽 on 15/8/27.
//  Copyright (c) 2015年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)

@property (nonatomic, assign)CGFloat fm_x;
@property (nonatomic, assign)CGFloat fm_y;
@property (nonatomic, assign)CGFloat fm_width;
@property (nonatomic, assign)CGFloat fm_height;
@property (nonatomic, assign)CGFloat fm_centerX;
@property (nonatomic, assign)CGFloat fm_centerY;

@property (nonatomic, assign) CGPoint   fm_origin;
@property (nonatomic, assign) CGSize    fm_size;
@property (nonatomic, assign) CGFloat   fm_bottom;
@property (nonatomic, assign) CGFloat   fm_right;
@property (nonatomic) CGFloat fm_left;
@property (nonatomic) CGFloat fm_top;
@property (nonatomic) CGPoint fm_leftTop;
@property (nonatomic) CGPoint fm_leftBottom;
@property (nonatomic) CGPoint fm_rightTop;
@property (nonatomic) CGPoint fm_rightBottom;
@property (nonatomic, readonly) CGPoint fm_boundsCenter;
@property (nonatomic) CGPoint fm_topCenter;
@property (nonatomic) CGPoint fm_bottomCenter;
@property (nonatomic) CGPoint fm_leftCenter;
@property (nonatomic) CGPoint fm_rightCenter;

- (id)initWithBackgroundColor:(UIColor *)color;

//找到视图对应的控制器
-(UIViewController*)viewController;

@end
