//
//  GKHomePushTransition.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/15.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKHomePushTransition.h"

@implementation GKHomePushTransition

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    toVC.view.alpha = .0f;
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.alpha = 0;
        toVC.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        fromVC.view.alpha = 1.0f;
        [transitionContext completeTransition:YES];
    }];
    
}
@end
