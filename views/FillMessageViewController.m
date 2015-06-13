//
//  FillMessageViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-15.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "FillMessageViewController.h"
#import "ShenHeZhongVC.h"

@implementation FillMessageViewController
{
    UIScrollView *_listView;
    NSMutableArray *_dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    tab.tabBar.hidden=YES;
    [self dataConfig];
    [self showUI];
    [self getBackKeybord];//二级键盘
    [self getExpressCompany];
}

-(void)dataConfig{
    _dataArray = [[NSMutableArray alloc] init];
}

#pragma mark - 获取所有快递公司
-(void)getExpressCompany{
    NSString *postPath = [NSString stringWithFormat:CESHIZONG,ALLWULIU];
    NSString *sign=[Helper addSecurityWithUrlStr:ALLWULIU];
    AFHTTPClient *aClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [aClient postPath:postPath parameters:@{@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)res[@"success"] boolValue];
        if (isSuccess) {
            NSArray *arr = res[@"result"];
            NSLog(@"%@",arr);
            for (NSDictionary *dict in arr) {
                [_dataArray addObject:dict[@"name"]];
            }
            [self creatCompanyListFromCompanyArr:_dataArray];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertViewWithMaessage:@"网络错误"];
    }];
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"验证网点信息";
    BACKKEYITEM;
}
-(void)getBack{
    if (self.isCheckFinal) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self changeRootViewController];
    }
}

#pragma mark - 快递公司列表
- (void)creatCompanyListFromCompanyArr:(NSMutableArray *)arr{
    UIButton *btn=(UIButton *)[self.view viewWithTag:101];
    _listView=[[UIScrollView alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+51, btn.frame.size.width, arr.count*30)];
    _listView.hidden=YES;
    if (arr.count>6) {
        _listView.contentSize = CGSizeMake(btn.frame.size.width, arr.count*30);
    }
    for (int i=0; i<arr.count; i++) {
        UIButton *button=[MyControl creatButtonWithFrame:CGRectMake(0, i*30, btn.frame.size.width, 29) target:self sel:@selector(companySelected:) tag:801+i image:nil title:arr[i]];
        button.layer.borderWidth=1;
        button.layer.borderColor=GRAYCOLOR.CGColor;
        [button setBackgroundColor:[UIColor whiteColor]];
        [_listView addSubview:button];
    }
    [self.view addSubview:_listView];
}

#pragma mark -收键盘
SHOUJIANPAN;
INPUTACCESSVIEW

#pragma mark - 选择公司触发

- (void)companySelected:(UIButton *)btn{
    self.companyLabel.text=btn.titleLabel.text;
    self.companyLabel.textColor=[UIColor blackColor];
    _listView.hidden=YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - 实现输入框的协议内容

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
            rect.origin.y-= 60*(textField.tag-201);
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
    switch (sender.tag) {
        case 100:
        {//先把键盘收起
            for (UIView *text in self.view.subviews) {
                if ([text isKindOfClass:[UITextField class]]) {
                    [(UITextField *)text resignFirstResponder];
                }
            }
            _listView.hidden=!_listView.hidden;
        }
            break;

        case 101:
        {//先把键盘收起
            for (UIView *text in self.view.subviews) {
                if ([text isKindOfClass:[UITextField class]]) {
                    [(UITextField *)text resignFirstResponder];
                }
            }
            _listView.hidden=!_listView.hidden;
        }
            break;
        case 102:
        {
            BOOL isOk=[self testIsok];
            if (isOk) {
                HUODONGZHISHIQI
                NSString *urlPath=[NSString stringWithFormat:CESHIZONG,WANSHANXINXI];
                 //regMobile:expressCompanyName,netSiteName,netSiteAddress,netSiteMobile：注册者账号,快递公司名称,网点名称,网点地址,网点电话
                GET_PLISTdICT
                NSString *phoneNumber=dictPlist[@"regMobile"];
                NSString *sign=[Helper addSecurityWithUrlStr:WANSHANXINXI];
                NSDictionary *dict=@{@"realName":self.textField1.text,@"regMobile": phoneNumber,@"expressCompanyName":self.companyLabel.text,@"netSiteName":self.textField2.text,@"netSiteAddress":self.textField3.text,@"netSiteMobile":self.textField4.text,@"publicKey":PUBLICKEY,@"sign":sign};
                AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
                [client postPath:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [tumblrHUD removeFromSuperview];
                    [self downLoadSuccess:responseObject];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [tumblrHUD removeFromSuperview];
                }];
            }
        }
            break;
        default:
            break;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textField3 resignFirstResponder];
    [self.textField4 resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect=self.view.frame;
        rect.origin.y=65;
        self.view.frame=rect;
    }];
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)title{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - 下载成功提取信息
- (void)downLoadSuccess:(id)responseObject{
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    BOOL n = [(NSNumber *)dict[@"success"] boolValue];
    if (!n) {
        [self showAlertViewWithMaessage:dict[@"message"]];
    }else{
        GET_PLISTdICT
        [dictPlist setValue:self.textField1.text forKey:@"username"];
        [dictPlist setValue:@"1" forKey:@"isTureNetSite"];
        [dictPlist setValue:@"2" forKey:@"checkStatus"];
        [dictPlist writeToFile:filePatn atomically:YES];
        //跳转到审核中界面
        ShenHeZhongVC *svc = [[ShenHeZhongVC alloc]init];
        svc.hidesBottomBarWhenPushed = YES;
        NSLog(@"self.isOderManager:%d",self.isOderManager);
        svc.isOderManager = self.isOderManager;
        [self.navigationController pushViewController:svc animated:YES];
    }
}

#pragma mark - 切换视图控制器
-(void)changeRootViewController{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    [tab.view reloadInputViews];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    app2.window.rootViewController=tab;
    [tab creatSystemBar];
    tab.selectedIndex=0;
}

@end
