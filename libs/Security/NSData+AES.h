//
//  NSData+AES.h
//  Encryption
//
//  Created by niujinyong on 14-9-1.
//  Copyright (c) 2014年 AllanNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

-(NSData *)AES256EncryptionWithKey:(NSString *)key;//加密
-(NSData *)AES256DecryptionWithKey:(NSString *)key;//解密

@end
