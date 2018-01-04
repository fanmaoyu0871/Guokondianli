//
//  GKBaoxiuResultController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaoxiuResultController.h"
#import "GKBaoxiuInfoCell.h"

@interface GKBaoxiuResultController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation GKBaoxiuResultController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(void)requestData{
    
    if(!self.deviceId)
        return;
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getRepairList" parameters:@{@"device_id":self.deviceId} successBlock:^(id responseObject) {
        
        id repair_list = responseObject[@"repair_list"];
        
        if([repair_list isKindOfClass:[NSArray class]]){
            NSArray *array = repair_list;
            
            for(id obj in array){
                if([obj isKindOfClass:[NSDictionary class]]){
                    NSMutableArray *container = [NSMutableArray array];
                    NSDictionary *dict = obj;
                    [container addObject:[@{@"left":@"报修站点", @"right":dict[@"station_name"]} mutableCopy]];
                    [container addObject:[@{@"left":@"充电桩号码", @"right":dict[@"device_port"]} mutableCopy]];
                    [container addObject:[@{@"left":@"充电桩编号", @"right":dict[@"device_code"]} mutableCopy]];
                    [container addObject:[@{@"left":@"时间", @"right":dict[@"repair_time"]} mutableCopy]];
                    [container addObject:[@{@"left":@"处理结果", @"right":dict[@"repair_result"]} mutableCopy]];
                    
                    [self.dataArray addObject:container];
                }
            }
            
            [self.tableView reloadData];
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle = @"充电桩报修结果";
    
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.fm_y = self.fm_navigationBar.fm_height;
    self.tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.fm_width, 50)];
    UILabel *label = [UILabel labelWithTitle:@"历史报修记录单" fontSize:16.0f textColor:HEXCOLOR(MainTheme_Color) textWeight:UIFontWeightRegular];
    label.fm_left = 10;
    label.fm_centerY = headerView.fm_height / 2;
    [headerView addSubview:label];
    self.tableView.tableHeaderView = headerView;
    
    RegisterCell(self.tableView, GKBaoxiuInfoCell.class);
    
    [self requestData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GKBaoxiuInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKBaoxiuInfoCell.class)];
    NSArray *array = self.dataArray[indexPath.section];
    NSDictionary *dict = array[indexPath.row];
    [cell configUI:dict];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.fm_width, 50)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:HEXCOLOR(MainTheme_Color) title:@"查看详情"];
    [btn addTarget:self action:@selector(seeDetailBtnAction) forControlEvents:UIControlEventTouchUpInside];
    btn.fm_size = CGSizeMake(100, 30);
    btn.fm_right = bgView.fm_width - 10;
    btn.fm_centerY = bgView.fm_height / 2;
    btn.layer.cornerRadius = 2;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = HEXCOLOR(MainTheme_Color).CGColor;
    [bgView addSubview:btn];
    return bgView;
}

-(void)seeDetailBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
