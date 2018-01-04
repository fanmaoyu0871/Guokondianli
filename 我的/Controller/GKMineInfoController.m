//
//  GKMineInfoController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKMineInfoController.h"
#import "GKPersonalCell.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "GKNickController.h"
#import "YLBDatePicker.h"
#import "YLBPicker.h"
#import "HZAreaPickerView.h"
#import "GKChangePwdController.h"
#import "GKRealAuthController.h"
#import "GKBindPhoneController.h"

@interface GKMineInfoController ()<UITableViewDelegate, UITableViewDataSource, HZAreaPickerDelegate>
{
    NSArray *_leftTitles;
    NSArray *_leftImages;
    NSArray *_educations;
    NSArray *_incomes;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIImage *personalImage; //头像
@property (nonatomic, copy)NSString* nickName; // 昵称
@property (nonatomic, copy)NSString *birthday; //生日
@property (nonatomic, copy)NSString *city;   //居住城市
@property (nonatomic, copy)NSString* income; //收入
@property (nonatomic, copy)NSString* career; //职业
@property (nonatomic, copy)NSString* education; //学历
@property (nonatomic, copy)NSString* address; //地址

@end

@implementation GKMineInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"资料";
    
    _leftTitles = @[@[@"头像", @"昵称", @"生日", @"地址", @"学历", @"职业" , @"收入", @"居住城市"], @[@"实名认证", @"绑定手机", @"修改密码"]];
    _educations = @[@"博士", @"硕士", @"本科", @"大专", @"其他"];
    _incomes = @[@"40k以上", @"30k-40k", @"10k-30k", @"10k以下"];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.fm_top = self.fm_navigationBar.fm_height;
    _tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    RegisterNib(_tableView, GKPersonalCell.class);
    
    [self requestData];
}

-(void)requestData{
    GKProgressHUD *hud = [GKProgressHUD showAtView:_tableView];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getPersonInfo" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"]} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = responseObject;
            self.personalImage = dict[@"pic"];
            if(self.personalImage && ![self.personalImage isKindOfClass:[NSNull class]]){
                [FMUserDefault setObject:self.personalImage forKey:@"user_pic"];
            }
            self.nickName = dict[@"name"];
            if(self.nickName){
                [FMUserDefault setObject:self.nickName forKey:@"user_name"];
            }
            self.birthday = dict[@"birthday"];
            self.city = dict[@"city"];
            self.income = dict[@"income"];
            self.career = dict[@"profession"];
            self.education = dict[@"education"];
            self.address = dict[@"address"];
            
            [self.tableView reloadData];
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _leftTitles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_leftTitles[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0)
        return 60.0f;
    
    return 44.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKPersonalCell.class)];
    switch (indexPath.row) {
        case 0:
            if(indexPath.section == 0){
                [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:@"" rightImage:self.personalImage];
            }else{
                [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:@"" rightImage:nil];
            }
            break;
        case 1:
            if(indexPath.section == 0){
                [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:self.nickName rightImage:nil];
            }else{
                [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:@"" rightImage:nil];
            }
            break;
        case 2:
            if(indexPath.section == 0){
                [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:self.birthday rightImage:nil];
            }else{
                [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:@"" rightImage:nil];
            }
            break;
        case 3:
            [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:self.address rightImage:nil];
            break;
        case 4:
            [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:self.education rightImage:nil];
            break;
        case 5:
            [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:self.career rightImage:nil];
            break;
        case 6:
            [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:self.income rightImage:nil];
            break;
        case 7:
            [cell configLeftTitle:_leftTitles[indexPath.section][indexPath.row] leftImage:nil rightTitle:self.city rightImage:nil];
            break;
        default:
            break;
    }
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        UIView *bgView = [[UIView alloc]initWithBackgroundColor:[UIColor colorWithHex:TableBackground_Color]];
        return bgView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 20.0f;
    }
    
    return .0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELf
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0: //头像
            {
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
                imagePickerVc.allowCrop = YES;
                imagePickerVc.cropRect = CGRectMake(0, (ScreenHeight-ScreenWidth)/2, ScreenWidth, ScreenWidth);
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    if(photos.count == 1){
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"data"] = UIImageJPEGRepresentation(photos[0], 1.0);
                        dic[@"filename"] = [assets[0] valueForKey:@"filename"];
                        weakSelf.personalImage = photos[0];
                        [FMUserDefault setObject:photos[0] forKey:@"user_pic"];
                        [weakSelf requestParam:nil multipart:@{@"pic":@[dic]}];
                    }
                    
                }];
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }
                break;
            case 1: //昵称
            {
                GKNickController *vc = [[GKNickController alloc]init];
                vc.type = TYPE_NICK;
                vc.modifyBlock = ^(NSString *text) {
                    self.nickName = text;
                    [FMUserDefault setObject:self.nickName forKey:@"user_name"];
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2: //生日
            {
                [YLBDatePicker showPickerType:UIDatePickerModeDate LeftTitle:@"取消" leftAction:nil rightTitle:@"确定" rightAction:^(NSDate *date) {
                    NSDateFormatter *fm = [[NSDateFormatter alloc]init];
                    fm.dateFormat = @"yyyy-MM-dd";
                    weakSelf.birthday = [fm stringFromDate:date];
                    [weakSelf requestParam:@{@"birthday":weakSelf.birthday} multipart:nil];
                } limitDate:nil];
            }
                break;
            case 3: //地址
            {
                GKNickController *vc = [[GKNickController alloc]init];
                vc.type = TYPE_ADDESS;
                vc.modifyBlock = ^(NSString *text) {
                    self.address = text;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4: //学历
            {
                [YLBPicker showData:_educations leftTitle:@"取消" leftAction:nil rightTitle:@"确定" rightAction:^(NSInteger row) {
                    weakSelf.education = _educations[row];
                    [weakSelf requestParam:@{@"education":weakSelf.education} multipart:nil];
                }];
            }
                break;
            case 5: //职业
            {
                GKNickController *vc = [[GKNickController alloc]init];
                vc.type = TYPE_CAREER;
                vc.modifyBlock = ^(NSString *text) {
                    self.career = text;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 6: //收入
            {
                [YLBPicker showData:_incomes leftTitle:@"取消" leftAction:nil rightTitle:@"确定" rightAction:^(NSInteger row) {
                    weakSelf.income = _incomes[row];
                    [weakSelf requestParam:@{@"income":weakSelf.income} multipart:nil];
                }];
            }
                break;
            case 7: //居住城市
            {
                HZAreaPickerView *cityPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
                [cityPicker showInView:self.view];
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0: //实 名 认 证
            {
                GKRealAuthController *vc = [[GKRealAuthController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1: //绑定手机
            {
                GKBindPhoneController *vc = [[GKBindPhoneController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2: //修 改 密 码
            {
                GKChangePwdController *vc = [[GKChangePwdController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

-(void)requestParam:(NSDictionary*)params multipart:(NSDictionary*)multipart{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[FMUserDefault objectForKey:@"user_id"] forKey:@"user_id"];
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"modifyPersonInfo" multipartFormData:multipart progress:nil parameters:dict successBlock:^(id responseObject) {
        
        [self.tableView reloadData];

        [MBProgressHUD showText:@"修改成功 " to:self.view];
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCity) {
        
        self.city = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
        
        [self requestParam:@{@"city":self.city} multipart:nil];

        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
