//
//  GKPayResultCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2018/1/4.
//  Copyright © 2018年 范茂羽. All rights reserved.
//

#import "GKPayResultCell.h"

@implementation GKPayResultCell
{
    UIImageView *_leftImageView;
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    UIView *_leftLine;
    UIView *_rightLine;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _leftImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_leftImageView];
        
        _leftLabel = [UILabel labelWithTitle:@"" fontSize:14.0f textColor:[UIColor colorWithHex:LightText_Color] textWeight:UIFontWeightRegular];
        [self.contentView addSubview:_leftLabel];
        
        _rightLabel = [UILabel labelWithTitle:@"" fontSize:14.0f textColor:[UIColor colorWithHex:LightText_Color] textWeight:UIFontWeightRegular];
        [self.contentView addSubview:_rightLabel];
        
        _leftLine = [[UIView alloc]initWithBackgroundColor:[UIColor colorWithHex:TableBackground_Color]];
        [self.contentView addSubview:_leftLine];
        
        _rightLine = [[UIView alloc]initWithBackgroundColor:[UIColor colorWithHex:TableBackground_Color]];
        [self.contentView addSubview:_rightLine];
    }
    
    return self;
}

-(void)configLeft:(NSString*)left right:(NSString*)right leftImage:(UIImage*)leftImage{
    _leftLabel.text = left?left:@"";
    
    if([right isKindOfClass:[NSNumber class]]){
        NSNumber *num = right;
        _rightLabel.text = [num stringValue];
    }else{
        _rightLabel.text = right?right:@"";
    }
    _leftImageView.image = leftImage;
    
    self.bottomLine.hidden = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_leftImageView sizeToFit];
    _leftImageView.fm_left = 20;
    _leftImageView.fm_centerY = self.contentView.fm_height / 2;
    
    [_leftLabel sizeToFit];
    _leftLabel.fm_left = _leftImageView.fm_right + 10;
    _leftLabel.fm_centerY = _leftImageView.fm_centerY;
    
    [_rightLabel sizeToFit];
    _rightLabel.fm_centerY = _leftImageView.fm_centerY;
    _rightLabel.fm_centerX = self.contentView.fm_width / 4 * 3;
    
    _leftLine.fm_size = CGSizeMake(self.contentView.fm_width / 2 - 20, 1);
    _leftLine.fm_left = 10;
    _leftLine.fm_bottom = self.contentView.fm_height - 2;
    
    _rightLine.fm_size = CGSizeMake(self.contentView.fm_width / 2 - 20, 1);
    _rightLine.fm_left = self.contentView.fm_width / 2 + 10;
    _rightLine.fm_bottom = self.contentView.fm_height - 2;
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
