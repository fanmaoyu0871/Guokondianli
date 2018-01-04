//
//  GKMyOrderController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/29.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKMyOrderController.h"
#import "GKButtonsView.h"
#import "GKIntroView.h"
#import "GKOrderCell.h"
#import "FMLocationManager.h"
#import "GKDeviceModel.h"
#import "GKPingjiaController.h"

@interface GKMyOrderController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableDictionary *cacheDict;
@end

@implementation GKMyOrderController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(NSMutableDictionary *)cacheDict{
    if(_cacheDict == nil){
        _cacheDict = [NSMutableDictionary dictionary];
    }
    
    return _cacheDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"我的充电订单";
    
    GKButtonsView *btnsView = [[GKButtonsView alloc]initWithFrame:CGRectMake(0, self.fm_navigationBar.fm_height, self.view.fm_width, 50) data:@[@"已完成", @"待评价"] images:@[@"", @""] action:^(NSInteger index, UIButton *btn) {
        [self requestDataWithType:index==0?@"1":@"2"];
    }];
    [self.view addSubview:btnsView];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.fm_y = btnsView.fm_bottom;
    _tableView.fm_height = self.view.fm_height - btnsView.fm_bottom;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    RegisterNib(_tableView, GKOrderCell);
    
    [btnsView pressAtIndex:0];
    
}

-(void)requestDataWithType:(NSString*)type{
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getOrderList" parameters:@{@"user_id":@"5", @"type":type, @"station_lon":[NSString stringWithFormat:@"%.6f", [FMLocationManager sharedManager].location.longitude], @"station_lat":[NSString stringWithFormat:@"%.6f", [FMLocationManager sharedManager].location.latitude]} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            id station_list = responseObject[@"order_list"];
            if([station_list isKindOfClass:[NSArray class]]){
                NSArray *array = station_list;
                for(NSDictionary *dict in array){
                    GKStateModel *model = [[GKStateModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
                
                [self.tableView reloadData];
            }
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(void)requestDetailByOrderId:(NSString*)order_id{
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getOrderDetails" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"order_id":order_id} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            GKDeviceModel *model = [[GKDeviceModel alloc]init];
            [model setValuesForKeysWithDictionary:responseObject];
            
            [_cacheDict setObject:model forKey:order_id];
            
            [self.tableView reloadData];
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    GKStateModel *model = self.dataArray[section];
    
    return model.isDetailSelected?1:0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKOrderCell.class)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GKStateModel *model = self.dataArray[indexPath.section];
    GKDeviceModel *deviceModel = [self.cacheDict objectForKey:model.order_id];
    [cell configUI:deviceModel rightBlock:^{
        GKPingjiaController *vc = [[GKPingjiaController alloc]init];
        vc.order_type = deviceModel.order_type;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.fm_width, 120)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    GKStateModel *model = self.dataArray[section];
    
    WEAKSELf
    GKIntroView *introView = [[GKIntroView alloc]initWithFrame:CGRectMake(0, 0, tableView.fm_width, 120)];
    [introView configUI:model rightBlock:^{
        
        if(model.isDetailSelected){
            model.isDetailSelected = nil;
        }else{
            model.isDetailSelected = @"";
        }
        
        if([weakSelf.cacheDict objectForKey:model.order_id]){
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf requestDetailByOrderId:model.order_id];
        }
    }];
    [bgView addSubview:introView];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
