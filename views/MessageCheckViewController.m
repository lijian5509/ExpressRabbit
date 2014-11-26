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

@interface MessageCheckViewController ()
{
    NSTimer *_timer;//定时器
    NSInteger _seconds;//60秒
}
@end

@implementation MessageCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(upDateTimer) userInfo:nil repeats:YES];
        _seconds = 60;
         [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.delegate=self;
    self.smallTitleView.backgroundColor=[UIColor whiteColor];
    self.smallTitleView.layer.cornerRadius=10;
    [self.testBtn setBackgroundImage:[UIImage imageNamed:@"注册_10"] forState:UIControlStateNormal];
    [self showUI];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"设置";
    BACKKEYITEM;
    BACKVIEW;
}
//设置二级键盘
INPUTACCESSVIEW;


-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton *)sender {
   GET_PLISTdICT
    AFHTTPClient *alient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,YINGHANGSMS];//验证码接口
    
    NSString *sureUrl=[NSString stringWithFormat:CESHIZONG,QUXIAN];//取现接口
    switch (sender.tag) {//获取验证码
        case 101:
        {
            if (self.textField.text.length==0) {
                [self showAlertViewWithMaessage:@"请输入验证码" title:@"提示" otherBtn:nil];
                [self.textField becomeFirstResponder];
                return;
            }
            if (self.textField.text.length!=4) {
                [self showAlertViewWithMaessage:@"请输入正确的验证码" title:@"警告" otherBtn:nil];
                [self.textField becomeFirstResponder];
                return;
            }
            [alient postPath:postUrl parameters:@{@"mobile": dictPlist[@"regMobile"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self showAlertViewWithMaessage:@"验证码已发送，请注意查收" title:@"提示" otherBtn:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlertViewWithMaessage:@"网络异常" title:@"提示" otherBtn:nil];
            }];
            [_timer setFireDate:[NSDate distantPast]];

        }
            break;
        case 102://确认
        {
            [alient postPath:sureUrl parameters:@{@"courierId":dictPlist[@"id"],@"turnOutMoney":self.cashNum,@"random":self.textField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess=dict[@"success"];
                if (!isSuccess) {
                    [self showAlertViewWithMaessage:@"提现失败,请认真核对信息" title:@"提示" otherBtn:nil];
                }else{
                    [self showAlert:@"恭喜提现成功" isSure:YES];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
            }];
        }
            break;
        default:
            break;
    }
    
    
}
#pragma mark - 提现成功后显示


#pragma mark - 输入框协议
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length + string.length>4) {
        return NO;
    }
       return YES;
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
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
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
