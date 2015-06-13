//
//  SecurityUtil.h
//  Encryption
//
//  Created by niujinyong on 14-9-1.
//  Copyright (c) 2014年 AllanNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject

#pragma mark - base64
+(NSString *)encodeBase64String:(NSString *)input;
+(NSString *)decodeBase64String:(NSString *)input;
+(NSString *)encodeBase64Data:(NSData *)data;
+(NSString *)decodeBase64Data:(NSData *)data;

#pragma mark - AES加密
//将字符串转换成带密码的data
+(NSData *)encryptAESData:(NSString *)string;
//将带密码的data转换成字符串
+(NSString *)decryptAESData:(NSData *)data;

#pragma mark - MD5加密
/*
 *  @brief 对字符串进行MD5加密
 *  @param 未加密的字符串
 *  @return 加密后的字符串
 */
+(NSString *)encryptMD5String:(NSString *)string;
@end
