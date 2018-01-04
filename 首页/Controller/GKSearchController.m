//
//  GKSearchController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/21.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKSearchController.h"
#import "GKInputView.h"
#import "GKButtonsView.h"
#import "GKSearchCell.h"
#import "GKSortView.h"
#import "GKFilterView.h"
#import "GKDetailController.h"
#import "FMDropToast.h"
#import "GKDetailPopTransition.h"

@interface GKSearchController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)GKSortView *sortView;
@property (nonatomic, strong)GKFilterView *filterView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)GKButtonsView *buttonsView;
@end

@implementation GKSearchController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(void)setListArray:(NSArray *)listArray{
    _listArray = listArray;
    
    [self.dataArray addObjectsFromArray:listArray];
}

-(GKSortView *)sortView{
    if(_sortView == nil){
        _sortView = [[GKSortView alloc]initWithFrame:self.tableView.bounds];
    }
    
    return _sortView;
}

-(GKFilterView *)filterView{
    if(_filterView == nil){
        WEAKSELf
        _filterView = [[GKFilterView alloc]initWithFrame:self.tableView.bounds];
        _filterView.finishBlock = ^(NSDictionary *filterDict) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:filterDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *filterStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [weakSelf reqSearchKey:@"" sort:@"1" filter:filterStr];
            [weakSelf.buttonsView pressAtIndex:1];
        };
    }
    
    return _filterView;
}

-(void)createLeftView{
    
}

-(void)createRightView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(self.fm_navigationBar.fm_width-60, 20, 60, 44);
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:rightBtn];
}

-(void)cancelBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTitleView{
    UIView *view = [[UIView alloc]init];
    view.fm_size = CGSizeMake(self.fm_navigationBar.fm_width - 140, 30);
    view.center = CGPointMake(self.fm_navigationBar.fm_boundsCenter.x, self.fm_navigationBar.fm_boundsCenter.y + 10);
    [self.fm_navigationBar addSubview:view];
    view.layer.cornerRadius = view.fm_height / 2;
    view.layer.borderColor = [UIColor colorWithHex:0xCFCECE].CGColor;
    view.layer.borderWidth = .5f;
    
    WEAKSELf
    GKInputView *inputView = [[GKInputView alloc]initWithFrame:view.bounds leftImage:[UIImage imageNamed:@"search"] placeHolder:@"请输入目的地／电站名"];
    inputView.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
    inputView.hideLine = YES;
    inputView.returnKeyType = UIReturnKeySearch;
    inputView.returnBlock = ^(NSString *key) {
        [weakSelf reqSearchKey:key sort:@"" filter:@"{}"];
    };
    [view addSubview:inputView];
    
    [UIView animateWithDuration:0.5f animations:^{
        view.fm_left = 20;
        view.fm_width = self.fm_navigationBar.fm_width - 80;
        inputView.frame = view.bounds;
    } completion:^(BOOL finished) {
        //搜索页面弹起键盘
        if(!self.listArray){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [inputView becomeFirstResponder];
            });
        }
    }];
}

-(void)reqSearchKey:(NSString*)searchKey sort:(NSString*)sort filter:(NSString*)filter{
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getStationList" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"station_city":self.cityName?self.cityName:@"", @"station_lon":[NSString stringWithFormat:@"%.2f", self.locationCoor.longitude], @"station_lat":[NSString stringWithFormat:@"%.2f", self.locationCoor.latitude], @"search_key":searchKey, @"station_sort":sort, @"station_filter":filter} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            id station_list = responseObject[@"station_list"];
            if([station_list isKindOfClass:[NSArray class]]){
                NSArray *array = station_list;
                [self.dataArray removeAllObjects];
                
                for(NSDictionary *dict in array){
                    GKStateModel *model = [[GKStateModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
                
                [FMDropToast showText:[NSString stringWithFormat:@"筛选出 %ld 条相关结果", self.dataArray.count] atView:self.tableView];

                
                [self.tableView reloadData];
            }
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WEAKSELf
    self.buttonsView = [[GKButtonsView alloc]initWithFrame:CGRectMake(0, self.fm_navigationBar.fm_bottom, self.view.fm_width, 40) data:@[@"综合排序", @"筛   选"] images:nil action:^(NSInteger index, UIButton *btn) {
        [weakSelf.view endEditing:YES]; //隐藏所有键盘
        if(index == 0){
            if(btn.isSelected){
                weakSelf.filterView.hidden = YES;
                weakSelf.sortView.hidden = NO;

                NSArray *data = @[@"综合排序", @"离我最近", @"评分最高", @"价格最低"];
                [weakSelf.sortView showData:data atX:0 atY:weakSelf.tableView.fm_y width:weakSelf.view.fm_width toView:weakSelf.view disSelect:^(NSInteger index){

                    [weakSelf reqSearchKey:@"" sort:[NSString stringWithFormat:@"%ld", index+1] filter:@"{}"];
                    [btn setTitle:data[index] forState:UIControlStateNormal];
                    btn.selected = NO;
                    weakSelf.sortView.hidden = YES;

                }];
            }else{
                btn.selected = NO;
                weakSelf.sortView.hidden = YES;
            }


        }else if (index == 1){
            if(btn.isSelected){
                weakSelf.filterView.hidden = NO;
                weakSelf.sortView.hidden = YES;
                [weakSelf.filterView showAtY:weakSelf.tableView.fm_y toView:weakSelf.view];
            }else{
                btn.selected = NO;
                weakSelf.filterView.hidden = YES;
            }
        }
    }];
    self.buttonsView.showVerticalLine = YES;
    self.buttonsView.showMoveLine = NO;
    self.buttonsView.titleColor = HEXCOLOR(NormalText_Color);
    [self.view addSubview:self.buttonsView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.buttonsView.fm_bottom, self.view.fm_width, self.view.fm_height - self.buttonsView.fm_bottom) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    RegisterCell(self.tableView, GKSearchCell.class);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKSearchCell.class)];
    GKStateModel *model = self.dataArray[indexPath.row];
    [cell configUI:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKDetailController *vc = [[GKDetailController alloc]init];
    GKStateModel *model = self.dataArray[indexPath.row];
    vc.stationModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if(operation == UINavigationControllerOperationPop){
        return [[GKDetailPopTransition alloc]init];
    }

    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

