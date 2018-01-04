//
//  GKPayResultController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2018/1/4.
//  Copyright © 2018年 范茂羽. All rights reserved.
//

#import "GKPayResultController.h"
#import "GKTerminalInfoView.h"
#import "GKPayResultCell.h"

@interface GKPayResultController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)GKTerminalInfoView *infoView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSDictionary *result;
@property (nonatomic, strong)UILabel *amountLabel;
@property (nonatomic, strong)UIButton *connectBtn;
@end

@implementation GKPayResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"充电详情";
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.fm_y = self.fm_navigationBar.fm_height;
    tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [self createHeader];
    tableView.tableFooterView = [self createFooterView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    RegisterCell(tableView, GKPayResultCell);
    
    [self requestData];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestData) userInfo:nil repeats:YES];
}

-(UIView*)createHeader{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, 160.0f)];
    
    self.infoView = [[GKTerminalInfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, 120)];
    [bgView addSubview:self.infoView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.infoView.fm_bottom, self.view.fm_width, 40.0f)];
    [bgView addSubview:bottomView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dianchi"]];
    [bottomView addSubview:imageView];
    imageView.fm_left = 10;
    imageView.fm_centerY = bottomView.fm_height / 2;
    
    self.statusLabel = [UILabel labelWithTitle:@"当前状态：空闲" fontSize:14.0f textColor:[UIColor colorWithHex:0x7ED321] textWeight:UIFontWeightRegular];
    [bottomView addSubview:self.statusLabel];
    self.statusLabel.fm_left = imageView.fm_right + 10;
    self.statusLabel.fm_centerY = bottomView.fm_height / 2;
    
    return bgView;
}

-(UIView*)createFooterView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, 160.0f)];
    
    self.amountLabel = [UILabel labelWithTitle:@"实时充电金额：¥0.00" fontSize:14.0f textColor:[UIColor colorWithHex:0xD0021B] textWeight:UIFontWeightRegular];
    [bgView addSubview:self.amountLabel];
    self.amountLabel.fm_centerX = bgView.fm_width / 2;
    self.amountLabel.fm_top = 20;
    
    self.connectBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:[UIColor whiteColor] title:@""];
    self.connectBtn.backgroundColor = [UIColor colorWithHex:MainTheme_Color];
    self.connectBtn.layer.cornerRadius = 2;
    [bgView addSubview:self.connectBtn];
    self.connectBtn.fm_size = CGSizeMake(220.0f, 40.0f);
    self.connectBtn.fm_top = self.amountLabel.fm_bottom + 50;
    self.connectBtn.fm_centerX = bgView.fm_width / 2;
    [self.connectBtn addTarget:self action:@selector(connectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return bgView;
}

-(void)connectionBtnAction:(UIButton*)btn{
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:[btn.currentTitle isEqualToString:@"充电"]?@"startCharge":@"stopCharge" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"order_id":self.order_id} successBlock:^(id responseObject) {
        
        [btn setTitle:[btn.currentTitle isEqualToString:@"充电"]?@"断开":@"充电" forState:UIControlStateNormal];
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(void)requestData{
    
    if(!self.order_id)
        return;
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getChargeDetailsInfo" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"order_id":self.order_id} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = responseObject;
            self.result = dict;
            
            [self.infoView configName:[NSString stringWithFormat:@"当前充电站点：%@", dict[@"station_name"]] no:[NSString stringWithFormat:@"充电终端编号：%@", dict[@"station_code"]]];
            self.statusLabel.text = [NSString stringWithFormat:@"当前状态：%@", [dict[@"device_status"] integerValue] == 0?@"空闲":@"充电中"];
            [self.statusLabel sizeToFit];
            [self.connectBtn setTitle:[dict[@"device_status"] integerValue] == 0?@"充电":@"断开" forState:UIControlStateNormal];
            self.amountLabel.text = [NSString stringWithFormat:@"实时充电金额：¥%@", dict[@"charge_price"]];
            [self.amountLabel sizeToFit];
            
            [self.tableView reloadData];
        }
        
        [hud hideHUD];
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [FMDropToast showText:msg atView:self.view offset:CGPointMake(0, 20)];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKPayResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKPayResultCell.class)];
    switch (indexPath.row) {
        case 0:
            [cell configLeft:@"桩号" right:self.result[@"device_id"] leftImage:[UIImage imageNamed:@"full_point"]];
            break;
        case 1:
            [cell configLeft:@"已充电时间" right:self.result[@"charge_time"] leftImage:[UIImage imageNamed:@"full_point"]];
            break;
        case 2:
            [cell configLeft:@"已充电度数" right:self.result[@"charge_degree"] leftImage:[UIImage imageNamed:@"full_point"]];
            break;
        case 3:
            [cell configLeft:@"接口" right:self.result[@"device_port"] leftImage:[UIImage imageNamed:@"full_point"]];
            break;
        case 4:
            [cell configLeft:@"充电车型" right:self.result[@"car_type"] leftImage:[UIImage imageNamed:@"full_point"]];
            break;
        case 5:
            [cell configLeft:@"模式" right:self.result[@"device_model"] leftImage:[UIImage imageNamed:@"full_point"]];
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
