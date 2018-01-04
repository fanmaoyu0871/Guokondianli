//
//  GKPingjiaController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/30.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPingjiaController.h"
#import "GKStarView.h"

@interface GKPingjiaController ()

@property (nonatomic, strong)UIView *hasPingjiaView;
@property (nonatomic, strong)UIView *pingjiaView;
@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong)GKStarView *starView;
@property (nonatomic, strong)UITextView *textView;

@end

@implementation GKPingjiaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HEXCOLOR(TableBackground_Color);
    
    self.navTitle = [self.order_type integerValue] == 1?@"查看评价":@"评价";
    
    if([self.order_type integerValue] == 1){
        [self createHasPingjiaView];
    }else{
        [self createPingjiaView];
    }
    
}

-(void)createHasPingjiaView{
    self.hasPingjiaView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.hasPingjiaView];
    
    self.starView = [[GKStarView alloc]initWithFrame:CGRectMake(0, self.fm_navigationBar.fm_height, self.view.fm_width, 100) type:self.order_type];
    [self.view addSubview:self.starView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.starView.fm_bottom + 20, self.view.fm_width, self.view.fm_height - self.starView.fm_bottom - 20)];
    bottomView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:bottomView];
    
    self.contentLabel = [UILabel labelWithTitle:@"" fontSize:14.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
    [bottomView addSubview:self.contentLabel];
}

-(void)createPingjiaView{
    self.pingjiaView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.pingjiaView];
    
    self.starView = [[GKStarView alloc]initWithFrame:CGRectMake(0, self.fm_navigationBar.fm_height, self.view.fm_width, 100) type:self.order_type];
    [self.view addSubview:self.starView];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.starView.fm_bottom + 20, self.view.fm_width, self.view.fm_height - self.starView.fm_bottom - 20)];
    bottomView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:bottomView];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, bottomView.fm_width - 20*2, 200)];
    grayView.backgroundColor = HEXCOLOR(0xFAFAFA);
    [bottomView addSubview:grayView];
    
    UILabel *label = [UILabel labelWithTitle:@"输入评价：" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
    [grayView addSubview:label];
    label.fm_leftTop = CGPointMake(10, 10);
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, label.fm_bottom + 10, grayView.fm_width - 20*2, grayView.fm_height - label.fm_bottom - 10 - 20)];
    self.textView.backgroundColor = HEXCOLOR(0xF0F0F0);
    [grayView addSubview:self.textView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:HEXCOLOR(0xffffff) title:@"提交"];
    submitBtn.fm_size = CGSizeMake(250.0f, 40.0f);
    submitBtn.fm_top = grayView.fm_bottom + 30;
    submitBtn.fm_centerX = grayView.fm_centerX;
    submitBtn.backgroundColor = HEXCOLOR(MainTheme_Color);
    submitBtn.layer.cornerRadius = 5;
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submitBtn];
}

-(void)submitAction{
    
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
