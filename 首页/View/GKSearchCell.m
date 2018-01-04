//
//  GKSearchCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/21.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKSearchCell.h"
#import "GKIntroView.h"

@interface GKSearchCell()
@property (nonatomic, strong)GKIntroView *introView;
@end

@implementation GKSearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.introView = [[GKIntroView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.fm_width, 120)];
        [self.contentView addSubview:self.introView];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.introView.fm_width = self.contentView.fm_width;
}

-(void)configUI:(GKStateModel *)model{
    [self.introView configUI:model rightBlock:nil];
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
