//
//  GKRealAuthController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2018/1/2.
//  Copyright © 2018年 范茂羽. All rights reserved.
//

#import "GKRealAuthController.h"
#import "GKInputCell.h"

@interface GKRealAuthController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_leftTitles;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString* realName;
@property (nonatomic, copy)NSString* birth;
@property (nonatomic, copy)NSString* identityNo;
@property (nonatomic, copy)NSString* phoneNo;
@property (nonatomic, copy)NSString* carNo;
@property (nonatomic, copy)NSString* job;
@end

@implementation GKRealAuthController

-(void)createRightView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(self.fm_navigationBar.fm_width-80, 20, 80, 44);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:rightBtn];
}

-(void)finishBtnAction{
    
    [self.view endEditing:YES];
    
    if(!self.realName || [self.realName isKindOfClass:[NSNull class]] || self.realName.length <= 0){
        [MBProgressHUD showText:@"请填写真实姓名" to:self.view];
        return;
    }
    
    if(!self.birth || [self.birth isKindOfClass:[NSNull class]] || self.birth.length <= 0){
        [MBProgressHUD showText:@"请填写出生年月" to:self.view];
        return;
    }
    
    if(!self.identityNo || [self.identityNo isKindOfClass:[NSNull class]] || self.identityNo.length <= 0){
        [MBProgressHUD showText:@"请填写身份证号" to:self.view];
        return;
    }
    
    if(!self.phoneNo || [self.phoneNo isKindOfClass:[NSNull class]] || self.phoneNo.length <= 0){
        [MBProgressHUD showText:@"请填写电话号码" to:self.view];
        return;
    }
    
    if(!self.carNo || [self.carNo isKindOfClass:[NSNull class]] || self.carNo.length <= 0){
        [MBProgressHUD showText:@"请填写车牌号" to:self.view];
        return;
    }
    
    if(!self.job || [self.job isKindOfClass:[NSNull class]] || self.job.length <= 0){
        [MBProgressHUD showText:@"请填写工作" to:self.view];
        return;
    }
    
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"setVerifiedInfo" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"name":self.realName, @"birthday":self.birth, @"id_card":self.identityNo, @"mobile":self.phoneNo, @"car_code":self.carNo, @"work":self.job} successBlock:^(id responseObject) {
        [hud hideHUD];
        
        [MBProgressHUD showText:@"实名认证成功!" to:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"实名认证";
    
    _leftTitles = @[@"真 实 姓 名", @"出 生 年 月", @"身 份 证 号", @"电 话 号 码", @"车 牌 号 码", @"工 作"];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.fm_top = self.fm_navigationBar.fm_height;
    _tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    RegisterCell(_tableView, GKInputCell.class);
    
    [self requestData];
}

-(void)requestData{

    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getVerifiedInfo" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"]} successBlock:^(id responseObject) {
        [hud hideHUD];
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = responseObject;
            self.realName = dict[@"name"];
            self.birth = dict[@"birthday"];
            self.identityNo = dict[@"id_card"];
            self.phoneNo = dict[@"mobile"];
            self.carNo = dict[@"car_code"];
            self.job = dict[@"work"];
            
            [self.tableView reloadData];
        }
        
      
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _leftTitles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKInputCell.class)];
    WEAKSELf
    switch (indexPath.row) {
        case 0:
        {
            [cell configUI:_leftTitles[indexPath.row] phTitle:@"必填" content:self.realName image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                weakSelf.realName = text;
            }];
        }
            break;
        case 1:
        {
            
            [cell configUI:_leftTitles[indexPath.row] phTitle:@"必填，格式: yyyy-mm-dd" content:self.birth image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                weakSelf.birth = text;
            }];
        }
            break;
        case 2:
        {
            [cell configUI:_leftTitles[indexPath.row] phTitle:@"必填" content:self.identityNo image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                weakSelf.identityNo = text;
            }];
        }
            break;
        case 3:
        {
            [cell configUI:_leftTitles[indexPath.row] phTitle:@"必填" content:self.phoneNo image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                weakSelf.phoneNo = text;
            }];
        }
            break;
        case 4:
        {
            [cell configUI:_leftTitles[indexPath.row] phTitle:@"必填" content:self.carNo image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                weakSelf.carNo = text;
            }];
        }
            break;
        case 5:
        {
            [cell configUI:_leftTitles[indexPath.row] phTitle:@"必填" content:self.job image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                weakSelf.job = text;
            }];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
