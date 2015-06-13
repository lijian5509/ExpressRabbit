//
//  GetBackPasswordViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-15.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "GetBackPasswordViewController.h"

@implementation GetBackPasswordViewController
{
    AFHTTPClient *_client;
    NSTimer *_timer;//定时器
    NSInteger _seconds;//60秒
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self dataConfig];
    [self showUI];
    [self getBackKeybord];//设置二级键盘
    BACKVIEW;
}

-(void)dataConfig{
    _client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(upDateTimer) userInfo:nil repeats:YES];
    _seconds = 60;
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 摆UI界面
- (void)showUI{
    self.smallTopView.backgroundColor=[UIColor whiteColor];
    self.smallTopView.layer.cornerRadius=10;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"找回密码";
    
    CGRect frame=self.huiXianIamgeView.frame;
    frame.size.height=0.5;
    self.huiXianIamgeView.frame=frame;
    //返回键
    BACKKEYITEM;
    BACKVIEW;
}
-(void)getBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -收键盘
SHOUJIANPAN;
INPUTACCESSVIEW

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - 实现输入框的协议
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneText resignFirstResponder];
    [self.testField resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) ;
    }];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame=CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) ;
    }];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.25 animations:^{
         self.view.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) ;
    }];
    return YES;
}

- (IBAction)btnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 101://获取验证码
        {
            BOOL phoneIsOK=[Helper validateMobile:self.phoneText.text];
            if (phoneIsOK) {
                NSString *urlPath=[NSString stringWithFormat:CESHIZONG,WANGHUOQU];
                NSString *sign=[Helper addSecurityWithUrlStr:WANGHUOQU];
                NSDictionary *dict=@{@"mobile": self.phoneText.text,@"publicKey":PUBLICKEY,@"sign":sign};
                [_client postPath:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    [_timer setFireDate:[NSDate distantPast]];
                    BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                    if (isSuccess) {
                        [self showAlertViewWithMaessage:@"验证码已发送，请查收"];
                    }else{
                        [self showAlertViewWithMaessage:@"网络请求有误"];
                        self.testField.text=@"";
                        _seconds=60;
                        [_timer setFireDate:[NSDate distantFuture]];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self showAlertViewWithMaessage:@"网络错误"];
                }];
            }else{
                if (self.phoneText.text.length==0) {
                    [self showAlertViewWithMaessage:@"请输入号码"];
                }else{
                    [self showAlertViewWithMaessage:@"请输入正确的号码"];
                }
            }
        }
            break;
        case 102://转换到登录界面
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 103://确定
        {
            BOOL isValid = [self isValid];
            if (isValid) {
                //确认验证码是否正确，正确则跳转到下一个界面
                NSString *urlPath=[NSString stringWithFormat:CESHIZONG,WANGYANZHENG];
                NSString *sign=[Helper addSecurityWithUrlStr:WANGYANZHENG];
                NSDictionary *dict=@{@"random": self.testField.text,@"mobile": self.phoneText.text,@"publicKey":PUBLICKEY,@"sign":sign};
                [_client postPath:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    BOOL n = [(NSNumber *)dataDict[@"success"] boolValue];
                    if (!n) {
                        [self.yanZhengBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                        self.testField.text=@"";
                        _seconds=60;
                        [_timer setFireDate:[NSDate distantFuture]];
                        [self showAlertViewWithMaessage:@"验证码输入错误,请重新输入"];
                    }else{
                        GET_PLISTdICT
                        [dictPlist setValue:self.phoneText.text forKey:@"regMobile"];
                        [dictPlist writeToFile:filePatn atomically:YES];
                        TGetPasswordViewController *get=[[TGetPasswordViewController alloc]init];
                        [self.navigationController pushViewController:get animated:YES];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self showAlertViewWithMaessage:@"网络错误"];
                }];
            }
        }
            break;
        default:
            break;
    }
    
}
//开启定时器
-(void)upDateTimer{
    UIButton *btn = (UIButton *)[self.view viewWithTag:101];
    _seconds--;
    if([SYSTEMVERSION floatValue]>=8.0){
        [self.yanZhengBtn setTitle:[NSString stringWithFormat:@"%ld秒",_seconds] forState:UIControlStateNormal] ;
        if (_seconds == 1) {
            [_timer setFireDate:[NSDate distantFuture]];
            _seconds = 60;
           [self.yanZhengBtn setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal] ;
        }
    }else{
        self.yanZhengBtn.titleLabel.text=[NSString stringWithFormat:@"%ld秒",_seconds];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        if (_seconds == 1) {
            [_timer setFireDate:[NSDate distantFuture]];
            _seconds = 60;
            [btn setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal] ;
        }

    }
}
#pragma mark -判断输入是否有效
-(BOOL)isValid{
    if (self.phoneText.text.length==0||self.phoneText.text.length!=11) {
        [self showAlertViewWithMaessage:@"请输入手机号码"];
        return NO;
    }
    if (self.testField.text.length==0||self.testField.text.length!=4) {
        [self showAlertViewWithMaessage:@"请输入验证码"];
        return NO;
    }
    return [Helper validateMobile:self.phoneText.text];
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)title{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
