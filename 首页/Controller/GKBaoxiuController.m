//
//  GKBaoxiuController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaoxiuController.h"
#import "GKBaoxiuInfoCell.h"
#import "GKBaoxiuTextViewCell.h"
#import "GKBaoxiuResultCell.h"
#import "GKBaoxiuResultController.h"

@interface GKBaoxiuController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *historyArray;

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation GKBaoxiuController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(NSMutableArray *)historyArray{
    if(_historyArray == nil){
        _historyArray = [NSMutableArray array];
    }
    
    return _historyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"充电桩报修";
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.fm_y = self.fm_navigationBar.fm_height;
    self.tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    RegisterCell(self.tableView, GKBaoxiuInfoCell.class);
    RegisterCell(self.tableView, GKBaoxiuTextViewCell.class);
    RegisterCell(self.tableView, GKBaoxiuResultCell.class);
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.fm_width, 200)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:HEXCOLOR(0xffffff) title:@"确认报修"];
    [btn addTarget:self action:@selector(baoxiuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = HEXCOLOR(MainTheme_Color);
    btn.fm_size = CGSizeMake(180, 40);
    btn.center = footerView.fm_boundsCenter;
    btn.layer.cornerRadius = 2;
    [footerView addSubview:btn];
    self.tableView.tableFooterView = footerView;
    
    if(self.flag == 1){ //未报修
        [self.dataArray addObject:[@{@"left":@"报修站点", @"right":self.stationName} mutableCopy]];
        [self.dataArray addObject:[@{@"left":@"充电桩号码", @"right":self.deviceModel.device_port} mutableCopy]];
        [self.dataArray addObject:[@{@"left":@"充电桩编号", @"right":self.deviceModel.device_code} mutableCopy]];
        [self.dataArray addObject:[@{@"left":@"故障描述", @"right":@""} mutableCopy]];
        [self.dataArray addObject:[@{@"left":@"联系方式", @"right":@""} mutableCopy]];
        
        [self.tableView reloadData];

    }else{ //已报修
        [btn setTitle:@"查看历史保修结果" forState:UIControlStateNormal];
        
        [self requestData];
    }
}

-(void)baoxiuBtnAction:(UIButton*)btn{
    
    if(self.flag == 1){ //确认报修
        
    }
    else if(self.flag == 2){ //查看历史报修记录
        GKBaoxiuResultController *vc = [[GKBaoxiuResultController alloc]init];
        vc.deviceId = self.deviceModel.device_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)requestData{
    
    if(!self.deviceModel.repair_id)
        return;
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getRepairDetails" parameters:@{@"repair_id":self.deviceModel.repair_id} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = responseObject;
        
            [self.dataArray addObject:[@{@"left":@"报修站点", @"right":dict[@"station_name"]} mutableCopy]];
            [self.dataArray addObject:[@{@"left":@"充电桩号码", @"right":dict[@"device_port"]} mutableCopy]];
            [self.dataArray addObject:[@{@"left":@"充电桩编号", @"right":dict[@"device_code"]} mutableCopy]];
            [self.dataArray addObject:[@{@"left":@"故障描述", @"right":dict[@"content"]} mutableCopy]];
            [self.dataArray addObject:[@{@"left":@"联系方式", @"right":dict[@"phone"]} mutableCopy]];
            
            id result = dict[@"result_list"];
            if([result isKindOfClass:[NSArray class]]){
                [self.historyArray addObjectsFromArray:result];
            }
            
            [self.tableView reloadData];
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.fm_width, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc]initWithBackgroundColor:[UIColor colorWithHex: TableBackground_Color]];
    line.fm_size = CGSizeMake(bgView.fm_width, 1);
    line.fm_leftBottom = CGPointMake(0, bgView.fm_height);
    [bgView addSubview:line];
    
    UILabel *label = [UILabel labelWithTitle:section == 0?@"报修记录单":@"报修结果" fontSize:16 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
    [bgView addSubview:label];
    label.fm_left = 10;
    label.fm_centerY = bgView.fm_height / 2;
    
    return bgView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.flag == 2){
        return 2;
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1 && self.flag == 2){
        return self.historyArray.count;
    }
    
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
        NSDictionary *dict = self.dataArray[indexPath.row];

        if(indexPath.row == 3 || indexPath.row == 4){
            GKBaoxiuTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKBaoxiuTextViewCell.class)];
            cell.canEdit = self.flag == 1?YES:NO;
            [cell configUI:dict placeHolder:indexPath.row == 3?@"请尽量详细的描述充电桩的故障":@"输入联系方式"];
            return cell;
        }
        
        GKBaoxiuInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKBaoxiuInfoCell.class)];
        [cell configUI:dict];
        return cell;
    }else if (indexPath.section == 1){
        NSDictionary *dict = self.historyArray[indexPath.row];

        GKBaoxiuResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKBaoxiuResultCell.class)];
        [cell configUI:dict];
        return cell;
    }
    
    return [[UITableViewCell alloc]init];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 3){
        return 120;
    }
    
    return 50;
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
