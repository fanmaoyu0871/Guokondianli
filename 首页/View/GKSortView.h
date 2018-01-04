//
//  GKFilterView.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/21.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKSortView : UIView

-(void)showData:(NSArray*)data atX:(CGFloat)x atY:(CGFloat)y width:(CGFloat)width toView:(UIView*)view disSelect:(void (^)(NSInteger index))selectBlock;

@end
