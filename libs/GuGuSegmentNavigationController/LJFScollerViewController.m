//
//  LJFScollerViewController.m
//  英雄联盟
//
//  Created by qianfeng on 14-9-28.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "LJFScollerViewController.h"
#import "UserLocationManager.h"
#import "ShenHeZhongVC.h"
#import "ShenHeShiBaiVC.h"

@implementation LJFScollerViewController
{
    NSInteger _currentIndex;
    UIScrollView *_scrollView;
    NSArray *_titleArray;
    UIImageView *_titleView;
    UIImageView *_rockView;
    NSArray *_viewControllers;
}

#pragma mark - 页面将要显示的时候先判断是否完善信息和是否激活
- (void)viewWillAppear:(BOOL)animated{
    [MobClick beginLogPageView:@"订单"];
    GET_PLISTdICT
    //查看是否退出登录
    NSString *exit=dictPlist[@"exit"];
    if (![exit isEqualToString:@"1"]) {
        [self changeRootController];
    }else{
        GET_PLISTdICT
        if ([dictPlist[@"isBackGroundCoriner"] isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkNewOrderNum) name:@"trans" object:nil];
        }else{
            NSLog(@"isTureNetSite:%@     checkStatus:%@",dictPlist[@"isTureNetSite"],dictPlist[@"checkStatus"]);
            [self checkStausFromNetSite:dictPlist[@"isTureNetSite"] andCheckStatus:dictPlist[@"checkStatus"]];
        }
    }
}

-(void)changeRootController{
    LogInViewController *log=[[LogInViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:log];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    app2.window.rootViewController=nav;
}

-(void)checkStausFromNetSite:(NSString *)netSite andCheckStatus:(NSString *)check{
    if ([netSite isEqualToString:@"0"]) {//进入完善信息界面
        FillMessageViewController *fvc = [[FillMessageViewController alloc] init];
        fvc.hidesBottomBarWhenPushed = YES;
        fvc.isOderManager = YES;
        [self.navigationController pushViewController:fvc animated:YES];
    }else{
        if ([check isEqualToString:@"1"]) {//隐藏 表示已经审核通过
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkNewOrderNum) name:@"trans" object:nil];
        }else if ([check isEqualToString:@"0"]){//审核未通过
            ShenHeShiBaiVC *svc = [[ShenHeShiBaiVC alloc] init];
            svc.hidesBottomBarWhenPushed = YES;
            svc.isOderManager = YES;
            [self.navigationController pushViewController:svc animated:YES];
        }else{//审核中
            ShenHeZhongVC *svc = [[ShenHeZhongVC alloc] init];
            svc.hidesBottomBarWhenPushed = YES;
            svc.isOderManager = YES;
            [self.navigationController pushViewController:svc animated:YES];
        }
    }
}

#pragma mark - 检测当前有多少新的推送订单
- (void)checkNewOrderNum{
    GET_PLISTdICT
    if (![dictPlist[@"id"] isEqualToString:@"0"]) {
        AFHTTPClient *_client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
        NSString *urlPath=[NSString stringWithFormat:CESHIZONG,DINGDANWEIDU];
        [_client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
            if(isSuccess){
                if ([dict[@"result"] integerValue]!=0) {
                    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[dict[@"result"] stringValue] ];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
                }else{
                    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - 页面将要消失时移除管擦者
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订单"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self dataConfig];
    [self showUI];
}

-(void)dataConfig{
    _currentIndex = 0;
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.title=@"订单";
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    [self creatScollers];
    [self creatTitleView];
}

-(void)creatScollers{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 320, self.view.frame.size.height-64-20)];
    _scrollView.backgroundColor=[UIColor grayColor];
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces = NO;
    _scrollView.contentSize=CGSizeMake(_viewControllers.count*320, 0);
    for (int i=0;i<_viewControllers.count ;i++) {
        UIViewController *view=_viewControllers[i];
        [self addChildViewController:view];
        view.view.frame=CGRectMake(320*i, 0,320,_scrollView.frame.size.height-49);
        [_scrollView addSubview:view.view];
    }
}

-(id)initWithViewControllers:(NSArray *)controllers withTitle:(NSArray *)titles{
    self = [super init];
    if (self){
        _viewControllers=controllers;
        _titleArray=titles;
    }
    return self;
}

-(void)creatTitleView{
    NSInteger viewWidth=320;
    NSInteger width=0;
    if (_titleArray.count>=6) {
        width=50;
        viewWidth=width*_titleArray.count;
    }else{
        width=320/_titleArray.count;
    }
    _titleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    _titleView.userInteractionEnabled=YES;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, 320, 0.5)];
    imageView.image=[UIImage imageNamed:@"灰线"];
    
    for (int i=0 ;i<_titleArray.count;i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"灰色背景 3"] forState:UIControlStateNormal];
        btn.tag=101+i;
        btn.frame=CGRectMake(width *i, 0, width, 60);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:btn];
    }
    UIButton *btn=(UIButton *)[self.view viewWithTag:101];
    btn.selected=YES;
    [self.view addSubview:_titleView];
    [self.view addSubview:imageView];
    _rockView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 57, width, 3)];
    _rockView.image=[UIImage imageNamed:@"订单详情_11"];
    [self.view addSubview:_rockView];
    
}
-(void)btnClick:(UIButton *)btn{
    _scrollView.contentOffset=CGPointMake((btn.tag-101)*320, 0);
    _currentIndex=btn.tag-101;
    for (UIButton *button in _titleView.subviews) {
        if (button.tag==btn.tag) {
            button.selected=YES;
        }else{
            button.selected=NO;
        }
    }
    CGPoint point=_rockView.center;
    point.x=btn.center.x;
    _rockView.center=point;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int i=scrollView.contentOffset.x/320;
    UIButton *btn=(UIButton *)[self.view viewWithTag:101+i];
    [self btnClick:btn];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
