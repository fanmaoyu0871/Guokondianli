//
//  GKBaseCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/16.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseCell.h"

@interface GKBaseCell()
@end

@implementation GKBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.bottomLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        [self.contentView addSubview:self.bottomLine];
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.bottomLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
    [self.contentView addSubview:self.bottomLine];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.bottomLine.fm_size = CGSizeMake(self.contentView.fm_width, 1);
    self.bottomLine.fm_leftBottom = CGPointMake(0, self.contentView.fm_height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
