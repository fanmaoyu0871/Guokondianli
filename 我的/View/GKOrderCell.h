//
//  GKOrderCell.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/30.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseCell.h"
#import "GKDeviceModel.h"

@interface GKOrderCell : GKBaseCell

-(void)configUI:(GKDeviceModel*)model rightBlock:(void (^)(void))rightBlock;

@end
