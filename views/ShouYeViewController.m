//
//  ShouYeViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "ShouYeViewController.h"
//#import "TabBarViewController.h"
//#import "ShareViewController.h"

@interface ShouYeViewController ()
{
    AFHTTPClient *_client;
    
}
@end

@implementation ShouYeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    tab.tabBar.hidden=NO;
    [self showUI];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestUrl];
    BACKVIEW;
}
-(void)requestUrl{
    GET_PLISTdICT
    NSString *mobile=dictPlist[@"regMobile"];
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,SHIFOUZHUCE];
    [_client postPath:postUrl parameters:@{@"mobile": mobile} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self downLoadSuccess:responseObject];
    } failure:nil];
    
}
#pragma mark - 解析数据
-(void)downLoadSuccess:(id)responseObject{
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    
    BOOL n=[(NSNumber *)dict[@"success"] boolValue];
    if (n) {
        GET_PLISTdICT
        //        [dictPlist setValue:@"1" forKey:@"isLog"];
        NSString *urlPath=[NSString stringWithFormat:CESHIZONG,GETWANSHANGXINXI];
        [_client postPath:urlPath parameters:@{@"regMobile": dict[@"result"][@"mobile"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *wDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL isFillMessage=[(NSNumber *)wDict[@"success"] boolValue];
           
            if (isFillMessage) {
                 NSNumber *checkStatus=wDict[@"result"][@"checkStatus"];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"登录_01"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 320, 40) target:self sel:@selector(btnClicked:) tag:101 image:@"首页图片_03" title:nil];
    [self.view addSubview:btn];
    UIButton *Dbtn=[MyControl creatButtonWithFrame:CGRectMake(20, 80, 280, 90) target:self sel:@selector(btnClicked:) tag:102 image:@"首页图片_06" title:nil];
    Dbtn.layer.cornerRadius=100;
    
    UIButton *Xbtn=[MyControl creatButtonWithFrame:CGRectMake(20, 200, 280, 90) target:self sel:@selector(btnClicked:) tag:103 image:@"首页图片_09" title:nil];
    Xbtn.layer.cornerRadius=10;
    
    [self.view addSubview:Dbtn];
    [self.view addSubview:Xbtn];
}
#pragma mark -btn被点击
-(void)btnClicked:(UIButton *)sender{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    switch (sender.tag) {
        case 101:
        {
            self.hidesBottomBarWhenPushed=YES;
            ShareViewController *share=[[ShareViewController alloc]init];
            [self.navigationController pushViewController:share animated:YES];
             self.hidesBottomBarWhenPushed=NO;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
