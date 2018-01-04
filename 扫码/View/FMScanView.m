//
//  FMScanView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/12/25.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "FMScanView.h"

@implementation FMScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.48];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGRect cropRect = CGRectMake(0.12 * ScreenWidth, (ScreenHeight - 0.76*ScreenWidth) / 2, 0.76 * ScreenWidth, 0.76 * ScreenWidth);
    
    [self addClearRect:cropRect];
    [self addFourBorder:cropRect];
}

- (void)addClearRect:(CGRect)mainRect {
    CGFloat mainRectWidth = mainRect.size.width;
    CGFloat mainRectHeight = mainRect.size.height;
    [[UIColor colorWithWhite:0 alpha:0.1] setFill];
    UIRectFill(mainRect);
    CGRect clearRect = CGRectMake(mainRectWidth/6, mainRectHeight/2 - 2*mainRectWidth/3, 2*mainRectWidth/3, 2*mainRectWidth/3);
    CGRect clearIntersection = CGRectIntersection(clearRect, mainRect);
    [[UIColor clearColor] setFill];
    UIRectFill(clearIntersection);
}

- (void)addFourBorder:(CGRect)mainRect {
    CGFloat mainRectWidth = mainRect.size.width;
    CGFloat mainRectHeight = mainRect.size.height;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHex:MainTheme_Color].CGColor);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGPoint upLeftPoints[] = {CGPointMake(mainRect.origin.x, mainRect.origin.y), CGPointMake(mainRect.origin.x + 20, mainRect.origin.y), CGPointMake(mainRect.origin.x, mainRect.origin.y), CGPointMake(mainRect.origin.x, mainRect.origin.y + 20)};
    CGPoint upRightPoints[] = {CGPointMake(CGRectGetMaxX(mainRect) - 20, mainRect.origin.y), CGPointMake(CGRectGetMaxX(mainRect), mainRect.origin.y), CGPointMake(CGRectGetMaxX(mainRect), mainRect.origin.y), CGPointMake(CGRectGetMaxX(mainRect), mainRect.origin.y + 20)};
    CGPoint belowLeftPoints[] = {CGPointMake(mainRect.origin.x, CGRectGetMaxY(mainRect)), CGPointMake(mainRect.origin.x, CGRectGetMaxY(mainRect) - 20), CGPointMake(mainRect.origin.x, CGRectGetMaxY(mainRect)), CGPointMake(mainRect.origin.x +20, CGRectGetMaxY(mainRect))};
    CGPoint belowRightPoints[] = {CGPointMake(CGRectGetMaxX(mainRect), CGRectGetMaxY(mainRect)), CGPointMake(CGRectGetMaxX(mainRect) - 20, CGRectGetMaxY(mainRect)), CGPointMake(CGRectGetMaxX(mainRect), CGRectGetMaxY(mainRect)), CGPointMake(CGRectGetMaxX(mainRect), CGRectGetMaxY(mainRect) - 20)};
    CGContextStrokeLineSegments(ctx, upLeftPoints, 4);
    CGContextStrokeLineSegments(ctx, upRightPoints, 4);
    CGContextStrokeLineSegments(ctx, belowLeftPoints, 4);
    CGContextStrokeLineSegments(ctx, belowRightPoints, 4);
}

@end
