//
//  GKDetailSection0Cell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/16.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKDetailSection0Cell.h"
#import "GKIntroView.h"
#import "GKStatusView.h"

@interface GKDetailSection0Cell()
@property (nonatomic, strong)GKIntroView *introView;
@property (nonatomic, strong)GKStatusView *statusView;
@end

@implementation GKDetailSection0Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.introView = [[GKIntroView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.fm_width, 120)];
        [self.contentView addSubview:self.introView];
        
        self.statusView = [[GKStatusView alloc]initWithFrame:CGRectMake(0, self.introView.fm_bottom, self.contentView.fm_width, 44)];
        [self.contentView addSubview:self.statusView];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.introView.fm_width = self.contentView.fm_width;
    self.statusView.fm_width = self.contentView.fm_width;
}

-(void)configUI:(GKStateModel *)model{
    [self.introView configUI:model rightBlock:nil];
    [self.statusView configUI:model];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
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
