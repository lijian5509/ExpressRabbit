//
//  GetBackPasswordViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-15.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "GetBackPasswordViewController.h"
//#import "LogInViewController.h"
//#import "TGetPasswordViewController.h"


@interface GetBackPasswordViewController ()
{
    AFHTTPClient *_client;
    NSTimer *_timer;//定时器
    NSInteger _seconds;//60秒
    
}
@end

@implementation GetBackPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         _client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(upDateTimer) userInfo:nil repeats:YES];
        _seconds = 60;
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
    [self getBackKeybord];//设置二级键盘
}
#pragma mark - 摆UI界面
- (void)showUI{
    self.smallTopView.backgroundColor=[UIColor whiteColor];
    self.smallTopView.layer.cornerRadius=10;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"找回密码";
    //返回键、
    BACKKEYITEM;
    BACKVIEW;
}
-(void)getBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -收键盘
SHOUJIANPAN;
INPUTACCESSVIEW

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark - 实现输入框的协议

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

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag==201) {
        if (![Helper validateMobile:textField.text]) {
            [self showAlertViewWithMaessage:@"请输入正确的手机号"];
            return NO;
        }
    }
    return YES;
}

- (IBAction)btnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 101://获取验证码
        {
            BOOL phoneIsOK=[Helper validateMobile:self.phoneText.text];
            if (phoneIsOK) {
                NSString *urlPath=[NSString stringWithFormat:CESHIZONG,WANGHUOQU];
                NSDictionary *dict=@{@"mobile": self.phoneText.text};
                [_client postPath:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self showAlertViewWithMaessage:@"验证码已发送，请注意查收,5分钟内有效"];
                    [_timer setFireDate:[NSDate distantPast]];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
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
                NSDictionary *dict=@{@"random": self.testField.text,@"mobile": self.phoneText.text};
                [_client postPath:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    BOOL n = [(NSNumber *)dataDict[@"success"] boolValue];
                    if (!n) {
                        [self showAlertViewWithMaessage:@"验证码输入错误,请重新输入"];
                        return ;
                    }else{
                        TGetPasswordViewController *get=[[TGetPasswordViewController alloc]init];
                        [self.navigationController pushViewController:get animated:YES];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
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
