//
//  GKChargeController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPayChargeController.h"
#import "GKFlowView.h"
#import "GKBaseTextField.h"
#import "GKPayCell.h"

@interface GKPayChargeController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_images;
    NSArray *_titles;
    NSArray *_subTitles;
    NSMutableArray *_selecteds;
}
@end

@implementation GKPayChargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"充值";
    
    _images = @[@"zhifubao", @"weixin"];
    _titles = @[@"支付宝支付", @"微信支付"];
    _subTitles = @[@"推荐已安装支付宝的用户使用", @"推荐已安装微信的用户使用"];
    _selecteds = [NSMutableArray arrayWithArray:@[@(YES), @(NO)]];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.fm_y = self.fm_navigationBar.fm_height;
    tableView.fm_height = self.view.fm_height - self.fm_navigationBar.fm_height;
    tableView.rowHeight = 60;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = [self createHeaderView];
    tableView.tableFooterView = [self createFooterView];
    [self.view addSubview:tableView];
    
    RegisterCell(tableView, GKPayCell);
    
}

-(UIView*)createFooterView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:16.0f titleColor:[UIColor whiteColor] title:@"充值"];
    [bgView addSubview:btn];
    btn.backgroundColor = [UIColor colorWithHex:MainTheme_Color];
    btn.fm_size = CGSizeMake(220, 40);
    btn.center = bgView.fm_boundsCenter;
    btn.layer.cornerRadius = 5;
    
    return bgView;
}

-(UIView*)createHeaderView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    
    UILabel *label = [UILabel labelWithTitle:@"充值金额" fontSize:16.0f textColor:[UIColor colorWithHex:NormalText_Color] textWeight:UIFontWeightMedium];
    [bgView addSubview:label];
    label.fm_leftTop = CGPointMake(10, 5);
    
    CGFloat flowView_H = 30;

    
    GKFlowView *flowView = [[GKFlowView alloc]initWithFrame:CGRectMake(0, flowView_H, ScreenWidth, 0) data:@[@"50元", @"100元", @"200元", @"500元", @"800元", @"1000元"] rowCount:3 itemSize:CGSizeMake(self.view.fm_width/3 - 20, 60) lineSpace:10 block:^(NSInteger index, UIButton *btn) {
        
    }];
    flowView.normalTitleColor = HEXCOLOR(MainTheme_Color);
    flowView.selectedTitleColor = HEXCOLOR(0xffffff);
    flowView.selectedBgColor = HEXCOLOR(MainTheme_Color);
    flowView.normalBgColor = HEXCOLOR(0xffffff);
    flowView.selectedBorderColor = HEXCOLOR(MainTheme_Color);
    flowView.normalBorderColor = HEXCOLOR(MainTheme_Color);
    [bgView addSubview:flowView];
    
    flowView_H += [flowView heightForData];
    
    GKBaseTextField *amountTf = [[GKBaseTextField alloc]init];
    amountTf.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular];
    amountTf.layer.borderWidth = 1;
    amountTf.layer.borderColor = HEXCOLOR(TableBackground_Color).CGColor;
    amountTf.fm_size = CGSizeMake(self.view.fm_width - 20, 40);
    amountTf.fm_top = flowView.fm_bottom + 20;
    amountTf.fm_left = 10;
    amountTf.keyboardType = UIKeyboardTypeDecimalPad;
    amountTf.placeholder = @"请输入充值数额";
    [bgView addSubview:amountTf];
    
    flowView_H += 60.0f;
    
    UILabel *customLabel = [UILabel labelWithTitle:@"当前余额：¥40.20" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
    customLabel.fm_leftTop = CGPointMake(10, amountTf.fm_bottom + 10);
    [bgView addSubview:customLabel];
    
    flowView_H += 30.0f;
    
    bgView.fm_height = flowView_H;
    
    return bgView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titles.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(0xffffff)];
        view.fm_size = CGSizeMake(tableView.fm_width, 60);
        UILabel *label = [UILabel labelWithTitle:@"选择支付方式" fontSize:16.0f textColor:[UIColor colorWithHex:NormalText_Color] textWeight:UIFontWeightMedium];
        [view addSubview:label];
        label.frame = view.bounds;
        label.fm_left = 10;
        return view;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 60;
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   if(indexPath.section == 0){
        GKPayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKPayCell.class)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configTitle:_titles[indexPath.row] subTitle:_subTitles[indexPath.row] leftImage:[UIImage imageNamed:_images[indexPath.row]] isSelected:[_selecteds[indexPath.row] boolValue]];
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for(NSInteger i = 0; i < _selecteds.count; i++){
        if(i == indexPath.row){
            _selecteds[i] = @(YES);
        }else{
            _selecteds[i] = @(NO);
        }
    }
    
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
