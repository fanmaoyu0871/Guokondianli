//
//  GKFilterView.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/21.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKFilterView : UIView

@property (nonatomic, copy)void (^finishBlock)(NSDictionary* filterDict);

-(void)showAtY:(CGFloat)y toView:(UIView*)view;
@end
