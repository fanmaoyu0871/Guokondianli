//
//  GKPersonDetailController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPersonDetailController.h"
#import "GKInputCell.h"
#import "HZAreaPickerView.h"

@interface GKPersonDetailController ()<UITableViewDelegate, UITableViewDataSource, HZAreaPickerDelegate>
@property (nonatomic, strong)NSMutableArray *xuliehaoArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString* name;
@property (nonatomic, copy)NSString* phone;
@property (nonatomic, copy)NSString* zhanName;

@property (nonatomic, copy)NSString* address;
@property (nonatomic, copy)NSString* province;
@property (nonatomic, copy)NSString* city;
@property (nonatomic, copy)NSString* area;
@property (nonatomic, copy)NSString* detailAddress;
@property (nonatomic, copy)NSString* commAddress;

@end

@implementation GKPersonDetailController

-(NSMutableArray *)xuliehaoArray{
    if(_xuliehaoArray == nil){
        _xuliehaoArray = [NSMutableArray array];
    }
    
    return _xuliehaoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"申请个人桩";
    
    [self.xuliehaoArray addObject:@""];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.fm_top = self.fm_navigationBar.fm_height;
    _tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc]init];
    footerView.fm_size = CGSizeMake(self.view.fm_width, 200);
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:[UIColor whiteColor] title:@"申请新桩"];
    sureBtn.fm_size = CGSizeMake(180.0f, 40.0f);
    sureBtn.center = footerView.fm_boundsCenter;
    sureBtn.layer.cornerRadius = 5;
    sureBtn.backgroundColor = HEXCOLOR(MainTheme_Color);
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sureBtn];
    _tableView.tableFooterView = footerView;
    
    RegisterCell(_tableView, GKInputCell.class);
}

-(void)sureBtnAction{
    
    if(!self.name || self.name.length <= 0){
        [MBProgressHUD showText:@"请填写联系人姓名" to:self.view];
        return;
    }
    
    if(!self.phone || self.phone.length <= 0){
        [MBProgressHUD showText:@"请填写联系方式" to:self.view];
        return;
    }
    
    if(!self.zhanName || self.zhanName.length <= 0){
        [MBProgressHUD showText:@"请填写站点名称" to:self.view];
        return;
    }
    
    if(!self.address || self.address.length <= 0){
        [MBProgressHUD showText:@"请选择安装地址" to:self.view];
        return;
    }
    
    if(!self.detailAddress || self.detailAddress.length <= 0){
        [MBProgressHUD showText:@"请填写详细地址" to:self.view];
        return;
    }
    
    if(!self.commAddress || self.commAddress.length <= 0){
        [MBProgressHUD showText:@"请填写通讯地址" to:self.view];
        return;
    }
    
    if([self.xuliehaoArray containsObject:@""]){
        [MBProgressHUD showText:@"请将序列号输入完整" to:self.view];
        return;
    }
    
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.xuliehaoArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [[YLBNetworkingManager sharedManager]PostMethod:@"applyPersonDevice" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"person_name":self.name, @"person_mobile":self.phone, @"station_name":self.zhanName, @"station_address":self.detailAddress, @"device_nums":[NSString stringWithFormat:@"%ld", self.xuliehaoArray.count], @"device_port":@"", @"code_list":str, @"person_address":self.commAddress, @"station_province":self.province, @"station_city":self.city, @"station_area":self.area?self.area:@""} successBlock:^(id responseObject) {
        [hud hideHUD];

        [MBProgressHUD showText:@"申请提交成功!" to:self.view];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });        
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 5;
    }else if (section == 1){
        return self.xuliehaoArray.count;
    }
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKInputCell.class)];
    WEAKSELf
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
            {
                [cell configUI:@"联系人姓名" phTitle:@"请输入申请人姓名" content:self.name image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                    weakSelf.name = text;
                }];
            }
                break;
            case 1:
            {
                
                [cell configUI:@"联系方式" phTitle:@"输入常用联系方式" content:self.phone image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                    weakSelf.phone = text;
                }];
            }
                break;
            case 2:
            {
                [cell configUI:@"站点名称" phTitle:@"输入新建站点名称" content:self.zhanName image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                    weakSelf.zhanName = text;
                }];
            }
                break;
            case 3:
            {
                [cell configUI:@"安装地址" phTitle:@"请选择" content:self.address image:[UIImage imageNamed:@"right_arrow"] canEdit:NO block:^{
                    [weakSelf.view endEditing: YES];
                    HZAreaPickerView *cityPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
                    [cityPicker showInView:self.view];
                } didEndEditBlock:nil];
            }
                break;
            case 4:
            {
                [cell configUI:@"详细地址" phTitle:@"请输入详细地址" content:self.detailAddress image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
                    weakSelf.detailAddress = text;
                }];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        [cell configUI:indexPath.row == 0?@"序列号":@"" phTitle:@"输入序列号" content:self.xuliehaoArray[indexPath.row] image:[UIImage imageNamed:indexPath.row == 0?@"addxuliehao":@"subxuliehao"] canEdit:YES block:^{
            if(indexPath.row != 0){
                [weakSelf.xuliehaoArray removeObjectAtIndex:indexPath.row];
            }else{
                [weakSelf.xuliehaoArray addObject:@""];
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        } didEndEditBlock:^(NSString *text){
            if(text.length > 0){
                 [self.xuliehaoArray replaceObjectAtIndex:indexPath.row withObject:text];
            }
        }];
    }else if(indexPath.section == 2){
        [cell configUI:@"通讯地址" phTitle:@"输入常驻地址" content:self.commAddress image:nil canEdit:YES block:nil didEndEditBlock:^(NSString *text){
            weakSelf.commAddress = text;
        }];
    }
    
    return cell;
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.address = [NSString stringWithFormat:@"%@%@%@", picker.locate.state, picker.locate.city, picker.locate.district];
        
        self.province = picker.locate.state;
        self.city = picker.locate.city;
        self.area = picker.locate.district;

        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
