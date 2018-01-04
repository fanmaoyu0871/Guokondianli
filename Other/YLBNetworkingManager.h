//
//  YLBNetworkingManager.h
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/25.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailBlock)(NSString *msg);

@interface YLBNetworkingManager : NSObject

+(instancetype)sharedManager;

-(void)PostMethod:(NSString*)method parameters:(NSDictionary*)parameters successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;

//上传图片
-(void)PostMethod:(NSString*)method multipartFormData:(NSDictionary*)multipartData progress:(void (^)(NSProgress *uploadProgress))progressBlock parameters:(NSDictionary*)parameters successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;

@end
