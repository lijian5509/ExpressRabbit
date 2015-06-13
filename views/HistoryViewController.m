//
//  HistoryViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-14.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "HistoryViewController.h"
#import "HisCell.h"
#import "HistoryModel.h"
#import "MJRefresh.h"

@implementation HistoryViewController
{
   AMTumblrHud *tumblrHUD;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.dataArray =[[NSMutableArray alloc]init];
        self.currentPage=1;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"历史记录"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"历史记录"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TABLEVIEWBACKVIEW;
    BACKKEYITEM;
    self.title=@"历史信息";
    [self refreshTableview];
    [self.tableView headerBeginRefreshing];
}
-(void)getBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 刷新
-(void)refreshTableview{
    AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    GET_PLISTdICT
    SHOWACTIVITY
    NSString *urlPath=[NSString stringWithFormat:CESHIZONG,DUANXINJILU];
    __block HistoryViewController *bSelf=self;
    NSString *sign=[Helper addSecurityWithUrlStr:DUANXINJILU];
    [bSelf.tableView addHeaderWithCallback:^{
        if (_isRefreshinging) {
            return ;
        }
        _isRefreshinging=YES;
        _currentPage=1;
        [client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"],@"page":@"1",@"pageNum":@"10",@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self downloadSuccessWithData:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self endRefreshing];
        }];
    }];
    [bSelf.tableView addFooterWithCallback:^{
        
        if (_isRefreshinging) {
            return ;
        }
        _isRefreshinging=YES;
        _currentPage++;
        if (self.dataArray.count == 0) {
            [self endRefreshing];
            return;
        }
        HistoryModel *model=[self.dataArray lastObject];
        [client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"],@"page":@"1",@"pageNum":@"10",@"problemId":[model.id stringValue],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self downloadSuccessWithData:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self endRefreshing];
        }];
    }];
    
}
-(void)endRefreshing{
    
    [tumblrHUD removeFromSuperview];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
}
#pragma mark - 解析数据
-(void)downloadSuccessWithData:(id)response{
    [self endRefreshing];
    _isRefreshinging=NO;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
    if (!isSuccess) {
        return;
    }
    if (self.currentPage==1) {
        [self.dataArray removeAllObjects];
    }
    NSArray *arr=dict[@"result"];
    for (NSDictionary *dic in arr) {
        HistoryModel *model=[[HistoryModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:model];
    }
    if (self.dataArray.count==0) {
        [self showAlert:@"您暂时还没没有短信记录" isSure:YES];
        return;
    }
    [self.tableView reloadData];
    
    
}
#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    HisCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[HisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    HistoryModel *model = self.dataArray[indexPath.row];
    [cell showData:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryModel *model = self.dataArray[indexPath.row];
    CGFloat neiRongHeight = [Helper textHeightFromString:[NSString stringWithFormat:@"%@",model.smsContent] width:tableView.frame.size.width-30 fontsize:13];
    CGFloat dianHuaHeight = [Helper textHeightFromString:[NSString stringWithFormat:@"发送至:%@",[Helper phoneFromSendTelphone:model.sendTelephone]] width:tableView.frame.size.width-30 fontsize:13];
    NSLog(@"%@",model.sendTelephone);
    if (neiRongHeight<20) {
        neiRongHeight=20;
    }
    if (dianHuaHeight<20) {
        dianHuaHeight=20;
    }
    CGFloat allHeight = 52+neiRongHeight+dianHuaHeight;
    return allHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}

#pragma mark - 提现成功后显示
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
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
