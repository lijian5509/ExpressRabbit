//
//  WaitViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-18.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "WaitViewController.h"

//#import "AppDelegate.h"
//#import "TabBarViewController.h"

@interface WaitViewController ()

@end

@implementation WaitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getBack{
    
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    [tab.view reloadInputViews];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    [tab creatSystemBar];
    tab.selectedIndex=0;
    app2.window.rootViewController=tab;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GET_PLISTdICT
    self.phoneLabel.text=[NSString stringWithFormat:@"手机号:%@",dictPlist[@"regMobile"]];
    self.imageView.alpha=1;
    self.title=@"等待审核";
    self.imageView.layer.cornerRadius=5;
    [self showUI];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    BACKKEYITEM
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
