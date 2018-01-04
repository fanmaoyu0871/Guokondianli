//
//  GKBaoxiuTextViewCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaoxiuTextViewCell.h"

@interface GKBaoxiuTextViewCell()<UITextViewDelegate>
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UIView *verLine;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *placeHolderLabel;
@end

@implementation GKBaoxiuTextViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.leftLabel = [UILabel labelWithTitle:@"保修站点" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.leftLabel];
        
        self.verLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        self.verLine.fm_width = 1;
        [self.contentView addSubview:self.verLine];
        
        self.textView = [[UITextView alloc]init];
        self.textView.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular];
        self.textView.textAlignment = NSTextAlignmentCenter;
        self.textView.textColor = [UIColor colorWithHex:NormalText_Color];
        self.textView.delegate = self;
        [self.contentView addSubview:self.textView];
        
        self.placeHolderLabel = [UILabel labelWithTitle:@"" fontSize:14.0f textColor:[UIColor colorWithHex:LightText_Color] textWeight:UIFontWeightRegular];
        [self.textView addSubview:self.placeHolderLabel];
    }
    
    return self;
}


-(void)configUI:(NSDictionary*)dict placeHolder:(NSString*)placeHolder{
    
    self.leftLabel.text = dict[@"left"];
    self.textView.text = dict[@"right"];
    self.placeHolderLabel.text = placeHolder;
    self.placeHolderLabel.hidden = self.textView.text.length > 0?YES:NO;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setCanEdit:(BOOL)canEdit{
    _canEdit = canEdit;
    
    self.textView.editable = canEdit;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.leftLabel.fm_width = 150;
    self.leftLabel.fm_height = self.contentView.fm_height;
    self.leftLabel.fm_leftTop = CGPointMake(0, 0);
    
    self.verLine.fm_height = self.contentView.fm_height;
    self.verLine.fm_leftTop = CGPointMake(self.leftLabel.fm_right, 0);
    
    self.textView.fm_width = self.contentView.fm_width - self.verLine.fm_right-20;
    self.textView.fm_height = self.contentView.fm_height-20;
    self.textView.fm_leftTop = CGPointMake(self.verLine.fm_right+10, 10);
    
    [self.placeHolderLabel sizeToFit];
    self.placeHolderLabel.fm_top = 7;
    self.placeHolderLabel.fm_centerX = self.textView.fm_width / 2;
}

-(void)textViewDidChange:(UITextView *)textView{
    self.placeHolderLabel.hidden = textView.text.length > 0?YES:NO;
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
