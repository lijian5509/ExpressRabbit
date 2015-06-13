//
//  SecurityUtil.m
//  Encryption
//
//  Created by niujinyong on 14-9-1.
//  Copyright (c) 2014年 AllanNiu. All rights reserved.
//

#define PUBLIC_KEY @"I Love You,My Baby"
#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "NSString+MD5.h"
@implementation SecurityUtil

#pragma mark - Base64
+(NSString *)encodeBase64String:(NSString *)input{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}
+(NSString *)decodeBase64String:(NSString *)input{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}
+(NSString *)encodeBase64Data:(NSData *)data{
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}
+(NSString *)decodeBase64Data:(NSData *)data{
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}

#pragma mark - AES加密
//将字符串转化为加密的data
+(NSData *)encryptAESData:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对data加密
    NSData *dataEncrypt = [data AES256EncryptionWithKey:PUBLIC_KEY];
    return dataEncrypt;
}
//将带密码的data转换为字符串
+(NSString *)decryptAESData:(NSData *)data{
    //将带密码的data转换为不带密码的data
    NSData *dataDecrypt = [data AES256DecryptionWithKey:PUBLIC_KEY];
    //将data转换为字符串
    NSString *str = [[[NSString alloc] initWithData:dataDecrypt encoding:NSUTF8StringEncoding] autorelease];
    return str;
}
#pragma mark - MD5加密
+(NSString *)encryptMD5String:(NSString *)string{
    
    return [string MD5Encryption];
}
@end
