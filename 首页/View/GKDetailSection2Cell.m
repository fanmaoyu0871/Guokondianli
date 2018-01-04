//
//  GKDetailSection2Cell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/16.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKDetailSection2Cell.h"

@interface GKDetailSection2Cell()
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@end

@implementation GKDetailSection2Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.leftLabel = [UILabel labelWithTitle:@"支付方式" fontSize:14 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self.contentView addSubview:self.leftLabel];
        
        self.contentLabel = [UILabel labelWithTitle:@"支付宝、账户余额、微信支付" fontSize:14 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        [self.contentView addSubview:self.contentLabel];
    }
    
    return self;
}

-(void)configLeft:(NSString*)leftStr right:(NSString*)righStr{
    self.leftLabel.text = leftStr;
    self.contentLabel.text = righStr;
    
    [self.leftLabel sizeToFit];
    [self.contentLabel sizeToFit];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.leftLabel.fm_width = 100;
    self.leftLabel.fm_centerY = self.contentView.fm_height / 2;
    self.leftLabel.fm_left = 10;
    
    self.contentLabel.fm_centerY = self.contentView.fm_height / 2;
    self.contentLabel.fm_left = self.leftLabel.fm_right + 10;
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
