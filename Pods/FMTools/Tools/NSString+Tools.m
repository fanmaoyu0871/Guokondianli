//
//  NSString+Tools.m
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/25.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "NSString+Tools.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Tools)

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    NSString *resultStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return resultStr;
}

+(NSString*)secret:(NSString*)password{
    
    NSString* hash   = @"aD#n*7%tybn56gh@)~";
    NSString* key    = [NSString md5:hash].uppercaseString;
    NSString* string = [NSString md5:password].uppercaseString;
    
    int num    = (int)key.length;
    char tmp[33] = {0};
    
    for (int i = 0; i < num; i++)
    {
        char result = ((char)[key characterAtIndex:i]) ^ ((char)[string characterAtIndex:i]);
        tmp[i] = result;
    }
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(tmp, 32, result);
    NSString *resultStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    
    return resultStr;
}

+(NSInteger)countOfMinites:(NSString*)minites{
    NSArray *array = [minites componentsSeparatedByString:@":"];
    if(array.count == 2){
        return [array[0] integerValue] * 60 + [array[1] integerValue];
    }
    
    return 0;
}


@end
