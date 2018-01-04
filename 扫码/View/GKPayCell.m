//
//  GKPayCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/26.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPayCell.h"

@interface GKPayCell(){
    void (^_btnBlock)(void);
}
@property (nonatomic, strong)UIImageView *leftImageView;
@property (nonatomic, strong)UILabel *topLabel;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)UIButton *checkBtn;
@end

@implementation GKPayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.leftImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.leftImageView];
        
        self.topLabel = [UILabel labelWithTitle:@"" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        [self.contentView addSubview:self.topLabel];
        
        self.subLabel = [UILabel labelWithTitle:@"" fontSize:12.0f textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self.contentView addSubview:self.subLabel];
        
        self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom image:[UIImage imageNamed:@"no-check"] fontSize:14.0f titleColor:nil title:nil];
        [self.checkBtn setImage:[[UIImage imageNamed:@"check"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [self.contentView addSubview:self.checkBtn];
    }
    
    return self;
}

-(void)configTitle:(NSString*)title subTitle:(NSString*)subTitle leftImage:(UIImage*)image isSelected:(BOOL)isSelected{
    self.topLabel.text = title;
    self.subLabel.text = subTitle;
    self.leftImageView.image = image;
    
    self.checkBtn.selected = isSelected;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftImageView sizeToFit];
    self.leftImageView.fm_left = 10;
    self.leftImageView.fm_centerY = self.contentView.fm_height / 2;
    
    [self.topLabel sizeToFit];
    self.topLabel.fm_left = self.leftImageView.fm_right + 10;
    self.topLabel.fm_centerY = self.contentView.fm_height / 3;
    
    [self.subLabel sizeToFit];
    self.subLabel.fm_left = self.leftImageView.fm_right + 10;
    self.subLabel.fm_centerY = self.contentView.fm_height * 2 / 3;
    
    [self.checkBtn sizeToFit];
    self.checkBtn.fm_right = self.contentView.fm_width - 20;
    self.checkBtn.fm_centerY = self.contentView.fm_height / 2;
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
