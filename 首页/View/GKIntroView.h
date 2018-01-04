//
//  GKIntroView.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/15.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKStateModel.h"

@interface GKIntroView : UIView

-(void)configUI:(GKStateModel*)model rightBlock:(void (^)(void))rightBlock;

@end
