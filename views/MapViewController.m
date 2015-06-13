//
//  MapViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-12-8.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "MapViewController.h"
#import "UserLocationManager.h"
#import "MyAnnotion.h"

@interface MapViewController ()
{
    MKMapView *myMapView;
    MyAnnotion *UserAnnotion;
    MyAnnotion *ClientAnnotion;
    
}
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUI];
    self.view.backgroundColor=[UIColor whiteColor];
    BACKKEYITEM
    //1.实例化
    myMapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    //2.标注当前位置
    myMapView.showsUserLocation = YES;
    //3.设置当前位置标题
    myMapView.userLocation.title = @"我的位置";
    //4.设定区域
    MKCoordinateSpan span = MKCoordinateSpanMake(10, 10);
    //回到用户位置。animated：是否带有动画。
    [myMapView setRegion:MKCoordinateRegionMake(myMapView.userLocation.location.coordinate, span) animated:YES];
    myMapView.delegate = self;
    myMapView.mapType = MKMapTypeStandard;
    //5.添加视图
    [self.view addSubview:myMapView];
    
    if (ClientAnnotion == nil) {
        ClientAnnotion = [[MyAnnotion alloc]init];
    }
    NSLog(@"客户位置  %f %f",self.muBiao2La,self.muBiao2Long);
#pragma mark - 把百度地理坐标转换为高德地理坐标
    const  double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    //位置1
    float x = self.muBiao2Long - 0.0065, y = self.muBiao2La - 0.006;
    float z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    float theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    float gg_lon;
    float gg_lat;
    gg_lon = z * cos(theta);
    gg_lat = z * sin(theta);

    ClientAnnotion.latti = gg_lat;
    ClientAnnotion.longti = gg_lon;
    ClientAnnotion.name = @"客户位置";
    [myMapView addAnnotation:ClientAnnotion];
}

-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.title=@"订单详情";
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
}


#pragma mark - 实现代理协议
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
   //回到用户位置。animated：是否带有动画。
    [mapView setRegion:MKCoordinateRegionMake(mapView.userLocation.location.coordinate, span) animated:YES];
    
    //获取两地距离
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:self.muBiao2La  longitude:self.muBiao2Long];
    [self getDistanceWith:userLocation.location andOldLocation:orig];
    if (UserAnnotion == nil) {
        UserAnnotion = [[MyAnnotion alloc]init];
    }
    //distance 进行回调到前面的页面
}

#pragma mark - 计算距离
-(void)getDistanceWith:(CLLocation *)location andOldLocation:(CLLocation *)oldLocation{
    CLLocationDistance distance = [location distanceFromLocation:oldLocation];
    //代理反向传值
    [self.delegate transDis:[NSString stringWithFormat:@"%d",(int)distance]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"地图"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    myMapView.delegate == nil;
    [MobClick endLogPageView:@"地图"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
