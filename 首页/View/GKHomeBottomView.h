//
//  GKHomeBottomView.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/24.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKStateModel.h"

@interface GKHomeBottomView : UIView

-(void)configUI:(GKStateModel*)model leftBlock:(void (^)(void))leftBlock rightBlock:(void (^)(void))rightBlock;

@end
