//
//  NoMoneyViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "NoMoneyViewController.h"
#import "GetBankCardViewController.h"



@interface NoMoneyViewController ()
{
    AFHTTPClient *_client;
}
@end

@implementation NoMoneyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
}
//得到银行卡信息
-(void)viewWillAppear:(BOOL)animated{
    GET_PLISTdICT
    NSString *urlPath=[NSString stringWithFormat:CESHIZONG,GETBANKCARKMESSASGE];
    [_client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *bankCard=dict[@"result"][@"bankCard"];
        if (bankCard) {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
    }];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"设置";
    BACKVIEW;
    BACKKEYITEM;
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
    GetBankCardViewController *get=[[GetBankCardViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:get animated:YES];
    
}
//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btnT, nil];
    [alert show];
}


@end
