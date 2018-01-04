//
//  GKMineController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/14.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKMineController.h"
#import "GKPersonalCell.h"
#import "GKMineInfoController.h"
#import "GKMyPurseController.h"
#import "GKMyOrderController.h"
#import "GKTabBarController.h"

@interface GKMineController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_leftTitles;
    NSArray *_leftImages;
}
@property (nonatomic, strong)UIButton *headpicBtn;
@property (nonatomic, strong)UIButton *nameBtn;
@property (nonatomic, strong)UIImageView *headerImageView;

@end

@implementation GKMineController

-(void)createRightView{
}

-(void)createLeftView{
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    id pic = [FMUserDefault objectForKey:@"user_pic"];
    if([pic isKindOfClass:[UIImage class]]){
        [self.headpicBtn setBackgroundImage:pic forState:UIControlStateNormal];
    }else if([pic isKindOfClass:[NSString class]]){
        [self.headpicBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Prefix_Img_Host, pic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headerPlaceHolder"]];
    }else{
        [self.headpicBtn setBackgroundImage:[UIImage imageNamed:@"headerPlaceHolder"] forState:UIControlStateNormal];
    }
    
    NSString *name = [FMUserDefault objectForKey:@"user_name"];
    [self.nameBtn setTitle:name?name:@"登录" forState:UIControlStateNormal];
    [self.nameBtn sizeToFit];
    self.nameBtn.fm_top = self.headpicBtn.fm_bottom + 10;
    self.nameBtn.fm_centerX = self.headerImageView.fm_width / 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _leftTitles = @[@"我的钱包", @"我的订单", @"我的收藏", @"我的充电桩", @"我的预约", @"我的社区", @"设置"];
//    _leftImages = @[@"wodeqianbao", @"wodedingdan", @"wodeshoucang", @"wodechongdianzhuang", @"wodeyuyue", @"wodeshequ", @"wodeshezhi"];
    
    _leftTitles = @[@"我的钱包", @"我的订单",@"我的充电桩",@"我的社区"];
    _leftImages = @[@"wodeqianbao", @"wodedingdan", @"wodechongdianzhuang",  @"wodeshequ"];
    
    
    [self hideNavigationBar:NO];
    
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, 245.0f*self.view.fm_width/375.0f)];
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.image = [UIImage imageNamed:@"personal_bg"];
    self.headpicBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    self.headpicBtn.layer.cornerRadius = 45;
    self.headpicBtn.layer.masksToBounds = YES;
    self.headpicBtn.center = self.headerImageView.fm_boundsCenter;
    [self.headpicBtn setBackgroundImage:[UIImage imageNamed:@"headerPlaceHolder"] forState:UIControlStateNormal];
    [self.headpicBtn addTarget:self action:@selector(headPicBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerImageView addSubview:self.headpicBtn];
    
    
    self.nameBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:[UIColor whiteColor] title:@"登录"];
    self.nameBtn.userInteractionEnabled = NO;
    self.nameBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    self.nameBtn.fm_top = self.headpicBtn.fm_bottom + 10;
    self.nameBtn.fm_centerX = self.headerImageView.fm_width / 2;
    [self.headerImageView addSubview:self.nameBtn];
    
    [self.view addSubview:self.headerImageView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    tableView.fm_height = self.view.fm_height - 49 - self.headerImageView.fm_height;
//    tableView.fm_y = self.headerImageView.fm_bottom;
    tableView.contentInset = UIEdgeInsetsMake(self.headerImageView.fm_height, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    [self.view bringSubviewToFront:self.headerImageView];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    RegisterNib(tableView, GKPersonalCell.class);
}

-(void)headPicBtnAction{
    GKMineInfoController *vc = [[GKMineInfoController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _leftTitles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKPersonalCell.class)];
    [cell configLeftTitle:_leftTitles[indexPath.row] leftImage:[UIImage imageNamed:_leftImages[indexPath.row]] rightTitle:indexPath.row == 0?@"发票":@"" rightImage:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            GKMyPurseController *vc = [[GKMyPurseController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            GKMyOrderController *vc = [[GKMyOrderController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            GKTabBarController *tabbarVC = (GKTabBarController*)[UIApplication sharedApplication].delegate.window.rootViewController;
            [tabbarVC selectedAtIndex:2];
        }
            break;
        case 3:
        {
            GKTabBarController *tabbarVC = (GKTabBarController*)[UIApplication sharedApplication].delegate.window.rootViewController;
            [tabbarVC selectedAtIndex:1];
        }
            break;
        default:
            break;
    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f", scrollView.contentOffset.y);
//
//    scrollView.contentInset = UIEdgeInsetsMake(self.headerImageView.fm_height + scrollView.contentOffset.y, 0, 0, 0);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
