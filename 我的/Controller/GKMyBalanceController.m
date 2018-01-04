//
//  GKMyBalanceController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKMyBalanceController.h"
#import "GKPayChargeController.h"

@interface GKMyBalanceController ()
@property (nonatomic, strong)UILabel *balanceLabel;
@property (nonatomic, strong)UIButton *chargeBtn;
@property (nonatomic, strong)UIButton *tixianBtn;
@property (nonatomic, strong)UIButton *hisBtn;
@end

@implementation GKMyBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"我的钱包";
    
    [self hideNavigationBar:NO];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_purse"]];
    imageView.fm_centerX = self.view.fm_centerX;
    imageView.fm_top = 50;
    [self.view addSubview:imageView];
    
    self.balanceLabel = [UILabel labelWithTitle:@"¥123.00" fontSize:30 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightBold];
    [self.view addSubview:self.balanceLabel];
    self.balanceLabel.fm_top = imageView.fm_bottom + 20;
    self.balanceLabel.fm_centerX = self.view.fm_centerX;
    
    self.chargeBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:HEXCOLOR(MainTheme_Color) title:@"充值"];
    [self.view addSubview:self.chargeBtn];
    self.chargeBtn.layer.borderColor = HEXCOLOR(MainTheme_Color).CGColor;
    self.chargeBtn.layer.borderWidth = 1;
    self.chargeBtn.layer.cornerRadius = 5;
    [self.chargeBtn addTarget:self action:@selector(chargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
//    self.tixianBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:14.0f titleColor:HEXCOLOR(LightText_Color) title:@"提现"];
//    [self.view addSubview:self.tixianBtn];
//    self.tixianBtn.layer.borderWidth = 1;
//    self.tixianBtn.layer.borderColor = HEXCOLOR(LightText_Color).CGColor;
//    self.tixianBtn.layer.cornerRadius = 5;
//
//    self.hisBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:14.0f titleColor:HEXCOLOR(LightText_Color) title:@"历史账单"];
//    [self.view addSubview:self.hisBtn];
//    self.hisBtn.layer.borderWidth = 1;
//    self.hisBtn.layer.borderColor = HEXCOLOR(LightText_Color).CGColor;
//    self.hisBtn.layer.cornerRadius = 5;
}

-(void)chargeBtnAction{
    GKPayChargeController *vc = [[GKPayChargeController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.chargeBtn.fm_bottom = self.view.fm_height - 100;
    self.chargeBtn.fm_size = CGSizeMake(280, 40);
    self.chargeBtn.fm_centerX = self.view.fm_centerX;
    
    self.tixianBtn.fm_size = CGSizeMake(120.0f, 30);
    self.tixianBtn.fm_top = self.chargeBtn.fm_bottom + 20;
    self.tixianBtn.fm_right = self.view.fm_width / 2 - 20;
    
    self.hisBtn.fm_size = CGSizeMake(120.0f, 30);
    self.hisBtn.fm_top = self.chargeBtn.fm_bottom + 20;
    self.hisBtn.fm_left = self.view.fm_width / 2 + 20;
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
