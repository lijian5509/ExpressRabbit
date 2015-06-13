//
//  DuanXinViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "DuanXinViewController.h"
#import "FootView.h"
#import "DuanXinViewCell.h"
#import "ChongZhiVC.h"
#import "GengHuanMoBanBianJiVC.h"
#import "ShenHeShiBaiVC.h"
#import "ShenHeZhongVC.h"

@implementation DuanXinViewController
{
    NSMutableArray *_dataArray;
    UITextView *_textView;//文本框
    UIView *_headerView;//文本框底层视图
    FootView *_footView;
    NSInteger _messageNumber;//记录当天免费短信量
    NSInteger _messageAllNumber;//当前购买的短信的总量
    UILabel *_lblNoteSur; //短信剩余
    UIImageView *_imgHisAndPrepid; //历史记录或支付
    DuanXinYongWanTiShiVC *_messageFinish;
}
//单元格数目
static NSInteger cellNumber=1;

#pragma mark - 视图将要显示
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:@"短信"];
    GET_PLISTdICT
    //如果用户是否登录后退出
    NSString *exit=dictPlist[@"exit"];
    if ([exit isEqualToString:@"1"]) {
        NSLog(@"-----id:%@------",dictPlist[@"id"]);
        [self getSmsNumberCanUseFromConrierId:dictPlist[@"id"]];
        if ([dictPlist[@"isBackGroundCoriner"] isEqualToString:@"1"]) {//先判断是否是后台注册的快递员
            [self changeRightNavigationItemFromWidth:30 andHeight:15 andTag:99 andImage:nil andTitle:@"更多"];
        }else{
            if ([dictPlist[@"isTureNetSite"] isEqualToString:@"1"]&&[dictPlist[@"checkStatus"] isEqualToString:@"1"]) {
                [self changeRightNavigationItemFromWidth:30 andHeight:15 andTag:99 andImage:nil andTitle:@"更多"];
            }
        }
    }
}

-(void)changeRightNavigationItemFromWidth:(CGFloat)width andHeight:(CGFloat)height andTag:(NSInteger)tag andImage:(NSString *)image andTitle:(NSString *)title{
    UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(0, 0, width, height) target:self sel:@selector(showHisOrPrepid) tag:tag image:image title:title];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

#pragma mark - 视图将要消失
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"短信"];
    [self clearDuanXin];
}

#pragma mark - 清空短信内容
-(void)clearDuanXin{
    cellNumber=1;
    [_dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self dataConfig];
    [self showUI];
    //给桌面增加一个手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.tableView addGestureRecognizer:tap];
}

#pragma mark -收键盘
-(void)tap{
    _imgHisAndPrepid.hidden = YES;
    [_textView resignFirstResponder];
}

-(void)dataConfig{
    _dataArray =[[NSMutableArray alloc]init];
}

