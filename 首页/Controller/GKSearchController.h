//
//  GKSearchController.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/21.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseController.h"

@interface GKSearchController : GKBaseController
@property (nonatomic, weak)NSArray *listArray;

@property (nonatomic, copy)NSString* cityName;
@property (nonatomic, assign)CLLocationCoordinate2D locationCoor;

@end
