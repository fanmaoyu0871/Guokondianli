//
//  GKSimpleCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/26.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKSimpleCell.h"

@implementation GKSimpleCell

-(void)configLeftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle{
    self.leftLabel.text = leftTitle;
    
    if([rightTitle isKindOfClass: [NSString class]]){
        self.rightLabel.text = rightTitle;
    }else if([rightTitle isKindOfClass: [NSNumber class]]){
        self.rightLabel.text = [NSString stringWithFormat:@"%ld", [rightTitle integerValue]];
    }else{
        self.rightLabel.text = nil;
    }
        
    
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
