//
//  Helper.h
//  快递兔测试版
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

//MD5加密
+ (NSString *) addSecurityWithUrlStr:(NSString *)url;

//包括年的时间字符串  2014
+ (NSString *) fullDateStringFromNumberString:(NSString *)str;
//格式化电话薄
+ (NSString *) phoneFromAddressTelphone:(NSString *)str;
//获取电话号码进行格式化
+ (NSString *) phoneFromSendTelphone:(NSString *)str;

//把一个时间转化为字符串
+ (NSString *)dateStringFromNumberDate:(NSDate *)date;

//把一个时间字符串转化为date格式的字符串
+ (NSString *) dateStringFromNumberString:(NSString *)str;
//根据字符串内容 获取lable的真实的高度
+ (CGFloat) textHeightFromString:(NSString *)textStr width:(CGFloat)width fontsize:(CGFloat)Size;
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;
//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;
//车型
+ (BOOL) validateCarType:(NSString *)CarType;
//用户名
+ (BOOL) validateUserName:(NSString *)name;
//密码
+ (BOOL) validatePassword:(NSString *)passWord;
//昵称
+ (BOOL) validateNickname:(NSString *)nickname;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//银行卡号验证
+ (BOOL) bankCard:(NSString *)cardID;
//验证邮箱
+ (BOOL) isValidateEmail:(NSString *)email ;
//获取个人的发送短信的列表
+ (NSMutableDictionary *)getMessageListAndSelectIndex;
//获取个人的发送短信路径
+ (NSString *)getMessagePath;
@end
