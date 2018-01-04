//
//  GKPersonalCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPersonalCell.h"

@interface GKPersonalCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@end

@implementation GKPersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configLeftTitle:(NSString*)leftTitle leftImage:(UIImage*)leftImage rightTitle:(NSString*)rightTitle rightImage:(UIImage*)rightImage{
    self.leftLabel.text = leftTitle;
    self.leftImageView.image = leftImage;
    
    if(rightTitle && ![rightTitle isKindOfClass:[NSNull class]]){
        self.rightLabel.text = rightTitle;
    }else{
        self.rightLabel.text = @"未填";
    }
    
    if([rightImage isKindOfClass:[UIImage class]]){
        self.rightImageView.image = rightImage;
        self.rightLabel.text = @"";
    }else if([rightImage isKindOfClass:[NSString class]]){
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Prefix_Img_Host, rightImage]] placeholderImage:nil];
        self.rightLabel.text = @"";
    }else{
        self.rightImageView.image = nil;
    }
    
}

-(void)hideRightArrow:(BOOL)isHide{
    self.rightArrow.hidden = isHide;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
