//
//  GKDetailController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/15.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKDetailController.h"
#import "GKLeftDetailController.h"
#import "GKRightDetailController.h"

@interface GKDetailController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIView *moveLine;
@property (nonatomic, strong)UIButton *navbar_leftBtn;
@property (nonatomic, strong)UIButton *navbar_rightBtn;
@property (nonatomic, strong)UIView *left_container;
@property (nonatomic, strong)UIView *right_container;

@property (nonatomic, strong)GKRightDetailController *rightDetailVC;
@property (nonatomic, strong)GKLeftDetailController *leftDetailVC;

@property (nonatomic, strong)UIScrollView *scrollView;

@end

@implementation GKDetailController

-(void)createRightView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(self.fm_navigationBar.fm_width-60, 20, 60, 44);
    [rightBtn setTitle:@"地图" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [self.fm_navigationBar addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)rightBtnAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)navbarBtnAction:(UIButton*)btn{
    
    [UIView animateWithDuration:0.3f animations:^{
        self.moveLine.fm_centerX = btn.fm_centerX;
    }];
    
    btn.selected = YES;

    if(btn == self.navbar_leftBtn){
        self.navbar_rightBtn.selected = NO;
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        
        if(self.leftDetailVC == nil){
            self.leftDetailVC = [[GKLeftDetailController alloc]init];
            self.leftDetailVC.stationModel = self.stationModel;
            [self.scrollView addSubview:self.leftDetailVC.view];
            
            [self addChildViewController:self.leftDetailVC];
        }
        
    }else{
        self.navbar_leftBtn.selected = NO;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.fm_width, 0) animated:YES];
        
        if(self.rightDetailVC == nil){
            self.rightDetailVC = [[GKRightDetailController alloc]init];
            self.rightDetailVC.stationModel = self.stationModel;
            self.rightDetailVC.view.fm_left = self.scrollView.fm_width;
            [self.scrollView addSubview:self.rightDetailVC.view];
            [self addChildViewController:self.rightDetailVC];
        }
    }
}

-(void)createTitleView{
    
    self.navbar_leftBtn = [UIButton buttonWithType:UIButtonTypeCustom image:nil fontSize:16.0f titleColor:HEXCOLOR(LightText_Color) title:@"充电站"];
    [self.navbar_leftBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateSelected];
    [self.navbar_leftBtn addTarget:self action:@selector(navbarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:self.navbar_leftBtn];
    self.navbar_leftBtn.fm_height = 30;
    self.navbar_leftBtn.fm_right = self.fm_navigationBar.fm_width / 2 - 30;
    self.navbar_leftBtn.fm_centerY = self.fm_navigationBar.fm_height / 2 + 10;
    
    self.navbar_rightBtn = [UIButton buttonWithType:UIButtonTypeCustom image:nil fontSize:16.0f titleColor:HEXCOLOR(LightText_Color) title:@"充电桩"];
    [self.navbar_rightBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateSelected];
    [self.navbar_rightBtn addTarget:self action:@selector(navbarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:self.navbar_rightBtn];
    self.navbar_rightBtn.fm_height = 30;
    self.navbar_rightBtn.fm_left = self.fm_navigationBar.fm_width / 2 + 30;
    self.navbar_rightBtn.fm_centerY = self.fm_navigationBar.fm_height / 2 + 10;

    self.moveLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(MainTheme_Color)];
    self.moveLine.fm_size = CGSizeMake(self.navbar_leftBtn.titleLabel.intrinsicContentSize.width, 2);
    self.moveLine.fm_bottom = self.fm_navigationBar.fm_height - 2;
    [self.fm_navigationBar addSubview:self.moveLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat singleViewH = self.view.fm_height - self.fm_navigationBar.fm_height;
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.fm_navigationBar.fm_height, self.view.fm_width, singleViewH)];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.fm_width * 2, self.scrollView.fm_height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    //选中第一个
    [self navbarBtnAction:self.navbar_leftBtn];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x == scrollView.fm_width){
        [self navbarBtnAction:self.navbar_rightBtn];
    }else if(scrollView.contentOffset.x == 0){
        [self navbarBtnAction:self.navbar_leftBtn];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
