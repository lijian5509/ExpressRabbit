//
//  LogInViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-15.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "LogInViewController.h"
#import "APService.h"

@implementation LogInViewController
{
    AMTumblrHud *tumblrHUD;
}

-(void)getBack{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    app2.window.rootViewController=tab;
    [tab creatSystemBar];
    tab.selectedIndex=0;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    BACKKEYITEM;
    [self showUI];
    [self getBackKeybord];//设置二级键盘
    self.phoneTextField.delegate=self;
    self.passwordText.delegate=self;
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.title=@"登录";
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    UIButton *btn=(UIButton *)[self.view viewWithTag:101];
    btn.userInteractionEnabled=NO;
}
#pragma mark -收键盘
SHOUJIANPAN;
INPUTACCESSVIEW

#pragma mark - 实现输入框的协议
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==201) {
        if (textField.text.length+string.length>11) {
            return NO;
        }
    }else{
        if (textField.text.length+string.length>16) {
            return NO;
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnClicked:(UIButton *)sender {
    if(sender.tag == 101){
        return;
    }
    if(sender.tag == 102)//注册
    {
        RegisterViewController *reg=[[RegisterViewController alloc]init];
        UINavigationController *nac=[[UINavigationController alloc]initWithRootViewController:reg];
        reg.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nac animated:YES completion:nil];
    }
    if(sender.tag == 103)//忘记密码
    {
        GetBackPasswordViewController *get=[[GetBackPasswordViewController alloc]init];
        UINavigationController *nac=[[UINavigationController alloc]initWithRootViewController:get];
        get.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [self presentViewController:nac animated:YES completion:nil];
    }
    if(sender.tag == 104)//确定登录
    {
        [self requestUrl];
    }
}
#pragma mark -用户请求
-(void)requestUrl{
    if (self.phoneTextField.text.length==0) {
        [self showAlertViewWithMaessage:@"账号不能为空"];
        return;
    }
    if (self.passwordText.text.length==0) {
        [self showAlertViewWithMaessage:@"密码不能为空"];
        return;
    }
    if(![Helper validateMobile:self.phoneTextField.text]){
        [self showAlertViewWithMaessage:@"号码格式不正确"];
        return;
    }
    NSString *urlPath=[NSString stringWithFormat:CESHIZONG,DENGLU];
    NSString *sign=[Helper addSecurityWithUrlStr:DENGLU];
    NSLog(@"登录sign:%@",sign);
    NSDictionary *dic=@{@"mobile": self.phoneTextField.text,@"password":self.passwordText.text,@"publicKey":PUBLICKEY,@"sign":sign};
    //动画
    SHOWACTIVITY
    //初始化为空 方便下面统一赋值
    GET_PLISTdICT
    AFHTTPClient *aClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [aClient postPath:urlPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [tumblrHUD removeFromSuperview];
        BOOL n=[(NSNumber *)dataDict[@"success"] boolValue];
        if (!n) {
            [self showAlertViewWithMaessage:dataDict[@"message"]];
            return ;
        }else{
            NSNumber *userId=dataDict[@"result"][@"id"];
            NSLog(@"---------%@----------",dataDict);
            NSNumber *verSion=dataDict[@"result"][@"version"];
            if (dataDict[@"result"][@"realname"]!=[NSNull null]) {
                [dictPlist setValue:dataDict[@"result"][@"realname"] forKey:@"realname"];
            }
            [dictPlist setValue:@"1" forKey:@"exit"];
            [dictPlist setValue:[userId stringValue] forKey:@"id"];
            [dictPlist setValue:[verSion stringValue] forKey:@"version"];
            [dictPlist setValue:[dataDict[@"result"][@"workFlag"] stringValue] forKey:@"workStatus"];
            [dictPlist setValue:dataDict[@"result"][@"courierCode"] forKey:@"invite"];
            if (![dataDict[@"result"][@"username"] isKindOfClass:[NSNull class]]) {
                [dictPlist setValue:dataDict[@"result"][@"username"] forKey:@"username"];
            }else{
                [dictPlist setValue:@"null" forKey:@"username"];
            }
            [dictPlist setValue:dataDict[@"result"][@"mobile"] forKey:@"regMobile"];
            
            if ([dataDict[@"result"][@"netSite"][@"id"] integerValue]==[dataDict[@"result"][@"defaultNetsiteId"] integerValue]) {//表示客户端注册的快递员
                if (dataDict[@"result"][@"regInfo"]==[NSNull null]) {//没有完善信息		
                    [dictPlist setValue:@"0" forKey:@"isTureNetSite"];  //1代表已经完善信息 0代表没有
                    [dictPlist writeToFile:filePatn atomically:YES];
                    [self changeRootViewController];
                }else{
                    [dictPlist setValue:@"1" forKey:@"isTureNetSite"];
                    [dictPlist setValue:[dataDict[@"result"][@"regInfo"][@"checkStatus"] stringValue] forKey:@"checkStatus"];
                    NSLog(@"userId:%@",dictPlist[@"id"]);
                    [APService setTags:nil alias:[NSString stringWithFormat:@"%@",dictPlist[@"id"]] callbackSelector:nil object:nil];
                    [dictPlist writeToFile:filePatn atomically:YES];
                    [self changeRootViewController];
                }
            }else{//表示后台快递员
                [dictPlist setValue:@"1" forKey:@"isTureNetSite"];  //1代表已经完善信息 0代表没有
                [dictPlist setValue:@"1" forKey:@"isBackGroundCoriner"]; //是否是后台快递员
                [APService setTags:nil alias:[NSString stringWithFormat:@"%@",dictPlist[@"id"]] callbackSelector:nil object:nil];
                [dictPlist writeToFile:filePatn atomically:YES];
                [self changeRootViewController];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tumblrHUD removeFromSuperview];
        [self showAlertViewWithMaessage:@"网络问题"];
    }];
}

#pragma mark - 切换视图控制器
-(void)changeRootViewController{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    [tab.view reloadInputViews];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    app2.window.rootViewController=tab;
    [tab creatSystemBar];
    tab.selectedIndex=0;
}

#pragma mark - 修改
#pragma mark - 点击输入框 调整高度
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==201) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame=CGRectMake(0, -30, self.view.frame.size.width, self.view.frame.size.height) ;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame=CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height) ;
        }];
    }
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneTextField resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) ;
    }];
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)title{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
