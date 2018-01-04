//
//  GKBaoxiuInfoCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaoxiuInfoCell.h"

@interface GKBaoxiuInfoCell()
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *rightLabel;
@property (nonatomic, strong)UIView *verLine;
@end

@implementation GKBaoxiuInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.leftLabel = [UILabel labelWithTitle:@"保修站点" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.leftLabel];
        
        self.verLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        self.verLine.fm_width = 1;
        [self.contentView addSubview:self.verLine];
        
        self.rightLabel = [UILabel labelWithTitle:@"杭州西溪湿地充电站" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        self.rightLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.rightLabel];
    }
    
    return self;
}

-(void)configUI:(NSDictionary*)dict{
    self.leftLabel.text = dict[@"left"];
    self.rightLabel.text = dict[@"right"];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.leftLabel.fm_width = 150;
    self.leftLabel.fm_height = self.contentView.fm_height;
    self.leftLabel.fm_leftTop = CGPointMake(0, 0);
    
    self.verLine.fm_height = self.contentView.fm_height;
    self.verLine.fm_leftTop = CGPointMake(self.leftLabel.fm_right, 0);
    
    self.rightLabel.fm_width = self.contentView.fm_width - self.leftLabel.fm_width - self.verLine.fm_width;
    self.rightLabel.fm_leftTop = CGPointMake(self.verLine.fm_right, 0);
    self.rightLabel.fm_height = self.contentView.fm_height;
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
