//
//  UIView+Tools.m
//  JeeSea
//
//  Created by 范茂羽 on 15/8/27.
//  Copyright (c) 2015年 范茂羽. All rights reserved.
//

#import "UIView+Tools.h"

@implementation UIView (Tools)


-(void)setFm_x:(CGFloat)fm_x
{
    CGRect frame = self.frame;
    frame.origin.x = fm_x;
    self.frame = frame;
}

-(CGFloat)fm_x
{
    return self.frame.origin.x;
}

-(void)setFm_y:(CGFloat)fm_y
{
    CGRect frame = self.frame;
    frame.origin.y = fm_y;
    self.frame = frame;
}

-(CGFloat)fm_y
{
    return self.frame.origin.y;
}

-(void)setFm_width:(CGFloat)fm_width
{
    CGRect frame = self.frame;
    frame.size.width = fm_width;
    self.frame = frame;
}

-(CGFloat)fm_width
{
    return self.frame.size.width;
}

-(void)setFm_height:(CGFloat)fm_height
{
    CGRect frame = self.frame;
    frame.size.height = fm_height;
    self.frame = frame;
}

-(CGFloat)fm_height
{
    return self.frame.size.height;
}

-(void)setFm_centerX:(CGFloat)fm_centerX
{
    CGPoint center =self.center;
    center.x = fm_centerX;
    self.center = center;
}

-(CGFloat)fm_centerX
{
    return self.center.x;
}

-(void)setFm_centerY:(CGFloat)fm_centerY
{
    CGPoint center = self.center;
    center.y = fm_centerY;
    self.center = center;
}

-(CGFloat)fm_centerY
{
    return self.center.y;
}

-(void)setFm_origin:(CGPoint)fm_origin
{
    self.fm_x          = fm_origin.x;
    self.fm_y          = fm_origin.y;
}

-(void)setFm_size:(CGSize)fm_size
{
    self.fm_width      = fm_size.width;
    self.fm_height     = fm_size.height;
}

-(void)setFm_right:(CGFloat)fm_right
{
    CGRect frame = self.frame;
    frame.origin.x = fm_right - frame.size.width;
    self.frame = frame;
}

-(void)setFm_bottom:(CGFloat)fm_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = fm_bottom - frame.size.height;
    self.frame = frame;
}

-(CGPoint)fm_origin
{
    return CGPointMake(self.fm_x, self.fm_y);
}

-(CGSize)fm_size
{
    return CGSizeMake(self.fm_width, self.fm_height);
}

-(CGFloat)fm_right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)fm_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)fm_left {
    return self.frame.origin.x;
}

-(void)setFm_left:(CGFloat)fm_left
{
    self.frame = CGRectMake(fm_left, self.fm_top, self.fm_width, self.fm_height);
}

- (CGFloat)fm_top {
    return self.frame.origin.y;
}

-(void)setFm_top:(CGFloat)fm_top
{
    self.frame = CGRectMake(self.fm_left, fm_top, self.fm_width, self.fm_height);
}

- (CGPoint)fm_leftTop {
    return CGPointMake(self.fm_left, self.fm_top);
}

-(void)setFm_leftTop:(CGPoint)fm_leftTop
{
    self.fm_left = fm_leftTop.x;
    self.fm_top = fm_leftTop.y;
}


-(CGPoint)fm_leftBottom
{
    return CGPointMake(self.fm_left, self.fm_bottom);
}

-(void)setFm_leftBottom:(CGPoint)fm_leftBottom
{
    self.fm_left = fm_leftBottom.x;
    self.fm_bottom = fm_leftBottom.y;
}

- (CGPoint)fm_rightTop {
    return CGPointMake(self.fm_right, self.fm_top);
}

-(void)setFm_rightTop:(CGPoint)fm_rightTop
{
    self.fm_right = fm_rightTop.x;
    self.fm_top = fm_rightTop.y;
}

- (CGPoint)fm_rightBottom {
    return CGPointMake(self.fm_right, self.fm_bottom);
}

-(void)setFm_rightBottom:(CGPoint)fm_rightBottom
{
    self.fm_right = fm_rightBottom.x;
    self.fm_bottom = fm_rightBottom.y;
}

- (CGPoint)fm_boundsCenter {
    return CGPointMake(self.fm_width / 2, self.fm_height / 2);
}

- (CGPoint)fm_topCenter {
    return CGPointMake(self.fm_centerX, self.fm_top);
}

-(void)setFm_topCenter:(CGPoint)fm_topCenter
{
    self.fm_left = fm_topCenter.x - self.fm_width / 2;
    self.fm_top = fm_topCenter.y;
}

- (CGPoint)fm_bottomCenter {
    return CGPointMake(self.fm_centerX, self.fm_bottom);
}

-(void)setFm_bottomCenter:(CGPoint)fm_bottomCenter
{
    self.fm_left = fm_bottomCenter.x - self.fm_width / 2;
    self.fm_bottom = fm_bottomCenter.y;
}

- (CGPoint)fm_leftCenter {
    return CGPointMake(self.fm_left, self.fm_centerY);
}

-(void)setFm_leftCenter:(CGPoint)fm_leftCenter
{
    self.fm_left = fm_leftCenter.x;
    self.fm_top = fm_leftCenter.y - self.fm_height / 2;
}

- (CGPoint)fm_rightCenter {
    return CGPointMake(self.fm_right, self.fm_centerY);
}

-(void)setFm_rightCenter:(CGPoint)fm_rightCenter
{
    self.fm_right = fm_rightCenter.x;
    self.fm_top = fm_rightCenter.y - self.fm_height / 2;
}

- (id)initWithBackgroundColor:(UIColor *)color {
    self = [self init];
    if (self) {
        self.backgroundColor = color;
    }
    return self;
}

-(UIViewController*)viewController
{
    for(UIView *next = self.superview; next; next = next.superview)
    {
        UIResponder *responder = [next nextResponder];
        if([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)responder;
        }
    }
    
    return nil;
}



@end
