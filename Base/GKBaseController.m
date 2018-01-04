//
//  GKBaseController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/10.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseController.h"

@interface GKBaseController ()
{
    UIView *_fm_navigationBar;
    BOOL _isTabbarHidden;
}

@property (nonatomic, strong)UILabel *fm_navTitleLabel;

@end

@implementation GKBaseController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    if(self.navigationController.viewControllers.count > 1){
        [self hideTabBar:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.navigationController.viewControllers.count == 1){
        [self showTabBar:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createLeftView];
    [self createRightView];
    [self createTitleView];
}

-(void)setShowNavBarLine:(BOOL)showNavBarLine{
    _showNavBarLine = showNavBarLine;
    
    if(showNavBarLine){
        self.fm_navigationBar.layer.borderWidth = 0.5;
        self.fm_navigationBar.layer.borderColor = [UIColor colorWithHex:TableBackground_Color].CGColor;
    }
}

-(UIView *)fm_navigationBar{
    if(_fm_navigationBar == nil){
        _fm_navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _fm_navigationBar.backgroundColor = [UIColor whiteColor];
        self.showNavBarLine = YES;
        [self.view addSubview:_fm_navigationBar];
    }
    
    return _fm_navigationBar;
}

-(void)createLeftView{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBtn setImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.fm_size = CGSizeMake(60, 44);
    leftBtn.fm_leftTop = CGPointMake(0, 20);
    [self.fm_navigationBar addSubview:leftBtn];
}

-(void)leftBtnAction{
    if(self.navigationController && self.navigationController.viewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)createRightView{
    
}

-(void)createTitleView{
    self.fm_navTitleLabel = [UILabel labelWithTitle:@"" fontSize:18.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightHeavy];
    [self.fm_navigationBar addSubview:self.fm_navTitleLabel];
}

-(void)setNavTitle:(NSString *)navTitle{
    _navTitle = navTitle;
    self.fm_navTitleLabel.text = navTitle;
    [self.fm_navTitleLabel sizeToFit];
    self.fm_navTitleLabel.center = CGPointMake(self.fm_navigationBar.fm_boundsCenter.x, self.fm_navigationBar.fm_boundsCenter.y + 10);
}

-(void)showNavigationBar:(BOOL)animated{
    if(animated){
        self.fm_navigationBar.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            self.fm_navigationBar.fm_top = 0;
        }];
    }else{
        self.fm_navigationBar.hidden = NO;
        self.fm_navigationBar.fm_top = 0;
    }
}

-(void)hideNavigationBar:(BOOL)animated{
    if(animated){
        [UIView animateWithDuration:0.3f animations:^{
            self.fm_navigationBar.fm_bottom = 0;
        } completion:^(BOOL finished) {
            self.fm_navigationBar.hidden = YES;
        }];
    }else{
        self.fm_navigationBar.hidden = YES;
        self.fm_navigationBar.fm_bottom = 0;
    }
}

-(void)hideTabBar:(BOOL)animated{
    if(animated){
        [UIView animateWithDuration:0.3f animations:^{
            self.tabBarController.tabBar.fm_top = ScreenHeight+30;
        } completion:^(BOOL finished) {
            self.tabBarController.tabBar.hidden = YES;
            _isTabbarHidden = YES;
        }];
    }else{
        self.tabBarController.tabBar.hidden = YES;
        self.tabBarController.tabBar.fm_top = ScreenHeight+30;
        _isTabbarHidden = YES;
    }
}

-(void)showTabBar:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    if(animated){
        [UIView animateWithDuration:0.3f animations:^{
            self.tabBarController.tabBar.fm_bottom = ScreenHeight;
        } completion:^(BOOL finished) {
            _isTabbarHidden = NO;
        }];
    }
}

-(BOOL)isTabbarHidden{
    return _isTabbarHidden;
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
