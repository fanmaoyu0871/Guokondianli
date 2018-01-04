//
//  FMBubbleTabbar.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/14.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMBubbleTabbar : UIView

+(instancetype)tabTitles:(NSArray*)titles images:(NSArray*)images selectedImages:(NSArray*)selectedImages selectedBlock:(void (^)(NSInteger index))selectedBlock centerBlock:(void (^)(void))centerBlock;

-(void)pressAtIndex:(NSInteger)index;

@end
