//
//  GKTopicController.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/17.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseController.h"

@class GKTopicModel;
@interface GKTopicController : GKBaseController

@property (nonatomic, copy)void (^selectedBlock)(GKTopicModel *model);

@end
