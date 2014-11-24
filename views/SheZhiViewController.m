//
//  SheZhiViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "SheZhiViewController.h"
#import "GeRenTableViewCell.h"
#import "TabBarViewController.h"
#import "AboutViewController.h"

@interface SheZhiViewController ()
{
    NSArray *_cellImagesArray;
    NSArray *_cellTitleArray;
}
@end

@implementation SheZhiViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _cellImagesArray=@[@"个人中心-设置_03",@"个人中心-设置_06",@"个人中心-设置_12"];
        _cellTitleArray = @[@"消息推送",@"版本更新",@"关于我们"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TABLEVIEWBACKVIEW;
    self.tableView.scrollEnabled=NO;
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"设置";
   GET_PLISTdICT
    NSString *exit=dictPlist[@"exit"];
    if ([exit isEqualToString:@"1"]) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        
        UIButton *btn1=[MyControl creatButtonWithFrame:CGRectMake(20, 20, 280, 40) target:self sel:@selector(btnClicked:) tag:102 image:nil title:@"退出登录"];
        btn1.backgroundColor=[UIColor whiteColor];
        [btn1 setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        [view addSubview:btn1];
        self.tableView.tableFooterView=view;
    }
        BACKKEYITEM;
    
}
-(void)btnClicked:(UIButton *)btn{
    btn.hidden=YES;
    GET_PLISTdICT
    [dictPlist setValue:@"2" forKey:@"exit"];
    [dictPlist setObject:@"0" forKey:@"checkStatus"];//激活状态
    [dictPlist setObject:@"0" forKey:@"regMobile"];//用户手机号
    [dictPlist setObject:@"0" forKey:@"id"];//用户id
    [dictPlist setObject:@"0" forKey:@"version"];//版本
    [dictPlist setObject:@"0" forKey:@"fillMassage"];//记录是否完善信息
    [dictPlist setObject:@"0" forKey:@"isTureNetSite"];//网点id  登陆时保存，用于判断用户是否完善信息
    [dictPlist setObject:@"0" forKey:@"bankCard"];
    [dictPlist setObject:@"null" forKey:@"username"];//用户信息
    [dictPlist writeToFile:filePatn atomically:YES];

}

-(void)getBack{
    self.hidesBottomBarWhenPushed=NO;
    [self.navigationController popViewControllerAnimated:YES];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellId";
    GeRenTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellId]
    ;
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GeRenTableViewCell" owner:self options:nil]lastObject];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row==0) {
        UISwitch *cellSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(270, 6, 50, 30)];
        //设置开关开 状态的背景颜色
        cellSwitch.onTintColor = [UIColor orangeColor];
        [cell.contentView addSubview:cellSwitch];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cellSwitch addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventEditingChanged];
    }
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
    switch (indexPath.row) {
        case 0:
        {
            return;
        }
            break;
        case 1:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"版本更新" message:@"已经是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case 2:
        {
            self.hidesBottomBarWhenPushed=YES;
            AboutViewController *about=[[AboutViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -通知状态改变
-(void)switchChanged{
    
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
