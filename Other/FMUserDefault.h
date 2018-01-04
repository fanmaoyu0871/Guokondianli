//
//  FMUserDefault.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/28.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMUserDefault : NSObject

+(id)objectForKey:(NSString*)key;

+(BOOL)setObject:(nullable id)object forKey:(NSString *)key;

@end
