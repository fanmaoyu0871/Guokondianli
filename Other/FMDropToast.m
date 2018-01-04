//
//  FMDropToast.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "FMDropToast.h"

#define Tag 90132

@interface FMDropToast()
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, copy)NSString* content;
@end

@implementation FMDropToast

+(instancetype)showText:(NSString*)text atView:(UIView*)view{
    return [self showText:text atView:view offset:CGPointZero];
}

+(instancetype)showText:(NSString*)text atView:(UIView*)view offset:(CGPoint)point{
    
    if([view viewWithTag:Tag])
        return nil;
    
    FMDropToast *toast = [[self alloc]initWithFrame: CGRectMake(point.x, 0, view.fm_width, 0)];
    toast.tag = Tag;
    toast.contentLabel.text = text;
    [toast.contentLabel sizeToFit];
    toast.contentLabel.fm_y += point.y;
    toast.fm_height = toast.contentLabel.fm_height + 20 + point.y;
    toast.fm_y = -toast.fm_height;
    [view addSubview:toast];
    
    [UIView animateWithDuration:0.8f animations:^{
        toast.fm_y += toast.fm_height;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8f animations:^{
                toast.fm_y -= toast.fm_height;
            } completion:^(BOOL finished) {
                [toast removeFromSuperview];
            }];
        });
    }];
    
    return toast;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:107/255.0f blue:182/255.0f alpha:0.9];
        
        self.contentLabel = [UILabel labelWithTitle:@"" fontSize:14.0f textColor:[UIColor whiteColor] textWeight:UIFontWeightLight];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.fm_width = frame.size.width - 20;
        self.contentLabel.fm_leftTop = CGPointMake(10, 10);
        [self addSubview:self.contentLabel];
    }
    return self;
}

@end
