//
//  OrderDetailViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-28.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "MapViewController.h"
#import "UserLocationManager.h"
#import "ScanBarViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订单详情"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订单详情"];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self showUI];
    [self fillMessageWithDataWith:nil];
    BACKKEYITEM
    
    [[NSUserDefaults standardUserDefaults]setObject:[self.model.id stringValue] forKey:@"orderId"];
    CGRect frame=self.grayView.frame;
    frame.size.height=0.5;
    self.grayView.frame=frame;
    CGRect frame1=self.grayView1.frame;
    frame1.size.height=0.5;
    self.grayView1.frame=frame1;
}
-(void)getBack{
    if ([self.model.readFlag intValue]==0) {//未读
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestUrl{
    NSString *urlPath=[NSString stringWithFormat:CESHIZONG,DINGDANXIANGQING];
    AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    NSString *sign=[Helper addSecurityWithUrlStr:DINGDANXIANGQING];
    [client postPath:urlPath parameters:@{@"orderId": [self.model.id stringValue],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
        if (isSuccess) {
            [self fillMessageWithDataWith:dict];
        }else{
            [self showAlert:@"请求出错" isSure:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlert:@"网络错误" isSure:YES];
    }];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.title=@"订单详情";
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
}

- (void)fillMessageWithDataWith:(NSDictionary *)dict{
    
    [[NSUserDefaults standardUserDefaults]setObject:[self.model.expressCompany[@"id"] stringValue] forKey:@"expresscompanyId"];
    
    [[NSUserDefaults standardUserDefaults]setObject:self.model.expressCompany[@"name"] forKey:@"logisticsCompanyId"];
    
    self.userPhoneLabel.text = _model.baseOrderNo;
    self.timeLabel.text=[Helper fullDateStringFromNumberString:[self.model.xdDate stringValue]];
    
    if ((id)self.model.netsiteName!=nil) {
        self.companyLabel.text=self.model.netsiteName;
    }
    
    if ([self.model.orderStatus isEqualToString:@"PICKED_INPUT"]) {//录入单号
        self.orderStatusLabel.text=@"状态:已完成";
        self.eneteringButton.hidden=YES;
        self.bottomImageView.hidden=YES;
        self.label1.hidden=YES;
        self.btn1.hidden=YES;
        self.addressBackView.hidden=YES;
        self.image1.hidden=YES;
        self.imageView.hidden=YES;
        self.distensLabel.hidden=YES;
        [self creatExpressOrder];
    }else{
        self.orderStatusLabel.text=@"状态:等待取件";
    }
    if ([self.model.fromCityName isEqualToString:@"其他城市"]) {
        self.model.fromCityName=@"";
    }
    if ([self.model.fromDistrictName isEqualToString:@"不限"]) {
        self.model.fromDistrictName=@"";
    }
    self.sendAddressLabel.text=[NSString stringWithFormat:@"取件地:%@%@%@%@",self.model.fromProvinceName,self.model.fromCityName,self.model.fromDistrictName,self.model.fromAddress];
    
    self.sendPhoneLabel.text=self.model.senderTelephone;
    self.sendNameLabel.text=self.model.senderName;
    if ([self.model.toCityName isEqualToString:@"其他城市"]) {
        self.model.toCityName=@"";
    }
    if ([self.model.toDistrictName isEqualToString:@"不限"]) {
        self.model.toDistrictName=@"";
    }
    self.receiveAddressLabel.text=[NSString stringWithFormat:@"目的地:%@%@%@%@",self.model.toProvinceName,self.model.toCityName,self.model.toDistrictName,self.model.toAddress];
    self.receiveNameLabel.text=self.model.receiverName;
    self.receivePhoneLabel.text=self.model.receiverTelephone;
    if (self.model.content==NULL) {
        self.remarkLabel.text=@"无";
    }else if ([self.model.content isEqualToString:@"填写备注信息"]) {
        self.remarkLabel.text=@"无";
    }else{
        self.remarkLabel.text=self.model.content;
    }
    if (self.model.addressLat==NULL) {
        self.distensLabel.text=@"无位置信息";
    }else{
        float addressDis=[[UserLocationManager shareManager]getDistanceWithMuDiC1La:[self.model.addressLat floatValue] andC1Long:[self.model.addressLng floatValue]];
        self.distensLabel.text=[NSString stringWithFormat:@"%.2fkm",addressDis/1000];
    }
}

-(void)creatExpressOrder{
    CGRect rect=self.remarkLabel.frame;
    UIImageView *backView=[[UIImageView alloc]initWithFrame:CGRectMake(0, rect.origin.y+1+rect.size.height, 320, 30)];
    backView.userInteractionEnabled=YES;
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    UILabel *addressLabel=[MyControl creatLabelWithFrame:CGRectMake(10, 0, 60, 30) text:self.model.logisticsCompany[@"name"]];
    [backView addSubview:addressLabel];
    UILabel *orderNum=[MyControl creatLabelWithFrame:CGRectMake(70, 0, 170, 30) text:self.model.expressOrderNo];
    [backView addSubview:orderNum];
    UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(200, 0, 110, 30) target:self sel:@selector(editExpressOrder) tag:1000 image:nil title:@"修改"];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 15);
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(100, 5, 10, 20)];
    img.image=[UIImage imageNamed:@"个人中心-设置_08"];
    [btn addSubview:img];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backView addSubview:btn];
    
}
#pragma mark - 修改订单
- (void)editExpressOrder{//编辑快递订单
    [self showAlertViewWithMaessage:@"你确定要修改单号吗" title:@"提示" otherBtn:@"修改"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            // 判断的手机的定位功能是否开启
            // 开启定位:设置 > 隐私 > 位置 > 定位服务
            if ([CLLocationManager locationServicesEnabled] &&
                ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
                 || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
                    // 启动位置更新
                    // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
                }else {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启定位功能" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
                    [alter show];
                    return;
                }
            
            MapViewController *map=[[MapViewController alloc]init];
            map.muBiao2La=[self.model.addressLat floatValue];
            map.muBiao2Long=[self.model.addressLng floatValue];
            map.muBiaotitle=@"客户位置";
            
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:map animated:YES];
        }
            break;
            
        case 102:
        {
            ScanBarViewController *scan=[[ScanBarViewController alloc]init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:scan animated:YES];
        }
            break;
            
        default:
            break;
    }
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

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {//修改
        ScanBarViewController *scan=[[ScanBarViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:scan animated:YES];
    }else{
        
    }
}

@end
