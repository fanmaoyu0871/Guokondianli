//
//  GKTopicController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/17.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKTopicController.h"
#import "GKTopicCell.h"
#import "GKTopicModel.h"
#import "GKPublishController.h"
#import "GKNavigationController.h"

@interface GKTopicController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation GKTopicController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, self.view.fm_height) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44.0f;
    [self.view addSubview:_tableView];
    
    RegisterNib(_tableView, GKTopicCell);
    
    [self requestData];
}

-(void)requestData{
    GKProgressHUD *hud = [GKProgressHUD showAtView:_tableView];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getTopicList" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"]} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            id station_list = responseObject[@"topic_list"];
            if([station_list isKindOfClass:[NSArray class]]){
                NSArray *array = station_list;
                for(NSDictionary *dict in array){
                    GKTopicModel *model = [[GKTopicModel alloc]init];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKTopicCell.class)];
    GKTopicModel *model = self.dataArray[indexPath.row];
    [cell configUI:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKTopicModel *model = self.dataArray[indexPath.row];

    if(self.selectedBlock){
        self.selectedBlock(model);
    }else{
        GKPublishController *vc = [[GKPublishController alloc]init];
        vc.topicModel = model;
        GKNavigationController *navVC = [[GKNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}

@end
