//
//  LinkBankViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-25.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "LinkBankViewController.h"
#import "CheckPhoneViewController.h"

@interface LinkBankViewController ()

@end

@implementation LinkBankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getBackKeybord];
    self.title=@"绑定银行卡";
    BACKKEYITEM;
    CGRect rect1=self.lineView1.frame;
    rect1.size.height=0.5;
    self.lineView1.frame=rect1;
    CGRect rect2=self.lineView2.frame;
    rect2.size.height=0.5;
    self.lineView2.frame=rect2;
    
}
-(void)getBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//二级键盘
INPUTACCESSVIEW
SHOUJIANPAN

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nameTextField resignFirstResponder];
    [self.bankCardTextField resignFirstResponder];
    [self.cardNameTextField resignFirstResponder];
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
- (IBAction)btnClicked:(UIButton *)sender {
    if (self.nameTextField.text.length==0) {
        [self showAlertViewWithMaessage:@"请输入姓名" title:nil otherBtn:nil];
        [self.nameTextField becomeFirstResponder];
        return;
    }
    
    if (self.bankCardTextField.text.length==0) {
        [self showAlertViewWithMaessage:@"请输入银行卡号" title:nil otherBtn:nil];
        [self.bankCardTextField becomeFirstResponder];
        return;
    }
    if (![Helper bankCard:self.bankCardTextField.text]) {
        [self showAlertViewWithMaessage:@"请输入正确的卡号" title:nil otherBtn:nil];
        [self.bankCardTextField becomeFirstResponder];
        return;
    }
    if (self.cardNameTextField.text.length==0) {
        [self showAlertViewWithMaessage:@"请输入银行名称" title:nil otherBtn:nil];
        [self.cardNameTextField becomeFirstResponder];
        return;
    }
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [arr addObject:self.nameTextField.text];
    [arr addObject:self.bankCardTextField.text];
    [arr addObject:self.cardNameTextField.text];
    CheckPhoneViewController *check=[[CheckPhoneViewController alloc]init];
    self.navigationController.hidesBottomBarWhenPushed=YES;
    check.dataArray=arr;
    [self.navigationController pushViewController:check animated:YES];
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}


@end
