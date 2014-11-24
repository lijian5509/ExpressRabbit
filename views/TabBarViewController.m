//
//  TabBarViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "TabBarViewController.h"
//#import "LJFScollerViewController.h"
//#import "DidDealTableViewController.h"
//#import "KuaiDiViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.barTintColor=[UIColor whiteColor];
    self.tabBar.translucent=NO;
    [self creatSystemBar];
    
}

#pragma mark 调用系统的tabBar
-(void)creatSystemBar{
    NSArray *images = @[@"tabBar1",@"tabBar2",@"tabBar3",@"tabBar4"];
    NSArray *selectImages= @[@"tabBar-1",@"tabBar-2",@"tabBar-3",@"tabBar-4"];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSArray *views=@[@"ShouYeViewController",@"LJFScollerViewController",@"DuanXinViewController",@"GeRenViewController"];
    NSArray *titles=@[@"首页",@"快递订单",@"短信通知",@"我"];
    for (int i=0; i<4; i++) {
        Class cls=NSClassFromString(views[i]);
        if (i==2||i==3) {
            UITableViewController *control=[[cls alloc]init];
            UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:control];
            navC.tabBarItem.image=[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.tabBarItem.selectedImage=[[UIImage imageNamed:selectImages[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.title=titles[i];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor orangeColor]} forState:UIControlStateNormal];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor grayColor]} forState:UIControlStateSelected];
            [array addObject:navC];
        }else if (i==1) {
            KuaiDiViewController *kuaiDi=[[KuaiDiViewController alloc]init];
            DidDealTableViewController *didDeal=[[DidDealTableViewController alloc]init];
            
            LJFScollerViewController *ljf=[[LJFScollerViewController alloc]initWithViewControllers:@[kuaiDi,didDeal] withTitle:@[@"待处理",@"已处理"]];
            UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:ljf];
            navC.tabBarItem.image=[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.tabBarItem.selectedImage=[[UIImage imageNamed:selectImages[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.title=titles[i];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor orangeColor]} forState:UIControlStateNormal];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor grayColor]} forState:UIControlStateSelected];
            [array addObject:navC];
        }else{
            UIViewController *control=[[cls alloc]init];
            UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:control];
            navC.tabBarItem.image=[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navC.tabBarItem.selectedImage=[[UIImage imageNamed:selectImages[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor orangeColor]} forState:UIControlStateNormal];
            [navC.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor grayColor]} forState:UIControlStateSelected];
            navC.title=titles[i];
            [array addObject:navC];
        }
    }
    self.viewControllers=array;
}

/*
#pragma mark - 增加子视图控制器
-(void)creatTabItems{
    NSArray *images = @[@"导航－橙色_12",@"导航－橙色_14",@"导航－橙色_16",@"导航－橙色_18"];
    NSArray *selectImages= @[@"导航－灰_12",@"导航－灰_14",@"导航－灰_16",@"导航－灰_18"];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSArray *views=@[@"ShouYeViewController",@"KuaiDiViewController",@"DuanXinViewController",@"GeRenViewController"];
    for (int i=0; i<4; i++) {
        Class cls=NSClassFromString(views[i]);
        if (i!=0) {
            UITableViewController *control=[[cls alloc]init];
            UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:control];
            [array addObject:navC];
        }else{
            UIViewController *control=[[cls alloc]init];
            UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:control];
            [array addObject:navC];
        }
        UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(80*i, 0, 80, 49) target:self sel:@selector(btnClick:) tag:101+i image:images[i] title:nil];
        [btn setBackgroundImage:[UIImage imageNamed:selectImages[i]] forState:UIControlStateSelected];
        [self.TabImageView addSubview:btn];
        if (i==0) {
            btn.selected=YES;
        }
        self.viewControllers=array;
    }
    
}

#pragma mark - btn被点击
- (void)btnClick:(UIButton *)btn{
    //设置为选中状态
    btn.selected = YES;
    //修改tabBarController的selectedIndex  这样我们就可以通过selectedIndex来管理视图切换
    //设置选中的视图控制器的索引
    self.selectedIndex = btn.tag - 101;
    //遍历tabBar所有子视图  把其他的button selected 改为NO
    for (UIView *view in self.TabImageView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.tag!= btn.tag) {
                //判断是否是其他的button
                ((UIButton *)view).selected = NO;
                //设置未选中
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 */

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
