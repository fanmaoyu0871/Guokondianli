//
//  GKPayController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/26.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPayController.h"
#import "GKPayCell.h"
#import "GKSimpleCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GKPayResultController.h"
#import "WXApi.h"

@interface GKPayController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_images;
    NSArray *_titles;
    NSArray *_subTitles;
    NSMutableArray *_selecteds;
}
@end

@implementation GKPayController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alipayResult:) name:Alipay_notification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpayResult:) name:Wxpay_notification object:nil];


    self.navTitle = @"支付订单";
    
    _images = @[@"qianbao", @"zhifubao", @"weixin"];
    _titles = @[@"钱包支付", @"支付宝支付", @"微信支付"];
    _subTitles = @[@"请确定钱包余额", @"推荐已安装支付宝的用户使用", @"推荐已安装微信的用户使用"];
    _selecteds = [NSMutableArray arrayWithArray:@[@(YES), @(NO), @(NO)]];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.fm_y = self.fm_navigationBar.fm_height;
    tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    tableView.rowHeight = 60;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    RegisterCell(tableView, GKPayCell);
    RegisterNib(tableView, GKSimpleCell);
    
    tableView.tableFooterView = [self createBottomView];
}


-(void)paySuccessful{
    [MBProgressHUD showText:@"支付成功" to:self.view];
    GKPayResultController *vc = [[GKPayResultController alloc]init];
    vc.order_id = self.order_id;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSMutableArray *vcArray =             [self.navigationController.viewControllers mutableCopy];
    if(vcArray.count >= 2){
        [vcArray removeObjectsInRange:NSMakeRange(1, vcArray.count - 2)];
    }
    [self.navigationController setViewControllers:vcArray];
}

//微信支付完成后通知回调
-(void)wxpayResult:(NSNotification*)noti{
    id resp = noti.object;

    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        
        switch(response.errCode){
            case WXSuccess:
            {
                NSLog(@"微信支付成功");
                [self paySuccessful];
            }
                break;
            default:
                NSLog(@"微信支付失败，retcode=%d",response.errCode);
                [MBProgressHUD showText:response.errCode == -2?@"支付取消":@"支付失败" to:self.view];
                break;
        }
    }
}

//支付宝支付完成后通知回调
-(void)alipayResult:(NSNotification*)noti{
    NSDictionary *resultDic = noti.object;
    
    NSInteger orderState=[resultDic[@"resultStatus"]integerValue];
    if (orderState==9000) {
        [self paySuccessful];
    }else{
        switch (orderState) {
            case 8000:
            {
                [MBProgressHUD showText:@"订单正在处理中" to:self.view];
            }
                break;
            case 4000:
            {
                [MBProgressHUD showText:@"订单支付失败" to:self.view];
            }
                break;
            case 6001:
            {
                [MBProgressHUD showText:@"订单取消" to:self.view];
            }
                break;
            case 6002:
            {
                [MBProgressHUD showText:@"网络连接出错" to:self.view];
            }
                break;
            default:
                break;
        }
        
    }
}

//调起微信支付
-(void)wxPay:(NSDictionary*)payInfo{
    PayReq *request = [[PayReq alloc] init];
    
    request.partnerId = payInfo[@"partnerid"];
    
    request.prepayId=  payInfo[@"prepayid"];
    
    request.package = payInfo[@"package"];
    
    request.nonceStr= payInfo[@"noncestr"];
    
    request.timeStamp= [payInfo[@"timestamp"] integerValue];
    
    request.sign= payInfo[@"sign"];
    
    [WXApi sendReq:request];
}

//确定支付按钮事件
-(void)sureBtnAction{
    
    if(!self.order_id || !self.amount)
        return;
    
    self.amount = @"0.01";
    
    NSMutableDictionary *params = [@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"order_id":self.order_id, @"price":self.amount} mutableCopy];
    
    NSInteger index = [_selecteds indexOfObject:@(YES)];
    NSString *method = @"payByWallet";
    if(index == 1){
        [params setObject:@"ALI" forKey:@"pay_type"];
        method = @"payByOther";
    }else if (index == 2){
        [params setObject:@"WX" forKey:@"pay_type"];
        method = @"payByOther";
    }
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:method parameters:params successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *dict = responseObject;
            
            if(index == 1){ //支付宝支付
                [[AlipaySDK defaultService] payOrder:dict[@"ali_order_info"] fromScheme:Alipay_scheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }else if (index == 2){ //微信支付
                [self wxPay:dict[@"wx_order_Info"]];
            }
        }else{//钱包支付成功
            [self paySuccessful];
        }
        
        [hud hideHUD];
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [FMDropToast showText:msg atView:self.view offset:CGPointMake(0, 20)];
    }];
}

-(UIView*)createBottomView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, 200)];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:[UIColor whiteColor] title:@"确认支付"];
    sureBtn.backgroundColor = HEXCOLOR(MainTheme_Color);
    sureBtn.layer.cornerRadius = 5;
    sureBtn.fm_size = CGSizeMake(250.0f, 40.0f);
    sureBtn.fm_top = 60;
    sureBtn.fm_centerX = bgView.fm_width / 2;
    [bgView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:[UIColor whiteColor] title:@"取消支付"];
    cancelBtn.backgroundColor = HEXCOLOR(TableBackground_Color);
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.fm_size = CGSizeMake(250.0f, 40.0f);
    cancelBtn.fm_top = sureBtn.fm_bottom + 30;
    cancelBtn.fm_centerX = bgView.fm_width / 2;
    [bgView addSubview:cancelBtn];
    
    return bgView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
        return 1;
    
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        UIView *view = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        view.fm_size = CGSizeMake(tableView.fm_width, 10);
        
        return view;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 10;
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        GKSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKSimpleCell.class)];
        cell.rightLabel.textColor = HEXCOLOR(0xD0021B);
        [cell configLeftTitle:@"充值金额：" rightTitle:[NSString stringWithFormat:@"¥%@", self.amount]];
        return cell;
    }else if(indexPath.section == 1){
        GKPayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKPayCell.class)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configTitle:_titles[indexPath.row] subTitle:_subTitles[indexPath.row] leftImage:[UIImage imageNamed:_images[indexPath.row]] isSelected:[_selecteds[indexPath.row] boolValue]];
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    for(NSInteger i = 0; i < _selecteds.count; i++){
        if(i == indexPath.row){
            _selecteds[i] = @(YES);
        }else{
            _selecteds[i] = @(NO);
        }
    }
    
    [tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
