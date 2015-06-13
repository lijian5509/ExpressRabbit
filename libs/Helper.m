//
//  Helper.m
//  快递兔测试版
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "Helper.h"
#import "SecurityUtil.h"

@implementation Helper

+ (NSString *) addSecurityWithUrlStr:(NSString *)url{
    NSString *str=[NSString stringWithFormat:CESHIZONG,url];
    NSString *string=[NSString stringWithFormat:@"%@%@",str,PRIVATEKEY];
    return [SecurityUtil encryptMD5String:string];
}

+ (NSString *) phoneFromAddressTelphone:(NSString *)str{
    char c=[str characterAtIndex:0];
    if (c=='+') {
        str =[str substringFromIndex:4];
    }
    
    NSString *strGeShi = @"";
    for (int i =0; i<str.length; i++) {
        unichar c = [str characterAtIndex:i];
        if (c=='-') {
            
        }else{
            strGeShi = [strGeShi stringByAppendingFormat:@"%c",c];
        }
    }
    return strGeShi;
}

+ (NSString *) phoneFromSendTelphone:(NSString *)str{
    if ([str isEqualToString:@"[]"]) {
        return @"";
    }else{
        NSString *sendStr = [str substringWithRange:NSMakeRange(1, str.length-2)];
        NSArray *arr = [sendStr componentsSeparatedByString:@","];
        if (arr==nil) {
            return sendStr;
        }else{
            NSString *onlypaceStr = [arr componentsJoinedByString:@" "];
            NSArray *enterArr = [onlypaceStr componentsSeparatedByString:@"\n"];
            NSString *str = @"";
            if (enterArr.count ==1) {
                return sendStr;
            }
            for (NSString *s in [onlypaceStr componentsSeparatedByString:@"\n"]) {
                if ([s isEqualToString: @""]) {
                    
                }else{
                    str = [str stringByAppendingString:[s substringFromIndex:4]];
                }
            }
            NSString *strGeShi = [[str componentsSeparatedByString:@" "] componentsJoinedByString:@","];
            return strGeShi;
        }
    }
}


+ (NSString *) dateStringFromNumberString:(NSString *)str{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]/1000];
    NSDateFormatter *fm=[[NSDateFormatter alloc]init];
//    fm.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    fm.dateFormat=@"MM-dd HH:mm";
    return [fm stringFromDate:date];
}

+ (NSString *) fullDateStringFromNumberString:(NSString *)str{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]/1000];
    NSDateFormatter *fm=[[NSDateFormatter alloc]init];
    //    fm.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    fm.dateFormat=@"yyyy-MM-dd HH:mm";
    return [fm stringFromDate:date];
}

+(NSString *)dateStringFromNumberDate:(NSDate *)date{
    NSDateFormatter *fm=[[NSDateFormatter alloc]init];
    fm.dateFormat=@"yyyy-MM-dd HH:mm";
    return [fm stringFromDate:date];
}

+ (CGFloat) textHeightFromString:(NSString *)textStr width:(CGFloat)width fontsize:(CGFloat)Size{
    //最好判断一下SDK 的版本
    //下面的方法是ios7 的
    /**
     *  根据字符串的内容 和固定的宽度来求高度
     @param size 给一个预设的大小 宽度写成固定的 高度写成float 的最大值
     @param option 第二哥参数用于设置 是否以段为基准 不以base line 为准
     第三个参数对文字进行设置
     @return 真实的大小
     */
    float dev=[[[UIDevice currentDevice]systemVersion]floatValue];
    if (dev>=7.0) {
        NSDictionary *dict=@{
                             NSFontAttributeName: [UIFont systemFontOfSize:Size]
                             };
        
        CGRect frame=[textStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
        return frame.size.height;
        
    }else{
        CGSize size=[textStr sizeWithFont:[UIFont systemFontOfSize:Size] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        return size.height;
    }
    
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}

//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//利用正则表达式验证

+ (BOOL) isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) bankCard:(NSString *)cardID{
    NSString *regex = @"[0-9]{16,19}";
    NSPredicate *passwordText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [passwordText evaluateWithObject:cardID];
}

+ (NSMutableDictionary *)getMessageListAndSelectIndex{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/messageInfo.plist"];
    NSMutableDictionary *messageDict=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    return messageDict;
}

+ (NSString *)getMessagePath{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/messageInfo.plist"];
    return filePath;
}

@end
