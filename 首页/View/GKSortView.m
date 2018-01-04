//
//  GKFilterView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/21.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKSortView.h"
#import "GKPersonalCell.h"

@interface GKSortView()<UITableViewDataSource, UITableViewDelegate>
{
    void (^_didSelectBlock)(NSInteger index);
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *filterArray;
@end

@implementation GKSortView

-(NSMutableArray *)filterArray{
    if(_filterArray == nil){
        _filterArray = [NSMutableArray array];
    }
    
    return _filterArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.4f];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 0) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.bounces = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        self.tableView.backgroundColor = nil;
        self.tableView.tableFooterView = [[UIView alloc]init];
        
        RegisterNib(self.tableView, GKPersonalCell.class);
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _filterArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GKPersonalCell.class)];
    [cell configLeftTitle:_filterArray[indexPath.row] leftImage:nil rightTitle:@"" rightImage:nil];
    [cell hideRightArrow:YES];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_didSelectBlock){
        _didSelectBlock(indexPath.row);
    }
}


-(void)showData:(NSArray*)data atX:(CGFloat)x atY:(CGFloat)y width:(CGFloat)width toView:(UIView*)view disSelect:(void (^)(NSInteger index))selectBlock{
    
    _didSelectBlock = selectBlock;
    
    self.tableView.fm_width = width;
    
    [self.filterArray removeAllObjects];
    [self.filterArray addObjectsFromArray:data];
    [self.tableView reloadData];
    
    self.fm_top = y;
    self.tableView.fm_x = x;
    [view addSubview:self];
    [view bringSubviewToFront:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.fm_height = self.fm_height;
    } completion:^(BOOL finished) {
        
    }];
}


@end
