//
//  RegisterViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-15.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController
{
    NSTimer *_timer;//定时器
    NSInteger _seconds;//60秒
    AFHTTPClient *aClient;//下载请求，初始化一次即可
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self dataConfig];
    [self showUI];
    [self getBackKeybord];
    self.testTextField.delegate=self;
    self.phoneTextField.delegate=self;
    self.passwordTextField.delegate=self;
    self.tPasswordField.delegate=self;
}

-(void)dataConfig{
    _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(upDateTimer) userInfo:nil repeats:YES];
    _seconds = 60;
    aClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"320首页"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    UIButton *btn = (UIButton *)[self.view viewWithTag:102];
    btn.userInteractionEnabled=NO;
}
#pragma mark -收键盘
SHOUJIANPAN;
INPUTACCESSVIEW

#pragma mark - 实现协议的内容

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag>200) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect=self.view.frame;
            rect.origin.y-=75*(textField.tag-201);
            self.view.frame=rect;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag>200) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect=self.view.frame;
            rect.origin.y=64;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneTextField resignFirstResponder];
    [self.testTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.tPasswordField resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect=self.view.frame;
        rect.origin.y=64;
        self.view.frame=rect;
    }];

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
    if(sender.tag == 101)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if(sender.tag == 103)//获取验证码
    {
        
       self.testBtn.enabled=NO;
        //先检测号码是否为空
        BOOL isKong = [self testTextFieldData];
        if (![Helper validateMobile:self.phoneTextField.text]) {
            [self showAlertViewWithMaessage:@"请输入正确的号码"];
            return;
        }
        if (isKong) {
            NSString *postPath=[NSString stringWithFormat:CESHIZONG,FASONGYANZHENG];
            NSString *sign=[Helper addSecurityWithUrlStr:FASONGYANZHENG];
            [aClient postPath:postPath parameters:@{@"mobile":self.phoneTextField.text,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict2=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess=[(NSNumber *)dict2[@"success"] boolValue];
                if (isSuccess) {
                    [self showAlertViewWithMaessage:@"验证码已发送，请查收"];
                    self.testBtn.enabled=NO;
                    [_timer setFireDate:[NSDate distantPast]];
                    
                }else{
                    [self showAlertViewWithMaessage:dict2[@"message"]];
                    self.testBtn.enabled=YES;
                    self.testTextField.text=@"";
                    _seconds=60;
                    [_timer setFireDate:[NSDate distantFuture]];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                self.testBtn.enabled=YES;
                [self showAlertViewWithMaessage:@"网络错误"];
                NSLog(@"%@",error);
            }];
        }else {
            self.testBtn.enabled=YES;
            [self showAlertViewWithMaessage:@"号码不能为空"];
        }
        return;
    }
    
    GET_PLISTdICT //保存用户电话
    if(sender.tag == 104)//注册
    {
        if (![Helper validateMobile:self.phoneTextField.text]) {
            [self showAlertViewWithMaessage:@"号码不正确"];
            return;
        }
        if (self.testTextField.text.length==0) {
            [self showAlertViewWithMaessage:@"请输入验证码"];
            return;
        }
        if (self.testTextField.text.length!=4) {
            [self showAlertViewWithMaessage:@"验证码格式不正确"];
            return;
        }
        if (self.passwordTextField.text.length==0) {
            [self showAlertViewWithMaessage:@"请输入密码"];
            return;
        }
        if (self.passwordTextField.text.length<6) {
            [self showAlertViewWithMaessage:@"请输入正确的密码"];
            return;
        }
        if (self.tPasswordField.text.length==0) {
            [self showAlertViewWithMaessage:@"请输入确认密码"];
            return;
        }
        if (self.tPasswordField.text.length<6) {
            [self showAlertViewWithMaessage:@"确认密码格式不正确"];
            return;
        }
        if (![self.passwordTextField.text isEqualToString:self.tPasswordField.text]) {
            [self showAlertViewWithMaessage:@"确认密码有误,请重新输入"];
            return;
        }
        NSString *urlPath = [NSString stringWithFormat:CESHIZONG,ZHUCE];
        NSString *sign=[Helper addSecurityWithUrlStr:ZHUCE];
        NSDictionary *dict = @{@"mobile": self.phoneTextField.text,@"random":self.testTextField.text,@"password":self.passwordTextField.text,@"publicKey":PUBLICKEY,@"sign":sign};
        [aClient postPath:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL n = [(NSNumber *)dataDict[@"success"] boolValue];
            
            if (n) {//注册成功，跳转到完善信息界面
                [self showAlertViewWithMaessage:@"注册成功,即将跳转"];
                NSString *userId=[NSString stringWithFormat:@"%ld",[dataDict[@"result"][@"id"] longValue]];
                [dictPlist setValue:@"1" forKey:@"exit"];
                [dictPlist setValue:self.phoneTextField.text forKey:@"regMobile"];
                [dictPlist setValue:userId forKey:@"id"];
                [dictPlist writeToFile:filePatn atomically:YES];
                FillMessageViewController *fil=[[FillMessageViewController alloc]init];
                [self.navigationController pushViewController:fil animated:YES];
            }else{
                self.testBtn.enabled=YES;
                [self.testBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                _seconds=60;
                self.testTextField.text = @"";
                [_timer setFireDate:[NSDate distantFuture]];
                [self showAlertViewWithMaessage:dataDict[@"message"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlertViewWithMaessage:@"网络错误"];
            NSLog(@"%@",error);
        }];
    }
    
}

//开启定时器
-(void)upDateTimer{
    UIButton *btn = (UIButton *)[self.view viewWithTag:103];
    btn.enabled = NO;
    _seconds--;
    if([SYSTEMVERSION floatValue]>=8.0){
        [btn setTitle:[NSString stringWithFormat:@"%ld秒",_seconds] forState:UIControlStateNormal] ;
        if (_seconds == 1) {
            [_timer setFireDate:[NSDate distantFuture]];
            _seconds = 60;
            [btn setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal] ;
            btn.enabled=YES;
        }
    }else{
        btn.titleLabel.text=[NSString stringWithFormat:@"%ld秒",_seconds];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        if (_seconds == 1) {
            [_timer setFireDate:[NSDate distantFuture]];
            _seconds = 60;
            [btn setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal] ;
            btn.enabled=YES;
        }
        
    }
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)title{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
