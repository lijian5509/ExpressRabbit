//
//  RegisterViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-15.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "RegisterViewController.h"
//#import "FillMessageViewController.h"
//#import "LogInViewController.h"

@interface RegisterViewController ()
{
    NSTimer *_timer;//定时器
    NSInteger _seconds;//60秒
    AFHTTPClient *aClient;//下载请求，初始化一次即可
    
}
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(upDateTimer) userInfo:nil repeats:YES];
        _seconds = 60;
        aClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
    [self getBackKeybord];
    self.testTextField.delegate=self;
    self.phoneTextField.delegate=self;
    self.passwordTextField.delegate=self;
    self.tPasswordField.delegate=self;
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"登录_01"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    UIButton *btn = (UIButton *)[self.view viewWithTag:102];
    btn.userInteractionEnabled=NO;
}
#pragma mark -收键盘
SHOUJIANPAN;
INPUTACCESSVIEW

#pragma mark - 实现协议的内容

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag>202) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect=self.view.frame;
            rect.origin.y-=90;
            self.view.frame=rect;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag>202) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect=self.view.frame;
            rect.origin.y+=90;
            self.view.frame=rect;
        }];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 202) {
        if (self.phoneTextField.text.length==0) {
            [self showAlertViewWithMaessage:@"请先输入手机号"];
            return NO;
        }
    }
    return YES;
}

//结束输入 - 判断每个输入是否合理
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 201)
    {
        if ([textField.text length] == 0) {
            
            [self showAlertViewWithMaessage:@"请输入手机号"];
            return YES;
        }
        BOOL isMatch = [Helper validateMobile: textField.text];
        if (!isMatch) {
            [self showAlertViewWithMaessage:@"请输入正确的手机号码"];
            return NO;
        }
    }
//    if (textField.tag == 202)
//    {
//        if ([textField.text length] == 0) {
//            [self showAlertViewWithMaessage:@"请输入验证码"];
//            return YES;
//            
//        }
//        BOOL isMatch = [Helper validatePassword: textField.text];
//        if (!isMatch) {
//            [self showAlertViewWithMaessage:@"验证码输入有误"];
//        }
//    }
    if (textField.tag == 203)
    {
        if ([textField.text length] == 0) {
            [self showAlertViewWithMaessage:@"请输入密码"];
            return YES;
        }
        BOOL isMatch = [Helper validatePassword: textField.text];
        if (!isMatch) {
            [self showAlertViewWithMaessage:@"密码格式有误"];
            return YES;
        }
    }
    if (textField.tag == 204)
    {
        if ([textField.text length] == 0) {
            [self showAlertViewWithMaessage:@"请确认密码"];
            return YES;
            
        }
        if (![self.passwordTextField.text isEqualToString:self.tPasswordField.text]) {
            [self showAlertViewWithMaessage:@"密码输入有误"];
            return YES;
        }
    }
    return YES;
}
//输入时设置每个输入框的限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==201) {
        if (textField.text.length + string.length>11) {
            return NO;
        }
    }
    
    if (textField.tag==202) {
        if (textField.text.length+string.length>4) {
            return NO;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//检测数据是否为空
- (BOOL)testTextFieldData{
    if (self.phoneTextField.text.length==0) {
        return NO;
    }
    return YES;
}

- (IBAction)btnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 103://获取验证码
        {
            //先检测号码是否为空
            BOOL isKong = [self testTextFieldData];
            if (isKong) {
                //检测手机是否注册过
                NSDictionary *dic = @{@"mobile": self.phoneTextField.text};
                NSString *urlPath = [NSString stringWithFormat:CESHIZONG,SHIFOUZHUCE];
                //初始化为空 方便下面统一赋值
                [aClient postPath:urlPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    BOOL n = [(NSNumber *)dataDict[@"success"] boolValue];
                    if (!n) {//没有注册就给手机发送验证码    同时开启定时器
                        NSString *postPath=[NSString stringWithFormat:CESHIZONG,FASONGYANZHENG];
                        [aClient postPath:postPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [self showAlertViewWithMaessage:@"验证码已发送，请注意查收,5分钟后失效！"];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"%@",error);
                        }];
                        [_timer setFireDate:[NSDate distantPast]];//block内无法开启线程
                    }else{//判断是否激活
                        NSNumber *checkStatus=dataDict[@"result"][@"checkStatus"];
                        if ([checkStatus boolValue]) {
                            [self showAlertViewWithMaessage:@"该用户已激活，请到登录界面登录"];
                            return;
                        }
                        NSString *postPath=[NSString stringWithFormat:CESHIZONG,FASONGYANZHENG];
                        [aClient postPath:postPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [self showAlertViewWithMaessage:@"验证码已发送，请注意查收,5分钟后失效！"];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"%@",error);
                        }];
                        [_timer setFireDate:[NSDate distantPast]];

                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                }];

            }else {
                [self showAlertViewWithMaessage:@"号码不能为空"];
            }
        }
            break;
        case 104://注册
        {
            NSDictionary *dict = @{@"mobile": self.phoneTextField.text,@"random":self.testTextField.text,@"password":self.passwordTextField.text};
            NSString *urlPath = [NSString stringWithFormat:CESHIZONG,ZHUCE];
            [aClient postPath:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL n = [(NSNumber *)dataDict[@"success"] boolValue];
                if (n) {//注册成功，跳转到完善信息界面
                    GET_PLISTdICT //保存用户电话
                    [dictPlist setValue:self.phoneTextField.text forKey:@"regMobile"];
                    [dictPlist writeToFile:filePatn atomically:YES];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLog"];//记录用户已登录 下次直接加载主页面
                    FillMessageViewController *fil=[[FillMessageViewController alloc]init];
                    [self.navigationController pushViewController:fil animated:YES];
                }else{
                    [self showAlertViewWithMaessage:@"注册失败，请认真核对信息"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
        }
            break;
            
        default:
            break;
    }
}

//开启定时器
-(void)upDateTimer{
    UIButton *btn = (UIButton *)[self.view viewWithTag:103];
    btn.enabled = NO;
    _seconds--;
    btn.titleLabel.text=[NSString stringWithFormat:@"%ld秒",_seconds];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    if (_seconds == 1) {
        [_timer setFireDate:[NSDate distantFuture]];
        _seconds = 60;
        btn.titleLabel.text=[NSString stringWithFormat:@"%ld",_seconds];
        btn.enabled=YES;
    }
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)title{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
