//
//  GeRenViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "GeRenViewController.h"
#import "BalanceViewController.h"
#import "NoBillViewController.h"
#import "ShenHeShiBaiVC.h"
#import "ShenHeZhongVC.h"
#import "ShenHeTiJiao_DanHao.h"
#import "InviteViewController.h"

@implementation GeRenViewController
{
    HeadView *_headView;
    NSArray *_cellImagesArray;
    NSArray *_cellTitleArray;
    NSString *_littleLabel;
    NSMutableDictionary *_personDict;
    NSString *_filePath;
    UILabel *_label;
    UIButton *_btnStatus;  //按钮的状态 审核 未审核  未通过
    AFHTTPClient *_client;
}

#pragma mark - 点击头视图 登录
-(void)btnClicked:(UIButton *)btn{
    [self changeRootViewControllerToLogin];
}

#pragma mark - 产看是否有新流水
-(void)checkNewBillNumFromUserId:(NSString *)userId{
    AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
    NSString *dataPath=[NSString stringWithFormat:CESHIZONG,XINLIUSHUISHUMU];
    NSString *key=[NSString stringWithFormat:@"%@Time",userId];
    NSString *str=[[NSUserDefaults standardUserDefaults]stringForKey:key];
    if (str==nil) {
        str=@"0";
    }
    NSString *sign=[Helper addSecurityWithUrlStr:XINLIUSHUISHUMU];
    [client postPath:dataPath parameters:@{@"courierId": userId,@"motifyTime":str,@"publicKey":PUBLICKEY,@"sign":sign}   success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
        if(isSuccess){
            if ([dict[@"result"][@"ProcessCount"] integerValue]!=0) {
                _littleLabel=[dict[@"result"][@"ProcessCount"] stringValue];
                [self.tabBarController.tabBar.items[3] setBadgeValue:[dict[@"result"][@"ProcessCount"] stringValue]];
                [self.tableView reloadData];
            }else{
                [self.tabBarController.tabBar.items[3] setBadgeValue:nil];
                if ([_littleLabel integerValue]!=0) {
                    _littleLabel=@"0";
                    [self.tableView reloadData];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark - 将要显示
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:@"我"];
    GET_PLISTdICT
    if ([dictPlist[@"exit"] isEqualToString:@"1"]) {
        _headView=[[[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:nil]lastObject];
        [self createCheckButton];
        self.tableView.tableHeaderView = _headView;
        //获取个人消息
        [self getUserMassegeFromUserId:dictPlist[@"id"]];
        //获取流水
        [self checkNewBillNumFromUserId:dictPlist[@"id"]];
        //判断当前快递员状态
        if ([dictPlist[@"isBackGroundCoriner"] isEqualToString:@"1"]) {
            _btnStatus.hidden = YES;
        }else{
            NSLog(@"isTureNetSite:%@     checkStatus:%@",dictPlist[@"isTureNetSite"],dictPlist[@"checkStatus"]);
            [self checkStausFromNetSite:dictPlist[@"isTureNetSite"] andCheckStatus:dictPlist[@"checkStatus"]];
        }
    }else{
        UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90) target:self sel:@selector(btnClicked:) tag:101 image:nil title:@"点击登录"];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:25];
        self.tableView.tableHeaderView=btn;
        _littleLabel=@"0";
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkNewBillNum) name:@"trans" object:nil];
}

-(void)createCheckButton{
    _btnStatus = [MyControl creatButtonWithFrame:CGRectMake(SCREENWIDTH-10-60, 15, 60, 20) target:self sel:@selector(btnPushCheck:) tag:301 image:nil title:@""];
    _btnStatus.layer.masksToBounds = YES;
    _btnStatus.layer.cornerRadius = 4;
    [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnStatus.titleLabel.font = [UIFont systemFontOfSize:10];
    _btnStatus.backgroundColor = MyColor(255, 78, 0);
    [_headView addSubview:_btnStatus];
}

#pragma mark - 审核验证
-(void)btnPushCheck:(UIButton *)btn{
    NSString *title = btn.titleLabel.text;
    [self checkStatusFromString:title];
}

-(BOOL)checkStatusFromString:(NSString *)title{
    if ([title isEqualToString:@"我要审核"]) {
        FillMessageViewController *fvc = [[FillMessageViewController alloc] init];
        fvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fvc animated:YES];
        return NO;
    }else if ([title isEqualToString:@"审核中"]){
        ShenHeZhongVC *svc = [[ShenHeZhongVC alloc] init];
        svc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:svc animated:YES];
        return NO;
    }else if([title isEqualToString:@"审核失败"]){//审核失败
        ShenHeShiBaiVC *svc = [[ShenHeShiBaiVC alloc] init];
        svc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:svc animated:YES];
        return NO;
    }else{
        return YES;
    }
}

