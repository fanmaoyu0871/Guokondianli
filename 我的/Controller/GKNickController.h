//
//  GKNickController.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/23.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseController.h"

typedef NS_ENUM(NSInteger, VC_TYPE){
    TYPE_NICK,
    TYPE_USERNAME,
    TYPE_ADDESS,
    TYPE_CAREER
};

@interface GKNickController : GKBaseController

@property (nonatomic, assign)VC_TYPE type;
@property (nonatomic, copy)void (^modifyBlock)(NSString* text);

@end
