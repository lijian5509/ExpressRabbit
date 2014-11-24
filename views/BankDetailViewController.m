//
//  BankDetailViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "BankDetailViewController.h"


@interface BankDetailViewController ()

@end

@implementation BankDetailViewController

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
    [self showUI];
}
#pragma mark - 摆UI界面
- (void)showUI{
    self.textField1.delegate=self;
    self.textField2.delegate=self;
    self.textField3.delegate=self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"银行卡详情";
    //返回键、
    BACKKEYITEM;
    BACKVIEW;
    UIButton *bianJiBtn=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 50, 40) target:self sel:@selector(editorBtn) tag:201 image:nil title:@"编辑"];
    bianJiBtn.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [bianJiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:bianJiBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}
-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)editorBtn{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
