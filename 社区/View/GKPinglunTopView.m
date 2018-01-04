//
//  GKPinglunTopView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPinglunTopView.h"

@interface GKPinglunTopView()
@property (nonatomic, strong)UIImageView *leftImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIView *bgStartView;
@property (nonatomic, strong)UIImageView *bgStartImageView;
@property (nonatomic, strong)UIImageView *startImageView;
@end

@implementation GKPinglunTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftImageView = [[UIImageView alloc]init];
        self.leftImageView.fm_size = CGSizeMake(45, 45);
        self.leftImageView.image = [UIImage imageNamed:@"headerPlaceHolder"];
        [self addSubview:self.leftImageView];
        
        self.nameLabel = [UILabel labelWithTitle:@"游客" fontSize:14 textColor:HEXCOLOR(MainTheme_Color) textWeight:UIFontWeightRegular];
        [self addSubview:self.nameLabel];
        
        self.timeLabel = [UILabel labelWithTitle:@"2017-09-09 12:58" fontSize:12 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:self.timeLabel];
        
        self.bgStartView = [[UIView alloc]init];
        self.bgStartView.fm_size = CGSizeMake(200, 2);
        [self addSubview:self.bgStartView];
        
        UILabel *label = [UILabel labelWithTitle:@"点评" fontSize:10.0f textColor:HEXCOLOR(0xD0021B) textWeight:UIFontWeightRegular];
        label.layer.cornerRadius = 2;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = HEXCOLOR(0xD0021B).CGColor;
        [self.bgStartView addSubview:label];
        label.fm_left = 0;
        label.fm_centerY = self.bgStartView.fm_boundsCenter.y;
        
        self.bgStartImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_five_start"]];
        [self.bgStartView addSubview:self.bgStartImageView];
        self.bgStartImageView.fm_left = label.fm_right + 10;
        self.bgStartImageView.fm_centerY = self.bgStartView.fm_boundsCenter.y;
        
        self.startImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"five_start"]];
        self.startImageView.contentMode = UIViewContentModeLeft;
        [self.bgStartView addSubview:self.startImageView];
        self.startImageView.fm_left = label.fm_right + 10;
        self.startImageView.fm_centerY = self.bgStartView.fm_boundsCenter.y;
    }
    return self;
}

-(void)configUI:(GKDynamicModel*)model{
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Prefix_Img_Host, model.user_pic]] placeholderImage:[UIImage imageNamed:@"headerPlaceHolder"]];
    self.nameLabel.text = model.user_name;
    self.timeLabel.text = model.time;
    
    NSInteger starCount = 5 - [model.score integerValue];
    CGFloat starWidth = 192.0f / starCount==0?1:starCount;
    self.startImageView.fm_width = starWidth;
    self.startImageView.fm_leftTop = self.bgStartImageView.fm_leftTop;
    self.startImageView.layer.masksToBounds = YES;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    self.leftImageView.fm_leftTop = CGPointMake(10, 10);
    
    [self.nameLabel sizeToFit];
    self.nameLabel.fm_left = self.leftImageView.fm_right + 10;
    self.nameLabel.fm_top = 20;
    
    [self.timeLabel sizeToFit];
    self.timeLabel.fm_right = self.fm_width - 10;
    self.timeLabel.fm_centerY = self.nameLabel.fm_centerY;
    
    self.bgStartView.fm_top = self.nameLabel.fm_bottom + 15;
    self.bgStartView.fm_left = self.leftImageView.fm_right + 10;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
