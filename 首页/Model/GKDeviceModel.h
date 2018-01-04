//
//  GKDeviceModel.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/24.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKDeviceModel : GKBaseModel

@property (nonatomic, copy)NSString* device_id;
@property (nonatomic, copy)NSString* device_port;
@property (nonatomic, copy)NSString* device_pic;
@property (nonatomic, copy)NSString* device_code;
@property (nonatomic, copy)NSString* device_type;
@property (nonatomic, copy)NSString* device_interface;
@property (nonatomic, copy)NSString* device_power;
@property (nonatomic, copy)NSString* device_voltage;
@property (nonatomic, copy)NSString* device_source;
@property (nonatomic, copy)NSString* device_status;
@property (nonatomic, copy)NSString* repair_id;
@property (nonatomic, copy)NSString* used_nums;
@property (nonatomic, copy)NSString* used_time;
@property (nonatomic, copy)NSString* current_time;
@property (nonatomic, copy)NSString* used_degree;
@property (nonatomic, copy)NSString* error_code;
@property (nonatomic, copy)NSString* kefu_mobile;
@property (nonatomic, copy)NSString* car_type;
@property (nonatomic, copy)NSString* device_model;
@property (nonatomic, copy)NSString* time;
@property (nonatomic, copy)NSString* duration;
@property (nonatomic, copy)NSString* order_type;


@end
