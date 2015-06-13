//
//  EditBankCardViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-26.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "EditBankCardViewController.h"
#import "FixBankCheckViewController.h"
@interface EditBankCardViewController ()

@end

@implementation EditBankCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
    [self getBackKeybord];
    
}


#pragma mark - 摆UI界面
- (void)showUI{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"编辑银行卡信息";
    //返回键、
    BACKKEYITEM;
    BACKVIEW;
    //赋予最初的值，老的银行卡信息
    self.nameTextField.text=self.dataArray[0];
    self.bankCardField.text=self.dataArray[1];
    self.bankNameField.text=self.dataArray[2];
    self.phoneNumFiled.text=self.dataArray[3];
    CGRect rect1=self.lineView1.frame;
    rect1.size.height=0.5;
    self.lineView1.frame=rect1;
    CGRect rect2=self.lineView2.frame;
    rect2.size.height=0.5;
    self.lineView2.frame=rect2;
    CGRect rect3=self.lineView3.frame;
    rect3.size.height=0.5;
    self.lineView3.frame=rect3;
}
#pragma mark - 设置二级键盘 收键盘
INPUTACCESSVIEW
SHOUJIANPAN
//返回
-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 实现输入框协议
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==204) {
        if (textField.text.length+string.length>11) {
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

#pragma mark - 实现输入框协议
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag>200) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect=self.view.frame;
            rect.origin.y-= 30*(textField.tag-201);
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

- (IBAction)btnClicked:(UIButton *)sender {//确认跳转
    if (self.nameTextField.text.length==0) {
        [self showAlert:@"请输入姓名" isSure:YES];
        [self.nameTextField becomeFirstResponder];
        return;
    }
    if (self.bankNameField.text.length==0) {
        [self showAlert:@"请输入银行名称" isSure:YES];
        [self.bankNameField becomeFirstResponder];
        return;
    }
    if (![Helper validateMobile:self.phoneNumFiled.text]) {
        [self showAlert:@"请输入有效的手机号码" isSure:YES];
        [self.phoneNumFiled becomeFirstResponder];
        return;
    }
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:self.nameTextField.text];
    [self.dataArray addObject:self.bankCardField.text];
    [self.dataArray addObject:self.bankNameField.text];
    [self.dataArray addObject:self.phoneNumFiled.text];
    
    FixBankCheckViewController *fix=[[FixBankCheckViewController alloc]init];
    fix.dataArray=self.dataArray;
    fix.count=10;
    [self.navigationController pushViewController:fix animated:YES];
    
}

#pragma mark - //显示警告框
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
