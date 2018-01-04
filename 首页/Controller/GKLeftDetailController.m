//
//  GKLeftDetailController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/16.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKLeftDetailController.h"
#import "GKDetailSection0Cell.h"
#import "GKDetailSection1Cell.h"
#import "GKDetailSection2Cell.h"
#import "GKDetailSection3Cell.h"
#import "GKPinglunCell.h"
#import "GKStateModel.h"
#import "GKPinglunModel.h"
#import "FMLocationManager.h"

@interface GKLeftDetailController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)UITableView *topTableView;
@property (nonatomic, strong)UITableView *bottomTableView;

@property (nonatomic, strong)GKStateModel *stateModel;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *supportCarArray;

@end

@implementation GKLeftDetailController

-(NSMutableArray *)supportCarArray{
    if(_supportCarArray == nil){
        _supportCarArray = [NSMutableArray array];
    }
    
    return _supportCarArray;
}

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, (self.view.fm_height-64)*2)];
    [self.view addSubview:self.containerView];
    
    [self createTopTableView];
}

-(void)createTopTableView{
    self.topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.containerView.fm_width, self.containerView.fm_height/2) style:UITableViewStylePlain];
    self.topTableView.delegate = self;
    self.topTableView.dataSource = self;
    self.topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.containerView addSubview:self.topTableView];
    
    UIView *footerVew = [[UIView alloc]init];
    footerVew.fm_size = CGSizeMake(self.topTableView.fm_width, 40);
    UILabel *label = [UILabel labelWithTitle:@"向上拖动查看评论" fontSize:14.0f textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightLight];
    label.center = footerVew.fm_boundsCenter;
    [footerVew addSubview:label];
    self.topTableView.tableFooterView = footerVew;
    
    RegisterCell(self.topTableView, GKDetailSection0Cell);
    RegisterCell(self.topTableView, GKDetailSection1Cell);
    RegisterCell(self.topTableView, GKDetailSection2Cell);
    RegisterCell(self.topTableView, GKDetailSection3Cell);

    [self requestData];
}

-(void)createBottomTableView{
    self.bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.containerView.fm_height/2, self.containerView.fm_width, self.containerView.fm_height/2) style:UITableViewStylePlain];
    self.bottomTableView.backgroundColor = [UIColor colorWithHex:TableBackground_Color];
    self.bottomTableView.delegate = self;
    self.bottomTableView.dataSource = self;
    self.bottomTableView.tableFooterView = [[UIView alloc]init];
    [self.containerView addSubview:self.bottomTableView];
    
    RegisterCell(self.bottomTableView, GKPinglunCell);
    
    [self requestPinglunData];
}

