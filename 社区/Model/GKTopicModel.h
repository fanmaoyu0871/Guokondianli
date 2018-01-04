//
//  GKTopicModel.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseModel.h"

@interface GKTopicModel : GKBaseModel

@property (nonatomic, copy)NSString* topic_id;
@property (nonatomic, copy)NSString* topic_content;
@property (nonatomic, copy)NSString* topic_tuijian;
@property (nonatomic, copy)NSString* topic_zuixin;

@end
