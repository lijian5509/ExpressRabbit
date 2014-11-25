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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (self.nameTextField.text.length==0) {
        [self showAlertViewWithMaessage:@"请输入姓名" title:@"警告" otherBtn:nil];
        [self.nameTextField becomeFirstResponder];
        return;
    }
    if ([Helper validateUserName:self.nameTextField.text]) {
        [self showAlertViewWithMaessage:@"请输入正确的姓名" title:@"警告" otherBtn:nil];
        [self.nameTextField becomeFirstResponder];
        return;
    }
    if (self.bankCardTextField.text.length==0) {
        [self showAlertViewWithMaessage:@"请输入银行卡号" title:@"警告" otherBtn:nil];
        [self.bankCardTextField becomeFirstResponder];
        return;
    }
    if ([Helper bankCard:self.bankCardTextField.text]) {
        [self showAlertViewWithMaessage:@"请输入正确的卡号" title:@"警告" otherBtn:nil];
        [self.bankCardTextField becomeFirstResponder];
        return;
    }
    if (self.cardNameTextField.text.length==0) {
        [self showAlertViewWithMaessage:@"请输入银行名称" title:@"警告" otherBtn:nil];
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
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btnT, nil];
    [alert show];
}


@end
