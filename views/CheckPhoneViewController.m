//
//  CheckPhoneViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "CheckPhoneViewController.h"
#import "MessageCheckViewController.h"
#import "TakeOutMoneyViewController.h"

@interface CheckPhoneViewController ()
{
    NSTimer *_timer;//定时器
    NSInteger _seconds;//60秒
    
}
@end

@implementation CheckPhoneViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField1.delegate=self;
    self.textField2.delegate=self;
    self.smallTitleView.backgroundColor=[UIColor whiteColor];
    self.smallTitleView.layer.cornerRadius=10;
    [self showUI];
    
    CGRect rect1=self.lineView1.frame;
    rect1.size.height=0.5;
    self.lineView1.frame=rect1;
    [self.textBtn setBackgroundImage:[UIImage imageNamed:@"注册_10"] forState:UIControlStateNormal];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"验证手机";
    //返回键、
    BACKKEYITEM;
    BACKVIEW;
}
-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 收键盘
SHOUJIANPAN;

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==202) {
        if ([Helper validateMobile:self.textField1.text]) {
            return YES;
        }else{
            [self showAlertViewWithMaessage:@"请先输入手机号" title:@"提示" otherBtn:nil];
            [self.textField1 becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==201) {
        if (textField.text.length + string.length>11) {
            return NO;
        }
    }
    if (textField.tag==202) {
        if (textField.text.length + string.length>4) {
            return NO;
        }
    }
    return YES;
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
    NSString *urlStr=[NSString stringWithFormat:CESHIZONG,TIANJIAYINHANGKA];
    
    if (sender.tag==101) //获取验证码
    {
        sender.enabled = NO;
        if (self.textField1.text.length==0) {
            [self showAlertViewWithMaessage:@"请输入手机号" title:@"提示" otherBtn:nil];
            [self.textField1 becomeFirstResponder];
            return;
        }
        if ([Helper validateMobile:self.textField1.text]) {
            self.textField1.enabled=NO;
            NSString *sign=[Helper addSecurityWithUrlStr:YINGHANGSMS];
            [alient postPath:postUrl parameters:@{@"mobile": self.textField1.text,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                sender.enabled = YES;
                BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                if (isSuccess) {
                    [self showAlertViewWithMaessage:@"验证码已发送，请查收" title:@"提示" otherBtn:nil];
                    [_timer setFireDate:[NSDate distantPast]];
                }else{
                    self.textField1.enabled=YES;
                    [self showAlertViewWithMaessage:@"网络请求有误" title:@"提示" otherBtn:nil];
                    self.textBtn.enabled=YES;
                    self.textField2.text=@"";
                    _seconds=60;
                    [_timer setFireDate:[NSDate distantFuture]];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                sender.enabled = YES;
                [self showAlertViewWithMaessage:@"网络异常" title:@"提示" otherBtn:nil];
            }];
            
            return;
        }else{
            [self showAlertViewWithMaessage:@"请先输入手机号" title:@"提示" otherBtn:nil];
            self.textField1.text=@"";
            [self.textField1 becomeFirstResponder];
            return;
        }
    }
    
    if (sender.tag==102)//确定
    {
        
        //先判断数据是否有问题
        // courierId 快递员Id,@param cardName持有者姓名,@param bankCard  卡号,@param bankName  银行名称,@param checkMobile  验证电话,@param random 验证码
        if ([Helper validateMobile:self.textField1.text]) {
            if (self.textField2.text.length==0) {
                [self showAlertViewWithMaessage:@"请输入验证码" title:@"提示" otherBtn:nil];
                [self.textField2 becomeFirstResponder];
                return ;
            }else{
                NSString *sign=[Helper addSecurityWithUrlStr:TIANJIAYINHANGKA];
                [alient postPath:urlStr parameters:@{@"courierId": dictPlist[@"id"],@"cardName":self.dataArray[0],@"bankCard":self.dataArray[1],@"bankName":self.dataArray[2],@"checkMobile":self.textField1.text,@"random":self.textField2.text,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                    if (isSuccess) {
                        [[NSUserDefaults standardUserDefaults]setValue:self.textField1.text forKey:@"bankMobile"];
                        TakeOutMoneyViewController *take=[[TakeOutMoneyViewController alloc]init];
                        self.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:take animated:YES];
                    }else{
                        
                        self.textBtn.enabled=YES;
                        [ self.textBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                        _seconds=60;
                        self.textField2.text=@"";
                        [_timer setFireDate:[NSDate distantFuture]];
                        [self showAlertViewWithMaessage:@"提交失败,请认真核对后再提交" title:@"提示" otherBtn:nil];
                        return ;
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self showAlertViewWithMaessage:@"网路异常" title:@"提示" otherBtn:nil];
                    return ;
                }];
                
            }
        }else{
            [self showAlertViewWithMaessage:@"请仔细核对手机号码" title:@"提示" otherBtn:nil];
            [self.textField1 becomeFirstResponder];
            return ;
        }
    }
}
//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}
//开启定时器
-(void)upDateTimer{
    UIButton *btn = (UIButton *)[self.view viewWithTag:101];
    btn.enabled = NO;
    _seconds--;
    if([SYSTEMVERSION floatValue]>=8.0){
        [btn setTitle:[NSString stringWithFormat:@"%ld秒",(long)_seconds] forState:UIControlStateNormal] ;
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
