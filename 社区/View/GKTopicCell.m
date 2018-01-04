//
//  GKTopicCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/17.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKTopicCell.h"

@interface GKTopicCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *recomLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;
@end

@implementation GKTopicCell

-(void)configUI:(GKTopicModel*)model{
    self.contentLabel.text = model.topic_content;
    
    self.recomLabel.hidden = [model.topic_tuijian integerValue] == 1?NO:YES;
    
    if(self.recomLabel.isHidden){
        self.leadingCons.constant = 5;
    }else{
        self.leadingCons.constant = 30;
    }
    self.newsLabel.hidden = [model.topic_zuixin integerValue] == 1?NO:YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.recomLabel.layer.borderColor = HEXCOLOR(0xF6B03C).CGColor;
    self.recomLabel.layer.borderWidth = 1;

    self.newsLabel.layer.borderColor = HEXCOLOR(0x8AD735).CGColor;
    self.newsLabel.layer.borderWidth = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
