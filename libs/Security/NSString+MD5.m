//
//  NSString+MD5.m
//  Encryption
//
//  Created by niujinyong on 14-9-1.
//  Copyright (c) 2014年 AllanNiu. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (MD5)

-(NSString *)MD5Encryption{

    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X"
            ,result[0],result[1],result[2],result[3]
            ,result[4],result[5],result[6],result[7]
            ,result[8],result[9],result[10],result[11]
            ,result[12],result[13],result[14],result[15]] lowercaseString];
}

@end
