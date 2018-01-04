//
//  GKPointAnnotation.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/24.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>


@class GKStateModel;

@interface GKPointAnnotation : MAPointAnnotation
@property (nonatomic, strong)GKStateModel *stationModel;
@end
