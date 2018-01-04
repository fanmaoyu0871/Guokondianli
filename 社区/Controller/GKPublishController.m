//
//  GKPublishController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPublishController.h"
#import "YLBPhotoWall.h"
#import "TZImagePickerController.h"
#import "GKPersonalCell.h"
#import "GKTopicController.h"

@interface GKPublishController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIView *tableHeaderView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)YLBPhotoWall *photoWall;
@property (nonatomic, strong)UITextView *textView;

@end

@implementation GKPublishController

-(NSMutableArray *)photoArray{
    if(_photoArray == nil){
        _photoArray = [NSMutableArray array];
    }
    
    return _photoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"发动态";
    
    [self.photoArray addObject:@{@"image":[UIImage imageNamed:@"add_photo"]}];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.fm_navigationBar.fm_height, self.view.fm_width, self.view.fm_height-self.fm_navigationBar.fm_height) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44.0f;
    _tableView.tableHeaderView = [self createHeaderView];
    [self.view addSubview:_tableView];
    
    RegisterNib(_tableView, GKPersonalCell);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

-(void)createLeftView{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 20, 60, 44);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:HEXCOLOR(NormalText_Color) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:leftBtn];
}

-(void)cancelBtnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createRightView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(self.fm_navigationBar.fm_width-60, 20, 60, 44);
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(publishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:rightBtn];
}

-(void)publishBtnAction{
    
    [self.view endEditing:YES];
    
    NSString *user_id = [FMUserDefault objectForKey:@"user_id"];
    if(user_id){
        NSData *topicData = [NSJSONSerialization dataWithJSONObject:@[@"1"] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *topicString = [[NSString alloc]initWithData:topicData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *inputDict = [NSMutableDictionary dictionary];
        NSMutableArray *inputArray = [NSMutableArray array];
        NSMutableDictionary *fileInput = [NSMutableDictionary dictionary];
        NSInteger i = 1;
        
        //删除最后一个加号
        [self.photoArray removeLastObject];
        
        for(NSDictionary *dict in self.photoArray){
            [inputArray removeAllObjects];
            inputDict[@"data"] = UIImageJPEGRepresentation(dict[@"image"], 1.0);
            inputDict[@"filename"] = dict[@"picPath"];
            [inputArray addObject:inputDict];
            
            fileInput[[NSString stringWithFormat:@"picture%ld", i]] = inputArray;
            i++;
        }
        
        GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
        [[YLBNetworkingManager sharedManager]PostMethod:@"sendNewTalk" multipartFormData:fileInput progress:nil parameters:@{@"user_id":user_id, @"address":@"", @"content":self.textView.text, @"topic_list":topicString} successBlock:^(id responseObject) {
            
            [MBProgressHUD showText:@"发布动态成功" to:self.view];

            [hud hideHUD];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } failBlock:^(NSString *msg) {
            [hud hideHUD];
            [MBProgressHUD showText:msg to:self.view];
        }];
    }else{
        GKLoginController *vc = [[GKLoginController alloc]init];
        vc.loginFinishBlock = ^{
            [self publishBtnAction];
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
    

}

-(UIView*)createHeaderView{
    self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.fm_width, 250)];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, self.tableHeaderView.fm_width - 20, 100)];
    self.textView.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular];
    [self.tableHeaderView addSubview:self.textView];
    
    WEAKSELf
    self.photoWall = [[YLBPhotoWall alloc]initWithFrame:CGRectMake(10, self.textView.fm_bottom + 20, self.view.fm_width - 20, 0) addBlock:^{
        [weakSelf addPhoto];

    } delBlock:^(NSInteger index) {
        [weakSelf.photoArray removeObjectAtIndex:index];
        [weakSelf.photoWall showData:weakSelf.photoArray];
        weakSelf.tableHeaderView.fm_height = weakSelf.photoWall.fm_bottom + 20;
        weakSelf.tableView.tableHeaderView = weakSelf.tableHeaderView;
    }];
    self.photoWall.maxPicCount = 4;
    self.photoWall.direction = WALL_VERTICAL;
    [self.tableHeaderView addSubview:self.photoWall];
    
    [self.photoWall showData:self.photoArray];
    self.tableHeaderView.fm_height = weakSelf.photoWall.fm_bottom + 20;
    
    return self.tableHeaderView;
}

//添加照片，最多10张
-(void)addPhoto{
    WEAKSELf
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4-self.photoArray.count delegate:nil];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        if(photos.count == assets.count){
            for(int i = 0; i < photos.count; i++){
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"image"] = photos[i];
                dic[@"picPath"] = [assets[i] valueForKey:@"filename"];
                [weakSelf.photoArray insertObject:dic atIndex:0];
            }
            
            [weakSelf.photoWall showData:weakSelf.photoArray];
            weakSelf.tableHeaderView.fm_height = weakSelf.photoWall.fm_bottom + 20;
            weakSelf.tableView.tableHeaderView = weakSelf.tableHeaderView;
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKPersonalCell.class)];
    [cell configLeftTitle:self.topicModel?[NSString stringWithFormat:@"#%@#", self.topicModel.topic_content]:@"添加话题" leftImage:[UIImage imageNamed:@"pub_topic"] rightTitle:@"" rightImage:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        GKTopicController *vc = [[GKTopicController alloc]init];
        WEAKSELf
        vc.selectedBlock = ^(GKTopicModel *model) {
            weakSelf.topicModel = model;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
