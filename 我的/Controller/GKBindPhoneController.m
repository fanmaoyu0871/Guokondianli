//
//  GKBindPhoneController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2018/1/2.
//  Copyright © 2018年 范茂羽. All rights reserved.
//

#import "GKBindPhoneController.h"
#import "GKInputCell.h"

@interface GKBindPhoneController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_leftTitles;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString* phoneNo;
@property (nonatomic, copy)NSString* pwd;

@end

@implementation GKBindPhoneController

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
    
    if(!self.phoneNo || [self.phoneNo isKindOfClass:[NSNull class]] || self.phoneNo.length <= 0){
        [MBProgressHUD showText:@"请填写手机号" to:self.view];
        return;
    }
    
    if(!self.pwd || [self.pwd isKindOfClass:[NSNull class]] || self.pwd.length <= 0){
        [MBProgressHUD showText:@"请填写密码" to:self.view];
        return;
    }
    
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"bindMobileInfo" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"mobile":self.phoneNo, @"pwd":self.pwd} successBlock:^(id responseObject) {
        [hud hideHUD];
        
        [MBProgressHUD showText:@"手机绑定成功!" to:self.view];
        
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

    self.navTitle = @"绑定手机";
    
    _leftTitles = @[@"手 机 号", @"密 码"];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.fm_top = self.fm_navigationBar.fm_height;
    _tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    RegisterCell(_tableView, GKInputCell.class);
    
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
            [cell configUI:_leftTitles[indexPath.row] phTitle:@"必填" content:self.phoneNo image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                weakSelf.phoneNo = text;
            }];
        }
            break;
        case 1:
        {
            
            [cell configUI:_leftTitles[indexPath.row] phTitle:@"必填" content:self.pwd image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                weakSelf.pwd = text;
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
