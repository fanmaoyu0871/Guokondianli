//
//  GKChargeController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/25.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKChargeController.h"
#import "GKTerminalInfoView.h"
#import "GKFlowView.h"
#import "GKBaseTextField.h"
#import "GKPayController.h"

@interface GKChargeController ()<UITextFieldDelegate>

@property (nonatomic, strong)UILabel *amountLabel;
@property (nonatomic, copy)NSString* order_id;
@property (nonatomic, strong)UISwitch *switcher;
@property (nonatomic, strong)GKBaseTextField *amountTf;
@property (nonatomic, strong)GKFlowView *flowView;
@end

@implementation GKChargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"充电设置";
    
    [self requestData];
}

-(void)requestData{
    
    if(!self.device_id)
        return;
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getChargeSettingInfo" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"device_id":self.device_id} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = responseObject;
            self.order_id = dict[@"order_id"];
            NSString *station_name = dict[@"station_name"];
            NSString *device_code = dict[@"device_code"];
            NSArray *price_list = dict[@"price_list"];

            
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
            scrollView.fm_y = self.fm_navigationBar.fm_height;
            scrollView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
            [self.view addSubview:scrollView];
            
            GKTerminalInfoView *infoView = [[GKTerminalInfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, 120)];
            [infoView configName:station_name no:[NSString stringWithFormat:@"编号：%@", device_code]];
            [scrollView addSubview:infoView];
            
            UIView *line = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
            line.frame = CGRectMake(0, infoView.fm_bottom, self.view.fm_width, 20);
            [scrollView addSubview:line];
            
            UILabel *label = [UILabel labelWithTitle:@"选择金额" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
            label.fm_leftTop = CGPointMake(10, line.fm_bottom + 10);
            [scrollView addSubview:label];
            
            UIView *labelLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
            labelLine.fm_size = CGSizeMake(self.view.fm_width - 20, 1);
            labelLine.fm_leftTop = CGPointMake(10, label.fm_bottom + 10);
            [scrollView addSubview:labelLine];
            
            WEAKSELf
            GKFlowView *flowView = [[GKFlowView alloc]initWithFrame:CGRectMake(0, labelLine.fm_bottom, self.view.fm_width, 0) data:price_list rowCount:3 itemSize:CGSizeMake(self.view.fm_width/3 - 20, 60) lineSpace:10 block:^(NSInteger index, UIButton *btn) {
                weakSelf.amountLabel.text = [NSString stringWithFormat:@"¥%ld", [btn.currentTitle integerValue]];
                [weakSelf.amountLabel sizeToFit];
            }];
            flowView.normalTitleColor = HEXCOLOR(MainTheme_Color);
            flowView.selectedTitleColor = HEXCOLOR(0xffffff);
            flowView.selectedBgColor = HEXCOLOR(MainTheme_Color);
            flowView.normalBgColor = HEXCOLOR(0xffffff);
            flowView.selectedBorderColor = HEXCOLOR(MainTheme_Color);
            flowView.normalBorderColor = HEXCOLOR(MainTheme_Color);
            [scrollView addSubview:flowView];
            flowView.fm_top = labelLine.fm_bottom + 10;
            flowView.fm_left = 0;
            self.flowView = flowView;
            
            UILabel *customLabel = [UILabel labelWithTitle:@"自定义金额" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
            customLabel.fm_leftTop = CGPointMake(10, flowView.fm_bottom + 10);
            [scrollView addSubview:customLabel];
            
            self.switcher = [[UISwitch alloc]init];
            [self.switcher addTarget:self action:@selector(switcherChanged:) forControlEvents:UIControlEventValueChanged];
            [scrollView addSubview:self.switcher];
            [self.switcher sizeToFit];
            self.switcher.fm_right = self.view.fm_width - 20;
            self.switcher.fm_centerY = customLabel.fm_centerY;
            
            self.amountTf = [[GKBaseTextField alloc]init];
            self.amountTf.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular];
            self.amountTf.layer.borderWidth = 1;
            self.amountTf.layer.borderColor = HEXCOLOR(TableBackground_Color).CGColor;
            self.amountTf.fm_size = CGSizeMake(self.view.fm_width - 20, 40);
            self.amountTf.fm_top = customLabel.fm_bottom + 20;
            self.amountTf.fm_left = 10;
            self.amountTf.keyboardType = UIKeyboardTypeNumberPad;
            self.amountTf.placeholder = @"请输入大于30的预付金额";
            self.amountTf.enabled = NO;
            self.amountTf.delegate = self;
            [scrollView addSubview:self.amountTf];
            
            UILabel *preLabel = [UILabel labelWithTitle:@"充电预付金额" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
            preLabel.fm_leftTop = CGPointMake(10, self.amountTf.fm_bottom + 20);
            [scrollView addSubview:preLabel];
            
            self.amountLabel = [UILabel labelWithTitle:@"¥0.00" fontSize:20 textColor:HEXCOLOR(0xD0021B) textWeight:UIFontWeightRegular];
            [scrollView addSubview:self.amountLabel];
            self.amountLabel.fm_right = self.view.fm_width - 20;
            self.amountLabel.fm_centerY = preLabel.fm_centerY;
            
            UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:20 titleColor:HEXCOLOR(MainTheme_Color) title:@"付款"];
            [payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
            payBtn.layer.cornerRadius = 18;
            payBtn.layer.borderColor = HEXCOLOR(MainTheme_Color).CGColor;
            payBtn.layer.borderWidth = 1;
            [scrollView addSubview:payBtn];
            payBtn.fm_size = CGSizeMake(100, 36);
            payBtn.fm_right = self.view.fm_right - 20;
            payBtn.fm_top = self.amountLabel.fm_bottom + 20;
            
            
            UIView *labelLine1 = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
            labelLine1.fm_size = CGSizeMake(self.view.fm_width - 20, 1);
            labelLine1.fm_leftTop = CGPointMake(10, payBtn.fm_bottom + 20);
            [scrollView addSubview:labelLine1];
            
            UILabel *insLabel = [UILabel
                                 labelWithTitle:@"预付款金额可以再\"我的钱包\"中查看，充电期间预付金额在APP的钱包中冻结状态，充电结束进行扣款，超出金额存储在钱包余额中。"
                                 fontSize:12.0f textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
            insLabel.numberOfLines = 0;
            [scrollView addSubview:insLabel];
            insLabel.fm_width = self.view.fm_width - 20;
            insLabel.fm_leftTop = CGPointMake(10, labelLine1.fm_bottom + 10);
            [insLabel sizeToFit];
            
            scrollView.contentSize = CGSizeMake(self.view.fm_width, insLabel.fm_bottom + 50);
        }
        
        [hud hideHUD];
        
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [FMDropToast showText:msg atView:self.view offset:CGPointMake(0, 20)];
    }];
}

-(void)switcherChanged:(UISwitch*)switcher{
    
    self.amountTf.text = @"";
    self.amountLabel.text = @"¥0.00";

    if(switcher.isOn){
        self.amountTf.enabled = YES;
        [self.flowView cancelAllBtn];
        [self.flowView enableAllBtn:NO];
        [self.amountTf becomeFirstResponder];
    }else{
        self.amountTf.enabled = NO;
        [self.flowView enableAllBtn:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.amountLabel.text = [NSString stringWithFormat:@"¥%ld", [textField.text integerValue]];
    [self.amountLabel sizeToFit];
    self.amountLabel.fm_right = self.view.fm_width - 20;
}

-(void)payBtnAction{
    
    NSString *amount = [self.amountLabel.text substringFromIndex:1];
    if([amount integerValue] == 0){
        [MBProgressHUD showText:@"请选择或者输入金额" to:self.view];
        return;
    }
    
    GKPayController *vc = [[GKPayController alloc]init];
    vc.amount = amount;
    vc.order_id = self.order_id;
    [self.navigationController pushViewController:vc animated:YES];
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
