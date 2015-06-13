//
//  AppDelegate.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-23.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HandWriteViewController.h"
#import "EditBankCardViewController.h"
#import "Music.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //友盟统计
    [MobClick startWithAppkey:@"5487ac94fd98c53e99000c7a" reportPolicy:BATCH   channelId:nil];
    //记录当前的版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //Badge  标记
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    [APService setupWithOption:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BOOL isFirst=[[[NSUserDefaults standardUserDefaults]objectForKey:@"first"]boolValue];
    if (!isFirst) {//plist文件创建一次
        [self creatPlistFile];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"first"];
    }
    self.window.rootViewController=[TabBarViewController shareTabBar];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 创建一个本地plist文件存储数据

- (void)creatPlistFile{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"refresh"];
    [[NSUserDefaults standardUserDefaults]setValue:@"110" forKey:@"bankMobile"];
    [[NSUserDefaults standardUserDefaults]setValue:@"顺风快递" forKey:@"logisticsCompanyId"];//快递公司名字
    [[NSUserDefaults standardUserDefaults]setValue:@"14" forKey:@"expresscompanyId"];//快递公司id
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"finishCheck"];//是否提交过审核
    
    //在Document的目录下创建一个plist文件用来存放用户的信息
    NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userInfo.plist"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    [dict setObject:@"2" forKey:@"checkStatus"];//激活状态 0审核失败 ，1审核成功    ，2审核中
    [dict setObject:@"0" forKey:@"isBackGroundCoriner"];//是否是后台快递员
    [dict setObject:@"0" forKey:@"regMobile"];//用户手机号
    
    [dict setObject:@"0" forKey:@"id"];//用户id
    [dict setObject:@"0" forKey:@"version"];//版本
    
    [dict setObject:@"0" forKey:@"workStatus"];//记录工作状态
    [dict setObject:@"0" forKey:@"isTureNetSite"];//网点id  登陆时保存，用于判断用户是否完善信息
    
    [dict setObject:@"0" forKey:@"exit"];//记录是否退出  0,未登录过  1 登录 2 登录后退出
    [dict setObject:@"null" forKey:@"username"];//用户信息
    [dict setObject:@"" forKey:@"realname"];//用户真实姓名
    
    [dict setObject:@"0" forKey:@"bankCard"];
    [dict setObject:@"0" forKey:@"money"];//我的余额
    [dict setObject:@"0" forKey:@"invite"];//邀请码
    [dict writeToFile:path atomically:YES];
}

//已经注册来自远程通知的发送
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // Required
    //向极光服务器上报device Tokens
    [APService registerDeviceToken:deviceToken];
}
//已经接收远程通知 iOS8
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    //向极光服务器上报收到的推送消息
    [Music playReminderMusic:@"didi.mp3"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"trans" object:nil];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 0) {
        [APService handleRemoteNotification:userInfo];
        //打印收到的通知
        //    NSLog(@"---收到通知:%@", [self logDic:userInfo]);
        //最后把Iconbadge归0
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    [APService handleRemoteNotification:userInfo];
}
//已经接收远程通知 当前设备应用于此函数
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [Music playReminderMusic:@"didi.mp3"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"trans" object:nil];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 0) {
        //向服务器上报收到的推送消息
        [APService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
        //打印收到的通知
        //    NSLog(@"---收到通知:%@", [self logDic:userInfo]);
        //最后把Iconbadge归0
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}
//app已经成为本地---2
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"trans" object:nil];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber!=0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"trans" object:nil];
        [Music playReminderMusic:@"didi.mp3"];
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
    }];
    return YES;
}

@end
