//
//  GKPersonalZhanDetailController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/26.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPersonalZhanDetailController.h"
#import "GKDeviceModel.h"
#import "GKSimpleCell.h"

@interface GKPersonalZhanDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIImageView *headerImageView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIButton *bottomBtn;

@property (nonatomic, strong)GKDeviceModel *model;
@end

@implementation GKPersonalZhanDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitle = @"个人站详情";
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.fm_y = self.fm_navigationBar.fm_height;
    _tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    _tableView.rowHeight = 50;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self createHeaderView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    RegisterNib(_tableView, GKSimpleCell);
    
    [self requestData];
}

-(UIView*)createHeaderView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.fm_width, 180)];
    
    self.headerImageView = [[UIImageView alloc]init];
    self.headerImageView.fm_size = CGSizeMake(80, 80);
    self.headerImageView.fm_top = 30;
    self.headerImageView.fm_centerX = bgView.fm_width / 2;
    [bgView addSubview:self.headerImageView];
    
    self.statusLabel = [UILabel labelWithTitle:@"" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
    [bgView addSubview:self.statusLabel];

    
    return bgView;
}

-(UIView *)createFooterView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.fm_width, 200)];
    
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.bottomBtn.fm_size = CGSizeMake(250, 40);
    self.bottomBtn.backgroundColor = HEXCOLOR(MainTheme_Color);
    [self.bottomBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    self.bottomBtn.layer.cornerRadius = 5;
    self.bottomBtn.center = bgView.fm_boundsCenter;
    [bgView addSubview:self.bottomBtn];
    
    return bgView;
}

-(void)bottomBtnAction{
    //to do
    if([self.model.device_status integerValue] == 1){
        [self openInterfaceReq:@"startPersonCharge"];
    }else if([self.model.device_status integerValue] == 2){
        [self openInterfaceReq:@"stopPersonCharge"];
    }else if([self.model.device_status integerValue] == 3){
        NSString* str=[NSString stringWithFormat:@"telprompt://0531-23234567"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(void)openInterfaceReq:(NSString*)interface{
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:interface parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"device_id":self.device_id} successBlock:^(id responseObject) {
        
        //成功后刷新数据
        [self requestData];
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
    
}

-(void)requestData{
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getPersonDeviceDetails" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"device_id":self.device_id} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            self.model = [[GKDeviceModel alloc]init];
            [self.model setValuesForKeysWithDictionary:responseObject];
        
            NSString *str = @"";
            NSString *status_str = @"";
            if([self.model.device_status integerValue] == 1){
                str = @"开启";
                status_str = @"当前状态：空闲";
            }else if([self.model.device_status integerValue] == 2){
                str = @"断开";
                status_str = @"当前状态：充电中";
            }else if([self.model.device_status integerValue] == 3){
                str = @"联系客服 0531-23234567";
                status_str = @"当前状态：损坏";
            }
        
            self.statusLabel.text = status_str;
            [self.statusLabel sizeToFit];
            self.statusLabel.fm_top = self.headerImageView.fm_bottom + 20;
            self.statusLabel.fm_centerX = self.headerImageView.fm_centerX;
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Prefix_Img_Host, self.model.device_pic]] placeholderImage:[UIImage imageNamed:@"test"]];
            
            _tableView.tableFooterView = [self createFooterView];
            [self.bottomBtn setTitle:str forState:UIControlStateNormal];

        
            [self.tableView reloadData];
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.model.device_status integerValue] == 1){
        return 4;
    }else if([self.model.device_status integerValue] == 2){
        return 6;
    }else if([self.model.device_status integerValue] == 3){
        return 4;
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKSimpleCell.class)];
    switch (indexPath.row) {
        case 0:
            [cell configLeftTitle:@"编号" rightTitle:self.model.device_code];
            break;
        case 1:
        {
            if([self.model.device_status integerValue] == 2){
                [cell configLeftTitle:@"已充电时间" rightTitle:self.model.current_time];
            }else{
                [cell configLeftTitle:@"以充电次数" rightTitle:self.model.used_nums];
            }
        }
            break;
        case 2:
        {
            if([self.model.device_status integerValue] == 2){
                [cell configLeftTitle:@"总充电度数" rightTitle:self.model.used_degree];
            }else{
                [cell configLeftTitle:@"总充电时间" rightTitle:self.model.used_time];
            }
        }
            break;
        case 3:
        {
            if([self.model.device_status integerValue] == 3){
                [cell configLeftTitle:@"故障代码" rightTitle:self.model.error_code];
            }else if([self.model.device_status integerValue] == 1){
                [cell configLeftTitle:@"总充电度数" rightTitle:self.model.used_degree];
            }else if([self.model.device_status integerValue] == 2){
                [cell configLeftTitle:@"接口" rightTitle:self.model.device_port];
            }
        }
            break;
        case 4:
            [cell configLeftTitle:@"充电车型" rightTitle:self.model.car_type];
            break;
        case 5:
            [cell configLeftTitle:@"模式" rightTitle:self.model.device_model];
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
