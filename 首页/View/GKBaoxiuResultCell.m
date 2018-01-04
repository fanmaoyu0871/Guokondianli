//
//  GKBaoxiuResultCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/12/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaoxiuResultCell.h"

@interface GKBaoxiuResultCell()
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *midLabel;
@property (nonatomic, strong)UILabel *rightLabel;
@property (nonatomic, strong)UIView *verLine1;
@property (nonatomic, strong)UIView *verLine2;
@end

@implementation GKBaoxiuResultCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.leftLabel = [UILabel labelWithTitle:@"" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.leftLabel];
        
        self.verLine1 = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        self.verLine1.fm_width = 1;
        [self.contentView addSubview:self.verLine1];
        
        self.midLabel = [UILabel labelWithTitle:@"" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        self.midLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.midLabel];
        
        self.verLine2 = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        self.verLine2.fm_width = 1;
        [self.contentView addSubview:self.verLine2];
        
        self.rightLabel = [UILabel labelWithTitle:@"" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        self.rightLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.rightLabel];
    }
    
    return self;
}

-(void)configUI:(NSDictionary*)dict{
    self.leftLabel.text = dict[@"repair_title"];
    self.midLabel.text = dict[@"repair_status"];
    self.rightLabel.text = dict[@"repair_time"];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.leftLabel.fm_width = 100;
    self.leftLabel.fm_height = self.contentView.fm_height;
    self.leftLabel.fm_leftTop = CGPointMake(0, 0);
    
    self.verLine1.fm_height = self.contentView.fm_height;
    self.verLine1.fm_leftTop = CGPointMake(self.leftLabel.fm_right, 0);
    
    self.midLabel.fm_width = 100;
    self.midLabel.fm_height = self.contentView.fm_height;
    self.midLabel.fm_leftTop = CGPointMake(self.verLine1.fm_right, 0);
    
    self.verLine2.fm_height = self.contentView.fm_height;
    self.verLine2.fm_leftTop = CGPointMake(self.midLabel.fm_right, 0);
    
    self.rightLabel.fm_width = self.contentView.fm_width - self.verLine2.fm_right;
    self.rightLabel.fm_leftTop = CGPointMake(self.verLine2.fm_right, 0);
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
