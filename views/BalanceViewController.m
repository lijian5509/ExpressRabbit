//
//  BalanceViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-24.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "BalanceViewController.h"
#import "MJRefresh.h"
#import "BalanceViewCell.h"
#import "BalanceModel.h"
#import "TradeDetailViewController.h"
#import "BankDetailViewController.h"
#import "LinkBankViewController.h"


@interface BalanceViewController ()
{
    
    UIButton *_takeBtn;
    UILabel *_footLabel;
    UIImageView *_bottomView;
    NSMutableArray *_dataArray;
    BOOL _isRefreshing;
    NSInteger _currenPage;
    AFHTTPClient *_client;
    NSInteger _moneyNum;
    
}
@end

@implementation BalanceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray=[[NSMutableArray alloc]init];
        _client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    }
    return self;
}


#pragma mark - 页面将要显示时，
-(void)viewWillAppear:(BOOL)animated{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    tab.tabBar.hidden=YES;

    [self showUI];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsLandscapePhone];
    BACKKEYITEM;
    self.title=@"我的余额";
    BACKVIEW;
    //解析数据，获取当前余额
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,HUOQUYUE];
    GET_PLISTdICT
    [_client postPath:postUrl parameters:@{@"courierId": dictPlist[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    
        BOOL n=[(NSNumber *)dict[@"success"] boolValue];
        if (n) {
            _footLabel.text=[NSString stringWithFormat:@"可提现金额为%.f元" ,[(NSNumber *)dict[@"result"] floatValue] ];
            _moneyNum=[dict[@"result"] integerValue];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertViewWithMaessage:@"网络异常" title:@"提示" otherBtn:nil];
    }];
    
}


//导航栏返回键
-(void)getBack{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    tab.tabBar.hidden=NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self creatRefresh];//创建刷新
    [_tableview headerBeginRefreshing];
    
    // Do any additional setup after loading the view.
}
#pragma mark -搭建视图界面
-(void)showUI{
    //表格视图
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    [self.view addSubview:_tableview];
    _bottomView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
    _bottomView.backgroundColor=[UIColor darkGrayColor];
    _bottomView.userInteractionEnabled=YES;
    _footLabel=[MyControl creatLabelWithFrame:CGRectMake(0, 0, 260, 44) text:@"  可提现金额为xxx元"];
    _footLabel.textAlignment=NSTextAlignmentLeft;
    _footLabel.textColor=[UIColor whiteColor];
    _footLabel.font=[UIFont systemFontOfSize:22];
    [_bottomView addSubview:_footLabel];
    _takeBtn=[MyControl creatButtonWithFrame:CGRectMake(260, 0, 60, 44) target:self sel:@selector(btnClicked:) tag:101 image:@"我的余额2_03" title:nil];
    [_bottomView addSubview:_takeBtn];
    [self.view addSubview:_bottomView];
}
#pragma mark - 创建刷新
-(void)creatRefresh{
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,ZHANGDANCHAXUN];
    GET_PLISTdICT
    __block BalanceViewController *bSelf=self;
    [bSelf.tableview addHeaderWithCallback:^{
        if (_isRefreshing) {
            return ;
        }
        _isRefreshing=YES;
        _currenPage=0;
        [_client postPath:postUrl parameters:@{@"courierId": dictPlist[@"id"],@"page":[NSString stringWithFormat:@"%ld",_currenPage],@"pageNum":@"10"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            BOOL n=[(NSNumber *)dict[@"success"] boolValue];
            if (n) {
                [self downloadSuccessWith:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlertViewWithMaessage:@"网络异常" title:@"提示" otherBtn:nil];
        }];
    }];
    
    [bSelf.tableview addHeaderWithCallback:^{
        if (_isRefreshing) {
            return ;
        }
        _isRefreshing=YES;
        _currenPage++;
        [_client postPath:postUrl parameters:@{@"courierId": dictPlist[@"id"],@"page":[NSString stringWithFormat:@"%ld",_currenPage],@"pageNum":@"10"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            BOOL n=[(NSNumber *)dict[@"success"] boolValue];
            if (n) {
                [self downloadSuccessWith:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlertViewWithMaessage:@"网络异常" title:@"提示" otherBtn:nil];
        }];
        
    }];
}

-(void)btnClicked:(UIButton *)btn{
    //首先看余额是否为零
    if (_moneyNum==0) {
        [self showAlertViewWithMaessage:@"余额为0,暂不能提现" title:@"提示" otherBtn:nil];
        return;
    }
    
    //查看银行卡是否绑定
    NSString *urlPatn=[NSString stringWithFormat:CESHIZONG,GETYINHANGKAXINXI];//得到银行卡信息
    GET_PLISTdICT
    [_client postPath:urlPatn parameters:@{@"couriedId": dictPlist[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
        if (isSuccess) {
            BankDetailViewController *balance=[[BankDetailViewController alloc]init];
            [self.navigationController pushViewController:balance animated:YES];
        }else{
            LinkBankViewController *no=[[LinkBankViewController alloc]init];
            [self.navigationController pushViewController:no animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
    }];
}

-(void)downloadSuccessWith:(id)responseObject{
    [self endRefreshing];//结束刷新
    _isRefreshing=NO;
    if (_currenPage==0) {
        [_dataArray removeAllObjects];
    }
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    if (dict) {
        NSArray *resultArray=dict[@"result"];
        for (NSDictionary *dic in resultArray) {
            BalanceModel *model=[[BalanceModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
    }
    [_tableview reloadData];
    
}

#pragma mark - 结束刷新
-(void)endRefreshing{
    [_tableview headerEndRefreshing];
    [_tableview footerEndRefreshing];
    
}
#pragma mark -实现表格视图的协议

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"balance";
    
    BalanceViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"BalanceViewCell" owner:self options:nil]lastObject];
    }
    BalanceModel *model=_dataArray[indexPath.row];
    [cell setModel:model];
    return cell;
}
//cell被选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BalanceModel *model=_dataArray[indexPath.row];
    TradeDetailViewController *trade=[[TradeDetailViewController alloc]init];
    trade.model=model;
    [self.navigationController pushViewController:trade animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
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
