//
//  TGetPasswordViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-18.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "TGetPasswordViewController.h"

//#import "AppDelegate.h"
//#import "TabBarViewController.h"


@interface TGetPasswordViewController ()

@end

@implementation TGetPasswordViewController

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
    self.passwordText.delegate=self;
    self.surePasswordText.delegate=self;
    self.smallTopView.backgroundColor=[UIColor whiteColor];
    self.smallTopView.layer.cornerRadius=10;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"找回密码";
    //返回键、
    BACKKEYITEM;
    BACKVIEW;
}
#pragma mark -收键盘
SHOUJIANPAN;
INPUTACCESSVIEW

-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 实现代理协议的方法

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isValid{
    
    if (self.passwordText.text.length==0) {
        [self showAlertViewWithMaessage:@"请输入新密码"];
        return NO;
    }
    if (self.surePasswordText.text.length==0) {
        [self showAlertViewWithMaessage:@"请确认密码"];
        return NO;
    }
    if (![self.passwordText.text isEqualToString:self.surePasswordText.text]) {
        [self showAlertViewWithMaessage:@"请仔细核对密码"];
        return NO;
    }
    return YES;
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    BOOL isValid = [self isValid];
    if (isValid) {
        AFHTTPClient *aclient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
        NSString *strUrl=[NSString stringWithFormat:CESHIZONG,WANGGENGHUAN];
       GET_PLISTdICT
        NSString *phone=[NSString stringWithFormat:@"手机号:%@",dictPlist[@"regMobile"]];
        NSDictionary *dict=@{@"mobile": phone,@"password":self.passwordText.text};
        [aclient postPath:strUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL n = [(NSNumber *)dataDict[@"success"] boolValue];
            if (n) {
                UIApplication *app=[UIApplication sharedApplication];
                AppDelegate *app2=app.delegate;
                app2.window.rootViewController=[TabBarViewController shareTabBar];
            }else{
                [self showAlertViewWithMaessage:@" 信息错误 "];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}
//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)title{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
