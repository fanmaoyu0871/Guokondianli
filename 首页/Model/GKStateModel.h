//
//  GKStateModel.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/24.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKStateModel : GKBaseModel

@property (nonatomic, copy)NSString* station_id;
@property (nonatomic, copy)NSString* station_name;
@property (nonatomic, copy)NSString* station_pic;
@property (nonatomic, copy)NSString* station_price;
@property (nonatomic, copy)NSString* station_type;
@property (nonatomic, copy)NSString* station_area;
@property (nonatomic, copy)NSString* station_lon;
@property (nonatomic, copy)NSString* station_lat;
@property (nonatomic, copy)NSString* station_address;
@property (nonatomic, copy)NSString* station_score;
@property (nonatomic, copy)NSString* pay_type;
@property (nonatomic, copy)NSString* distance;
@property (nonatomic, copy)NSString* nums_total_man;
@property (nonatomic, copy)NSString* nums_total_kuai;
@property (nonatomic, copy)NSString* nums_free_man;
@property (nonatomic, copy)NSString* nums_free_kuai;
@property (nonatomic, copy)NSString* parking_free;
@property (nonatomic, copy)NSString* business_hours;

@property (nonatomic, copy)NSString* business_time;
@property (nonatomic, copy)NSString* free_price;
@property (nonatomic, copy)NSString* free_service;
@property (nonatomic, copy)NSString* station_owner;
@property (nonatomic, copy)NSString* service_phone;

@property (nonatomic, copy)NSString* order_id;
@property (nonatomic, copy)NSString* price;
@property (nonatomic, copy)NSString* type;
@property (nonatomic, copy)NSString* isDetailSelected;

@end
