//
//  GKInputView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKInputView.h"

@interface GKInputView()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIView *line;
@end

@implementation GKInputView

- (instancetype)initWithFrame:(CGRect)frame leftImage:(UIImage*)image placeHolder:(NSString*)placeHolder
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textField = [[UITextField alloc]init];
        self.textField.delegate = self;
        self.textField.fm_size = CGSizeMake(frame.size.width, 30);
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        self.textField.placeholder = placeHolder;
        self.textField.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightLight];
        self.textField.fm_left = 0;
        self.textField.fm_centerY = frame.size.height / 2;
        [self addSubview:self.textField];
        
        self.line = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        self.line.fm_size = CGSizeMake(frame.size.width, 0.5);
        self.line.fm_left = 0;
        self.line.fm_bottom = frame.size.height - 1;
        [self addSubview:self.line];
        
        UIView *leftView = [[UIView alloc]init];
        leftView.fm_size = CGSizeMake(40, frame.size.height);
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:image];
        [leftView addSubview:leftImageView];
        leftImageView.center = leftView.fm_boundsCenter;
        
        self.textField.leftView = leftView;
    }
    return self;
}

-(void)becomeFirstResponder{
    [self.textField becomeFirstResponder];
}

-(void)setFont:(UIFont *)font{
    _font = font;
    self.textField.font = font;
}

-(void)setHideLine:(BOOL)hideLine{
    _hideLine = hideLine;
    
    self.line.hidden = hideLine;
}

-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType{
    _returnKeyType = returnKeyType;
    self.textField.returnKeyType = returnKeyType;
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

-(void)setSecureTextEntry:(BOOL)secureTextEntry{
    _secureTextEntry = secureTextEntry;
    self.textField.secureTextEntry = secureTextEntry;
}

-(NSString *)content{
    [self.textField resignFirstResponder];
    return self.textField.text;
}

-(void)setContent:(NSString *)content{
    self.textField.text = content;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(self.returnBlock){
        self.returnBlock(self.content);
    }
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
