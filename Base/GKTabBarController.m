//
//  GKTabBarController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/14.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKTabBarController.h"
#import "GKBaseController.h"
#import "FMBubbleTabbar.h"
#import "GKNavigationController.h"
#import "FMScanController.h"


#import "GKLoginController.h"

@interface GKTabBarController ()

@property (nonatomic, strong)FMBubbleTabbar *bubbleTabbar;

@end

@implementation GKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    NSArray *image = @[@"tab_shouye", @"tab_shequ", @"scan",  @"tab_gerenzhuang", @"tab_wode"];
    NSArray *selectedImages = @[@"tab_selected_shouye", @"tab_selected_shequ", @"scan", @"tab_selected_gerenzhuang", @"tab_selected_wode"];
    
    NSArray *vcStr = @[@"GKHomeController", @"GKCommunityController", @"GKPersonalController", @"GKMineController"];
    NSMutableArray *vcs = [NSMutableArray array];
    for(NSString *str in vcStr){
        Class cls = NSClassFromString(str);
        GKBaseController *vc = [[cls alloc]init];
        GKNavigationController *navVC = (GKNavigationController*)[[GKNavigationController alloc]initWithRootViewController:vc];
        [vcs addObject:navVC];
    }
    
    self.viewControllers = vcs;
    
    WEAKSELf
    self.bubbleTabbar = [FMBubbleTabbar tabTitles:nil images:image selectedImages:selectedImages selectedBlock:^(NSInteger index) {
        weakSelf.selectedIndex = index;
    } centerBlock:^{
        GKNavigationController *vc = weakSelf.selectedViewController;
        [vc pushViewController:[[FMScanController alloc]init] animated:YES];
    }];
    [self.tabBar addSubview:self.bubbleTabbar];
}

-(void)selectedAtIndex:(NSInteger)tabIndex{
    self.selectedIndex = tabIndex;
    [self.bubbleTabbar pressAtIndex:tabIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
