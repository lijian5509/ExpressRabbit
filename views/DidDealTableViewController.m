//
//  DidDealTableViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-20.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "DidDealTableViewController.h"
#import "OrderDetailViewController.h"

@implementation DidDealTableViewController
{
    AFHTTPClient *aClient;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.orderStatus=@"2";
    }
    return self;
}

#pragma mark - 页面出现刷新

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self.tableView headerBeginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(daichuliRefresh) name:@"refresh" object:nil];
    
}
//接收通知刷新界面
-(void)daichuliRefresh{
    [self.tableView headerBeginRefreshing];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - 单元格选中后跳转


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetailViewController *detail=[[OrderDetailViewController alloc]init];
    detail.hidesBottomBarWhenPushed=YES;
    detail.model=self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
    detail.hidesBottomBarWhenPushed=NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"kuaidi";
    DidDealViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DidDealViewCell" owner:self options:nil]lastObject];
    }
    cell.model=self.dataArray[indexPath.row];
    return cell;
}
@end
