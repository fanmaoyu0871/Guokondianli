//
//  GKDynamicController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/17.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKDynamicController.h"
#import "GKDynamicCell.h"
#import "GKPinglunHeaderView.h"
#import "GKDynamicModel.h"

@interface GKDynamicController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSDateFormatter *_dateFormatter;
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *pinglunArray;
@end

@implementation GKDynamicController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(NSMutableArray *)pinglunArray{
    if(_pinglunArray == nil){
        _pinglunArray = [NSMutableArray array];
    }
    
    return _pinglunArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dateFormatter = [[NSDateFormatter alloc]init];
    _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, self.view.fm_height-64-44-49) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    RegisterCell(_tableView, GKDynamicCell);
    
    [self requestData];
}

-(void)requestData{
    GKProgressHUD *hud = [GKProgressHUD showAtView:_tableView];
    [[YLBNetworkingManager sharedManager]PostMethod:self.type==TYPE_NEWEST?@"getLatestCommentList":@"getHotCommentList" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"]} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            id comment_list = responseObject[@"comment_list"];
            if([comment_list isKindOfClass:[NSArray class]]){
                NSArray *array = comment_list;
                for(NSDictionary *dict in array){
                    GKDynamicModel *model = [[GKDynamicModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    
                    //解析时间
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]/1000];
                    NSString *time = [_dateFormatter stringFromDate: date];
                    model.time = time;
                    
                    //解析赞
                    id zan_list = dict[@"zanlist"];
                    if([zan_list isKindOfClass:[NSArray class]]){
                        NSMutableArray *zanArray = [NSMutableArray array];
                        for(NSDictionary *zan_dict in zan_list){
                            [zanArray addObject:zan_dict];
                        }
                        model.zan_list = zanArray;
                    }
                    
                    
                    //解析评论
                    id comment_sub_list = dict[@"comment_sub_list"];
                    if([comment_sub_list isKindOfClass:[NSArray class]]){
                        NSMutableArray *commentArray = [NSMutableArray array];
                        for(NSDictionary *comment_dict in comment_sub_list){
                            [commentArray addObject:comment_dict];
                        }
                        model.comment_sub_list = commentArray;
                    }
                    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    GKDynamicModel *model = self.dataArray[section];
    
    NSInteger count = 0;
    if(model.zan_list && model.zan_list.count >0){
        count += 1;
    }
    
    if(model.comment_sub_list){
        count += model.comment_sub_list.count;
    }
    
    return count;
}

//sendType == @"1" :点击评论按钮发送
//sendType == @"2" :点击cell发送
//sendType == @"3" :点赞发送，可忽略
-(void)pinglunReqModel:(GKDynamicModel*)model content:(NSString*)content type:(NSString*)type section:(NSInteger)section sendType:(NSString*)sendType{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"endEdit" object:nil];
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:_tableView];
    
    NSMutableDictionary *params = [@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"comment_id":model.comment_id, @"content":content, @"to_id":model.user_id, @"comment_type":type, @"replay_type":self.type == TYPE_NEWEST?@"1":@"2"} mutableCopy];
 
    [[YLBNetworkingManager sharedManager]PostMethod:@"replayComment" parameters:params successBlock:^(id responseObject) {
        
        if([type isEqualToString:@"1"]){
            NSMutableArray *array = [NSMutableArray arrayWithArray:model.comment_sub_list];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"from_id"] = [FMUserDefault objectForKey:@"user_id"];
            if([sendType isEqualToString:@"2"]){
                dict[@"to_id"] = model.user_id;
            }
            dict[@"from_name"] = [FMUserDefault objectForKey:@"user_name"];
            dict[@"to_name"] = model.user_name;
            dict[@"sub_content"] = content;
            [array addObject:dict];
            model.comment_sub_list = array;
            
            [self.tableView reloadData];
        }else{
            NSMutableArray *array = [NSMutableArray arrayWithArray:model.zan_list];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"from_id"] = [FMUserDefault objectForKey:@"user_id"];
            dict[@"from_name"] = [FMUserDefault objectForKey:@"user_name"];
            [array addObject:dict];
            model.zan_list = array;
            
            [self.tableView reloadData];
        }
        
        [MBProgressHUD showText:[type integerValue] == 2?@"点赞成功":@"评论成功" to:self.view];
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WEAKSELf
    GKPinglunHeaderView *headerView = [[GKPinglunHeaderView alloc]initWithFrame:CGRectMake(0, 0, tableView.fm_width, 300)];
    
    GKDynamicModel *model = self.dataArray[section];
    [headerView configUI:model zanBlock:^{
        [weakSelf pinglunReqModel:model content:@"" type:@"2" section:section sendType:@"3"];
    } pinglunBlock:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"beginEdit" object:@{@"model":model, @"section":[NSString stringWithFormat:@"%ld", section], @"type":@"1"}];
    }];
    return headerView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.fm_width, 20)];
    bgView.backgroundColor = HEXCOLOR(0xffffff);
    
    UIView *line = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
    line.fm_size = CGSizeMake(tableView.fm_width, 0.5);
    line.fm_bottom = bgView.fm_height - 0.5;
    line.fm_left = 0;
    [bgView addSubview:line];
    
    return bgView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKDynamicCell.class)];
    GKDynamicModel *model = self.dataArray[indexPath.section];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(70, 0, cell.fm_width-70, cell.fm_height)];
    cell.selectedBackgroundView.backgroundColor = HEXCOLOR(TableBackground_Color);
    if(indexPath.row == 0){
        if(model.zan_list && model.zan_list.count > 0){
            [cell configLeft:model.zan_list right:nil image:[UIImage imageNamed:@"zan"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if(model.comment_sub_list && model.comment_sub_list.count > 0){
            NSDictionary *dict = model.comment_sub_list[0];
            [cell configLeft:dict right:dict[@"sub_content"] image:[UIImage imageNamed:@"pinglun"]];
        }
    }else{
        NSDictionary *dict = model.comment_sub_list[indexPath.row-1];

        [cell configLeft:model.comment_sub_list[indexPath.row-1] right:dict[@"sub_content"] image:(indexPath.row-1==0)?[UIImage imageNamed:@"pinglun"]:nil];
    }


    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [GKPinglunHeaderView heightForModel:self.dataArray[section] contentWidth:tableView.fm_width - 70];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GKDynamicModel *model = self.dataArray[indexPath.section];
    if(indexPath.row == 0){
        if(model.zan_list && model.zan_list.count > 0){
            return [GKDynamicCell heightForZanModel:model];
        }else if(model.comment_sub_list && model.comment_sub_list.count > 0){
            NSDictionary *dict = model.comment_sub_list[0];
            return [GKDynamicCell heightForPinglunDict:dict];
        }
    }else{
        NSDictionary *dict = model.comment_sub_list[indexPath.row-1];
        return [GKDynamicCell heightForPinglunDict:dict];
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GKDynamicModel *model = self.dataArray[indexPath.section];
    if(indexPath.row == 0){
        if(model.zan_list && model.zan_list.count > 0){
            return;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //不是当前用户的评论
    NSInteger offset = (model.zan_list && model.zan_list.count > 0)?1:0;
    NSDictionary *dict = model.comment_sub_list[indexPath.row - offset];
    if([dict[@"from_id"] integerValue] != [[FMUserDefault objectForKey:@"user_id"] integerValue])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"beginEdit" object:@{@"model":model, @"section":[NSString stringWithFormat:@"%ld", indexPath.section], @"type":@"2"}];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
