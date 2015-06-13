//
//  UserLocationManager.m
//  地图两个点之间的距离
//
//  Created by 快递兔 on 14-11-28.
//  Copyright (c) 2014年 快递兔. All rights reserved.
//

#import "UserLocationManager.h"

@implementation UserLocationManager

+(UserLocationManager *)shareManager{
    static UserLocationManager *_instance = nil;
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[UserLocationManager alloc] init];
            
        }
    }
    return _instance;
}

-(id)init{
    if (self == [super init]) {
        
    }
    locationManage = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"开始执行定位服务" );
        [locationManage setDelegate:self];
        locationManage.distanceFilter = 50;
        [locationManage setDesiredAccuracy:kCLLocationAccuracyBest];
        if ([[[UIDevice currentDevice]systemVersion] floatValue]>=8.0) {
            [locationManage requestAlwaysAuthorization];
            [locationManage requestWhenInUseAuthorization];
        }
//        [locationManage startUpdatingLocation];
    }else{
         NSLog( @"定位无法使用" );
    }
   
    return self;
}

//-(void)initBMKUserLocation{
//    if([CLLocationManager locationServicesEnabled])
//    {
//        NSLog( @"开始执行定位服务" );
//        // 设置定位精度：最佳精度
//        locationManage.desiredAccuracy = kCLLocationAccuracyBest;
//        // 设置距离过滤器为50米，表示每移动50米更新一次位置
//        locationManage.distanceFilter = 50;
//        // 将视图控制器自身设置为CLLocationManager的delegate
//        // 因此该视图控制器需要实现CLLocationManagerDelegate协议
//       locationManage.delegate = self;
//        // 开始监听定位信息
//        [locationManage startUpdatingLocation];
//    }else
//    {
//        NSLog( @"无法使用定位服务！" );
//    }
//    if ([CLLocationManager locationServicesEnabled] == NO) {
//        NSLog(@"服务未开启");
//        return;
//    }else{
//        NSLog(@"服务已开启");
//    }
//}
//

-(void)startLocation{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            locationManage = [[CLLocationManager alloc] init];
            locationManage.delegate = self;
            [locationManage startUpdatingLocation];
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位服务未打开，请在设置里面手动开启" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"定位功能不可用，提示用户或忽略");
    }
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=8.0) {
        [locationManage requestAlwaysAuthorization];
        [locationManage requestWhenInUseAuthorization];
    }
    [locationManage startUpdatingLocation];
}


-(void)stopLocation{
     [locationManage stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations{
    for (CLLocation *loc in locations) {
        float x = loc.coordinate.latitude;//纬度
        float y = loc.coordinate.longitude;//经度
        self.clloction = loc;
        self.userLatitude = loc.coordinate.latitude;
        self.userLongtitude = loc.coordinate.longitude;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dis" object:nil];
        [self stopLocation];
    }
}

-(CGFloat)getDistanceWithMuDiC1La:(float)c1La andC1Long:(float)c1Long{
    
    if ((int)self.userLatitude == 0) {
        return 0;
    }
   
    float distance = [self CLLocationdistanceC1La:self.userLatitude andC1Long:self.userLongtitude andC2La:c1La andC2Long:c1Long];
    return distance;
}

//void bd_decrypt(double bd_lat, double bd_lon,double gg_lat,double gg_lon)
//{
//    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
//    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
//    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
//    gg_lon = z * cos(theta);
//    gg_lat = z * sin(theta);
//}

//- (void)getGeodeLocationAccordingBaidu:(float)bd_lat andLong:(float)bd_lon{
//    float x = bd_lon - 0.0065, y = bd_lat - 0.006;
//    float z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
//    float theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
//    float gg_lon;
//    float gg_lat;
//    gg_lon = z * cos(theta);
//    gg_lat = z * sin(theta);
//}

//两点之间的距离
-(float)CLLocationdistanceC1La:(float)c1La andC1Long:(float)c1Long andC2La:(float)c2La andC2Long:(float)c2Long{
#pragma mark - 百度地图与高德地图的坐标转换
    const  double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    //位置1
    float x = c2Long - 0.0065, y = c2La - 0.006;
    float z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    float theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    float gg_lon;
    float gg_lat;
    gg_lon = z * cos(theta);
    gg_lat = z * sin(theta);
    CLLocation *location=[[CLLocation alloc] initWithLatitude:c1La  longitude:c1Long];
    CLLocation *oldLocation=[[CLLocation alloc] initWithLatitude:gg_lat  longitude:gg_lon];
    CLLocationDistance distance = [location distanceFromLocation:oldLocation];
    return distance;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [locationManage stopUpdatingLocation];
    
    self.clloction = newLocation;
    self.userLatitude = self.clloction.coordinate.latitude;
    self.userLongtitude = self.clloction.coordinate.longitude;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dis" object:nil];
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locError:%@", error);
    [self stopLocation];
}


@end
