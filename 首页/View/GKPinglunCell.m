//
//  GKPinglunCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/16.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPinglunCell.h"

@interface GKPinglunCell()
@property (nonatomic, strong)UIImageView *leftImageView;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@end

@implementation GKPinglunCell

-(void)configUI:(GKPinglunModel*)model{
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Prefix_Img_Host, model.pic]] placeholderImage:[UIImage imageNamed:@"headerPlaceHolder"]];
    
    self.contentLabel.text = model.content;
    self.nameLabel.text = model.name;
    
    [self.contentLabel sizeToFit];
    [self.nameLabel sizeToFit];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.leftImageView = [[UIImageView alloc]init];
        self.leftImageView.fm_size = CGSizeMake(45, 45);
        [self.contentView addSubview:self.leftImageView];
        
        self.contentLabel = [UILabel labelWithTitle:@"浙江省杭州市余杭区西溪湿地充电桩金之源大厦513绿汀路与文二西路交叉口会议中心车位" fontSize:14 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        self.nameLabel = [UILabel labelWithTitle:@"大壮爱吃肉" fontSize:14 textColor:HEXCOLOR(MainTheme_Color) textWeight:UIFontWeightRegular];
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel = [UILabel labelWithTitle:@"2017-09-09 12:58" fontSize:12 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self.contentView addSubview:self.timeLabel];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.leftImageView.fm_leftTop = CGPointMake(10, 10);
    
    self.nameLabel.fm_left = self.leftImageView.fm_right + 10;
    self.nameLabel.fm_top = 20;
    
    self.timeLabel.fm_right = self.contentView.fm_width - 10;
    self.timeLabel.fm_centerY = self.nameLabel.fm_centerY;
    
    self.contentLabel.fm_width = self.contentView.fm_width - 10 - self.leftImageView.fm_right - 10 - 10;
    [self.contentLabel sizeToFit];
    self.contentLabel.fm_left = self.leftImageView.fm_right + 10;
    self.contentLabel.fm_top = self.nameLabel.fm_bottom + 20;
    
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