-(void)checkStausFromNetSite:(NSString *)netSite andCheckStatus:(NSString *)check{
    if ([netSite isEqualToString:@"0"]) {//进入完善信息界面
        [_btnStatus setTitle:@"我要审核" forState:UIControlStateNormal];
    }else{
        if ([check isEqualToString:@"1"]) {//隐藏 表示已经审核通过
            _btnStatus.hidden = YES;
        }else if ([check isEqualToString:@"0"]){//审核未通过
            [_btnStatus setTitle:@"审核失败" forState:UIControlStateNormal];
        }else{//审核中
            [_btnStatus setTitle:@"审核中" forState:UIControlStateNormal];
        }
    }
}

-(void)checkNewBillNum{
    GET_PLISTdICT
    [self checkNewBillNumFromUserId:dictPlist[@"id"]];
}

#pragma mark - 将要消失
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"我"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self dataConfig];
    [self showUI];
}

-(void)dataConfig{
    _cellImagesArray=@[@"个人中心_06",@"个人中心_09",@"个人中心_11",@"个人中心_13"];
    _cellTitleArray = @[@"我的余额",@"邀请有奖",@"意见反馈",@"设置"];
    _littleLabel = @"0";
    _filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.plist"];
    _client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
}

-(void)createTableView{
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TABLEVIEWBACKVIEW;
}

