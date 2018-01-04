//
//  YLBPhotoWall.m
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/28.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "YLBPhotoWall.h"

#define photoCellID @"photoCellID"

@interface YLBPhotoCell:UICollectionViewCell
-(void)configUI:(id)source index:(NSInteger)index showDelete:(BOOL)isShow delBlock:(DelPhotoBlock)delBlock;
@end

@interface YLBPhotoCell()
@property (nonatomic, strong)UIImageView *centerImageView;
@property (nonatomic, strong)UIButton *deleteBtn;
@property (nonatomic, copy)DelPhotoBlock delBlock;
@property (nonatomic, assign)NSInteger index;

@end
@implementation YLBPhotoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.centerImageView = [[UIImageView alloc]init];
        self.centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.centerImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.centerImageView];
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:[UIImage imageNamed:@"delete_photo"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)layoutSubviews{
    self.centerImageView.frame = self.contentView.bounds;
    [self.deleteBtn sizeToFit];
    self.deleteBtn.fm_rightTop = self.centerImageView.fm_rightTop;
}
-(void)configUI:(NSDictionary*)source index:(NSInteger)index showDelete:(BOOL)isShow delBlock:(DelPhotoBlock)delBlock{
    self.index = index;
    self.delBlock = delBlock;
    
    UIImage *image = [source objectForKey:@"image"];
    
    if(image){
        self.centerImageView.image = image;
    }else{
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Prefix_Img_Host, source[@"picPath"]]] placeholderImage:nil];
    }
    
    [self.deleteBtn setHidden:!isShow];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

//删除按钮事件
-(void)deleteBtnAction{
    if(self.delBlock){
        self.delBlock(self.index);
    }
}

@end

@interface YLBPhotoWall()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, copy)AddPhotoBlock addBlock;
@property (nonatomic, copy)DelPhotoBlock delBlock;
@property (nonatomic, strong)UICollectionViewFlowLayout *layout;
@end

@implementation YLBPhotoWall

-(void)setDirection:(WallDirection)direction{
    if(direction == WALL_HORIZONTAL){
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else{
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
}

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame addBlock:(AddPhotoBlock)addBlock delBlock:(DelPhotoBlock)delBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.itemSize = CGSizeMake((frame.size.width-50) / 4, (frame.size.width-50) / 4);
        self.layout.minimumLineSpacing = 10;
        self.layout.minimumInteritemSpacing = 10;
        self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[YLBPhotoCell class] forCellWithReuseIdentifier:photoCellID];
        
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.addBlock = addBlock;
        self.delBlock = delBlock;
        
        self.maxPicCount = 5;
    }
    return self;
}

-(void)showData:(NSArray*)data{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:data];
    
    NSInteger count = data.count;
    count = (count % 4 == 0?(count/4):(count/4 + 1));
    CGFloat singleH = (self.fm_width - 50) / 4;
    self.totalHeight = count * singleH + 20 + (count-1)*10;
    
    [self.collectionView reloadData];
}

-(void)setTotalHeight:(CGFloat)totalHeight{
    _totalHeight = totalHeight;
    self.collectionView.fm_height = totalHeight;
    self.fm_height = totalHeight;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.dataArray.count == self.maxPicCount){
        return self.dataArray.count - 1;
    }
    
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELf
    YLBPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellID forIndexPath:indexPath];
    [cell configUI:self.dataArray[indexPath.row] index:indexPath.row showDelete:indexPath.row==(self.dataArray.count-1)?NO:YES delBlock:^(NSInteger index){
        [weakSelf.dataArray removeObjectAtIndex:index];
        
        weakSelf.delBlock(index);
    }];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == self.dataArray.count - 1){
        if(self.addBlock){
            self.addBlock();
        }
    }
}

@end
