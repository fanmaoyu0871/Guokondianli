//
//  GKMyPurseController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKMyPurseController.h"
#import "GKButtonsView.h"
#import "GKMyBalanceController.h"
#import "GKMyCardController.h"
#import "GKMyBillController.h"

@interface GKMyPurseController ()
@property (nonatomic, strong)GKMyBalanceController *balanceVC;
@property (nonatomic, strong)GKMyCardController *cardVC;
@property (nonatomic, strong)GKMyBillController *billVC;
@property (nonatomic, strong)GKButtonsView *btnsView;
@end

@implementation GKMyPurseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"我的钱包";
    
    WEAKSELf
    self.btnsView = [[GKButtonsView alloc]initWithFrame:CGRectMake(0, self.fm_navigationBar.fm_bottom, self.view.fm_width, 50) data:@[@"我的余额", @"我的卡券", @"我的账单"] images:nil action:^(NSInteger index, UIButton *btn) {
        if(index == 0){
            if(weakSelf.balanceVC == nil){
                weakSelf.balanceVC = [[GKMyBalanceController alloc]init];
                weakSelf.balanceVC.view.fm_top = weakSelf.btnsView.fm_bottom;
                weakSelf.balanceVC.view.fm_height = weakSelf.view.fm_height - weakSelf.btnsView.fm_bottom;
                [weakSelf.view addSubview:weakSelf.balanceVC.view];
                [weakSelf addChildViewController:weakSelf.balanceVC];
            }else{
                [weakSelf.view bringSubviewToFront:weakSelf.balanceVC.view];
            }
           
        }else if (index == 1){
            if(weakSelf.cardVC == nil){
                weakSelf.cardVC = [[GKMyCardController alloc]init];
                weakSelf.cardVC.view.fm_top = weakSelf.btnsView.fm_bottom;
                weakSelf.cardVC.view.fm_height = weakSelf.view.fm_height - weakSelf.btnsView.fm_bottom;
                [weakSelf.view addSubview:weakSelf.cardVC.view];
                [weakSelf addChildViewController:weakSelf.cardVC];
            }else{
                [weakSelf.view bringSubviewToFront:weakSelf.cardVC.view];
            }

        }else if (index == 2){
            if(weakSelf.billVC == nil){
                weakSelf.billVC = [[GKMyBillController alloc]init];
                weakSelf.billVC.view.fm_top = weakSelf.btnsView.fm_bottom;
                weakSelf.billVC.view.fm_height = weakSelf.view.fm_height - weakSelf.btnsView.fm_bottom;
                [weakSelf.view addSubview:weakSelf.billVC.view];
                [weakSelf addChildViewController:weakSelf.billVC];
            }else{
                [weakSelf.view bringSubviewToFront:weakSelf.billVC.view];
            }
        }
    }];
    self.btnsView.showVerticalLine = NO;
    [self.view addSubview:self.btnsView];
    [self.btnsView pressAtIndex:0];
    
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