-(void)requestData{
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.topTableView];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getStationById" parameters:@{@"user_id":@"0", @"station_id":self.stationModel.station_id} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            self.stateModel = [[GKStateModel alloc]init];
            [self.stateModel setValuesForKeysWithDictionary:responseObject];
            
            [self.supportCarArray addObjectsFromArray:responseObject[@"car_list"]];
            
            [self.topTableView reloadData];
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(void)requestPinglunData{
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.bottomTableView];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getCommentList" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"station_id":self.stationModel.station_id} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            id comment_list = responseObject[@"comment_list"];
            if([comment_list isKindOfClass:[NSArray class]]){
                NSArray *array = comment_list;
                for(NSDictionary *dict in array){
                    
                    GKPinglunModel *model = [[GKPinglunModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
                
                [self.bottomTableView reloadData];
            }
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.topTableView){
        return 4;
    }else if (tableView == self.bottomTableView){
        return 1;
    }
    
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.topTableView){
        
        if(section == 2)
            return 6;
        
        return 1;
    }else if (tableView == self.bottomTableView){
        return self.dataArray.count;
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.topTableView){
        if(indexPath.section == 0){
            GKDetailSection0Cell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKDetailSection0Cell.class)];
            [cell configUI:self.stateModel];
            return cell;
        }else if (indexPath.section == 1){
            GKDetailSection1Cell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKDetailSection1Cell.class)];
            [cell configUI:self.stateModel];
            return cell;
        }else if (indexPath.section == 2){
            GKDetailSection2Cell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKDetailSection2Cell.class)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch (indexPath.row) {
                case 0:
//                    [cell configLeft:@"支付方式" right:self.stateModel.pay_type];
                    [cell configLeft:@"支付方式" right:@"支付宝、账户余额、微信支付"];
                    break;
                case 1:
                    [cell configLeft:@"充电价格" right:[NSString stringWithFormat:@"电费%.2f元/度  服务费%.2f元/度", [self.stateModel.free_price floatValue], [self.stateModel.free_service floatValue]]];
                    break;
                case 2:
                    [cell configLeft:@"站点所有方" right:self.stateModel.station_owner];
                    break;
                case 3:
                {
                    NSInteger parking_fee = [self.stateModel.parking_free integerValue];
                    [cell configLeft:@"停车费" right:parking_fee==0?@"免费停车":@"停车收费"];
                }
                    break;
                case 4:
                    [cell configLeft:@"营业时间" right:self.stateModel.business_time];
                    break;
                case 5:
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    [cell configLeft:@"服务电话" right:self.stateModel.service_phone];
                    break;
                default:
                    break;
            }
            return cell;
            
        }else if (indexPath.section == 3){
            GKDetailSection3Cell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKDetailSection3Cell.class)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configUI:self.supportCarArray];
            return cell;
        }

        
    }else if (tableView == self.bottomTableView){
        
        GKPinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKPinglunCell.class)];
        GKPinglunModel *model = self.dataArray[indexPath.row];
        [cell configUI:model];
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 3){
        return 40.0f;
    }
    
    return .0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 3){
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.fm_width, 40)];
        
        UILabel *label = [UILabel labelWithTitle:@"支持充电车型" fontSize:14.0f textColor:[UIColor colorWithHex:LightText_Color] textWeight:UIFontWeightRegular];
        label.frame = bgView.bounds;
        label.fm_left = 10;
        [bgView addSubview:label];
        
        return bgView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.topTableView){
        if(indexPath.section == 0){
            return 170;
        }else if (indexPath.section == 1){
            return [GKDetailSection1Cell heightForModel:self.stateModel];
        }else if (indexPath.section == 2){
            return 50;
        }else if (indexPath.section == 3){
            return (self.topTableView.fm_width-50) / 4 + 40;
        }
    }else if(tableView == self.bottomTableView){
        return 100;
    }
    
    return .0f;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView == self.topTableView){
        if(scrollView.contentOffset.y > (MAX(scrollView.contentSize.height, scrollView.fm_height) - scrollView.fm_height + 100) ){
            
            if(self.bottomTableView == nil){
                [self createBottomTableView];
            }
            
            [UIView animateWithDuration:0.3f animations:^{
                self.containerView.fm_bottom = self.containerView.fm_height/2;
            }];
        }
    }else if (scrollView == self.bottomTableView){
        if(scrollView.contentOffset.y < -60){
            [UIView animateWithDuration:0.3f animations:^{
                self.containerView.fm_top = 0;
            }];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1){ //去导航
        if(self.stateModel.station_lat && self.stateModel.station_lon){
            [[FMLocationManager sharedManager]doNavigationWithEndLocation:@[self.stateModel.station_lat, self.stateModel.station_lon] atController:self];
        }
    }else if(indexPath.section == 2 && indexPath.row == 5){ //打电话
        
        if(self.stateModel.service_phone && ![self.stateModel.service_phone isKindOfClass:[NSNull class]] && self.stateModel.service_phone.length > 0){
            NSString* str=[NSString stringWithFormat:@"telprompt://%@", self.stateModel.service_phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
