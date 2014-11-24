//
//  FialViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-21.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "FialViewController.h"
//#import "AppDelegate.h"
//#import "TabBarViewController.h"


@interface FialViewController ()

@end

@implementation FialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    GET_PLISTdICT
    self.phoneLabel.text=dictPlist[@"regMobile"];
    BACKKEYITEM
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"审核失败";

}
-(void)getBack{
    
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    [tab.view reloadInputViews];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    app2.window.rootViewController=nil;
    app2.window.rootViewController=tab;
    [tab creatSystemBar];
    tab.selectedIndex=0;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
