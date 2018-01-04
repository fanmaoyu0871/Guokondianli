//
//  GKLoginController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKLoginController.h"
#import "GKButtonsView.h"
#import "GKInputView.h"
#import <UMSocialCore/UMSocialCore.h>

@interface GKLoginController ()

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)GKButtonsView *btnsView;

@property (nonatomic, strong)GKInputView *phoneTf;
@property (nonatomic, strong)GKInputView *pwdTf;

@property (nonatomic, strong)GKInputView *reg_phoneTf;
@property (nonatomic, strong)GKInputView *reg_verifyTf;
@property (nonatomic, strong)GKInputView *reg_pwdTf;
@property (nonatomic, strong)GKInputView *reg_nickTf;

@end

@implementation GKLoginController

-(void)loginBtnAction{
    
    if(self.phoneTf.content.length != 11){
        [MBProgressHUD showText:@"请输入合法手机号" to:self.view];
        return;
    }
    
    if(self.pwdTf.content.length <= 0){
        [MBProgressHUD showText:@"请输入密码" to:self.view];
        return;
    }
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"login" parameters:@{@"account":self.phoneTf.content, @"pwd":[NSString md5:self.pwdTf.content]} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = responseObject;
            [FMUserDefault setObject:dict[@"cookies"] forKey:@"cookies"];
            [FMUserDefault setObject:dict[@"user_id"] forKey:@"user_id"];
            [FMUserDefault setObject:dict[@"user_name"] forKey:@"user_name"];
            
            id pic = dict[@"user_pic"];
            if([pic isKindOfClass:[NSNull class]]){
                pic = @"";
            }
            [FMUserDefault setObject:pic forKey:@"user_pic"];

            [FMUserDefault setObject:dict[@"user_type"] forKey:@"user_type"];
        }
        
        [hud hideHUD];

        [self closeBtnAction];
        
        if(self.loginFinishBlock){
            self.loginFinishBlock();
        }
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [FMDropToast showText:msg atView:self.view offset:CGPointMake(0, 20)];
    }];
}

