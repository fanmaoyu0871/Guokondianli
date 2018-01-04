//
//  GKNickController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/23.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKNickController.h"

@interface GKNickController ()

@property (nonatomic, copy)NSString* phString;
@property (nonatomic, copy)NSString* content;

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UILabel *phLabel;
@property (nonatomic, strong)UITextField *textField;

@end

@implementation GKNickController

-(void)createRightView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(self.fm_navigationBar.fm_width-60, 20, 60, 44);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:rightBtn];
}

-(void)requestParam:(NSDictionary*)params{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[FMUserDefault objectForKey:@"user_id"] forKey:@"user_id"];
    
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"modifyPersonInfo" parameters:dict successBlock:^(id responseObject) {
        
        [MBProgressHUD showText:@"修改成功 " to:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(void)sureBtnAction{
    
    [self.textField resignFirstResponder];
    
    if(self.textField.text.length == 0){
        [MBProgressHUD showText:@"请输入内容" to:self.view];
        return;
    }
    
    if(self.type == TYPE_NICK){
        [self requestParam:@{@"name":self.textField.text}];
    }else if (self.type == TYPE_CAREER){
        [self requestParam:@{@"profession":self.textField.text}];
    }else if (self.type == TYPE_ADDESS){
        [self requestParam:@{@"address":self.textField.text}];
    }
    
    if(self.modifyBlock){
        self.modifyBlock(self.textField.text);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(20, self.fm_navigationBar.fm_bottom + 20, self.view.fm_width - 40, 50)];
    _bgView.layer.borderColor = HEXCOLOR(MainTheme_Color).CGColor;
    _bgView.layer.borderWidth = 1;
    [self.view addSubview:_bgView];
    
    self.phLabel = [UILabel labelWithTitle:@"" fontSize:16 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
    [_bgView addSubview:self.phLabel];

    
    self.textField = [[UITextField alloc]init];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:self.textField];
    
    if(self.type == TYPE_NICK){
        self.navTitle = @"修改昵称";
        self.phString = @"用户昵称:";
    }else if (self.type == TYPE_CAREER){
        self.navTitle = @"修改职业";
        self.phString = @"用户职业:";
    }else if (self.type == TYPE_ADDESS){
        self.navTitle = @"修改地址";
        self.phString = @"修改地址:";
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textField becomeFirstResponder];
    });
}

-(void)setPhString:(NSString *)phString{
    _phString = phString;
    self.phLabel.text = phString;
    [self.phLabel sizeToFit];
    
    self.phLabel.fm_left = 10;
    self.phLabel.fm_centerY = _bgView.fm_height / 2;
    
    self.textField.fm_height = _bgView.fm_height;
    self.textField.fm_width = _bgView.fm_width - self.phLabel.fm_right - 20;
    self.textField.fm_left = self.phLabel.fm_right + 10;
    self.textField.fm_centerY = _bgView.fm_height / 2;
}

-(void)setContent:(NSString *)content{
    _content = content;
    self.textField.text = content;
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
