
//
//  Music.m
//  ExpressRabbit
//
//  Created by 快递兔 on 14-12-13.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "Music.h"
#import <AVFoundation/AVFoundation.h>
@implementation Music

//获取音乐的路径
+(NSURL *)getUrlMusic:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSLog(@"path:%@",path);
    return [NSURL fileURLWithPath:path];
}
//利用桥接 注册系统声音ID 用系统的播放音乐
+(void)playReminderMusic:(NSString *)str{
    SystemSoundID soundID;
    CFURLRef thoseUrl = (__bridge CFURLRef)[Music getUrlMusic:str];
    AudioServicesCreateSystemSoundID(thoseUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end