-(void)regBtnAction{
    
    if(self.reg_phoneTf.content.length != 11){
        [MBProgressHUD showText:@"请输入合法手机号" to:self.view];
        return;
    }
    
    if(self.reg_verifyTf.content.length <= 0){
        [MBProgressHUD showText:@"请输入验证码" to:self.view];
        return;
    }
    
    if(self.reg_verifyTf.content.length <= 0){
        [MBProgressHUD showText:@"请输入密码" to:self.view];
        return;
    }
    
    if(self.reg_nickTf.content.length <= 0){
        [MBProgressHUD showText:@"请输入昵称" to:self.view];
        return;
    }
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"registe" parameters:@{@"phone":self.reg_phoneTf.content, @"pwd":[NSString md5:self.reg_pwdTf.content], @"code":self.reg_verifyTf.content, @"name":self.reg_nickTf.content} successBlock:^(id responseObject) {
        
        [hud hideHUD];
        
        [MBProgressHUD showText:@"注册成功" to:self.view];
        
        [self.btnsView pressAtIndex:0];
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [FMDropToast showText:msg atView:self.view offset:CGPointMake(0, 20)];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.fm_width*2, self.scrollView.fm_height);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.fm_width, self.scrollView.fm_height - 80)];
    [self.scrollView addSubview:leftView];
    
    UIImageView *leftImageView = [[UIImageView alloc]init];
    leftImageView.fm_size = CGSizeMake(self.scrollView.fm_width, self.scrollView.fm_width * 300 / 375);
    leftImageView.image = [UIImage imageNamed:@"login_bg"];
    [leftView addSubview:leftImageView];
    
    self.phoneTf = [[GKInputView alloc]initWithFrame:CGRectMake(10, leftImageView.fm_bottom + 10, leftView.fm_width-20, 50) leftImage:[UIImage imageNamed:@"phone"] placeHolder:@"手机号码"];
    self.phoneTf.keyboardType = UIKeyboardTypePhonePad;
    [leftView addSubview:self.phoneTf];
    
    self.pwdTf = [[GKInputView alloc]initWithFrame:CGRectMake(10, self.phoneTf.fm_bottom , leftView.fm_width-20, 50) leftImage:[UIImage imageNamed:@"password"] placeHolder:@"密码"];
    self.pwdTf.secureTextEntry = YES;
    [leftView addSubview:self.pwdTf];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:HEXCOLOR(0xffffff) title:@"登录"];
    loginBtn.backgroundColor = HEXCOLOR(MainTheme_Color);
    loginBtn.fm_top = self.pwdTf.fm_bottom + 50;
    loginBtn.fm_size = CGSizeMake(250.0f, 40.0f);
    loginBtn.fm_centerX = leftView.fm_width / 2;
    loginBtn.layer.cornerRadius = 20;
    [leftView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(self.scrollView.fm_width, 0, self.scrollView.fm_width, self.scrollView.fm_height - 80)];
    [self.scrollView addSubview:rightView];
    
    UIImageView *rightImageView = [[UIImageView alloc]init];
    rightImageView.fm_size = CGSizeMake(self.scrollView.fm_width, self.scrollView.fm_width * 300 / 375);
    rightImageView.image = [UIImage imageNamed:@"register_bg"];
    [rightView addSubview:rightImageView];
    
    self.reg_phoneTf = [[GKInputView alloc]initWithFrame:CGRectMake(10, rightImageView.fm_bottom + 10, rightView.fm_width-100, 50) leftImage:[UIImage imageNamed:@"phone"] placeHolder:@"手机号码"];
    self.reg_phoneTf.keyboardType = UIKeyboardTypePhonePad;
    [rightView addSubview:self.reg_phoneTf];
    
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom image:nil fontSize:14.0 titleColor:HEXCOLOR(MainTheme_Color) title:@"获取验证码"];
    getCodeBtn.fm_size = CGSizeMake(80, 30);
    getCodeBtn.fm_left = self.reg_phoneTf.fm_right;
    getCodeBtn.fm_centerY = self.reg_phoneTf.fm_centerY;
    getCodeBtn.layer.cornerRadius = 2;
    getCodeBtn.layer.borderWidth = 0.5;
    getCodeBtn.layer.borderColor = HEXCOLOR(MainTheme_Color).CGColor;
    [rightView addSubview:getCodeBtn];
    [getCodeBtn addTarget:self action:@selector(getCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.reg_verifyTf = [[GKInputView alloc]initWithFrame:CGRectMake(10, self.reg_phoneTf.fm_bottom , rightView.fm_width-20, 50) leftImage:[UIImage imageNamed:@"verify"] placeHolder:@"验证码"];
    self.reg_verifyTf.keyboardType = UIKeyboardTypePhonePad;
    [rightView addSubview:self.reg_verifyTf];
    
    self.reg_pwdTf = [[GKInputView alloc]initWithFrame:CGRectMake(10, self.reg_verifyTf.fm_bottom , rightView.fm_width-20, 50) leftImage:[UIImage imageNamed:@"password"] placeHolder:@"设置密码"];
    self.reg_pwdTf.secureTextEntry = YES;
    [rightView addSubview:self.reg_pwdTf];
    
    self.reg_nickTf = [[GKInputView alloc]initWithFrame:CGRectMake(10, self.reg_pwdTf.fm_bottom, rightView.fm_width-20, 50) leftImage:[UIImage imageNamed:@"nick"] placeHolder:@"输入昵称"];
    [rightView addSubview:self.reg_nickTf];
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:HEXCOLOR(0xffffff) title:@"注册"];
    regBtn.backgroundColor = HEXCOLOR(MainTheme_Color);
    regBtn.fm_top = self.reg_nickTf.fm_bottom + 20;
    regBtn.fm_size = CGSizeMake(250.0f, 40.0f);
    regBtn.fm_centerX = leftView.fm_width / 2;
    regBtn.layer.cornerRadius = 20;
    [rightView addSubview:regBtn];
    
    [regBtn addTarget:self action:@selector(regBtnAction) forControlEvents:UIControlEventTouchUpInside];

    
    WEAKSELf
    self.btnsView = [[GKButtonsView alloc]initWithFrame:CGRectMake(0, leftImageView.fm_bottom-40, self.view.fm_width, 40) data:@[@"登录", @"注册"] images:nil action:^(NSInteger index, UIButton *btn) {
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.fm_width*index, 0) animated:YES];
    }];
    self.btnsView.titleColor = [UIColor whiteColor];
    self.btnsView.lineColor = [UIColor whiteColor];
    self.btnsView.selectedColor = [UIColor whiteColor];
    self.btnsView.showVerticalLine = NO;
    self.btnsView.showBottomLine = NO;
    [self.view addSubview:self.btnsView];
    
    [self createBottomView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"close"] fontSize:14.0f titleColor:nil title:nil];
    [self.view addSubview:closeBtn];
    closeBtn.fm_size = CGSizeMake(60, 60);
    closeBtn.fm_rightTop = CGPointMake(self.view.fm_right, 10);
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnsView pressAtIndex:0];
}

