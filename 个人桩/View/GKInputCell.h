//
//  GKInputCell.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseCell.h"

typedef void(^DidEndEditBlock)(NSString *text);

@interface GKInputCell : GKBaseCell

-(void)configUI:(NSString*)leftTitle phTitle:(NSString*)placeHolder content:(NSString*)content image:(UIImage*)image canEdit:(BOOL)canEdit block:(void (^)(void))block didEndEditBlock:(DidEndEditBlock)didEndEditBlock;

@end
