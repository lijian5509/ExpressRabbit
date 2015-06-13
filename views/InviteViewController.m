//
//  InviteViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 15-3-9.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "InviteViewController.h"
#import "InviteHistoryViewController.h"

@implementation InviteViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"邀请"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"邀请"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"邀请";
    //设置返回键
    BACKKEYITEM;
    //邀请记录
    UIButton *historyBtn=[MyControl creatButtonWithFrame:CGRectMake(0, 0,60, 30) target:self sel:@selector(btnClicked:) tag:201 image:nil title:@"邀请记录"];
    historyBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    historyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [historyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:historyBtn];
    self.navigationItem.rightBarButtonItem=right;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    self.textField.inputAccessoryView = [self getInputAccessoryView];
    NSString *string = [NSString stringWithFormat:@"使用快递兔叫快递，注册时输入我的邀请码%@即可获得5元红包奖励哦",self.courierCode];
    self.messagelabel.attributedText = [string selfFont:15 selfColor:[UIColor blackColor] LightText:self.courierCode LightFont:15 LightColor:[UIColor orangeColor]];
}

- (void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)getInputAccessoryView{
    UIView *blackLineFromTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 1)];
    blackLineFromTop.backgroundColor = MyColor(200, 200, 200);
    UIButton *view=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 320, 40) target:self sel:@selector(done) tag:100002 image:nil title:nil];
    view.backgroundColor=[UIColor whiteColor];
    UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(280, 12.5, 30, 15) target:self sel:@selector(done) tag:10001 image:nil title:@"完成"];
    UIView *blackLineFromBottom = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-1, SCREENWIDTH, 1)];
    blackLineFromBottom.backgroundColor = MyColor(200, 200, 200);
    [view addSubview:blackLineFromTop];
    [view addSubview:blackLineFromBottom];
    [view addSubview:btn];
    return view;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}
- (void)done{
    [self.textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField.text.length+string.length>11) {
        return NO;
    }
    return YES;
}

- (IBAction)btnClicked:(UIButton *)sender {
    GET_PLISTdICT
    switch (sender.tag) {
        case 101://通讯录
        {
            //调用系统控件，选中后获得指定人信息
            ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
            peoplePicker.peoplePickerDelegate = self;
            [self presentViewController:peoplePicker animated:YES completion:nil];
        }
            break;
        case 102://确定
        {
            if (self.textField.text.length == 0) {
                [self showAlert:@"手机号码不能为空" isSure:YES];
                return;
            }
            if (![Helper validateMobile:self.textField.text]) {
                [self showAlert:@"手机号码不合法，请从新输入" isSure:YES];
                return;
            }
            sender.enabled = NO;
            //courierId,mobile,sms   快递员Id,手机号码,短信内容
            NSString *str=[NSString stringWithFormat:CESHIZONG,INVITETIJIAO];
            AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
            NSString *sign=[Helper addSecurityWithUrlStr:INVITETIJIAO];
            [client postPath:str parameters:@{@"courierId":dictPlist[@"id"],@"invitedMobile": self.textField.text,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                if (isSuccess) {
                    
                    [self showAlert:@"短信发送成功" isSure:YES];
                }else{
                    [self showAlert:dict[@"message"] isSure:YES];
                }
                sender.enabled=YES;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                sender.enabled=YES;
                [self showAlert:@"网络异常" isSure:YES];
            }];
        }
            break;
        case 201://邀请记录
        {
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[InviteHistoryViewController new] animated:YES];
        }
            
        default:
            break;
    }
}

#pragma mark ----电话本
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person;
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //获得选中Vcard相应信息
    
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        
        NSString *aPhone = (NSString*) CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti, i));
        //格式化字符串
        NSString *strGeShi = [Helper phoneFromAddressTelphone:aPhone];
        //NSLog(@"%@",strGeShi);
        //加入电话本数组
        //[phones addObject:strGeShi];
        self.textField.text = strGeShi;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}
#pragma mark - ios 8 后用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //获得选中Vcard相应信息
    
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        
        NSString *aPhone = (NSString*) CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti, i));
        //格式化字符串
        NSString *strGeShi = [Helper phoneFromAddressTelphone:aPhone];
        //NSLog(@"%@",strGeShi);
        //加入电话本数组
        //[phones addObject:strGeShi];
        self.textField.text = strGeShi;
        break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return YES;
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
