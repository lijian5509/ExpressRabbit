//
//  FixBankCheckViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-26.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "FixBankCheckViewController.h"
#import "EditBankCardViewController.h"


@interface FixBankCheckViewController ()
{
    NSTimer *_timer;//定时器
    NSInteger _seconds;//60秒
}
@end

@implementation FixBankCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(upDateTimer) userInfo:nil repeats:YES];
        _seconds = 60;
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
        self.dataArray=[[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"修改银行卡"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改银行卡"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.delegate=self;
    self.smallTitleView.backgroundColor=[UIColor whiteColor];
    self.smallTitleView.layer.cornerRadius=10;
    [self showUI];
    [self getBackKeybord];
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
    AFHTTPClient *alient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,YINGHANGSMS];//验证码接口
    NSString *xiuGaiUrl=[NSString stringWithFormat:CESHIZONG,XIUGAIYINHANGKA];//修改银行卡
    NSString *sureUrl=[NSString stringWithFormat:CESHIZONG,YINHANGYANZHENGYZM];//验证验证码是否正确的接口
    if (sender.tag==101) {//获取验证码
        self.checkBtn.enabled=NO;
        if ([self.dataArray count]==0) {
            [self showAlert:@"未获取银行信息" isSure:YES];
            return;
        }
        NSString *phoneStr=self.dataArray[3];
        NSString *sign=[Helper addSecurityWithUrlStr:YINGHANGSMS];
        [alient postPath:postUrl parameters:@{@"mobile": phoneStr,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
            if (isSuccess) {
                [self showAlertViewWithMaessage:@"验证码已发送，请查收" title:nil otherBtn:nil];
                [_timer setFireDate:[NSDate distantPast]];
            }else{
                self.checkBtn.enabled=YES;
                [_timer setFireDate:[NSDate distantFuture]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.checkBtn.enabled=YES;
            [self showAlertViewWithMaessage:@"网络异常" title:@"提示" otherBtn:nil];
        }];
    }
    if (sender.tag==102)//确认
    {
        if(self.count==10){//提交银行卡
            if ([self.dataArray[1] length]<13) {
                [self showAlert:@"请输入正确的卡号" isSure:YES];
                return;
            }
            if (![Helper validateMobile:self.dataArray[3]]) {
                [self showAlert:@"请输入正确的手机号" isSure:YES];
                return;
            }
            if(self.textField.text.length==0){
                [self showAlert:@"请输入验证码" isSure:YES];
                return;
            }
            if (self.textField.text.length!=4) {
                [self showAlert:@"请输入正确的验证码" isSure:YES];
                return;
            }
            NSString *sign=[Helper addSecurityWithUrlStr:XIUGAIYINHANGKA];
            [alient postPath:xiuGaiUrl parameters:@{@"courierId":dictPlist[@"id"],@"cardName":self.dataArray[0],@"bankCard":self.dataArray[1],@"bankName":self.dataArray[2],@"checkMobile":self.dataArray[3],@"random":self.textField.text,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                if (isSuccess) {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                }else{
                    [self showAlertViewWithMaessage:@"提交失败" title:nil otherBtn:nil];
                    self.checkBtn.enabled=YES;
                    _seconds=60;
                    [_timer setFireDate:[NSDate distantFuture]];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlert:@"网络错误" isSure:YES];
            }];
            return;
        }else{
            if (self.textField.text.length==0) {
                //验证验证码
                [self showAlertViewWithMaessage:@"请输入验证码" title:@"提示" otherBtn:nil];
                [self.textField becomeFirstResponder];
                return;
            }
            if (self.textField.text.length!=4) {
                [self showAlertViewWithMaessage:@"请输入正确的验证码" title:@"提示" otherBtn:nil];
                [self.textField becomeFirstResponder];
                return;
            }
            NSString *sign=[Helper addSecurityWithUrlStr:YINHANGYANZHENGYZM];
            NSLog(@"%@",sign);
            [alient postPath:sureUrl parameters:@{@"mobile": [[NSUserDefaults standardUserDefaults]valueForKey:@"bankMobile"],@"random":self.textField.text,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                if (isSuccess) {
                    EditBankCardViewController *edit=[[EditBankCardViewController alloc]init];
                    edit.dataArray=self.dataArray;
                    self.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:edit animated:YES];
                }else{
                    self.checkBtn.enabled=YES;
                    [self.checkBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    _seconds=60;
                    self.textField.text = @"";
                    [_timer setFireDate:[NSDate distantFuture]];
                    [self showAlertViewWithMaessage:@"提交失败" title:nil otherBtn:nil];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
            }];
        }
    }
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
