//
//  SheZhiViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "SheZhiViewController.h"
#import "APService.h"

@implementation SheZhiViewController
{
    NSArray *_cellImagesArray;
    NSArray *_cellTitleArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self dataConfig];
    [self showUI];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TABLEVIEWBACKVIEW;
    self.tableView.scrollEnabled=NO;
}

-(void)dataConfig{
    _cellImagesArray=@[@"个人中心-设置_06"];
    _cellTitleArray = @[@"关于我们"];
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"设置";
    BACKKEYITEM;
    GET_PLISTdICT
    NSString *exit=dictPlist[@"exit"];
    if ([exit isEqualToString:@"1"]) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        UIButton *btn1=[MyControl creatButtonWithFrame:CGRectMake(20, 20, 280, 40) target:self sel:@selector(btnClicked:) tag:102 image:nil title:@"退出登录"];
        btn1.backgroundColor=[UIColor whiteColor];
        [btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [view addSubview:btn1];
        self.tableView.tableFooterView=view;
    }
}

-(void)btnClicked:(UIButton *)btn{
    [self showAlertViewWithMaessage:@"是否确认退出" title:@"提示" otherBtn:@"退出"];
}

-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    GeRenTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GeRenTableViewCell" owner:self options:nil]lastObject];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.titleLabel.text=_cellTitleArray[indexPath.row];
    cell.rightView.image=[UIImage imageNamed:_cellImagesArray[indexPath.row]];
    return cell;
}

#pragma mark - 设置分区头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor=GRAYCOLOR;
    return view;
}

#pragma mark - 单元格选中后
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AboutUsViewController *about=[[AboutUsViewController alloc]init];
    about.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:about animated:YES];
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    [[tab.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    [[tab.tabBar.items objectAtIndex:1] setBadgeValue:nil];
    if (buttonIndex==1) {
        UIButton *btn=(UIButton *)[self.view viewWithTag:102];
        btn.hidden=YES;
        [APService setTags:nil alias:@"" callbackSelector:nil object:nil];
        NSFileManager *file=[NSFileManager defaultManager];
        [file removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.plist"] error:nil];
        [[NSUserDefaults standardUserDefaults]setValue:@"110" forKey:@"bankMobile"];
        [[NSUserDefaults standardUserDefaults]setValue:@"顺风快递" forKey:@"logisticsCompanyId"];//快递公司名字
        [[NSUserDefaults standardUserDefaults]setValue:@"14" forKey:@"expresscompanyId"];//快递公司id
        //[[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"finishCheck"];//是否提交过审核
        //在Document的目录下创建一个plist文件用来存放用户的信息
        NSString *filePatn=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userInfo.plist"];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:@"3" forKey:@"checkStatus"];//激活状态 0审核失败 ，1审核成功    ，2审核中
        [dict setObject:@"0" forKey:@"regMobile"];//用户手机号
        [dict setObject:@"0"  forKey:@"isBackGroundCoriner"];//是否是后台快递员
        [dict setObject:@"0" forKey:@"id"];//用户id
        [dict setObject:@"0" forKey:@"version"];//版本
        
        [dict setObject:@"0" forKey:@"fillMassage"];//记录是否完善信息
        [dict setObject:@"0" forKey:@"isTureNetSite"];//网点id  登陆时保存，用于判断用户是否完善信息
        
        [dict setObject:@"2" forKey:@"exit"];//记录是否退出  0,未登录过  1 登录 2 登录后退出
        [dict setObject:@"null" forKey:@"username"];//用户信息
        
        [dict setObject:@"0" forKey:@"bankCard"];
        [dict setObject:@"0" forKey:@"money"];//我的余额
        [dict writeToFile:filePatn atomically:YES];
    }else{
        
    }
}


@end
