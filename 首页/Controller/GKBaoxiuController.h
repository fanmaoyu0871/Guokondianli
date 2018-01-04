//
//  GKBaoxiuController.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseController.h"
#import "GKDeviceModel.h"

@interface GKBaoxiuController : GKBaseController

@property (nonatomic, assign)NSInteger flag;
@property (nonatomic, strong)GKDeviceModel *deviceModel;
@property (nonatomic, copy)NSString* stationName;

@end
