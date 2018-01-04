//
//  GKRightDetailController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/16.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKRightDetailController.h"
#import "GKStatusView.h"
#import "GKBaoxiuCell.h"
#import "GKBaoxiuController.h"
#import "GKDeviceModel.h"

@interface GKRightDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation GKRightDetailController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, 100)];
    [self.view addSubview:topView];
    
    UILabel *label = [UILabel labelWithTitle:self.stationModel.station_name fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightMedium];
    label.fm_leftTop = CGPointMake(10, 20);
    [topView addSubview:label];
    
    UILabel *disLabel = [UILabel labelWithTitle:[NSString stringWithFormat:@"%.2fkm", [self.stationModel.distance floatValue]/1000] fontSize:12.0f textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
    disLabel.fm_right = topView.fm_width - 10;
    disLabel.fm_centerY = label.fm_centerY;
    [topView addSubview:disLabel];
    
    UIView *line = [[UIView alloc]initWithBackgroundColor:[UIColor colorWithHex:TableBackground_Color]];
    line.fm_size = CGSizeMake(topView.fm_width, 1);
    line.fm_leftBottom = CGPointMake(0, topView.fm_height);
    
    [topView addSubview:line];
    
    GKStatusView *statusView = [[GKStatusView alloc]initWithFrame:CGRectMake(0, label.fm_bottom + 10, topView.fm_width, 50)];
    [statusView configUI:self.stationModel];
    [topView addSubview:statusView];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.fm_height = self.view.fm_height - topView.fm_height - 64;
    _tableView.fm_y = topView.fm_bottom;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 240;
    [self.view addSubview:_tableView];
    
    RegisterNib(_tableView, GKBaoxiuCell.class);
    
    [self requestData];
}

-(void)requestData{
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getDeviceListBySid" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"station_id":self.stationModel.station_id} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            id device_list = responseObject[@"device_list"];
            if([device_list isKindOfClass:[NSArray class]]){
                NSArray *array = device_list;
                for(NSDictionary *dict in array){
                    GKDeviceModel *model = [[GKDeviceModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
                
                [_tableView reloadData];
            }
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKBaoxiuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKBaoxiuCell.class)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GKDeviceModel *model = self.dataArray[indexPath.row];
    WEAKSELf
    [cell configUI:model block:^(NSInteger index){
        GKBaoxiuController *vc = [[GKBaoxiuController alloc]init];
        vc.flag = index;
        vc.deviceModel = model;
        vc.stationName = weakSelf.stationModel.station_name;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
