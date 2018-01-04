//
//  GKBaoxiuCell.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseCell.h"
#import "GKDeviceModel.h"

@interface GKBaoxiuCell : GKBaseCell

-(void)configUI:(GKDeviceModel*)model block:(void (^)(NSInteger index))block;

@end
