//
//  YLBNetworkingManager.m
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/25.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "YLBNetworkingManager.h"
#import <AFNetworking.h>

//与后台约定key
#define SIGN_KEY @"qweqweasd21@#214e12ewWEWQ(213)"

@interface YLBNetworkingManager()<UIAlertViewDelegate>
@end

@implementation YLBNetworkingManager

+(instancetype)sharedManager{
    static YLBNetworkingManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    
    return manager;
}


//将字典转换为我们应用协议格式
-(NSDictionary *)formatDictionary:(NSDictionary*)dict
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    //platform
    [mutDict setObject:@"iOS" forKey:@"platform"];
    
    //时间戳
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    [mutDict setObject:timeStr forKey:@"time"];
    
    //cookies
    NSString *cookies = [[NSUserDefaults standardUserDefaults]objectForKey:@"cookies"];
    if(cookies){
        [mutDict setObject:cookies forKey:@"cookies"];
    }
    
    NSMutableString *mutString = [NSMutableString string];
    
    //把字典排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    for (id nestedKey in [mutDict.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
        id nestedValue = mutDict[nestedKey];
        if (nestedValue) {
            [mutString appendFormat:@"%@-%@-", nestedKey, nestedValue];
        }
    }
    
    NSMutableString *tmpString = [NSMutableString stringWithString:mutString];
    [tmpString appendString:SIGN_KEY];
    
    NSString *sign = [NSString md5:tmpString].lowercaseString;
    [mutString appendFormat:@"%@-%@", @"sign", sign];
    
    NSLog(@"mutString = %@", mutString);
    
    [mutDict setObject:sign forKey:@"sign"];
    
    return mutDict;
}

-(void)PostMethod:(NSString*)method parameters:(NSDictionary*)parameters successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock{
    [self PostMethod:method multipartFormData:nil progress:nil parameters:parameters successBlock:successBlock failBlock:failBlock];
}

// multipartFormData格式 ==> {"name":[{"filename":filename, @"data":data}]}
-(void)PostMethod:(NSString*)method multipartFormData:(NSDictionary*)multipartData progress:(void (^)(NSProgress *uploadProgress))progressBlock parameters:(NSDictionary*)parameters successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *dict = [self formatDictionary:parameters];
    
    NSLog(@"requestParams = %@", dict);
    
    [manager POST:[NSString stringWithFormat:@"%@/%@", Prefix_Host, method] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for(NSString *name in multipartData.allKeys){
            NSArray *array = [multipartData objectForKey:name];
            for(NSDictionary *dict in array){
                NSString *filename = dict[@"filename"];
                NSData *data = dict[@"data"];
                [formData appendPartWithFileData:data name:name fileName:filename mimeType:@"image/*"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        if(progressBlock){
//            progressBlock(uploadProgress);
//        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"repsonseObj = %@", obj);
            
            if([obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *dict = obj;
                if(dict[@"code"]){
                    if([[dict[@"code"] uppercaseString] isEqualToString:@"SUCC"]){
                        //                        if(dict[@"data"] && successBlock){
                        if(successBlock){
                            successBlock(dict[@"data"]);
                        }
                    }else if([dict[@"code"] isEqualToString:@"Refuse"]){
                        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"重新登录" message:@"检测到另一台设备登录此账号" delegate:self
                                                          cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [av show];
                    }else{
                        if(failBlock){
                            NSLog(@"msg === %@", dict[@"msg"]);
                            failBlock(dict[@"msg"]);
                        }
                    }
                }else{
                    if(failBlock){
                        failBlock(@"返回数据出错啦");
                    }
                }
            }else{
                if(failBlock){
                    failBlock(@"返回数据出错啦");
                }
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(failBlock){
                NSLog(@"error.localizedDescription = %@", error.localizedDescription);
                failBlock(@"网络出错啦");
            }
        });
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //清空本地数据
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    

//    YLBLoginController *loginVC = [[YLBLoginController alloc]init];
//    YLBNavigationController *navVC = [[YLBNavigationController alloc]initWithRootViewController:loginVC];
//    [UIApplication sharedApplication].delegate.window.rootViewController = navVC;
}

@end
