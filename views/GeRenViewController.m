//
//  GeRenViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "GeRenViewController.h"
#import "HeadView.h"
#import "BalanceViewController.h"
#import "NoBillViewController.h"
//#import "GeRenTableViewCell.h"
//#import "SheZhiViewController.h"
//#import "ShareViewController.h"
//#import "TabBarViewController.h"
//#import "NoMoneyViewController.h"
//#import "FillMessageViewController.h"
//#import "WaitViewController.h"
//#import "LogInViewController.h"
//#import "AppDelegate.h"
//#import "ChatViewController.h"
//#import "FialViewController.h"


@interface GeRenViewController ()
{
    HeadView *_headView;
    NSArray *_cellImagesArray;
    NSArray *_cellTitleArray;
    AFHTTPClient *_client;
    
}
@end

@implementation GeRenViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _cellImagesArray=@[@"个人中心_06",@"个人中心_09",@"个人中心_11",@"个人中心_13"];
        _cellTitleArray = @[@"我的余额",@"分享有惊喜",@"意见反馈",@"设置"];
        _client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    GET_PLISTMEMBER(@"exit")
    NSString *exit=member;
    if ([exit isEqualToString:@"1"]) {
        _headView=[[[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:nil]lastObject] ;
        self.tableView.tableHeaderView=_headView;
        [self getUserMassege];
    }else{
        UILabel *label=[MyControl creatLabelWithFrame:CGRectMake(0, 0, 320, 90) text:@"您还未登录"];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont boldSystemFontOfSize:25];
        self.tableView.tableHeaderView=label;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TABLEVIEWBACKVIEW;
    self.tableView.scrollEnabled=NO;
   }
#pragma mark - 获取用户数据
- (void)getUserMassege{
    
    GET_PLISTMEMBER(@"id")
    NSString *userId=member;
    //获取用户的名字及快递公司
    NSString *userUrl=[NSString stringWithFormat:CESHIZONG,WODEXINXI];
    NSDictionary *userDict = @{@"courierId":userId};
    [_client postPath:userUrl parameters:userDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dataDict[@"success"] boolValue];
        NSLog(@"%@",dataDict[@"result"][@"realname"]);
        if (isSuccess) {
            if (dataDict[@"result"][@"realname"]!=[NSNull null]) {
                _headView.nameLabel.text=dataDict[@"result"][@"realname"];
            }else{
                _headView.nameLabel.text=@"null";
            }
            _headView.phoneLabel.text=dataDict[@"result"][@"mobile"];
            if (dataDict[@"result"][@"netSite"][@"name"]) {
                _headView.addressLabel.text=dataDict[@"result"][@"netSite"][@"name"];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
    }];
    //获取收益总额
    //获取取件总数
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"个人中心";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellId";
    GeRenTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellId]
    ;
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GeRenTableViewCell" owner:self options:nil]lastObject];
    }
    cell.titleLabel.text=_cellTitleArray[indexPath.row];
    if (indexPath.row==1) {
        cell.titleLabel.textColor=[UIColor orangeColor];
    }
    if (indexPath.row==3) {
        cell.lineLabel.hidden=YES;
    }
    cell.rightView.image=[UIImage imageNamed:_cellImagesArray[indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//设置分区头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor=GRAYCOLOR;
    return view;
}

#pragma mark - 单元格选中后
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
     GET_PLISTdICT
    switch (indexPath.row) {
        case 0://我的余额
        {
            NSString *exit=dictPlist[@"exit"];
            if ([exit isEqualToString:@"2"]) {
                [self showAlertViewWithMaessage:@"你还没有登录！" title:@"登录提醒" otherBtn:@"登录"];
                return;
            }
            //查看是否退出登录
            if (![exit isEqualToString:@"1"]) {
                LogInViewController *log=[[LogInViewController alloc]init];
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:log];
                UIApplication *app=[UIApplication sharedApplication];
                AppDelegate *app2=app.delegate;
                app2.window.rootViewController=nil;
                app2.window.rootViewController=nav;
                return ;
            }
            CHECKSTATUS
            NSString *urlPatn=[NSString stringWithFormat:CESHIZONG,ZHANGDANCHAXUN];//查看流水
            
            [_client postPath:urlPatn parameters:@{@"couriedId": dictPlist[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                if (isSuccess) {
                    BalanceViewController *balance=[[BalanceViewController alloc]init];
                    [self.navigationController pushViewController:balance animated:YES];
                }else{
                    NoBillViewController *no=[[NoBillViewController alloc]init];
                    self.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:no animated:YES];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
            }];

        }
            break;
        case 1://分享有惊喜
        {
            ShareViewController *share=[[ShareViewController alloc]init];
            [self.navigationController pushViewController:share animated:YES];
        }
            break;
        case 2://意见反馈
        {
            ChatViewController *chat=[[ChatViewController alloc]init];
            [self.navigationController pushViewController:chat animated:YES];
        }
            break;
        case 3://设置
        {
            SheZhiViewController *shezhi=[[SheZhiViewController alloc]init];
            [self.navigationController pushViewController:shezhi animated:YES];
        }
            break;
            
        default:
            break;
    }
    self.hidesBottomBarWhenPushed=NO;
    
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}
#pragma mark - 警告框及实现警告协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            return;
        }
            break;
        case 1:
        {
            LogInViewController *log=[[LogInViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:log];
            UIApplication *app=[UIApplication sharedApplication];
            AppDelegate *app2=app.delegate;
            app2.window.rootViewController=nil;
            app2.window.rootViewController=nav;
        }
            break;
            
        default:
            break;
    }
    
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
