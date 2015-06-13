//
//  UserLocationManager.h
//  地图两个点之间的距离
//
//  Created by 快递兔 on 14-11-28.
//  Copyright (c) 2014年 快递兔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserLocationManager : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManage;
}

//城市名
@property (strong,nonatomic) NSString *cityName;
//用户纬度
@property (nonatomic,assign) float userLatitude;
//用户经度
@property (nonatomic,assign) float userLongtitude;
//用户位置
@property (nonatomic,strong) CLLocation *clloction;
//用户距离
@property (nonatomic,assign) NSInteger *muDiDistance;

//初始化单例
+(UserLocationManager *)shareManager;

//初始化百度地图用户位置管理类
-(void)initBMKUserLocation;

//开始定位
-(void)startLocation;

//停止定位
-(void)stopLocation;

//计算距离
-(float)CLLocationdistanceC1La:(float)c1La andC1Long:(float)c1Long andC2La:(float)c2La andC2Long:(float)c2Long;
//计算最终距离
-(CGFloat)getDistanceWithMuDiC1La:(float)c1La andC1Long:(float)c1Long;

@end
