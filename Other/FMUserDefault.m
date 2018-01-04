//
//  FMUserDefault.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/28.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "FMUserDefault.h"

@implementation FMUserDefault
+(id)objectForKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

+(BOOL)setObject:(nullable id)object forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]setObject:object forKey:key];
    return [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
