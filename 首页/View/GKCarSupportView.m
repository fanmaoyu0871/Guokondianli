//
//  GKCarSupportView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/12/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKCarSupportView.h"

#define photoCellID @"photoCellID"

@interface GKPhotoCell:UICollectionViewCell
-(void)configUI:(NSDictionary*)dict;
@end

@interface GKPhotoCell()
@property (nonatomic, strong)UIImageView *centerImageView;
@property (nonatomic, strong)UILabel *contentLabel;

@end
@implementation GKPhotoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.centerImageView = [[UIImageView alloc]init];
        self.centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.centerImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.centerImageView];
        
        self.contentLabel = [UILabel labelWithTitle:@"" fontSize:10.0f textColor:[UIColor colorWithHex:NormalText_Color] textWeight:UIFontWeightRegular];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}
-(void)layoutSubviews{
    self.centerImageView.fm_size = CGSizeMake(self.contentView.fm_width - 10, self.contentView.fm_width - 10);
    
    self.centerImageView.fm_top = 10;
    self.centerImageView.fm_centerX = self.contentView.fm_width / 2;
    
    self.contentLabel.fm_width = self.contentView.fm_width - 10;
    [self.contentLabel sizeToFit];
    self.contentLabel.fm_top = self.centerImageView.fm_bottom + 10;
    self.contentLabel.fm_centerX = self.contentView.fm_width / 2;
}
-(void)configUI:(NSDictionary*)source {
    
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Prefix_Img_Host, source[@"car_pic"]]] placeholderImage:[UIImage imageNamed:@"test"]];
    
    self.contentLabel.text = source[@"car_name"];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end


@interface GKCarSupportView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation GKCarSupportView

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((frame.size.width-50) / 4, (frame.size.width-50) / 4 + 40);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[GKPhotoCell class] forCellWithReuseIdentifier:photoCellID];
        
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return self;
}

-(void)layoutSubviews{
    self.collectionView.frame = self.bounds;
}

-(void)showData:(NSArray*)data{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:data];
    
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GKPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellID forIndexPath:indexPath];
    [cell configUI:self.dataArray[indexPath.row]];
    return cell;
}


@end
