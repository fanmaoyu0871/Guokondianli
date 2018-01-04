//
//  GKAddressView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/15.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKAddressView.h"

@implementation GKAddressView
{
    UIImageView *_imageView;
    UILabel *_addressLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        
        _addressLabel = [UILabel labelWithTitle:@"" fontSize:14 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:_addressLabel];
    }
    return self;
}

-(void)configImage:(UIImage*)image title:(NSString*)title{
    _imageView.image = image;
    _addressLabel.text = title;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [_imageView sizeToFit];
    _imageView.fm_centerY = self.fm_height / 2;
    _imageView.fm_left = 10;
    
    [_addressLabel sizeToFit];
    _addressLabel.fm_left = _imageView.fm_right + 10;
    _addressLabel.fm_centerY = _imageView.fm_centerY;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
