//
//  GKDynamicModel.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/28.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKDynamicModel : GKBaseModel

@property (nonatomic, copy)NSString* comment_id;
@property (nonatomic, copy)NSString* user_id;
@property (nonatomic, copy)NSString* user_name;
@property (nonatomic, copy)NSString* user_pic;
@property (nonatomic, copy)NSString* time;
@property (nonatomic, copy)NSString* score;
@property (nonatomic, copy)NSString* content;
@property (nonatomic, copy)NSArray* picture_list; //另外解析
@property (nonatomic, copy)NSString* nums_zan;
@property (nonatomic, copy)NSString* nums_sub;
@property (nonatomic, copy)NSString* status_id;
@property (nonatomic, copy)NSString* status_pic;
@property (nonatomic, copy)NSString* status_name;
@property (nonatomic, copy)NSString* status_area;
@property (nonatomic, copy)NSString* status_type;
@property (nonatomic, copy)NSArray* comment_sub_list; //另外解析
@property (nonatomic, copy)NSArray* zan_list;//另外解析

@end