#pragma mark - 获取短信量
-(void)getSmsNumberCanUseFromConrierId:(NSString *)courierId{
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,CHAXUNDANGTIANDUANXINLIANG];
    AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    NSString *sign=[Helper addSecurityWithUrlStr:CHAXUNDANGTIANDUANXINLIANG];
    [client postPath:postUrl parameters:@{@"courierId": courierId,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
        if (isSuccess) {
            //免费剩余条数
            NSInteger freeNumber = 10 - [dict[@"result"][@"count"] integerValue];
            if (freeNumber<0) {
                freeNumber = 0;
            }
            NSString *strNumber = [NSString stringWithFormat:@"%ld",freeNumber];
            NSString *strFree = [NSString stringWithFormat:@"免费条数%@",strNumber];
            self.messageLabel.attributedText = [strFree selfFont:10 selfColor:[UIColor lightGrayColor] LightText:strNumber LightFont:10 LightColor:MyColor(38, 128, 254)];
            //购买的剩余条数
            NSString *strBuyNumber = [NSString stringWithFormat:@"%ld",[dict[@"result"][@"courierMesNum"] integerValue]];
            NSString *strBuy = [NSString stringWithFormat:@"短信剩余%@",strBuyNumber];
            _lblNoteSur.attributedText = [strBuy selfFont:10 selfColor:[UIColor lightGrayColor] LightText:strBuyNumber LightFont:10 LightColor:MyColor(38, 128, 254)];
            _messageAllNumber = [strBuyNumber integerValue];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -实现单元格输入协议
-(void)addTextField:(DuanXinViewCell *)message{
    if ([Helper validateMobile:message.phoneText]) {
        for (int i=0; i<_dataArray.count; i++) {
            NSString *str=_dataArray[i];
            if (message.deleteBtn.tag==i){
                //如果删除的下标等于数组对应的下标 就把数组的内容替换到对应删除的按钮的编号
                [_dataArray replaceObjectAtIndex:i withObject:message.phoneText];
                [self.tableView reloadData];
                return;
            }else  if ([str isEqualToString:message.phoneText]) {//如果有相同的内容就提示
                [self showAlert:@"该号码已存在,请核对后再输" isSure:YES];
                message.textField.text=@"";
                return;
            }
        }
        [_dataArray addObject:message.phoneText];
        cellNumber++;
        [self.tableView reloadData];
    }else{
        [self showAlert:@"输入的号码不正确!请认真核对" isSure:YES];
    }
}

-(void)removeTextViewWith:(DuanXinViewCell *)message{
    if (message.isValid) {
        //删除数组对应的下标
        [_dataArray removeObjectAtIndex:message.deleteBtn.tag];
        cellNumber--;
        [self.tableView reloadData];
    }else{
        cellNumber--;
        [self.tableView reloadData];
    }
}

#pragma mark - 摆UI界面
- (void)showUI{
    TABLEVIEWBACKVIEW;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.title=@"短信";
    //获取头视图
    self.tableView.tableHeaderView = [self getHeaderView];
    //获取脚视图
    self.tableView.tableFooterView = [self getFootView];
}

-(UIView *)getViewFromSecondLevel{
    UIView *blackLineFromTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 1)];
    blackLineFromTop.backgroundColor = MyColor(200, 200, 200);
    UIButton *view=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 320, 40) target:self sel:@selector(done) tag:100002 image:nil title:nil];
    view.backgroundColor=[UIColor whiteColor];
    UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(280, 12.5, 30, 15) target:self sel:@selector(done) tag:10001 image:nil title:@"完成"];
    UIView *blackLineFromBottom = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-1, SCREENWIDTH, 1)];
    blackLineFromBottom.backgroundColor = MyColor(200, 200, 200);
    [view addSubview:blackLineFromTop];
    [view addSubview:blackLineFromBottom];
    [view addSubview:btn];
    return view;
}

#pragma mark - 编辑完成收键盘
-(void)done{
    [_textView resignFirstResponder];
}

