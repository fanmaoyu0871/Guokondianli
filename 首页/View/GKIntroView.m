//
//  GKIntroView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/15.
//  Copyright © 2017年 范茂羽. All rights reserved.
//  充电桩简介

#import "GKIntroView.h"

@implementation GKIntroView
{
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UIImageView *_bgStartImageView;
    UIImageView *_startImageView;
    UILabel *_priceLabel;
    UILabel *_distanceLabel;
    UILabel *_typeLabel;
    UILabel *_addressLabel;
    UIButton *_freeBtn;
    UIButton *_allHourBtn;
    UIButton *_selfBtn;
    UILabel *_statusLabel;
    UIButton *_detailBtn;
    
    void (^_block)(void);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        _imageView.fm_size = CGSizeMake(80, 80);
        [self addSubview:_imageView];
        
        _nameLabel = [UILabel labelWithTitle:@"杭州西溪湿地充电站" fontSize:16 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightMedium];
        [self addSubview:_nameLabel];
        
        _bgStartImageView = [[UIImageView alloc]init];
        _bgStartImageView.image = [UIImage imageNamed:@"bg_five_start"];
        [self addSubview:_bgStartImageView];
        
        _startImageView = [[UIImageView alloc]init];
        _startImageView.image = [UIImage imageNamed:@"five_start"];
        [self addSubview:_startImageView];
        
        _priceLabel = [UILabel labelWithTitle:@"1.6元/度" fontSize:12 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:_priceLabel];
        
        _distanceLabel = [UILabel labelWithTitle:@"2.4km" fontSize:12 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:_distanceLabel];
        
        
        _typeLabel = [UILabel labelWithTitle:@"个人站" fontSize:12 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:_typeLabel];
        
        _addressLabel = [UILabel labelWithTitle:@"余杭区" fontSize:12 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:_addressLabel];
        
        _statusLabel = [UILabel labelWithTitle:@"空闲：2" fontSize:12 textColor:HEXCOLOR(0x62B13C) textWeight:UIFontWeightRegular];
        [self addSubview:_statusLabel];
        
        _freeBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"quanquan"] fontSize:12 titleColor:HEXCOLOR(LightText_Color) title:@"免费停车"];
        _freeBtn.userInteractionEnabled = NO;
        _freeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        [self addSubview:_freeBtn];
        
        _allHourBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"quanquan"] fontSize:12 titleColor:HEXCOLOR(LightText_Color) title:@"24小时"];
        _allHourBtn.userInteractionEnabled = NO;
        _allHourBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        [self addSubview:_allHourBtn];
        
        _selfBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"quanquan"] fontSize:12 titleColor:HEXCOLOR(LightText_Color) title:@"自营"];
        _selfBtn.userInteractionEnabled = NO;
        _selfBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        [self addSubview:_selfBtn];
        
        _detailBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:12 titleColor:HEXCOLOR(LightText_Color) title:@"详情"];
        _detailBtn.fm_size = CGSizeMake(60, 30);
        [_detailBtn addTarget:self action:@selector(detailBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_detailBtn];
    }
    return self;
}

-(void)detailBtnAction{
    if(_block){
        _block();
    }
}

-(void)configUI:(GKStateModel*)model rightBlock:(void (^)(void))rightBlock
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Prefix_Img_Host, model.station_pic]] placeholderImage:[UIImage imageNamed:@"test"]];
    _nameLabel.text = model.station_name;
    
    
    if(model.type){
        _priceLabel.text = [model.type integerValue] == 1?@"已评价":@"未评价";
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"%.2f元/度", [model.station_price floatValue]];
    }

    
    _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", [model.distance floatValue]/1000];
    _typeLabel.text = [model.station_type integerValue] == 1?@"个人站":@"公共站";
    _addressLabel.text = model.station_area;
    
    if(!model.price){
        NSInteger count = [model.nums_free_kuai integerValue] + [model.nums_free_man integerValue];
        _statusLabel.text = [NSString stringWithFormat:@"空闲：%ld", count];
    }else{
        _statusLabel.text = [NSString stringWithFormat:@"充电金额：%.2f", [model.price floatValue]];
    }
    
    NSString *parking_fee = [model.parking_free integerValue] == 0?@"免费停车":@"停车收费";
    [_freeBtn setTitle:parking_fee forState:UIControlStateNormal];
    [_allHourBtn setTitle:model.business_hours forState:UIControlStateNormal];
    
    
    _block = rightBlock;
    _detailBtn.hidden = rightBlock?NO:YES;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    
    [_nameLabel sizeToFit];
    [_priceLabel sizeToFit];
    [_distanceLabel sizeToFit];
    [_typeLabel sizeToFit];
    [_addressLabel sizeToFit];
    [_statusLabel sizeToFit];
    
    _imageView.fm_centerY = self.fm_height / 2;
    _imageView.fm_left = 10;
    
    [_nameLabel sizeToFit];
    _nameLabel.fm_top = _imageView.fm_top;
    _nameLabel.fm_left = _imageView.fm_right + 10;
    
    [_bgStartImageView sizeToFit];
    _bgStartImageView.fm_left = _imageView.fm_right + 10;
    _bgStartImageView.fm_top = _nameLabel.fm_bottom + 10;
    
    [_startImageView sizeToFit];
    _startImageView.fm_leftTop = _bgStartImageView.fm_leftTop;
    
    [_priceLabel sizeToFit];
    _priceLabel.fm_left = _startImageView.fm_right + 10;
    _priceLabel.fm_centerY = _bgStartImageView.fm_centerY;
    
    [_distanceLabel sizeToFit];
    _distanceLabel.fm_right = self.fm_width - 20;
    _distanceLabel.fm_centerY = _priceLabel.fm_centerY;
    
    [_typeLabel sizeToFit];
    _typeLabel.fm_left = _imageView.fm_right + 10;
    _typeLabel.fm_top = _bgStartImageView.fm_bottom + 10;
    
    [_addressLabel sizeToFit];
    _addressLabel.fm_left = _typeLabel.fm_right + 10;
    _addressLabel.fm_top = _bgStartImageView.fm_bottom + 10;
    
    [_statusLabel sizeToFit];
    _statusLabel.fm_right = self.fm_width - 20;
    _statusLabel.fm_centerY = _typeLabel.fm_centerY;
    
    [_freeBtn sizeToFit];
    _freeBtn.fm_top = _typeLabel.fm_bottom + 10;
    _freeBtn.fm_left = _imageView.fm_right + 10;
    
    [_allHourBtn sizeToFit];
    _allHourBtn.fm_top = _typeLabel.fm_bottom + 10;
    _allHourBtn.fm_left = _freeBtn.fm_right + 10;
    
    [_selfBtn sizeToFit];
    _selfBtn.fm_top = _typeLabel.fm_bottom + 10;
    _selfBtn.fm_left = _allHourBtn.fm_right + 10;
    
    _detailBtn.fm_right = self.fm_width - 10;
    _detailBtn.fm_centerY = _selfBtn.fm_centerY;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
