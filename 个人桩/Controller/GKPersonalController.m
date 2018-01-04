//
//  GKPersonalController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/14.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPersonalController.h"
#import "GKPersonDetailController.h"
#import "GKSimpleCell.h"
#import "GKButtonsView.h"
#import "GKSortView.h"
#import "GKPersonalZhanController.h"
#import "GKStateModel.h"
#import "FMLocationManager.h"

@interface GKPersonalController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_sortArrays;
    NSInteger _tab0;
    NSInteger _tab1;
    NSInteger _tab2;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)GKSortView *sortView;
@property (nonatomic, strong)UIView *noneView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation GKPersonalController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(GKSortView *)sortView{
    if(_sortView == nil){
        _sortView = [[GKSortView alloc]initWithFrame:self.tableView.bounds];
    }
    
    return _sortView;
}

-(void)createRightView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(self.fm_navigationBar.fm_width-80, 20, 80, 44);
    [rightBtn setTitle:@"申请建站" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:rightBtn];
}

-(void)createLeftView{
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitle = @"个人桩";
    
    [self createTableView];
    
    [self requestDataCity:_sortArrays[0][0] sort:@"1"];
}

-(void)createTableView{
    _sortArrays = @[@[@"余杭区",@"萧山区", @"西湖区", @"滨江区"], @[@"由多到少", @"由少到多"], @[@"离我最近", @"离我最远"]];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.fm_y = self.fm_navigationBar.fm_height;
    _tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    _tableView.rowHeight = 50;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    RegisterNib(_tableView, GKSimpleCell);
}

-(void)requestDataCity:(NSString*)city sort:(NSString*)sort{
    
    CLLocationCoordinate2D locationCoor = [FMLocationManager sharedManager].location;
    
    //to do
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getPersonStationList" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"station_city":city, @"station_sort":sort, @"station_lon":[NSString stringWithFormat:@"%.6f", locationCoor.longitude], @"station_lat":[NSString stringWithFormat:@"%.6f", locationCoor.latitude]} successBlock:^(id responseObject) {
        
        [self.dataArray removeAllObjects];
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            id station_list = responseObject[@"station_list"];
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

-(void)addBtnAction{
    GKPersonDetailController *vc = [[GKPersonDetailController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
        return 1;
    
    return self.dataArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        WEAKSELf
        GKButtonsView *btnsView = [[GKButtonsView alloc]initWithFrame:CGRectMake(0, 0, tableView.fm_width, 50) data:@[_sortArrays[0][_tab0], _sortArrays[1][_tab1], _sortArrays[2][_tab2]] images:@[@"fill_down_arrow", @"fill_down_arrow", @"fill_down_arrow"] action:^(NSInteger index, UIButton *btn) {
            
            if(btn.isSelected){
                weakSelf.tableView.scrollEnabled = NO;
                weakSelf.sortView.hidden = NO;
                [weakSelf.sortView showData:_sortArrays[index] atX:index*weakSelf.view.fm_width/3 atY:weakSelf.tableView.fm_y+100 width:weakSelf.view.fm_width/3 toView:weakSelf.view disSelect:^(NSInteger tabIndex) {
                    
                    [btn setTitle:_sortArrays[index][tabIndex] forState:UIControlStateNormal];
                    
                    if(index == 0){
                        _tab0 = tabIndex;
                        [weakSelf requestDataCity:_sortArrays[0][tabIndex] sort:@"1"];
                    }else if (index == 1){
                        _tab1 = tabIndex;
                         [weakSelf requestDataCity:_sortArrays[0][_tab0] sort:[NSString stringWithFormat:@"%ld", tabIndex+1]];
                    }else if (index == 2){
                        _tab2 = tabIndex;
                         [weakSelf requestDataCity:_sortArrays[0][_tab0] sort:[NSString stringWithFormat:@"%ld", tabIndex+3]];
                    }
                    
                    btn.selected = NO;
                    weakSelf.sortView.hidden = YES;
                    
                }];
            }else{
                weakSelf.tableView.scrollEnabled = YES;
                btn.selected = NO;
                weakSelf.sortView.hidden = YES;
            }
        }];
        btnsView.showMoveLine = NO;
        btnsView.backgroundColor = HEXCOLOR(0xDDECF6);
        for(UIButton *btn in btnsView.btnArray){
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.intrinsicContentSize.width + 20, 0, -btn.titleLabel.intrinsicContentSize.width);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.intrinsicContentSize.width, 0, btn.imageView.intrinsicContentSize.width);
        }
        return btnsView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 50;
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GKSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKSimpleCell.class)];
    if(indexPath.section == 0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configLeftTitle:@"所属站点（用户站点自命名）" rightTitle:@""];
    }else if (indexPath.section == 1){
        GKStateModel *model = self.dataArray[indexPath.row];
        [cell configLeftTitle:model.station_name rightTitle:nil];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKStateModel *model = self.dataArray[indexPath.row];
    if(indexPath.section == 1){
        GKPersonalZhanController *vc = [[GKPersonalZhanController alloc]init];
        vc.station_id = model.station_id;
        vc.station_name = model.station_name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
