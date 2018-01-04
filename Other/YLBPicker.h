//
//  YLBPicker.h
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/23.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(NSInteger row);

@interface YLBPicker : UIView

+(void)showData:(NSArray*)data leftTitle:(NSString*)leftTitle leftAction:(CompletionBlock)leftBlock rightTitle:(NSString*)rightTitle rightAction:(CompletionBlock)rightBlock;

@end