#pragma mark - 获取用户数据
- (void)getUserMassegeFromUserId:(NSString *)userId{
    _personDict = [NSMutableDictionary dictionaryWithContentsOfFile:_filePath];
    if (_personDict !=nil){
        _headView.nameLabel.text = _personDict[@"name"];
        _headView.phoneLabel.text = _personDict[@"phone"];
        _headView.addressLabel.text = _personDict[@"webName"];
        if (_personDict[@"imgPath"]==nil) {
             _headView.headImageView.image=[UIImage imageNamed:@"AppIcon"];
        }else{
            [_headView.headImageView setImageWithURL:[NSURL URLWithString:_personDict[@"imgPath"]]];
        }
    }
    //获取用户的名字及快递公司
    NSString *userUrl=[NSString stringWithFormat:CESHIZONG,WODEXINXI];
    NSString *sign=[Helper addSecurityWithUrlStr:WODEXINXI];
    NSLog(@"个人信息sign:%@",sign);
    NSLog(@"public:%@",PUBLICKEY);
    NSDictionary *userDict = @{@"courierId":userId,@"publicKey":PUBLICKEY,@"sign":sign};
    AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
    [client postPath:userUrl parameters:userDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",dataDict);
        BOOL isSuccess=[(NSNumber *)dataDict[@"success"] boolValue];
        if (isSuccess) {//每一次都加载网络有新数据替换
            if (_personDict!=nil) {
                //加载姓名
                if (dataDict[@"result"][@"realname"]!=[NSNull null]) {
                    if(![dataDict[@"result"][@"realname"] isEqualToString:_personDict[@"name"]]){
                        _headView.nameLabel.text=dataDict[@"result"][@"realname"];
                        [_personDict setValue:dataDict[@"result"][@"realname"] forKey:@"name"];
                    }
                }
                //加载电话
                if (![dataDict[@"result"][@"mobile"]isEqualToString :_personDict[@"phone"] ]) {
                    _headView.phoneLabel.text=dataDict[@"result"][@"mobile"];
                    [_personDict setValue:dataDict[@"result"][@"mobile"] forKey:@"phone"];
                }
                //加载网点
                if (![dataDict[@"result"][@"netSite"][@"expressCompany"][@"name"] isEqualToString:_personDict[@"webName"]]) {
                    _headView.addressLabel.text=dataDict[@"result"][@"netSite"][@"name"];
                    [_personDict setValue:dataDict[@"result"][@"netSite"][@"name"] forKey:@"webName"];
                }
                //加载图片
                if (dataDict[@"result"][@"netSite"][@"expressCompany"][@"applogoUrl"]!=[NSNull null]) {
                    NSString *imgPathTail = dataDict[@"result"][@"netSite"][@"expressCompany"][@"applogoUrl"];
                    NSString *imgPath = [NSString stringWithFormat:@"%@%@",CESHITUPIAN,imgPathTail];
                    if (![imgPath isEqualToString:_personDict[@"imgPath"]]) {
                        [_headView.headImageView setImageWithURL:[NSURL URLWithString:imgPath]];
                        [_personDict setValue:imgPath forKey:@"imgPath"];
                    }
                }
                [_personDict writeToFile:_filePath atomically:YES];
            }else{
                _personDict=[[NSMutableDictionary alloc]init];
                if (dataDict[@"result"][@"realname"]==[NSNull null]) {
                    _headView.nameLabel.text=@"null";
                    [_personDict setObject:@"null" forKey:@"name"];
                }else{
                    _headView.nameLabel.text=dataDict[@"result"][@"realname"];
                    [_personDict setObject:dataDict[@"result"][@"realname"] forKey:@"name"];
                }
                _headView.phoneLabel.text=dataDict[@"result"][@"mobile"];
                [_personDict setObject:dataDict[@"result"][@"mobile"] forKey:@"phone"];
                _headView.addressLabel.text=dataDict[@"result"][@"netSite"][@"name"];
                [_personDict setObject:dataDict[@"result"][@"netSite"][@"name"] forKey:@"webName"];
                
                if (dataDict[@"result"][@"netSite"][@"expressCompany"][@"applogoUrl"] !=[NSNull null]) {
                    NSString *imgPathTail = dataDict[@"result"][@"netSite"][@"expressCompany"][@"applogoUrl"];
                    NSString *imgPath = [NSString stringWithFormat:@"%@%@",CESHITUPIAN,imgPathTail];
                    NSLog(@"%@",imgPath);
                    [_headView.headImageView setImageWithURL:[NSURL URLWithString:imgPath]];
                    [_personDict setObject:imgPath forKey:@"imgPath"];
                }
                [_personDict writeToFile:_filePath atomically:YES];
            }
        }else{
            GET_PLISTdICT
            _headView.nameLabel.text=@"null";
            _headView.phoneLabel.text=dictPlist[@"regMobile"];
            _headView.addressLabel.text=@"默认网点";
            _headView.headImageView.image=[UIImage imageNamed:@"AppIcon"];
            [_personDict setValue:@"null" forKey:@"name"];
            [_personDict setValue:dictPlist[@"regMobile"] forKey:@"phone"];
            [_personDict setValue:@"默认网点" forKey:@"webName"];
            [_personDict setValue:nil forKey:@"imgPath"];
            [_personDict writeToFile:_filePath atomically:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //没有网时候
        [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
        _headView.nameLabel.text = _personDict[@"name"];
        _headView.phoneLabel.text = _personDict[@"phone"];;
        _headView.addressLabel.text = _personDict[@"webName"];
        [_headView.headImageView setImageWithURL:[NSURL URLWithString:_personDict[@"imgPath"]]];
    }];
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"我";
    [self createTableView];
    [self createCellLabel];
}

-(void)createCellLabel{
    //cell显示资金流动
    _label=[MyControl creatLabelWithFrame:CGRectMake(15, 0, 10, 10) text:_littleLabel];
    _label.layer.cornerRadius=5;
    _label.layer.masksToBounds = YES;
    _label.backgroundColor=[UIColor redColor];
    _label.textColor=[UIColor whiteColor];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.font=[UIFont systemFontOfSize:7];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Tableview协议
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    GeRenTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GeRenTableViewCell" owner:self options:nil]lastObject];
    }
    cell.titleLabel.text=_cellTitleArray[indexPath.row];
    if (indexPath.row==0) {
        _label.hidden=YES;
        if (![_littleLabel isEqualToString:@"0"]) {
            _label.text=_littleLabel;
            _label.hidden=NO;
            [cell.rightView addSubview:_label];
        }else{
            _label.hidden=YES;
        }
    }
    if (indexPath.row==1) {
        cell.titleLabel.textColor=[UIColor orangeColor];
    }
    if (indexPath.row==3) {
        cell.lineView.hidden=YES;
    }
    cell.rightView.image=[UIImage imageNamed:_cellImagesArray[indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//设置分区头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor=GRAYCOLOR;
    return view;
}

#pragma mark - 单元格选中后
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GET_PLISTdICT
    switch (indexPath.row) {
        case 0://我的余额
        {
            NSString *exit=dictPlist[@"exit"];
            //查看是否退出登录
            if (![exit isEqualToString:@"1"]) {
                [self showAlertViewWithMaessage:@"你还没有登录！" title:@"登录提醒" otherBtn:@"登录"];
                return ;
            }
            BOOL isCheck =[self checkStatusFromString:_btnStatus.titleLabel.text];
            if (!isCheck) {
                return;
            }
            NSString *urlPatn=[NSString stringWithFormat:CESHIZONG,ZHANGDANCHAXUN];//查看流水
            NSString *sign=[Helper addSecurityWithUrlStr:ZHANGDANCHAXUN];
            AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
            [client postPath:urlPatn parameters:@{@"courierId": dictPlist[@"id"],@"page":@"1",@"pageNum":@"10",@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                if (isSuccess) {
                    NSArray *resultArr=dict[@"result"];
                    if (resultArr.count) {
                        BalanceViewController *balance=[[BalanceViewController alloc]init];
                        balance.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:balance animated:YES];
                    }else{
                        NoBillViewController *no= [[NoBillViewController alloc]init];
                        if(_personDict!=nil){
                            no.realName=_personDict[@"name"];
                        }else{
                            no.realName=@"xxx";
                        }
                        no.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:no animated:YES];
                    }
                }else{
                    [self showAlertViewWithMaessage:@"查询错误请稍后再试" title:@"提示" otherBtn:nil];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
            }];
            
        }
            break;
        case 1://分享有惊喜
        {
            GET_PLISTdICT
            NSString *exit=dictPlist[@"exit"];
            if (![exit isEqualToString:@"1"]) {
                [self showAlertViewWithMaessage:@"还没有登陆" title:@"提示" otherBtn:@"确定"];
            }else{
                if ([dictPlist[@"invite"] isEqualToString:@"0"]||[dictPlist[@"invite"]length] == 0) {
                    NSString *urlPath=[NSString stringWithFormat:CESHIZONG,INVITECODE];
                    NSString *sign=[Helper addSecurityWithUrlStr:INVITECODE];
                    [_client postPath:urlPath parameters:@{@"courierId": dictPlist[@"id"],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *wDict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                        BOOL isFillMessage=[(NSNumber *)wDict[@"success"] boolValue];
                        if (isFillMessage) {
                            [dictPlist setValue:wDict[@"result"] forKey:@"invite"];
                            [dictPlist writeToFile:filePatn atomically:YES];
                            InviteViewController *invite = [InviteViewController new];
                            invite.courierCode = wDict[@"result"];
                            [self.navigationController pushViewController:invite animated:YES];
                        }else{
                            [self showAlertViewWithMaessage:wDict[@"message"] title:@"提示" otherBtn:@"确定"];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:@"确定"];
                    }];
                }else{
                    InviteViewController *invite = [InviteViewController new];
                    invite.hidesBottomBarWhenPushed = YES;
                    invite.courierCode = dictPlist[@"invite"];
                    [self.navigationController pushViewController:invite animated:YES];
                }
                
            }
        }
            break;
        case 2://意见反馈
        {
            ChatViewController *chat=[[ChatViewController alloc]init];
            chat.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:chat animated:YES];
        }
            break;
        case 3://设置
        {
            SheZhiViewController *shezhi=[[SheZhiViewController alloc]init];
            shezhi.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:shezhi animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}

#pragma mark - 警告框及实现警告协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self changeRootViewControllerToLogin];
    }else{
        
    }
}

#pragma mark - 改变视图控制器
-(void)changeRootViewControllerToLogin{
    LogInViewController *log=[[LogInViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:log];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    app2.window.rootViewController=nav;
}

@end
