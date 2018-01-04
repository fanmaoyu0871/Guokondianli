//
//  GKPinglunZanView.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDynamicModel.h"

@interface GKPinglunZanView : UIView

-(void)configUI:(GKDynamicModel*)model zanBlock:(void (^)(void))zanBlock pinglunBlock:(void (^)(void))pinglunBlock;

@end
