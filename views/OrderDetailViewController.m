//
//  OrderDetailViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-13.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailViewCell.h"


@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor=GRAYCOLOR;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self showUI];
    //设置脚视图
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    view.backgroundColor=GRAYCOLOR;
    view.userInteractionEnabled=YES;
    UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(20, 20, 280, 40) target:self sel:@selector(btnClicked:) tag:101 image:nil title:@"确认取件"];
    btn.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"订单详情_11"]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:btn];
    UIButton *cancelBtn=[MyControl creatButtonWithFrame:CGRectMake(20, 80, 280, 40) target:self sel:@selector(btnClicked:) tag:102 image:nil title:@"打印订单"];
    cancelBtn.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"订单详情_14"]];
    cancelBtn.titleLabel.textColor=[UIColor whiteColor];
    [view addSubview:cancelBtn];
    self.tableView.tableFooterView=view;
}
-(void)btnClicked:(UIButton *)btn{
    switch (btn.tag) {
        case 101:
        {
            
        }
            break;
        case 102:
        {
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"订单详情";
    BACKKEYITEM;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor=GRAYCOLOR;
    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"order";
    OrderDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell==nil) {
        if (indexPath.section==2) {
            cell=[[OrderDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            UILabel *lable=[MyControl creatLabelWithFrame:CGRectMake(5, 5, 315, 30) text:@"备注:"];
            lable.font=[UIFont boldSystemFontOfSize:17];
            lable.textColor=GRAYCOLOR;
            [cell.contentView addSubview:lable];
            
        }else{
            cell=[[[NSBundle mainBundle]loadNibNamed:@"OrderDetailViewCell" owner:self options:nil]lastObject];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        return 40;
    }else{
        //修改
        return 70;
    }
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
