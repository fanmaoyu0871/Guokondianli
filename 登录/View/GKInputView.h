//
//  GKInputView.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBlock)(NSString* key);

@interface GKInputView : UIView

@property (nonatomic, strong)UIFont *font;
@property (nonatomic, assign)BOOL hideLine;
@property (nonatomic, assign)UIReturnKeyType returnKeyType;
@property (nonatomic, assign)UIKeyboardType keyboardType;
@property (nonatomic, copy)NSString* content;
@property (nonatomic, assign)BOOL secureTextEntry;
@property (nonatomic, copy)ReturnBlock returnBlock;

- (instancetype)initWithFrame:(CGRect)frame leftImage:(UIImage*)image placeHolder:(NSString*)placeHolder;

-(void)becomeFirstResponder;

@end
