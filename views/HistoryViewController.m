//
//  HistoryViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-14.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryViewCell.h"

#import "MJRefresh.h"

@interface HistoryViewController ()
@end

@implementation HistoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TABLEVIEWBACKVIEW;
    BACKKEYITEM;
    self.title=@"历史信息";
    
}
-(void)getBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 刷新
-(void)refreshTableview{
    AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    GET_PLISTdICT
    NSString *urlPath=[NSString stringWithFormat:CESHIZONG,DUANXINJILU];
    __block HistoryViewController *bSelf=self;
    [bSelf.tableView addHeaderWithCallback:^{
        if (_isRefreshinging) {
            return ;
        }
        _isRefreshinging=YES;
        _currentPage=0;
        [client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"],@"page":@"0",@"pageNum":@"10"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self downloadSuccessWithData:responseObject];
            
        } failure:nil];
    }];
    [bSelf.tableView addFooterWithCallback:^{

        if (_isRefreshinging) {
            return ;
        }
       
        _isRefreshinging=YES;
        _currentPage++;
       [client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"],@"page":[NSString stringWithFormat:@"%ld",_currentPage],@"pageNum":@"10"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [self downloadSuccessWithData:responseObject];
       } failure:nil];
        
    }];
    
}
-(void)endRefreshing{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
}
#pragma mark - 解析数据
-(void)downloadSuccessWithData:(id)response{
    [self endRefreshing];
    if (response) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==9) {
        return nil;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor=GRAYCOLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"history";
    HistoryViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"HistoryViewCell" owner:self options:nil]lastObject];
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
