//
//  TGetPasswordViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-18.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "TGetPasswordViewController.h"

@implementation TGetPasswordViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self showUI];
}

- (void)showUI{
    self.passwordText.delegate=self;
    self.surePasswordText.delegate=self;
    self.smallTopView.backgroundColor=[UIColor whiteColor];
    self.smallTopView.layer.cornerRadius=10;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"找回密码";
    //返回键
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.passwordText resignFirstResponder];
    [self.surePasswordText resignFirstResponder];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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
        AFHTTPClient *aclient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
        NSString *strUrl=[NSString stringWithFormat:CESHIZONG,WANGGENGHUAN];
       GET_PLISTdICT
        NSString *phone=[NSString stringWithFormat:@"%@",dictPlist[@"regMobile"]];
        NSString *sign=[Helper addSecurityWithUrlStr:WANGGENGHUAN];
        NSDictionary *dict=@{@"mobile": phone,@"password":self.passwordText.text,@"publicKey":PUBLICKEY,@"sign":sign};
        [aclient postPath:strUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL n = [(NSNumber *)dataDict[@"success"] boolValue];
            if (n) {
                [self showAlert:@"更改成功,请重新登录" isSure:YES];
                LogInViewController *log=[[LogInViewController alloc]init];
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:log];
                [self presentViewController:nav animated:YES completion:nil];
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
#pragma mark - 提现成功后显示
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *) _message isSure:(BOOL)sure{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    if (sure) {
        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:YES];
        
    }
    [promptAlert show];
}


@end
