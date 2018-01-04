//
//  GKDetailPopTransition.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/16.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKDetailPopTransition.h"
#import "GKBaseController.h"

@implementation GKDetailPopTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    GKBaseController *fromVC = (GKBaseController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor clearColor];
    fromVC.view.alpha = 1.0f;
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    [fromVC hideNavigationBar:YES];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.alpha = .0f;
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
