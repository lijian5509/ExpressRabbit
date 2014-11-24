//
//  CheckPhoneViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "CheckPhoneViewController.h"
#import "MessageCheckViewController.h"

@interface CheckPhoneViewController ()

@end

@implementation CheckPhoneViewController

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
    self.textField1.delegate=self;
    self.textField2.delegate=self;
    self.smallTitleView.backgroundColor=[UIColor whiteColor];
    self.smallTitleView.layer.cornerRadius=10;
    [self.textBtn setBackgroundImage:[UIImage imageNamed:@"注册_10"] forState:UIControlStateNormal];
    [self showUI];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"验证手机";
    //返回键、
    BACKKEYITEM;
    BACKVIEW;
}
-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 收键盘
SHOUJIANPAN;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton *)sender {
    MessageCheckViewController *message=[[MessageCheckViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:message animated:YES];
    
}
@end
