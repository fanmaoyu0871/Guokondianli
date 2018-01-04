//
//  GKPersonalZhanController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/26.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPersonalZhanController.h"
#import "GKSimpleCell.h"
#import "GKButtonsView.h"
#import "GKSortView.h"
#import "GKPersonalZhanDetailController.h"
#import "GKDeviceModel.h"

@interface GKPersonalZhanController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_sortArrays;
    NSInteger _tab0;
    NSInteger _tab1;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)GKSortView *sortView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation GKPersonalZhanController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitle = @"查看个人桩";
    
    _sortArrays = @[@[@"由大到小", @"由小到大"], @[@"1  空闲", @"2  充电", @"3  损坏"]];
    
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
    
    [self requestDataSort:@"1"];
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
        GKButtonsView *btnsView = [[GKButtonsView alloc]initWithFrame:CGRectMake(0, 0, tableView.fm_width, 50) data:@[@"编号顺序", @"状态顺序"] images:@[@"fill_down_arrow", @"fill_down_arrow", @"fill_down_arrow"] action:^(NSInteger index, UIButton *btn) {
            
            if(btn.isSelected){
                weakSelf.tableView.scrollEnabled = YES;
                weakSelf.sortView.hidden = NO;
                [weakSelf.sortView showData:_sortArrays[index] atX:index*weakSelf.view.fm_width/2 atY:weakSelf.tableView.fm_y+100 width:weakSelf.view.fm_width/2 toView:weakSelf.view disSelect:^(NSInteger tabIndex) {
                    
                    if(index == 0){
                        [weakSelf requestDataSort:[NSString stringWithFormat:@"%ld", tabIndex+1]];
                    }else if (index == 1){
                        [weakSelf requestDataSort:[NSString stringWithFormat:@"%ld", tabIndex+3]];
                    }
                    
                    btn.selected = NO;
                    weakSelf.sortView.hidden = YES;
                    
                }];
            }else{
                weakSelf.tableView.scrollEnabled = NO;
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
        [cell configLeftTitle:[NSString stringWithFormat:@"所属站点 > %@", self.station_name] rightTitle:@""];
    }else if (indexPath.section == 1){
        GKDeviceModel *model = self.dataArray[indexPath.row];
        
        NSString *str = @"";
        if([model.device_status integerValue] == 1){
            str = @"空闲";
        }else if([model.device_status integerValue] == 2){
            str = @"充电中";
        }else if ([model.device_status integerValue] == 3){
            str = @"损坏";
        }
        [cell configLeftTitle:[NSString stringWithFormat:@"%@  %@", model.device_port, str] rightTitle:nil];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKDeviceModel *model = self.dataArray[indexPath.row];
    if(indexPath.section == 1){
        GKPersonalZhanDetailController *vc = [[GKPersonalZhanDetailController alloc]init];
        vc.device_id = model.device_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)requestDataSort:(NSString*)sort{
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getPersonDeviceList" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"station_id":self.station_id, @"device_sort":sort} successBlock:^(id responseObject) {
        
        [self.dataArray removeAllObjects];
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            id device_list = responseObject[@"device_list"];
            if([device_list isKindOfClass:[NSArray class]]){
                NSArray *array = device_list;
                
                for(NSDictionary *dict in array){
                    GKDeviceModel *model = [[GKDeviceModel alloc]init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
