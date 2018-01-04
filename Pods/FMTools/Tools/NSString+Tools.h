//
//  NSString+Tools.h
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/25.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)
#pragma mark - md5加密
+ (NSString *) md5:(NSString *)input;

//本app专用密码加密
+(NSString*)secret:(NSString*)password;

+(NSInteger)countOfMinites:(NSString*)minites;

@end
