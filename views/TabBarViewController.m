//
//  TabBarViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "TabBarViewController.h"
#import "Music.h"
#import "UserLocationManager.h"
#import "LJFScollerViewController.h"

@implementation TabBarViewController

#pragma mark - 创建一个非标准的单例
+(TabBarViewController *)shareTabBar{
    static TabBarViewController *Tab = nil;
    @synchronized(self){
        if (Tab == nil) {
            Tab=[[TabBarViewController alloc]init];
        }
    }
    return Tab;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"主控"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"主控"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.barTintColor=[UIColor whiteColor];
    self.tabBar.translucent=NO;
    [self creatSystemBar];
    [[UserLocationManager shareManager]startLocation];
    [self checkNewOrderNum];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkNewOrderNum) name:@"trans" object:nil];
}
#pragma mark - 检测当前有多少新的推送订单
- (void)checkNewOrderNum{
    GET_PLISTdICT
    AFHTTPClient *_client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
    if (![dictPlist[@"id"] isEqualToString:@"0"]) {
        NSString *urlPath=[NSString stringWithFormat:CESHIZONG,DINGDANWEIDU];
        NSString *sign=[Helper addSecurityWithUrlStr:DINGDANWEIDU];
        [_client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
            if(isSuccess){
                if ([dict[@"result"] integerValue]!=0) {
                    self.tabBarController.selectedIndex=1;
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"refresh"];
                    [[self.tabBar.items objectAtIndex:1] setBadgeValue:[dict[@"result"] stringValue] ];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        NSString *dataPath=[NSString stringWithFormat:CESHIZONG,XINLIUSHUISHUMU];
        NSString *key=[NSString stringWithFormat:@"%@Time",dictPlist[@"id"]];
        NSString *str=[[NSUserDefaults standardUserDefaults]stringForKey:key];
        if (str==nil) {
            str=@"0";
        }
        NSString *sign1=[Helper addSecurityWithUrlStr:XINLIUSHUISHUMU];
        [_client postPath:dataPath parameters:@{@"courierId": dictPlist[@"id"],@"motifyTime":str,@"publicKey":PUBLICKEY,@"sign":sign1}   success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
            if(isSuccess){
                if ([dict[@"result"][@"ProcessCount"] integerValue]!=0) {
                    [[self.tabBar.items objectAtIndex:3] setBadgeValue:[dict[@"result"][@"ProcessCount"] stringValue] ];
                }else{
                    [[self.tabBar.items objectAtIndex:3] setBadgeValue:nil];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 调用系统的tabBar
-(void)creatSystemBar{
    NSArray *selectImages = @[@"tabBar1",@"tabBar2",@"tabBar3",@"tabBar4"];
    NSArray *images= @[@"tabBar-1",@"tabBar-2",@"tabBar-3",@"tabBar-4"];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSArray *views=@[@"ShouYeViewController",@"LJFScollerViewController",@"DuanXinViewController",@"GeRenViewController"];
    NSArray *titles=@[@"首页",@"订单",@"短信",@"我"];
    for (int i=0; i<4; i++) {
        Class cls=NSClassFromString(views[i]);
        if (i==2||i==3) {
            UITableViewController *control=[[cls alloc]init];
            UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:control];
            navC.tabBarItem.image=[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.tabBarItem.selectedImage=[[UIImage imageNamed:selectImages[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.title=titles[i];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor grayColor]} forState:UIControlStateNormal];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor orangeColor]} forState:UIControlStateSelected];
            [array addObject:navC];
        }else if (i==1) {
            KuaiDiViewController *kuaiDi=[[KuaiDiViewController alloc]init];
            DidDealTableViewController *didDeal=[[DidDealTableViewController alloc]init];
            LJFScollerViewController *ljf=[[LJFScollerViewController alloc]initWithViewControllers:@[kuaiDi,didDeal] withTitle:@[@"待处理",@"已处理"]];
            UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:ljf];
            navC.tabBarItem.image=[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.tabBarItem.selectedImage=[[UIImage imageNamed:selectImages[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.title=titles[i];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor grayColor]} forState:UIControlStateNormal];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor orangeColor]} forState:UIControlStateSelected];
            [array addObject:navC];
        }else{
            UIViewController *control=[[cls alloc]init];
            UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:control];
            navC.tabBarItem.image=[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.tabBarItem.selectedImage=[[UIImage imageNamed:selectImages[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor grayColor]} forState:UIControlStateNormal];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor orangeColor]} forState:UIControlStateSelected];
            navC.title=titles[i];
            [array addObject:navC];
        }
    }
    self.viewControllers=array;
}

@end
