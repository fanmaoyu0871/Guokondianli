//
//  GKNoneController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKNoneController.h"

@interface GKNoneController ()

@end

@implementation GKNoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"none"]];
    imageView.center = self.view.fm_boundsCenter;
    [self.view addSubview:imageView];
    
    UILabel *label =[UILabel labelWithTitle:@"您的报修申请已经提交，感谢您的反馈！三个工作日内我们的工作人员会及时处理。" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightLight];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    label.fm_top = imageView.fm_bottom + 10;
    label.fm_centerX = self.view.fm_width / 2;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:[UIColor whiteColor] title:@"查看处理结果"];
    [self.view addSubview:btn];
    btn.fm_size = CGSizeMake(180, 40);
    btn.fm_top = label.fm_bottom + 100;
    btn.fm_centerX = self.view.fm_width / 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
