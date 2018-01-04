//
//  GKStatusView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/15.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKStatusView.h"

@implementation GKStatusView
{
    UIImageView *_leftImageView;
    UILabel *_leftLabel;
    UIImageView *_rightImageView;
    UILabel *_rightLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.image = [UIImage imageNamed:@"rocket_icon"];
        [self addSubview:_leftImageView];
        
        _leftLabel = [UILabel labelWithTitle:@"快速充电  空闲：2/4" fontSize:14 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:_leftLabel];
        
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.image = [UIImage imageNamed:@"bike_icon"];
        [self addSubview:_rightImageView];
        
        _rightLabel = [UILabel labelWithTitle:@"慢速充电  空闲：1/2" fontSize:14 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:_rightLabel];
    }
    return self;
}

-(void)configUI:(GKStateModel*)model{
    _leftLabel.text = [NSString stringWithFormat:@"快速充电  空闲：%ld/%ld", [model.nums_free_kuai integerValue], [model.nums_total_kuai integerValue]];
    _rightLabel.text = [NSString stringWithFormat:@"慢速充电  空闲：%ld/%ld", [model.nums_free_man integerValue], [model.nums_total_man integerValue]];
    
    [_leftLabel sizeToFit];
    [_rightLabel sizeToFit];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [_leftImageView sizeToFit];
    _leftImageView.fm_centerY = self.fm_height / 2;
    _leftImageView.fm_left = 10;
    
    [_leftLabel sizeToFit];
    _leftLabel.fm_left = _leftImageView.fm_right + 10;
    _leftLabel.fm_centerY = _leftImageView.fm_centerY;
    
    [_rightImageView sizeToFit];
    _rightImageView.fm_centerY = self.fm_height / 2;
    _rightImageView.fm_left = self.fm_width / 2 + 10;
    
    [_rightLabel sizeToFit];
    _rightLabel.fm_left = _rightImageView.fm_right + 10;
    _rightLabel.fm_centerY = _rightImageView.fm_centerY;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
