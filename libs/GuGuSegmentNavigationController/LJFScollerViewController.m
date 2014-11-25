//
//  LJFScollerViewController.m
//  英雄联盟
//
//  Created by qianfeng on 14-9-28.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "LJFScollerViewController.h"
//#import "LogInViewController.h"
//#import "TabBarViewController.h"
//#import "FillMessageViewController.h"
//#import "AppDelegate.h"
//#import "WaitViewController.h"
//
//#import "FialViewController.h"

@interface LJFScollerViewController ()<UIScrollViewDelegate>
{
    NSInteger _currentIndex;
    UIScrollView *_scrollView;
    NSArray *_titleArray;
    UIImageView *_titleView;
    UIImageView *_rockView;
    NSArray *_viewControllers;
}
@end

@implementation LJFScollerViewController

#pragma mark - 页面将要显示的时候先判断是否完善信息和是否激活
- (void)viewWillAppear:(BOOL)animated{
    self.hidesBottomBarWhenPushed=YES;
   GET_PLISTdICT
    //查看是否退出登录
    NSString *exit=dictPlist[@"exit"];
    if (![exit isEqualToString:@"1"]) {
        LogInViewController *log=[[LogInViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:log];
        UIApplication *app=[UIApplication sharedApplication];
        AppDelegate *app2=app.delegate;
        app2.window.rootViewController=nil;
        app2.window.rootViewController=nav;
        return ;
    }
    
    CHECKSTATUS
    self.hidesBottomBarWhenPushed=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _currentIndex=0;
    [self creatScollers];
    [self creatTitleView];
    [self showUI];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.title=@"订单管理";
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
}


-(void)creatScollers{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 42, 320, self.view.frame.size.height-64-42)];
    _scrollView.backgroundColor=[UIColor grayColor];
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces = NO;
    _scrollView.contentOffset=CGPointMake(self.currentIndex*320, 0);
    _scrollView.contentSize=CGSizeMake(_viewControllers.count*320, 0);
    for (int i=0;i<_viewControllers.count ;i++) {
        UIViewController *view=_viewControllers[i];
        [self addChildViewController:view];
        view.view.frame=CGRectMake(320*i, 0,320,_scrollView.frame.size.height-44);
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
    
    _titleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320,40)];
    
    _titleView.userInteractionEnabled=YES;
    
    for (int i=0 ;i<_titleArray.count;i++) {
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"灰色背景 3"] forState:UIControlStateNormal];
        btn.tag=101+i;
//        [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
        btn.frame=CGRectMake(width *i, 0, width, 40);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:btn];
    }
    UIButton *btn=(UIButton *)[self.view viewWithTag:101];
    btn.selected=YES;
    
    [self.view addSubview:_titleView];
    _rockView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, width, 2)];
    _rockView.image=[UIImage imageNamed:@"订单详情_11"];
    [self.view addSubview:_rockView];
}
-(void)btnClick:(UIButton *)btn{
    _scrollView.contentOffset=CGPointMake((btn.tag-101)*320, 0);
    _currentIndex=btn.tag-101;
    for (UIButton *button in _titleView.subviews) {
        NSLog(@"%@",_titleView.subviews);
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
