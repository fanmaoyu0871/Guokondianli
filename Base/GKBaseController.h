//
//  GKBaseController.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/10.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKBaseController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic, strong, readonly)UIView *fm_navigationBar;
@property (nonatomic, assign, readonly)BOOL isTabbarHidden;
@property (nonatomic, copy)NSString* navTitle;
@property (nonatomic, assign)BOOL showNavBarLine;


-(void)createLeftView;
-(void)createRightView;
-(void)createTitleView;

-(void)showNavigationBar:(BOOL)animated;
-(void)hideNavigationBar:(BOOL)animated;

-(void)showTabBar:(BOOL)animated;
-(void)hideTabBar:(BOOL)animated;

@end