-(UIView *)getFootView{
    GET_PLISTdICT
    NSString *plistName=dictPlist[@"id"];
    _footView = [[[NSBundle mainBundle]loadNibNamed:@"FootView" owner:self options:nil]lastObject];
    //脚视图添加事件
    [_footView.sureBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return _footView;
}

-(UIView *)getHeaderView{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 29+85+15)];
    //免费条数
    self.messageLabel=[MyControl creatLabelWithFrame:CGRectMake(10, 5, 140, 20) text:nil];
    self.messageLabel.font=[UIFont systemFontOfSize:10];
    NSString *strFree = @"免费条数10";
    self.messageLabel.attributedText = [strFree selfFont:10 selfColor:[UIColor lightGrayColor] LightText:@"10" LightFont:10 LightColor:MyColor(38, 128, 254)];
    //短信剩余
    _lblNoteSur = [MyControl creatLabelWithFrame:CGRectMake(_messageLabel.frame.origin.x+_messageLabel.text.length*10+15, 29/2-10/2, 100, 10) text:nil];
    NSString *strNote = @"短信剩余0";
    _lblNoteSur.font = [UIFont systemFontOfSize:10];
    _lblNoteSur.attributedText = [strNote selfFont:10 selfColor:[UIColor lightGrayColor] LightText:@"0" LightFont:10 LightColor:MyColor(38, 128, 254)];
    [_headerView addSubview:_lblNoteSur];
    [_headerView addSubview:self.messageLabel];
    //更换模板
    UIButton *btnChangeFormWork = [MyControl creatButtonWithFrame:CGRectMake(SCREENWIDTH-10-10*4, 0, 10*4, 29) target:self sel:@selector(btnChange:) tag:603 image:nil title:@"更换模板"];
    btnChangeFormWork.titleLabel.font = [UIFont systemFontOfSize:10];
    [btnChangeFormWork setTitleColor:MyColor(38, 128, 254) forState:UIControlStateNormal];
    [_headerView addSubview:btnChangeFormWork];
    //输入短信内容
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 29, SCREENWIDTH-20, 85)];
    _textView.delegate = self;
    _textView.text = @"请输入短信内容!";
    _textView.textColor = [UIColor lightGrayColor];
    _textView.font = [UIFont systemFontOfSize:12];
    _textView.layer.cornerRadius = 4;
    _textView.layer.masksToBounds = YES;
    _textView.keyboardType = UIKeyboardTypeNamePhonePad;
    _textView.inputAccessoryView=[self getViewFromSecondLevel];
    //计算还能输入的字数
    NSString *strSurperPlus = @"还能输入45字";
    self.wordLabel=[MyControl creatLabelWithFrame:CGRectMake(_textView.frame.size.width-100, _textView.frame.size.height-7-5, 100, 8) text:strSurperPlus];
    self.wordLabel.attributedText = [strSurperPlus selfFont:8 selfColor:[UIColor lightGrayColor] LightText:@"45" LightFont:8 LightColor:MyColor(521, 78, 10)];
    self.wordLabel.textAlignment = NSTextAlignmentRight;
    [_textView addSubview:self.wordLabel];
    [_headerView addSubview:_textView];
    //历史记录 充值栏
    _imgHisAndPrepid = [MyControl creatImageViewWithFrame:CGRectMake(SCREENWIDTH-80-10, 0, 80, 85) imageName:@"选择黑色框" isCache:YES];
    _imgHisAndPrepid.userInteractionEnabled = YES;
    _imgHisAndPrepid.hidden = YES;
    NSArray *arrTitle = @[@"历史记录",@"充值"];
    for (int i = 0; i<2; i++) {
        UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(0, 5+40*i, 80, 40) target:self sel:@selector(btnHisOrPrePid:) tag:601+i image:nil title:arrTitle[i]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_imgHisAndPrepid addSubview:btn];
    }
    [_headerView addSubview:_imgHisAndPrepid];
    return _headerView;
}

#pragma mark - ----更换模板事件----
-(void)btnChange:(UIButton *)btn{
    GengHuanMoBanVC *gvc = [[GengHuanMoBanVC alloc] init];
    gvc.hidesBottomBarWhenPushed = YES;
    gvc.delegate = self;
    [self.navigationController pushViewController:gvc animated:YES];
}

#pragma mark - 更换模板代理事件
-(void)updateMessage:(NSString *)message{
    _textView.textColor = [UIColor blackColor];
    _textView.text = message;
}

#pragma mark - *********选择历史记录或者充值事件*********
-(void)btnHisOrPrePid:(UIButton *)btn{
    switch (btn.tag) {
        case 601://历史记录
        {
            _imgHisAndPrepid.hidden = YES;
            HistoryViewController *history=[[HistoryViewController alloc]init];
            history.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:history animated:YES];
        }
            break;
        case 602://充值
        {
            _imgHisAndPrepid.hidden = YES;
            [self payMoneyFromMessage];
        }
            break;
        default:
            break;
    }
}

-(void)payMoneyFromMessage{
    ChongZhiVC *cvc = [[ChongZhiVC alloc] init];
    GET_PLISTdICT
    cvc.strMobile = dictPlist[@"regMobile"];
    cvc.strName = dictPlist[@"realname"];
    cvc.duanXinShengYu = _messageAllNumber;
    cvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cvc animated:YES];
}

