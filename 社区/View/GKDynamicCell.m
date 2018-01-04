//
//  GKDynamicCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/17.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKDynamicCell.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

#define cell_left 50
#define cell_right 20
#define cell_topPadding 3
#define image_padding 15

@interface GKDynamicCell()

@property (nonatomic, strong)UIImageView *leftImageView;
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *rightLabel;
@end

@implementation GKDynamicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.leftImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.leftImageView];
        
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.leftLabel.font = [UIFont systemFontOfSize:12];
        self.leftLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.leftLabel.textColor = HEXCOLOR(NormalText_Color);
        self.leftLabel.numberOfLines = 0;
        [self.contentView addSubview:self.leftLabel];
        
        self.bottomLine.hidden = YES;
    }
    
    return self;
}

-(void)configLeft:(id)obj right:(NSString*)rightString image:(UIImage*)image{
    
    self.leftImageView.image = image;
    
    if([obj isKindOfClass:[NSArray class]]){ //点赞
        NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc]init];
        NSDictionary *attr = @{NSForegroundColorAttributeName:HEXCOLOR(MainTheme_Color), NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f]};
        for(NSDictionary *dict in obj){
            NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:dict[@"from_name"] attributes:attr];
            NSAttributedString *dotString = [[NSAttributedString alloc]initWithString:@"，"];
            [mutString appendAttributedString:attrString];
            [mutString appendAttributedString:dotString];
        }
        [mutString deleteCharactersInRange:NSMakeRange(mutString.length-1, 1)];
        
        self.leftLabel.attributedText = mutString;
        
    }else if([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = obj;
        NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc]init];
        NSDictionary *attr = @{NSForegroundColorAttributeName:HEXCOLOR(MainTheme_Color), NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f]};


        if((dict[@"to_id"] && ![dict[@"to_id"] isKindOfClass:[NSNull class]]) && ([dict[@"from_id"] integerValue] != [dict[@"to_id"] integerValue])){
            NSAttributedString *fromString = [[NSAttributedString alloc]initWithString:dict[@"from_name"] attributes:attr];
            NSAttributedString *dotString = [[NSAttributedString alloc]initWithString:@"回复"];
            NSAttributedString *toString = [[NSAttributedString alloc]initWithString:dict[@"to_name"] attributes:attr];

            [mutString appendAttributedString:fromString];
            [mutString appendAttributedString:dotString];
            [mutString appendAttributedString:toString];
            
        }else{
            NSAttributedString *fromString = [[NSAttributedString alloc]initWithString:dict[@"from_name"] attributes:attr];
            [mutString appendAttributedString:fromString];
        }
        
        NSAttributedString *contentString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"：%@", dict[@"sub_content"]]];
        [mutString appendAttributedString:contentString];
        self.leftLabel.attributedText = mutString;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

+(CGFloat)heightForZanModel:(GKDynamicModel *)model{
    
    NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc]init];
    NSDictionary *attr = @{NSForegroundColorAttributeName:HEXCOLOR(MainTheme_Color), NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f]};
    for(NSDictionary *dict in model.zan_list){
        NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:dict[@"from_name"] attributes:attr];
        NSAttributedString *dotString = [[NSAttributedString alloc]initWithString:@"，"];
        [mutString appendAttributedString:attrString];
        [mutString appendAttributedString:dotString];
    }
    [mutString deleteCharactersInRange:NSMakeRange(mutString.length-1, 1)];
    
    return [[mutString string]boundingRectWithSize:CGSizeMake(ScreenWidth - cell_left - cell_right - image_padding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size.height + cell_topPadding + cell_topPadding;
}

+(CGFloat)heightForPinglunDict:(NSDictionary*)dict{

    NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc]init];
    NSDictionary *attr = @{NSForegroundColorAttributeName:HEXCOLOR(MainTheme_Color), NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f]};
    
    
    if((dict[@"to_id"] && ![dict[@"to_id"] isKindOfClass:[NSNull class]]) && ([dict[@"from_id"] integerValue] != [dict[@"to_id"] integerValue])){
        NSAttributedString *fromString = [[NSAttributedString alloc]initWithString:dict[@"from_name"] attributes:attr];
        NSAttributedString *dotString = [[NSAttributedString alloc]initWithString:@" 回复 "];
        NSAttributedString *toString = [[NSAttributedString alloc]initWithString:dict[@"to_name"] attributes:attr];
        
        [mutString appendAttributedString:fromString];
        [mutString appendAttributedString:dotString];
        [mutString appendAttributedString:toString];
        
    }else{
        NSAttributedString *fromString = [[NSAttributedString alloc]initWithString:dict[@"from_name"] attributes:attr];
        [mutString appendAttributedString:fromString];
    }
    
    NSAttributedString *contentString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"：%@", dict[@"sub_content"]]];
    [mutString appendAttributedString:contentString];
    

    return [[mutString string]boundingRectWithSize:CGSizeMake(ScreenWidth - cell_left - cell_right - image_padding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size.height + cell_topPadding + cell_topPadding;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.fm_x = cell_left;
    self.fm_width = ScreenWidth - cell_left - cell_right;
    
    [self.leftImageView sizeToFit];
    self.leftImageView.fm_leftTop = CGPointMake(0, cell_topPadding);
    
    self.leftLabel.fm_width = self.fm_width - image_padding;
    self.leftLabel.fm_leftTop = CGPointMake(image_padding, cell_topPadding);
    [self.leftLabel sizeToFit];
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
