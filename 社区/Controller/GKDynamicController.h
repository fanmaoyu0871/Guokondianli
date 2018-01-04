//
//  GKDynamicController.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/17.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseController.h"
#import "GKDynamicModel.h"

typedef NS_ENUM(NSInteger, DYNAMIC_TYPE){
    TYPE_HOSTEST,
    TYPE_NEWEST
};

@interface GKDynamicController : GKBaseController

@property (nonatomic, assign)DYNAMIC_TYPE type;

-(void)pinglunReqModel:(GKDynamicModel*)model content:(NSString*)content type:(NSString*)type section:(NSInteger)section sendType:(NSString*)sendType;
@end