-(void)getCodeBtnAction{
    
    if(self.reg_phoneTf.content.length != 11){
        [MBProgressHUD showText:@"请输入合法手机号" to:self.view];
        return;
    }
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getCode" parameters:@{@"phone":self.reg_phoneTf.content, @"type":@"1"} successBlock:^(id responseObject) {
        
        [hud hideHUD];
        
        [FMDropToast showText:@"验证码已发送您的手机，请注意查收！" atView:self.view offset:CGPointMake(0, 20)];
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [FMDropToast showText:msg atView:self.view offset:CGPointMake(0, 20)];
    }];
}

-(void)closeBtnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.fm_height - 80, self.view.fm_width, 80)];
    [self.view addSubview:bottomView];
    
    UILabel *label = [UILabel labelWithTitle:@"使用以下方式快速登录" fontSize:14.0f textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightLight];
    [bottomView addSubview:label];
    label.fm_top = 5;
    label.fm_centerX = bottomView.fm_width / 2;
    
    UIView *leftLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(LightText_Color)];
    [bottomView addSubview:leftLine];
    leftLine.fm_left = 20;
    leftLine.fm_centerY = label.fm_centerY;
    leftLine.fm_size = CGSizeMake(label.fm_left - 20 - 20, 0.5f);
    
    UIView *rightLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(LightText_Color)];
    [bottomView addSubview:rightLine];
    rightLine.fm_left = label.fm_right + 20;
    rightLine.fm_centerY = label.fm_centerY;
    rightLine.fm_size = leftLine.fm_size;
    
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"wechat"] fontSize:14.0f titleColor:nil title:nil];
    [bottomView addSubview:wechatBtn];
    wechatBtn.tag = 1002;
    [wechatBtn addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    wechatBtn.fm_size = CGSizeMake(60, 60);
    wechatBtn.fm_leftTop = CGPointMake(leftLine.fm_left, label.fm_bottom);
    
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"weibo"] fontSize:14.0f titleColor:nil title:nil];
    [bottomView addSubview:weiboBtn];
    weiboBtn.tag = 1003;
    [weiboBtn addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    weiboBtn.fm_size = CGSizeMake(60, 60);
    weiboBtn.fm_top = label.fm_bottom;
    weiboBtn.fm_centerX = label.fm_centerX;
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"qq"] fontSize:14.0f titleColor:nil title:nil];
    [bottomView addSubview:qqBtn];
    qqBtn.tag = 1004;
    [qqBtn addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    qqBtn.fm_size = CGSizeMake(60, 60);
    qqBtn.fm_top = label.fm_bottom ;
    qqBtn.fm_right = rightLine.fm_right;
}

-(void)thirdLoginAction:(UIButton*)btn{
    NSInteger index = btn.tag - 1000;
    
    UMSocialPlatformType type = -1;
    if(index == 2){
        type = UMSocialPlatformType_WechatSession;
    }else if(index == 3){
        type = UMSocialPlatformType_Sina;
    }else if(index == 4){
        type = UMSocialPlatformType_QQ;
    }
    
    [self getUserInfoForPlatform:type index:index];
}



- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType index:(NSInteger)index
{
    WEAKSELf
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        if(error){
            [MBProgressHUD showText:@"第三方登录出错，请重试" to:self.view];
            return;
        }
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        if(!resp.iconurl  || [resp.iconurl isKindOfClass:[NSNull class]]){
            resp.iconurl = @"";
        }
        //登录
        [weakSelf thirdLoginName:resp.name pic:resp.iconurl openId:resp.uid type:[NSString stringWithFormat:@"%ld", index]];
    }];
}

-(void)thirdLoginName:(NSString*)name pic:(NSString*)pic openId:(NSString*)openId type:(NSString*)type{
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"thirdLogin" parameters:@{@"name":name, @"pic":pic, @"openId":openId, @"type":type} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = responseObject;
            [FMUserDefault setObject:dict[@"cookies"] forKey:@"cookies"];
            [FMUserDefault setObject:dict[@"user_id"] forKey:@"user_id"];
            [FMUserDefault setObject:dict[@"user_name"] forKey:@"user_name"];
            
            id pic = dict[@"user_pic"];
            if([pic isKindOfClass:[NSNull class]]){
                pic = @"";
            }
            [FMUserDefault setObject:pic forKey:@"user_pic"];
            
            [FMUserDefault setObject:dict[@"user_type"] forKey:@"user_type"];
        }
        
        [hud hideHUD];
        
        [self closeBtnAction];
        
        if(self.loginFinishBlock){
            self.loginFinishBlock();
        }
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [FMDropToast showText:msg atView:self.view offset:CGPointMake(0, 20)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
