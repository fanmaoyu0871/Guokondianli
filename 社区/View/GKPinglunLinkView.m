//
//  GKPinglunLinkView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPinglunLinkView.h"

@interface GKPinglunLinkView()
//link view
@property (nonatomic, strong)UIImageView *linkImageView;
@property (nonatomic, strong)UILabel *topLabel;
@property (nonatomic, strong)UILabel *downLabel;
@end

@implementation GKPinglunLinkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(TableBackground_Color);
        
        self.linkImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test"]];
        self.linkImageView.fm_size = CGSizeMake(45, 45);
        self.linkImageView.fm_left = 10;
        [self addSubview:self.linkImageView];
        
        self.topLabel = [UILabel labelWithTitle:@"" fontSize:14.0f textColor:[UIColor colorWithHex:NormalText_Color] textWeight:UIFontWeightRegular];
        [self addSubview:self.topLabel];
        
        self.downLabel = [UILabel labelWithTitle:@"" fontSize:14.0f textColor:[UIColor colorWithHex:LightText_Color] textWeight:UIFontWeightRegular];
        [self addSubview:self.downLabel];
    }
    return self;
}

-(void)configUI:(GKDynamicModel *)model{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", Prefix_Img_Host, model.status_pic];
    [self.linkImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"test"]];
    
    self.topLabel.text = model.status_name;
    self.downLabel.text = model.status_area;
}

-(void)layoutSubviews{
    
    self.linkImageView.fm_centerY = self.fm_height / 2;
    
    [self.topLabel sizeToFit];
    self.topLabel.fm_left = self.linkImageView.fm_right + 5;
    self.topLabel.fm_top = self.linkImageView.fm_top;
    
    [self.downLabel sizeToFit];
    self.downLabel.fm_bottom = self.linkImageView.fm_bottom;
    self.downLabel.fm_left = self.topLabel.fm_left;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
