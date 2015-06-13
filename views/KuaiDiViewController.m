//
//  KuaiDiViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-12-2.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "KuaiDiViewController.h"

#import "KuaiDiModel.h"

@interface KuaiDiViewController ()
{
    AFHTTPClient *aClient;
    AMTumblrHud *tumblrHUD;
}
@end

@implementation KuaiDiViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        aClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        self.dataArray=[[NSMutableArray alloc]init];
        self.page=1;
        self.orderStatus=@"1";
    }
    return self;
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
#pragma mark - 请求数据
-(void)requetUrlForData{
    GET_PLISTdICT
    NSString *pathUrl=[NSString stringWithFormat:CESHIZONG,HUOQUDINGDAN];
    NSString *sign=[Helper addSecurityWithUrlStr:HUOQUDINGDAN];
    NSDictionary *dict=[[NSDictionary alloc]init];
    if (self.page==1) {
        dict=@{@"courierId": dictPlist[@"id"],@"page":@"1",@"pageNum":@"10",@"orderStatus":self.orderStatus,@"publicKey":PUBLICKEY,@"sign":sign};
        
    }else{
        if (self.dataArray.count == 0) {
            return;
        }
        KuaiDiModel *model=[self.dataArray lastObject];
        dict=@{@"courierId": dictPlist[@"id"],@"page":@"1",@"pageNum":@"10",@"orderStatus":self.orderStatus,@"orderId":[model.id stringValue],@"publicKey":PUBLICKEY,@"sign":sign};
        
    }
    //活动指示器
    SHOWACTIVITY
    [aClient postPath:pathUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *wDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isFillMessage=[(NSNumber *)wDict[@"success"] boolValue];
        if (isFillMessage) {
            [self downloadDataSuccess:responseObject];
        }else{
            [self showAlertViewWithMaessage:wDict[@"message"] title:@"提示" otherBtn:nil];
        }
        [self endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing];
        [self showAlert:@"网络错误" isSure:YES];
        NSLog(@"%@",error);
    }];
    
}
#pragma mark - 检测当前有多少新的推送订单
- (void)checkNewOrderNum{
    if (_isRefreshing) {
        return;
    }
    [self.tableView headerBeginRefreshing];
    GET_PLISTdICT
    if (![dictPlist[@"id"] isEqualToString:@"0"]) {
        AFHTTPClient *_client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
        NSString *urlPath=[NSString stringWithFormat:CESHIZONG,DINGDANWEIDU];
        NSString *sign=[Helper addSecurityWithUrlStr:DINGDANWEIDU];
        [_client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
            if(isSuccess){
                if ([dict[@"result"] integerValue]!=0) {
                    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[dict[@"result"] stringValue] ];
                }else{
                    //没有未读订单不刷新
                    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}


#pragma mark - 没有数据的时候显示
-(void)showNothingWithView{
    //   self.backView remo
    
    UILabel *label=[MyControl creatLabelWithFrame:CGRectMake(120, 120, 200, 20) text:@"您暂时还没有订单,"];
    label.textColor=[UIColor lightGrayColor];
    UILabel *label1=[MyControl creatLabelWithFrame:CGRectMake(120, 140, 200, 20) text:@"您可以在派件的时候,"];
    label1.textColor=[UIColor lightGrayColor];
    UILabel *label2=[MyControl creatLabelWithFrame:CGRectMake(120, 160, 200, 20) text:@"告诉客户用快递兔下单"];
    label2.textColor=[UIColor lightGrayColor];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 50, 80, 160)];
    
    imageView.image=[UIImage imageNamed:@"kuaiditu_no_order(1)"];
    [self.backView addSubview:label];
    [self.backView addSubview:label1];
    [self.backView addSubview:label2];
    [self.backView addSubview:imageView];
    [self.view addSubview:self.backView];
}

#pragma mark - 解析数据
-(void)downloadDataSuccess:(id)resultData{
    [tumblrHUD removeFromSuperview];
    
    if (self.page==1) {
        [self.dataArray removeAllObjects];
    }
    [self endRefreshing];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    for (NSDictionary *dic in dict[@"result"][@"orders"]) {
        KuaiDiModel *model=[[KuaiDiModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:model];
        [self.dataArray sortUsingSelector:@selector(isStatusNumBiggerThanAnother:)];
//        [self.dataArray sortUsingSelector:@selector(isTimeNumBiggerThanAnother:)];
    }
    if (self.dataArray.count==0) {
        [self showNothingWithView];
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

#pragma mark - 页面出现刷新

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(daichuliRefresh) name:@"refresh" object:nil];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"refresh"]) {
        [self.tableView headerBeginRefreshing];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"refresh"];
    }
    
}

//接收通知刷新界面
-(void)daichuliRefresh{
    [self.tableView headerBeginRefreshing];
    [self checkNewOrderNum];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TABLEVIEWBACKVIEW;
    
    self.backView=[[UIImageView alloc]initWithFrame:self.tableView.bounds];
    self.backView.backgroundColor=[UIColor whiteColor];
    [self refreshingData];
    [self.tableView headerBeginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkNewOrderNum) name:@"trans" object:nil];
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
}

#pragma mark - 单元格选中后跳转

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *urlPath=[NSString stringWithFormat:CESHIZONG,DINGDANYIDU];
    KuaiDiModel *model=self.dataArray[indexPath.row];
    NSString *sign=[Helper addSecurityWithUrlStr:DINGDANYIDU];
    [aClient postPath:urlPath parameters:@{@"orderId":[NSString stringWithFormat:@"%@",model.id],@"publicKey":PUBLICKEY,@"sign":sign} success:nil failure:nil];
    
    OrderDetailViewController *detail=[[OrderDetailViewController alloc]init];
    
    detail.hidesBottomBarWhenPushed=YES;
    
    detail.model=self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
    
    detail.hidesBottomBarWhenPushed=NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
    cell.model=self.dataArray[indexPath.row];
    
    return cell;
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
    //    BalanceViewController *bal=[[BalanceViewController alloc]init];
    //    self.hidesBottomBarWhenPushed=YES;
    //    [self.navigationController pushViewController:bal animated:YES];
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


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
