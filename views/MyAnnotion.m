//
//  MyAnnotion.m
//  ExpressRabbit
//
//  Created by kuaiditu on 15-1-22.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "MyAnnotion.h"

@implementation MyAnnotion

//实现协议方法
-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.latti, self.longti);
}
//标题
- (NSString *)title{
    return self.name;
}

//副标题
-(NSString *)subtitle{
    return self.subName;
}


@end
