//
//  GKDetailSection1Cell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/16.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKDetailSection1Cell.h"

@interface GKDetailSection1Cell()
@property (nonatomic, strong)UIImageView *leftImageView;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)UILabel *distanceLabel;
@end

@implementation GKDetailSection1Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"daohang"]];
        [self.contentView addSubview:self.leftImageView];
        
        self.contentLabel = [UILabel labelWithTitle:@"浙江省杭州市余杭区西溪湿地充电桩金之源大厦513绿汀路与文二西路交叉口会议中心车位" fontSize:14 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom image:[UIImage imageNamed:@"right_arrow"] fontSize:12 titleColor:HEXCOLOR(LightText_Color) title:@"导航"];
        self.rightBtn.fm_width = 80;
        self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.rightBtn.titleLabel.intrinsicContentSize.width + 5, 0, -self.rightBtn.titleLabel.intrinsicContentSize.width - 5);
        self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.rightBtn.currentImage.size.width, 0, self.rightBtn.currentImage.size.width);
        self.rightBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.rightBtn];
        
        self.distanceLabel = [UILabel labelWithTitle:@"距我12.4km" fontSize:12 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self.contentView addSubview:self.distanceLabel];
    }
    
    return self;
}

-(void)configUI:(GKStateModel*)model
{
    self.contentLabel.text = model.station_address;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"距我%.1fkm", [model.distance floatValue]];
    
    [self.contentLabel sizeToFit];
    [self.distanceLabel sizeToFit];
    
}

+(CGFloat)heightForModel:(GKStateModel*)model{
    return  [model.station_address boundingRectWithSize:CGSizeMake(ScreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular]} context:nil].size.height + 50;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftImageView sizeToFit];
    self.leftImageView.fm_leftTop = CGPointMake(10, 10);
    
    self.rightBtn.fm_centerY = self.contentView.fm_height / 2;
    self.rightBtn.fm_right = self.contentView.fm_width;
    
    self.contentLabel.fm_width = self.contentView.fm_width - self.leftImageView.fm_right - self.rightBtn.fm_width ;
    [self.contentLabel sizeToFit];
    self.contentLabel.fm_top = 10;
    self.contentLabel.fm_left = self.leftImageView.fm_right + 10;
    
    [self.distanceLabel sizeToFit];
    self.distanceLabel.fm_leftTop = CGPointMake(self.leftImageView.fm_right + 10, self.contentLabel.fm_bottom + 10);
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
