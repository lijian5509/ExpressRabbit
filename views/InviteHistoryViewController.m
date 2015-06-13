//
//  InviteHistoryViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 15-3-9.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "InviteHistoryViewController.h"
#import "InviteTableViewCell.h"
#import "InviteModel.h"

@implementation InviteHistoryViewController
{
    UILabel *_numberLabel;
    AFHTTPClient *aClient;
    AMTumblrHud *tumblrHUD;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        aClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        self.dataArray=[[NSMutableArray alloc]init];
        self.page=1;
    }
    return self;
}
#pragma mark - 友盟统计
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"邀请记录"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"邀请记录"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景 "]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _numberLabel = [MyControl creatLabelWithFrame:CGRectMake(0, 0, 305, 40) text:@"共发了xx条邀请"];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.font = [UIFont systemFontOfSize:14];
    BACKKEYITEM
    self.title = @"邀请记录";
}
#pragma mark - 返回
- (void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建刷新
-(void)refreshingData{
    __weak KuaiDiViewController *bSelf=self;
    
    [bSelf.tableView addHeaderWithCallback:^{
        
        if (self.isRefreshing) {
            return ;
        }
        self.isRefreshing=YES;
        self.page=1;
        [self requetUrlForData];
        
    }];
    [bSelf.tableView addFooterWithCallback:^{
        
        if (self.isRefreshing) {
            return ;
        }
        self.isRefreshing=YES;
        self.page++;
        [self requetUrlForData];
    }];
    
}

- (void)requetUrlForData{
    //活动指示器
    SHOWACTIVITY
    GET_PLISTdICT
    NSString *pathUrl=[NSString stringWithFormat:CESHIZONG,INVITEHISTORY];
    NSString *sign=[Helper addSecurityWithUrlStr:INVITEHISTORY];
    NSDictionary *dict=[[NSDictionary alloc]init];
    if (self.page==1) {
        dict=@{@"courierId": dictPlist[@"id"],@"pageNum":@"10",@"publicKey":PUBLICKEY,@"sign":sign};
    }else{
        if (self.dataArray.count == 0) {
            [self endRefreshing];
            return;
        }
        InviteModel *model=[self.dataArray lastObject];
        dict=@{@"courierId": dictPlist[@"id"],@"pageNum":@"10",@"recordId":[model.id stringValue],@"publicKey":PUBLICKEY,@"sign":sign};
    }
    [aClient postPath:pathUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *wDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isFillMessage=[(NSNumber *)wDict[@"success"] boolValue];
         [self endRefreshing];
        if (isFillMessage) {
            [self downloadDataSuccess:responseObject];
        }else{
            [self showAlert:wDict[@"message"] isSure:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing];
        [self showAlert:@"网络错误" isSure:YES];
        NSLog(@"%@",error);
    }];
}

#pragma mark - 下载成功
- (void)downloadDataSuccess:(id)resultData{
    if (self.page==1) {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    NSString *content = [NSString stringWithFormat:@"共发了%@条邀请",dict[@"result"][@"recordCount"]];
    NSAttributedString *string = [content selfFont:14 selfColor:[UIColor blackColor] LightText:[dict[@"result"][@"recordCount"] stringValue] LightFont:14 LightColor:[UIColor orangeColor]];
    _numberLabel.attributedText = string;
    if ([dict[@"result"][@"listRecord"] count] == 0) {
        if (self.dataArray.count == 0) {
            self.imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
            self.imageView.image = [UIImage imageNamed:@"灰色背景 "];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(75, 75, 209, 100)];
            image.image = [UIImage imageNamed:@"04_03"];
            [self.imageView addSubview:image];
            [self.view addSubview:self.imageView];
        }
        return;
    }
    for (NSDictionary *dic in dict[@"result"][@"listRecord"]) {
        InviteModel *model=[[InviteModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:model];
    }
    if (self.dataArray.count==0) {
        [self.tableView reloadData];
    }else{
        self.backView.hidden=YES;
        [self.tableView reloadData];
    }
}
#pragma mark - 结束刷新
-(void)endRefreshing{
    [tumblrHUD removeFromSuperview];
    self.isRefreshing=NO;
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview:_numberLabel];
    if (self.dataArray.count != 0) {
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count != 0) {
        return 40;
    }
    return 0.01;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"invite";
    InviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"InviteTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    InviteModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - 提现成功后显示
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
