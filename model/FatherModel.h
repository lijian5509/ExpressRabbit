//
//  FatherModel.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-22.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FatherModel : NSObject
//重写这个方法 kvc 的时候调用
//防止 数据模型中没有实现 key 对应的方法 产生崩溃
//如果没有实现 key 指定的属性方法 这个时候会调用这个方法而不崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
