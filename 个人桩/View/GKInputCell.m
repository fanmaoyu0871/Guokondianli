//
//  GKInputCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKInputCell.h"
#import "GKBaseTextField.h"

@interface GKInputCell()<UITextFieldDelegate>
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)GKBaseTextField *textField;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, copy)void (^block)(void);
@property (nonatomic, copy)DidEndEditBlock endEditBlock;
@property (nonatomic, assign)BOOL canEdit;
@end

@implementation GKInputCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.leftLabel = [UILabel labelWithTitle:@"" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        [self.contentView addSubview:self.leftLabel];
        
        self.textField = [[GKBaseTextField alloc]init];
        self.textField.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightLight];
        self.textField.delegate = self;
        [self.contentView addSubview:self.textField];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem image:nil fontSize:14.0f titleColor:[UIColor whiteColor] title:@""];
        [self.contentView addSubview:self.rightBtn];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftLabel sizeToFit];
    self.leftLabel.fm_width = 100;
    self.leftLabel.fm_left = 10;
    self.leftLabel.fm_centerY = self.contentView.fm_height / 2;
    
    self.textField.fm_left = self.leftLabel.fm_right + 10;
    self.textField.fm_size = CGSizeMake(self.contentView.fm_width  - self.leftLabel.fm_right, 30);
    self.textField.fm_centerY = self.contentView.fm_height / 2;
    
    CGFloat btnW = 80.0f;
    if(!self.canEdit){
        btnW = self.contentView.fm_width - self.leftLabel.fm_right - 20;
        self.textField.enabled = NO;
    }else{
        self.textField.enabled = YES;
    }
    self.rightBtn.fm_size = CGSizeMake(btnW, self.contentView.fm_height);
    self.rightBtn.fm_right = self.contentView.fm_width - 10;
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightBtn.fm_centerY = self.contentView.fm_height / 2;
    [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)rightBtnAction{
    if(self.block){
        self.block();
    }
}

-(void)configUI:(NSString*)leftTitle phTitle:(NSString*)placeHolder content:(NSString*)content image:(UIImage*)image canEdit:(BOOL)canEdit block:(void (^)(void))block didEndEditBlock:(DidEndEditBlock)didEndEditBlock{
    self.leftLabel.text = leftTitle;
    self.textField.placeholder = placeHolder;
    
    if(content && ![content isKindOfClass:[NSNull class]]){
        self.textField.text = content;
    }else{
        self.textField.text = @"";
    }
    [self.rightBtn setImage:image forState:UIControlStateNormal];
    self.block = block;
    self.canEdit = canEdit;
    self.endEditBlock = didEndEditBlock;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.endEditBlock){
        self.endEditBlock(textField.text);
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
