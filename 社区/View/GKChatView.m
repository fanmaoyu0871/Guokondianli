//
//  GKChatView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/28.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKChatView.h"

@interface GKChatView()<UITextViewDelegate>
@property (nonatomic, strong)UITextView *textView;
@end

@implementation GKChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = HEXCOLOR(TableBackground_Color);
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, frame.size.width - 40, 30)];
        self.textView.delegate = self;
        self.textView.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular];
        self.textView.returnKeyType = UIReturnKeySend;
        self.textView.layer.cornerRadius = 5;
        [self addSubview:self.textView];
    }
    return self;
}

-(void)layoutSubviews{
    self.textView.fm_left = 20;
    self.textView.fm_top = 10;
    self.textView.fm_width = self.fm_width - 40;
    self.textView.fm_height = self.fm_height - 20;
}

-(void)textViewDidChange:(UITextView *)textView{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(self.frame.size.width - 40, MAXFLOAT)];
    
    self.fm_height = sizeToFit.height + 20;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];

    if(self.changeBlock){
        self.changeBlock();
    }
}

-(void)cleanContent{
    self.textView.text = @"";
    
    self.textView.fm_height = 30;
    self.fm_height = 50;
}

-(void)becomeResponse{
    [self.textView becomeFirstResponder];
}

-(void)cancelResponse{
    [self.textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if(self.sendBlock){
            self.sendBlock(textView.text);
        }
        return NO;
    }
    
    return YES;
}


@end
