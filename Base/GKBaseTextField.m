//
//  GKBaseTextField.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseTextField.h"

@implementation GKBaseTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *view = [[UIView alloc]init];
        view.fm_size = CGSizeMake(10, 1);
        self.leftView = view;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc]init];
        view.fm_size = CGSizeMake(10, frame.size.height);
        self.leftView = view;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
