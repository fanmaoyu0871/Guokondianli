//
//  GKDetailSection3Cell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/12/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKDetailSection3Cell.h"
#import "GKCarSupportView.h"

@implementation GKDetailSection3Cell
{
    GKCarSupportView *_supportView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _supportView = [[GKCarSupportView alloc]initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_supportView];
    }
    
    return self;
}

-(void)configUI:(NSArray*)dataArray{
    [_supportView showData:dataArray];
}

-(void)layoutSubviews{
    _supportView.frame = self.contentView.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
