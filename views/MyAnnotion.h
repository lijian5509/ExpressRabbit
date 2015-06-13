//
//  MyAnnotion.h
//  ExpressRabbit
//
//  Created by kuaiditu on 15-1-22.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotion : NSObject<MKAnnotation>//大头针协议
@property (nonatomic, assign) float longti;
@property (nonatomic, assign) float latti;//经纬度

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subName;

@end
