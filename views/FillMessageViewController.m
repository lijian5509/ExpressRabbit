//
//  FillMessageViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-15.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "FillMessageViewController.h"
//#import "TabBarViewController.h"
//#import "AppDelegate.h"
//#import "WaitViewController.h"

@interface FillMessageViewController ()
{
    UIView *listView;
}
@end

@implementation FillMessageViewController

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
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    tab.tabBar.hidden=YES;
    [self showUI];
    [self getBackKeybord];//二级键盘
    [self creatCompanyList];
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"验证网点信息";
    BACKKEYITEM;
}
-(void)getBack{
    
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    [tab.view reloadInputViews];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    app2.window.rootViewController=nil;
    app2.window.rootViewController=tab;
    [tab creatSystemBar];
    tab.selectedIndex=0;
  
}

#pragma mark - 快递公司列表

- (void)creatCompanyList{
    UIButton *btn=(UIButton *)[self.view viewWithTag:101];
    listView=[[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+51, btn.frame.size.width, 240)];
    listView.backgroundColor=GRAYCOLOR;
    listView.hidden=YES;
    listView.userInteractionEnabled=YES;
    NSArray *array=@[@"韵达快递",@"申通快递",@"顺丰快递",@"圆通快递",@"中通快递",@"全峰快递",@"天天快递",@"汇通快递"];
    for (int i=0; i<array.count; i++) {
        UIButton *button=[MyControl creatButtonWithFrame:CGRectMake(0, i*30, btn.frame.size.width, 29) target:self sel:@selector(companySelected:) tag:801+i image:nil title:array[i]];
        button.titleLabel.textAlignment=NSTextAlignmentLeft;
        button.layer.borderWidth=1;
        button.layer.borderColor=GRAYCOLOR.CGColor;
        [button setBackgroundColor:[UIColor whiteColor]];
        [listView addSubview:button];
    }
    [self.view addSubview:listView];
}

#pragma mark -收键盘
SHOUJIANPAN;
INPUTACCESSVIEW

#pragma mark - 选择公司触发

- (void)companySelected:(UIButton *)btn{
    self.companyLabel.text=btn.titleLabel.text;
    self.companyLabel.textColor=[UIColor blackColor];
    listView.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 实现输入框的协议内容
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)testIsok{
    if ([self.textField1.text length] == 0) {
        
        [self showAlertViewWithMaessage:@"请输入您的姓名"];
        return NO;
    }
    if ([self.textField2.text length] == 0) {
        [self showAlertViewWithMaessage:@"请输入网点名称"];
        return NO;
    }
    if ([self.textField3.text length] == 0) {
        [self showAlertViewWithMaessage:@"请输入网点地址"];
        return NO;
    }
    if ([self.textField4.text length] == 0) {
        [self showAlertViewWithMaessage:@"请网点客户电话"];
        return NO;
    }
    BOOL isMatch = [Helper validatePassword: self.textField4.text];
    if (!isMatch) {
        [self showAlertViewWithMaessage:@"请输入正确的网点电话"];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag>202) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect=self.view.frame;
            rect.origin.y-=120;
            self.view.frame=rect;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag>202) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect=self.view.frame;
            rect.origin.y+=120;
            self.view.frame=rect;
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (IBAction)btnClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 100:
        {//先把键盘收起
            for (UIView *text in self.view.subviews) {
                if ([text isKindOfClass:[UITextField class]]) {
                    [(UITextField *)text resignFirstResponder];
                }
            }
            listView.hidden=!listView.hidden;
        }
            break;

        case 101:
        {//先把键盘收起
            for (UIView *text in self.view.subviews) {
                if ([text isKindOfClass:[UITextField class]]) {
                    [(UITextField *)text resignFirstResponder];
                }
            }
            listView.hidden=!listView.hidden;
        }
            break;
        case 102:
        {
            BOOL isOk=[self testIsok];
            if (isOk) {
                NSString *urlPath=[NSString stringWithFormat:CESHIZONG,WANSHANXINXI];
                 //regMobile:expressCompanyName,netSiteName,netSiteAddress,netSiteMobile：注册者账号,快递公司名称,网点名称,网点地址,网点电话
                GET_PLISTMEMBER(@"regMobile")
                NSString *phoneNumber=member;
                NSDictionary *dict=@{@"realName":self.textField1.text,@"regMobile": phoneNumber,@"expressCompanyName":self.companyLabel.text,@"netSiteName":self.textField2.text,@"netSiteAddress":self.textField3.text,@"netSiteMobile":self.textField4.text};
                AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
                [client postPath:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self downLoadSuccess:responseObject];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                }];
            }
        }
            break;
            
        default:
            break;
    }
    
}
//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)title{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - 下载成功提取信息
- (void)downLoadSuccess:(id)responseObject{
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    BOOL n=[(NSNumber *)dict[@"success"] boolValue];
    if (!n) {
        [self showAlertViewWithMaessage:@"提交有误，请仔细核对信息"];
        return;
    }else{
        GET_PLISTdICT
        [dictPlist setValue:self.textField1.text forKey:@"username"];
        [dictPlist setValue:@"1" forKey:@"isTureNetSite"];
        [dictPlist writeToFile:filePatn atomically:YES];
        self.hidesBottomBarWhenPushed=YES;
        WaitViewController *wait=[[WaitViewController alloc]init];
        [self.navigationController pushViewController:wait animated:YES];
    }

}


@end
