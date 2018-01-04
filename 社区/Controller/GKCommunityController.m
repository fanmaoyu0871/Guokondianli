//
//  GKCommunityController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/14.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKCommunityController.h"
#import "GKButtonsView.h"
#import "GKTopicController.h"
#import "GKDynamicController.h"
#import "GKPublishController.h"
#import "GKNavigationController.h"
#import "GKChatView.h"
#import "GKDynamicModel.h"

@interface GKCommunityController ()

@property (nonatomic, strong)GKTopicController *topicVC;
@property (nonatomic, strong)GKDynamicController *pinglunVC;
@property (nonatomic, strong)GKDynamicController *dynamicVC;

@property (nonatomic, strong)GKChatView *chatView;
@property (nonatomic, strong)GKDynamicModel *pinglunModel;
@property (nonatomic, assign)NSInteger section;
@property (nonatomic, copy)NSString *sendType;
@property (nonatomic, assign)NSInteger tabIndex;

@end

@implementation GKCommunityController


-(void)createRightView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(self.fm_navigationBar.fm_width-60, 20, 60, 44);
    [rightBtn setImage:[[UIImage imageNamed:@"edit"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:rightBtn];
}

-(void)editBtnAction{
    GKPublishController *vc = [[GKPublishController alloc]init];
    GKNavigationController *navVC = [[GKNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
}

-(void)createLeftView{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHadShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHadHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginEditAction:) name:@"beginEdit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endEditAction) name:@"endEdit" object:nil];

}

-(void)beginEditAction:(NSNotification*)noti{
    NSDictionary *dict = noti.object;
    self.pinglunModel = dict[@"model"];
    self.section = [dict[@"section"] integerValue];
    self.sendType = dict[@"type"];
    [self.chatView becomeResponse];
}

-(void)endEditAction{
    [self.chatView cancelResponse];
    [self.chatView cleanContent];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)keyboardHadShow:(NSNotification*)notification{
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    [self.chatView cleanContent];
    WEAKSELf
    [UIView animateWithDuration:duration animations:^{
        self.chatView.fm_bottom = keyboardFrame.origin.y;
        self.chatView.changeBlock = ^{
            weakSelf.chatView.fm_bottom = keyboardFrame.origin.y;
        };
    }];
    
}

-(void)keyboardHadHide:(NSNotification*)notification{
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.chatView.fm_top = ScreenHeight;
    }];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)sendData:(NSString*)text{
    if(self.pinglunModel){
        
        [self.tabIndex == 1?self.pinglunVC:self.dynamicVC pinglunReqModel:self.pinglunModel content:text type:@"1" section:self.section sendType:self.sendType];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"社区";
    
    WEAKSELf
    self.chatView = [[GKChatView alloc]initWithFrame:CGRectMake(0, ScreenHeight, self.view.fm_width, 50)];
    self.chatView.sendBlock = ^(NSString *text) {
        [weakSelf sendData:text];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.chatView];
    
    GKButtonsView *buttonsView = [[GKButtonsView alloc]initWithFrame:CGRectMake(0, 64, self.view.fm_width, 44) data:@[@"热门话题", @"最新评论", @"热门动态"] images:nil action:^(NSInteger index, UIButton *btn) {
        weakSelf.tabIndex = index;
        if(index == 0){
            if(weakSelf.topicVC == nil){
                weakSelf.topicVC = [[GKTopicController alloc]init];
                weakSelf.topicVC.view.fm_top = 64+44;
                weakSelf.topicVC.view.fm_height = weakSelf.view.fm_height - buttonsView.fm_bottom;
                [weakSelf.view addSubview:weakSelf.topicVC.view];
                
                [weakSelf addChildViewController:weakSelf.topicVC];
            }
            [weakSelf.view bringSubviewToFront:weakSelf.topicVC.view];
        }else if (index == 1){
            if(weakSelf.pinglunVC == nil){
                weakSelf.pinglunVC = [[GKDynamicController alloc]init];
                weakSelf.pinglunVC.type = TYPE_NEWEST;
                weakSelf.pinglunVC.view.fm_top = 64+44;
                weakSelf.pinglunVC.view.fm_height = weakSelf.view.fm_height - buttonsView.fm_bottom;
                [weakSelf.view addSubview:weakSelf.pinglunVC.view];
                
                [weakSelf addChildViewController:weakSelf.pinglunVC];
            }
            [weakSelf.view bringSubviewToFront:weakSelf.pinglunVC.view];
        }else if (index == 2){
            if(weakSelf.dynamicVC == nil){
                weakSelf.dynamicVC = [[GKDynamicController alloc]init];
                weakSelf.dynamicVC.type = TYPE_HOSTEST;
                weakSelf.dynamicVC.view.fm_top = 64+44;
                weakSelf.dynamicVC.view.fm_height = weakSelf.view.fm_height - buttonsView.fm_bottom;
                [weakSelf.view addSubview:weakSelf.dynamicVC.view];
                
                [weakSelf addChildViewController:weakSelf.dynamicVC];
            }
            [weakSelf.view bringSubviewToFront:weakSelf.dynamicVC.view];
        }
    }];
    [self.view addSubview:buttonsView];
    
    [buttonsView pressAtIndex:0];
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