#pragma mark - 更多 触发事件
-(void)showHisOrPrepid{
    _imgHisAndPrepid.hidden = !_imgHisAndPrepid.hidden;
}

#pragma mark - 验证快递员状态
-(BOOL)chexkStatusFromCornier{
    //判断当前快递员状态
    GET_PLISTdICT
    if ([dictPlist[@"isBackGroundCoriner"] isEqualToString:@"1"]){
        return YES;
    }else{
        NSLog(@"isTureNetSite:%@     checkStatus:%@",dictPlist[@"isTureNetSite"],dictPlist[@"checkStatus"]);
        return [self checkStausFromNetSite:dictPlist[@"isTureNetSite"] andCheckStatus:dictPlist[@"checkStatus"]];
    }
}

-(BOOL)checkStausFromNetSite:(NSString *)netSite andCheckStatus:(NSString *)check{
    if ([netSite isEqualToString:@"0"]) {//进入完善信息界面
        [self showAlertViewWithMaessage:@"请先提交个人信息" title:@"提示" otherBtn:@"确定" withAlterTag:902];
        return NO;
    }else{
        if ([check isEqualToString:@"1"]) {//表示已经审核通过
            return YES;
        }else if ([check isEqualToString:@"0"]){//审核未通过
            [self showAlertViewWithMaessage:@"审核失败" title:@"提示" otherBtn:@"确定" withAlterTag:903];
            return NO;
        }else{//审核中
            [self showAlertViewWithMaessage:@"状态审核中" title:@"提示" otherBtn:@"确定" withAlterTag:902];
            return NO;
        }
    }
}

#pragma mark -textView代理事件
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请输入短信内容!"]) {
        textView.text=@"";
    }
    textView.textColor=[UIColor blackColor];
    NSString *strSuperPlus = [NSString stringWithFormat:@"还能输入%ld个字",45-textView.text.length];
    self.wordLabel.attributedText = [strSuperPlus selfFont:8 selfColor:[UIColor lightGrayColor] LightText:[NSString stringWithFormat:@"%ld",45-textView.text.length] LightFont:8 LightColor:MyColor(521, 78, 10)];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>45) {
        NSString *strSuperPlus = [NSString stringWithFormat:@"已超出%ld个字",textView.text.length-45];
        self.wordLabel.attributedText = [strSuperPlus selfFont:8 selfColor:[UIColor lightGrayColor] LightText:[NSString stringWithFormat:@"%ld",textView.text.length-45] LightFont:8 LightColor:MyColor(521, 78, 10)];
    }else{
        NSString *strSuperPlus = [NSString stringWithFormat:@"还可输入%ld个字",45-textView.text.length];
        self.wordLabel.attributedText = [strSuperPlus selfFont:8 selfColor:[UIColor lightGrayColor] LightText:[NSString stringWithFormat:@"%ld",45-textView.text.length] LightFont:8 LightColor:MyColor(521, 78, 10)];
    }
}

