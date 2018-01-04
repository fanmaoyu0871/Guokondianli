//
//  GKChangePwdController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2018/1/2.
//  Copyright © 2018年 范茂羽. All rights reserved.
//

#import "GKChangePwdController.h"
#import "GKBaseTextField.h"

@interface GKChangePwdController ()

@property (nonatomic, strong)GKBaseTextField *curPwdTf;
@property (nonatomic, strong)GKBaseTextField *newestPwdTf;
@property (nonatomic, strong)GKBaseTextField *sureNewPwdTf;

@end

@implementation GKChangePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"修改密码";
    
    self.curPwdTf = [[GKBaseTextField alloc]init];
    self.curPwdTf.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular];
    self.curPwdTf.layer.borderWidth = 1;
    self.curPwdTf.layer.borderColor = HEXCOLOR(TableBackground_Color).CGColor;
    self.curPwdTf.fm_size = CGSizeMake(self.view.fm_width - 20, 40);
    self.curPwdTf.fm_top = self.fm_navigationBar.fm_height + 20;
    self.curPwdTf.fm_left = 10;
    self.curPwdTf.placeholder = @"当前密码";
    self.curPwdTf.secureTextEntry = YES;
    [self.view addSubview:self.curPwdTf];
    
    self.newestPwdTf = [[GKBaseTextField alloc]init];
    self.newestPwdTf.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular];
    self.newestPwdTf.layer.borderWidth = 1;
    self.newestPwdTf.layer.borderColor = HEXCOLOR(TableBackground_Color).CGColor;
    self.newestPwdTf.fm_size = CGSizeMake(self.view.fm_width - 20, 40);
    self.newestPwdTf.fm_top = self.curPwdTf.fm_bottom + 20;
    self.newestPwdTf.fm_left = 10;
    self.newestPwdTf.placeholder = @"新密码";
    self.newestPwdTf.secureTextEntry = YES;
    [self.view addSubview:self.newestPwdTf];
    
    self.sureNewPwdTf = [[GKBaseTextField alloc]init];
    self.sureNewPwdTf.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular];
    self.sureNewPwdTf.layer.borderWidth = 1;
    self.sureNewPwdTf.layer.borderColor = HEXCOLOR(TableBackground_Color).CGColor;
    self.sureNewPwdTf.fm_size = CGSizeMake(self.view.fm_width - 20, 40);
    self.sureNewPwdTf.fm_top = self.newestPwdTf.fm_bottom + 20;
    self.sureNewPwdTf.fm_left = 10;
    self.sureNewPwdTf.secureTextEntry = YES;
    self.sureNewPwdTf.placeholder = @"确认新密码";
    [self.view addSubview:self.sureNewPwdTf];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:[UIColor whiteColor] title:@"确认提交"];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor colorWithHex:MainTheme_Color];
    btn.fm_size = CGSizeMake(220, 40);
    btn.fm_centerX = self.view.fm_boundsCenter.x;
    btn.fm_top = self.sureNewPwdTf.fm_bottom + 50;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sureBtnAction{
    
    [self.view endEditing:YES];
    
    if(![self.newestPwdTf.text isEqualToString:self.sureNewPwdTf.text]){
        [MBProgressHUD showText:@"两次密码输入不一致" to:self.view];
        return;
    }
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"modifyPwd" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"old_pwd":self.curPwdTf, @"new_pwd":self.sureNewPwdTf } successBlock:^(id responseObject) {
        [hud hideHUD];
        
        [MBProgressHUD showText:@"修改密码成功!" to:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
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
