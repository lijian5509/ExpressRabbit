//
//  MessageCheckViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "MessageCheckViewController.h"
#import "BankDetailViewController.h"
#import "BalanceViewController.h"
#import "TakeOutMoneyViewController.h"

@implementation MessageCheckViewController
{
    NSTimer *_timer;//定时器
    NSInteger _seconds;//60秒
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.delegate=self;
    self.smallTitleView.backgroundColor=[UIColor whiteColor];
    self.smallTitleView.layer.cornerRadius=10;
    [self dataConfig];
    [self showUI];
}

-(void)dataConfig{
    _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(upDateTimer) userInfo:nil repeats:YES];
    _seconds = 60;
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"验证手机";
    BACKKEYITEM;
    BACKVIEW;
}
//设置二级键盘
INPUTACCESSVIEW;
SHOUJIANPAN

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"消息验证"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"消息验证"];
}

-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnClicked:(UIButton *)sender {
    GET_PLISTdICT
    AFHTTPClient *alient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,QUXIANYANZHENG];//验证码接口
    NSString *xiuGaiUrl=[NSString stringWithFormat:CESHIZONG,XIUGAIYINHANGKA];
    NSString *sureUrl=[NSString stringWithFormat:CESHIZONG,QUXIAN];//取现接口
    if (sender.tag==101) {//获取验证码
        self.testBtn.enabled=NO;
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"bankMobile"]);
        NSString *sign=[Helper addSecurityWithUrlStr:QUXIANYANZHENG];
        [alient postPath:postUrl parameters:@{@"mobile": [[NSUserDefaults standardUserDefaults]valueForKey:@"bankMobile"],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
            if (isSuccess) {
                [self showAlertViewWithMaessage:@"验证码已发送，请查收" title:@"提示" otherBtn:nil];
                [_timer setFireDate:[NSDate distantPast]];
                
            }else{
                self.testBtn.enabled=YES;
                [self showAlertViewWithMaessage:@"获取验证码失败" title:@"提示" otherBtn:nil];
                [_timer setFireDate:[NSDate distantFuture]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.testBtn.enabled=YES;
            [_timer setFireDate:[NSDate distantFuture]];
            [self showAlertViewWithMaessage:@"网络异常" title:@"提示" otherBtn:nil];
        }];
    }
    if (sender.tag==102){//确认
        if (self.textField.text.length==0) {
            [self showAlertViewWithMaessage:@"请输入验证码" title:@"提示" otherBtn:nil];
            [self.textField becomeFirstResponder];
            return;
        }
        if (self.textField.text.length!=4) {
            [self showAlertViewWithMaessage:@"请输入正确的验证码" title:@"提示" otherBtn:nil];
            [self.textField becomeFirstResponder];
            return;
        }
        //@param courierId 快递员Id,@param cardName持有者姓名,@param bankCard  卡号,@param bankName  银行名称,@param checkMobile  验证电话,@param random 验证码
        if (self.dataArray.count!=0) {//修改银行卡
            NSString *sign=[Helper addSecurityWithUrlStr:XIUGAIYINHANGKA];
            [alient postPath:xiuGaiUrl parameters:@{@"courierId":dictPlist[@"id"],@"cardName":self.dataArray[0],@"bankCard":self.dataArray[1],@"bankName":self.dataArray[2],@"checkMobile":self.dataArray[3],@"random":self.textField.text,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess= [(NSNumber *)dict[@"success"] boolValue];
                if (!isSuccess) {
                    self.testBtn.enabled=YES;
                    [ self.testBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    self.textField.text=@"";
                    _seconds=60;
                    [self showAlertViewWithMaessage:@"修改银行卡失败,请认真核对信息" title:@"提示" otherBtn:nil];
                }else{
                    [self showAlert:@"修改成功" isSure:YES];
                    TakeOutMoneyViewController *take=[[TakeOutMoneyViewController alloc]init];
                    take.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:take animated:YES];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
            }];
            
        }else{//提现
            NSString *sign=[Helper addSecurityWithUrlStr:QUXIAN];
            [alient postPath:sureUrl parameters:@{@"courierId":dictPlist[@"id"],@"turnOutMoney":self.cashNum,@"random":self.textField.text,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                if (!isSuccess) {
                    [self showAlertViewWithMaessage:@"操作失败" title:@"提示" otherBtn:nil];
                }else{
                    [self showAlert:@"恭喜提现成功,界面讲在2秒后跳转" isSure:YES];
                    [self performSelector:@selector(changeViewController) withObject:self afterDelay:0.25];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
            }];
        }
    }
}

#pragma mark - 提现成功后界面更换
-(void)changeViewController{
    NSArray *controllers=self.navigationController.viewControllers;
    [self.navigationController popToViewController:controllers[1] animated:YES];
}

#pragma mark - 输入框协议
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length + string.length>4) {
        return NO;
    }
    return YES;
}

//开启定时器
-(void)upDateTimer{
    UIButton *btn = (UIButton *)[self.view viewWithTag:101];
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
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}

#pragma mark - 提现成功后显示
- (void)timerFireMethod:(NSTimer*)theTimer{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
    BalanceViewController *bal=[[BalanceViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:bal animated:YES];
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