#pragma mark - -----发短信事件-----
-(void)btnClicked:(UIButton *)btn{
    GET_PLISTdICT
    if ([dictPlist[@"exit"] isEqualToString:@"1"]) {
        if (btn.tag==101) {//添加联系人
            if (_dataArray.count==cellNumber) {
                cellNumber++;
                [self.tableView reloadData];
            }else{
                [self showAlert:@"请先输入正确的手机号" isSure:YES];
                return;
            }
        }
        if (btn.tag==102) {//发送短信
            //先审核快递员
            BOOL isCorner = [self chexkStatusFromCornier];
            if (!isCorner) {
                return ;
            }
            if (_textView.text.length>45) {
                [self showAlert:@"短信内容超出,请删减" isSure:YES];
                return;
            }
            if (_textView.text.length==0) {
                [self showAlert:@"短信内容不能为空" isSure:YES];
                return;
            }
            if (_dataArray.count==0) {
                [self showAlert:@"请输入手机号" isSure:YES];
                return;
            }
            //做有效判断
            NSMutableArray *array=[[NSMutableArray alloc]init];
            for (int i=0; i<cellNumber; i++) {
                UITextField *textField=(UITextField *)[self.view viewWithTag:800+i];
                if (textField.text.length!=0) {
                    if ([Helper validateMobile:textField.text]) {
                        [array addObject:textField.text];
                    }else{
                        [self showAlert:@"号码有误，请仔细核实后在发送" isSure:YES];
                        return;
                    }
                }
            }
            //courierId,mobile,sms   快递员Id,手机号码,短信内容
            NSString *str=[NSString stringWithFormat:CESHIZONG,FASONGDUANXIN];
            AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
            NSString *dataStrFromArr= [NSString stringWithFormat:@"%@",array];
            NSString *sign=[Helper addSecurityWithUrlStr:FASONGDUANXIN];
            NSLog(@"用户id:%@",dictPlist[@"id"]);
            [client postPath:str parameters:@{@"courierId":dictPlist[@"id"],@"mobile": dataStrFromArr,@"sms":_textView.text,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
                [self getSmsNumberCanUseFromConrierId:dictPlist[@"id"]];
                [self clearDuanXin];
                if (isSuccess) {
                    [self showAlert:@"短信发送成功" isSure:YES];
                }else{
                    //调用定制的弹框
                    _messageFinish = [[DuanXinYongWanTiShiVC alloc] init];
                    _messageFinish.delegate = self;
                    _messageFinish.caseFromMessage = [dict[@"result"] integerValue];
                    NSLog(@"---%ld----",_messageFinish.caseFromMessage);
                    [self.view addSubview:_messageFinish.view];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showAlert:@"网络异常" isSure:YES];
            }];
        }
    }else{
        [self showAlertViewWithMaessage:@"您还没有登录,请登录！" title:@"登录提示" otherBtn:@"登录" withAlterTag:901];
    }
}

#pragma mark - 短息你充值代理事件
-(void)payMessage{
    _messageFinish.view.hidden = YES;
    [self payMoneyFromMessage];
}

#pragma mark - textFiled代理事件
SHOUJIANPAN
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length >=11) {
        cellNumber++;
        [_dataArray addObject:textField.text];
        [self.tableView reloadData];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    _imgHisAndPrepid.hidden = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellNumber;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"dunaxin";
    DuanXinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DuanXinViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.row==0) {
        cell.deleteBtn.hidden=YES;
        cell.deleteBtn1.hidden = YES;
    }
    if (indexPath.row <_dataArray.count) {
        cell.textField.text=_dataArray[indexPath.row];
    }
    cell.textDelegate=self;
    cell.deleteBtn.tag=indexPath.row;
    cell.textField.tag=indexPath.row+800;
    return cell;
}

#pragma mark - 警告框及实现警告协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==901) {//跳转登录
        if (buttonIndex==1) {
            [self changeViewController];
        }else{
            
        }
    }else if(alertView.tag ==902){//审核中 跳转审核中界面
        if (buttonIndex==1) {
            ShenHeZhongVC *svc = [[ShenHeZhongVC alloc] init];
            svc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:svc animated:YES];
        }else{
            
        }
    }else if(alertView.tag ==903){//审核失败 跳转提交订单
        if (buttonIndex==1) {
            ShenHeShiBaiVC *svc = [[ShenHeShiBaiVC alloc] init];
            svc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:svc animated:YES];
        }else{
            
        }
    }
}

//改变视图控制器到登陆注册
-(void)changeViewController{
    LogInViewController *log=[[LogInViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:log];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    app2.window.rootViewController=nav;
}

//显示警告框
- (void)showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT withAlterTag:(NSInteger)tag{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    alert.tag = tag;
    [alert show];
}

- (void)timerFireMethod:(NSTimer*)theTimer{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *) _message isSure:(BOOL)sure{
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
