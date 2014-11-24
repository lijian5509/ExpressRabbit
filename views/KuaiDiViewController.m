//
//  KuaiDiViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "KuaiDiViewController.h"
//#import "KuaiDiViewCell.h"
//#import "OrderDetailViewController.h"
//#import "FillMessageViewController.h"
//#import "WaitViewController.h"
//#import "TabBarViewController.h"
//#import "AppDelegate.h"
//#import "LogInViewController.h"

@interface KuaiDiViewController ()
{
     AFHTTPClient *aClient;
}
@end

@implementation KuaiDiViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
         aClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    }
    return self;
}

//#pragma mark - 页面将要显示的时候先判断是否完善信息和是否激活
//- (void)viewWillAppear:(BOOL)animated{
//    self.hidesBottomBarWhenPushed=YES;
//    NSString *filePatn=[NSHomeDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
//    NSMutableDictionary *dictPlist=[NSMutableDictionary dictionaryWithContentsOfFile:filePatn];
//    //查看是否退出登录
//    NSString *exit=dictPlist[@"exit"];
//    if ([exit isEqualToString:@"2"]) {
//        LogInViewController *log=[[LogInViewController alloc]init];
//        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:log];
//        UIApplication *app=[UIApplication sharedApplication];
//        AppDelegate *app2=app.delegate;
//        app2.window.rootViewController=nil;
//        app2.window.rootViewController=nav;
//        return ;
//    }
//
//    //获取是否完善信息的状态
//    NSString *isWanShan=dictPlist[@"isTureNetSite"];
//    if ([isWanShan isEqualToString:@"0"]) {//进入完善信息界面
//        FillMessageViewController *fill=[[FillMessageViewController alloc]init];
//       
//        [self.navigationController pushViewController:fill animated:YES];
//        return;
//    }
//    //查看是否激活，如果未激活则要跳到等待激活界面
//    NSString *isJiHuo=dictPlist[@"checkStatus"];
//    if ([isJiHuo isEqualToString:@"0"]) {
//        WaitViewController *wait=[[WaitViewController alloc]init];
//        wait.phoneLabel.text=@"审核失败";
//        [self.navigationController pushViewController:wait animated:YES];
//        return;
//    }else if ([isJiHuo isEqualToString:@"2"]){
//        WaitViewController *wait=[[WaitViewController alloc]init];
//        [self.navigationController pushViewController:wait animated:YES];
//        return;
//    }
//    
//     self.hidesBottomBarWhenPushed=NO;
//}

- (void)viewDidLoad
{
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TABLEVIEWBACKVIEW;
    
    [super viewDidLoad];
//    [self showUI];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"快速订单";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 单元格选中后跳转

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *detail=[[OrderDetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
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
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"kuaidi";
    KuaiDiViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"KuaiDiViewCell" owner:self options:nil]lastObject];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=[UIColor orangeColor];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
