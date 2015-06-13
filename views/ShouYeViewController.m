//
//  ShouYeViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "ShouYeViewController.h"
#import "InviteViewController.h"

@implementation ShouYeViewController
{
    AFHTTPClient *_client;
}

-(void)viewWillAppear:(BOOL)animated{
    [MobClick beginLogPageView:@"首页"];
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    tab.tabBar.hidden=NO;
    GET_PLISTdICT
    if (![dictPlist[@"isBackGroundCoriner"] isEqualToString:@"1"]) {
        [self requestUrl];
    }
    [self resetNaviGation];
}

-(void)resetNaviGation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"320首页"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self dataConfig];
    [self showUI];
    BACKVIEW;
}

-(void)dataConfig{
    _client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
}

-(void)requestUrl{
    GET_PLISTdICT
    NSString *mobile=dictPlist[@"regMobile"];
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,SHIFOUZHUCE];
    NSString *sign=[Helper addSecurityWithUrlStr:SHIFOUZHUCE];
    [_client postPath:postUrl parameters:@{@"mobile": mobile,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self downLoadSuccess:responseObject];
    } failure:nil];
}
#pragma mark - 解析数据
-(void)downLoadSuccess:(id)responseObject{
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    BOOL n=[(NSNumber *)dict[@"success"] boolValue];
    if (n) {
        GET_PLISTdICT
        NSString *urlPath=[NSString stringWithFormat:CESHIZONG,GETWANSHANGXINXI];
        NSString *sign=[Helper addSecurityWithUrlStr:GETWANSHANGXINXI];
        [_client postPath:urlPath parameters:@{@"regMobile": dict[@"result"][@"mobile"],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *wDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"%@",wDict);
            BOOL isFillMessage=[(NSNumber *)wDict[@"success"] boolValue];
            if (isFillMessage) {
                NSNumber *checkStatus=wDict[@"result"][@"checkStatus"];
                NSLog(@"checkStatus:%@",checkStatus);
                [dictPlist setValue:[checkStatus stringValue] forKey:@"checkStatus"];
                [dictPlist setValue:@"1" forKey:@"isTureNetSite"];
                NSNumber *userId=dict[@"result"][@"id"];
                NSNumber *verSion=dict[@"result"][@"version"];
                [dictPlist setValue:[userId stringValue] forKey:@"id"];
                [dictPlist setValue:[verSion stringValue] forKey:@"version"];
                [dictPlist writeToFile:filePatn atomically:YES];
            }
        } failure:nil];
    }
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"320首页"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    UIButton *btnInvited=[MyControl creatButtonWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70) target:self sel:@selector(btnClicked:) tag:101 image:@"邀请客户" title:nil];
    UIButton *Dbtn=[MyControl creatButtonWithFrame:CGRectMake(15, 100, 290, 100) target:self sel:@selector(btnClicked:) tag:102 image:@"首页图片_快递短信入口" title:nil];
    UIButton *Xbtn=[MyControl creatButtonWithFrame:CGRectMake(15, 200+30, 290, 100) target:self sel:@selector(btnClicked:) tag:103 image:@"首页图片_快递订单入口" title:nil];
    [self.view addSubview:btnInvited];
    [self.view addSubview:Dbtn];
    [self.view addSubview:Xbtn];
}

#pragma mark - 邀请
- (void)inviteCustomer{
    GET_PLISTdICT
    NSString *exit=dictPlist[@"exit"];
    if (![exit isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert show];
    }else{
        if ([dictPlist[@"invite"] isEqualToString:@"0"]||[dictPlist[@"invite"]length] == 0) {
            NSString *urlPath=[NSString stringWithFormat:CESHIZONG,INVITECODE];
            NSString *sign=[Helper addSecurityWithUrlStr:INVITECODE];
            [_client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *wDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isFillMessage=[(NSNumber *)wDict[@"success"] boolValue];
                if (isFillMessage) {
                    [dictPlist setValue:wDict[@"result"] forKey:@"invite"];
                    [dictPlist writeToFile:filePatn atomically:YES];
                    InviteViewController *invite = [InviteViewController new];
                    invite.courierCode = wDict[@"result"];
                    [self.navigationController pushViewController:invite animated:YES];
                }else{
                    [self showAlert:wDict[@"message"] isSure:YES];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlert:@"网络错误" isSure:YES];
            }];
        }else{
            InviteViewController *invite = [InviteViewController new];
            invite.hidesBottomBarWhenPushed = YES;
            invite.courierCode = dictPlist[@"invite"];
            [self.navigationController pushViewController:invite animated:YES];
        }
    }
}

#pragma mark -btn被点击
-(void)btnClicked:(UIButton *)sender{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    switch (sender.tag) {
        case 101:
        {
            [self inviteCustomer];
        }
            break;
        case 102:
        {
            tab.selectedIndex=1;
        }
            break;
        case 103:
        {
            tab.selectedIndex=2;
        }
            break;
        default:
            break;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        LogInViewController *log=[[LogInViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:log];
        UIApplication *app=[UIApplication sharedApplication];
        AppDelegate *app2=app.delegate;
        app2.window.rootViewController=nav;
    }else{
        
    }
}

#pragma mark - 警告框
- (void)timerFireMethod:(NSTimer*)theTimer{
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
