//
//  GKChatView.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/28.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKChatView : UIView

@property (nonatomic, copy)void (^changeBlock)(void);
@property (nonatomic, copy)void (^sendBlock)(NSString* text);

-(void)cleanContent;

-(void)becomeResponse;

-(void)cancelResponse;

@end
