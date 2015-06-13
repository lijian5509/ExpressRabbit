//
//  ChongZhiVC.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ChongZhiVC.h"
#import "ChongZhiChengGongVC.h"

@implementation ChongZhiVC
{
    UILabel *_lblJinE;
    //支付金额
    NSInteger _jinE;
    //支付条数
    NSInteger _tiaoShu;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor(240, 240, 240);
    [self addTitile:@"充值"];
    [self addBarButtonItemWithNormalimageName:@"ic_back" target:self action:@selector(goBack) isLeft:YES andTitle:nil andTitleWidth:0];
    [self dataConfig];
    [self showUI];
}

-(void)dataConfig{
    _jinE = 30;
    _tiaoShu = 360;
}

-(void)showUI{
    //白色背景
    UIView *backWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 48)];
    backWhiteView.backgroundColor = [UIColor whiteColor];
    //电话
    UILabel *lblMobile = [MyControl creatLabelWithFrame:CGRectMake(15, backWhiteView.frame.size.height/2-12/2, 12*11, 12) text:self.strMobile];
    lblMobile.font = [UIFont systemFontOfSize:12];
    //姓名
    UILabel *lblName = [MyControl creatLabelWithFrame:CGRectMake(SCREENWIDTH-15-self.strName.length*12, backWhiteView.frame.size.height/2-12/2, self.strName.length*12, 12) text:self.strName];
    lblName.font = [UIFont systemFontOfSize:12];
    [backWhiteView addSubview:lblMobile];
    [backWhiteView addSubview:lblName];
    [self.view addSubview:backWhiteView];
    //短信剩余
    NSString *strShengYu = [NSString stringWithFormat:@"短信剩余 %ld",(long)self.duanXinShengYu];
    UILabel *lblDuanXin = [MyControl creatLabelWithFrame:CGRectMake(10, backWhiteView.frame.origin.y+backWhiteView.frame.size.height+10, 100, 10) text:nil];
    lblDuanXin.font = [UIFont systemFontOfSize:10];
    lblDuanXin.attributedText = [strShengYu selfFont:10 selfColor:MyColor(100, 100, 100) LightText:[NSString stringWithFormat:@"%ld",(long)self.duanXinShengYu] LightFont:10 LightColor:MyColor(38, 128, 254)];
    [self.view addSubview:lblDuanXin];
    //四个选择充值的按钮
    NSArray *arrAll = @[@"360条",@"720条",@"1700条",@"4000条"];
    NSArray *arrUnit = @[@"约0.083/条",@"约0.071/条",@"约0.059/条",@"约0.05/条"];
    CGFloat pace = (SCREENWIDTH-62*4)/5;
    for (int i = 0; i<4; i++) {
        UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(pace+(62+pace)*i, lblDuanXin.frame.origin.y+lblDuanXin.frame.size.height+15, 62, 28) target:self sel:@selector(btnXuanDuanXin:) tag:201+i image:@"未选择短信" title:arrAll[i]];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        UILabel *lbl = [MyControl creatLabelWithFrame:CGRectMake(pace+(62+pace)*i, btn.frame.origin.y+btn.frame.size.height+5, 62, 9) text:arrUnit[i]];
        lbl.tag = 301+i;
        lbl.font = [UIFont systemFontOfSize:9];
        lbl.textColor = MyColor(100, 100, 100);
        lbl.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:btn];
        [self.view addSubview:lbl];
    }
    //改变btn的选中状态
    UIButton *btnFirst = (UIButton *)[self.view viewWithTag:201];
    [btnFirst setBackgroundImage:[UIImage imageNamed:@"已选择短信"] forState:UIControlStateNormal];
    //显示钱数
    UILabel *lblTiao = (UILabel *)[self.view viewWithTag:301];
    _lblJinE = [MyControl creatLabelWithFrame:CGRectMake(10, lblTiao.frame.origin.y+lblTiao.frame.size.height+17.5, 100, 15) text:@"30元"];
    _lblJinE.textColor = MyColor(251, 78, 10);
    [self.view addSubview:_lblJinE];
    //支付宝充值
    UIButton *btnPay = [MyControl creatButtonWithFrame:CGRectMake(15, _lblJinE.frame.origin.y+_lblJinE.frame.size.height+20, SCREENWIDTH-30, 43) target:self sel:@selector(btnPay:) tag:101 image:@"橙色按钮" title:nil];
    UILabel *lblYaoQing = [MyControl creatLabelWithFrame:CGRectMake(btnPay.frame.size.width/2-50, 5, 100, 30) text:@"支付宝充值"];
    lblYaoQing.textAlignment = NSTextAlignmentCenter;
    lblYaoQing.textColor = [UIColor whiteColor];
    lblYaoQing.font = [UIFont boldSystemFontOfSize:18];
    [btnPay addSubview:lblYaoQing];
    [self.view addSubview:btnPay];
}

#pragma mark - 支付按钮触发事件
-(void)btnPay:(UIButton *)btn{
    //调用支付宝的相关库
    GET_PLISTdICT
    [self createZhiFuBaoFromJinE:_jinE andTiaoShu:_tiaoShu andUserId:dictPlist[@"id"]];
}

//获取订单号 小订单号+"KDT"+时间戳
-(NSString *)getTradeNOFromBaseOrderNumber:(NSString *)base{
    NSInteger t = time(NULL);
    NSString *tradeNO = [NSString stringWithFormat:@"%ldKDT%@",(long)t,base];
    return tradeNO;
}

-(void)createZhiFuBaoFromJinE:(NSInteger)jinE andTiaoShu:(NSInteger)tiao andUserId:(NSString *)userId{
    //以下为公司支付宝的开发账号和邮箱
    //PKCS8的私钥
    NSString *partner = @"2088711135092854";
    NSString *seller = @"vipck@kuaiditu.cn";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAK3EmqE7ts6UDIJm9StqO9xjVlqtoctPWVp5BOKYA/F4Fa34COVUFvmnXNPeaxn9u/DR1tVb1iX3nZvde6jfdZjvqkeO5pG3e9saJT09BHkJAb8P57oYuMWF61t6XS/3vo5bCAQ4lRXFHx/F/kf0rS/9QYK5kKN4OM0c6qRmWoQRAgMBAAECgYBNFIv+/20M37FY2vDgLESXc10n5iOB+xXIwyv+k64UG8+KFx9jEtUKM0pDFUNvCRWoMnzYsd8hgmBgdnPXKiCQVmANalPmvacdMVJWmeNXMCxYojnSKWBh8RL37set3b479r/sfxjYQITVs1w6kci7Bac13koX7yix4GCggxuoAQJBANvhGUv0D2zbEQOoJ570Gbkwgs/fshhrZAXw/ihh/wGGGvPacYzvkgjSsjAlS6kpivY5kjZVrvHrf3kJWos6UYECQQDKUFHg6DJNLuBB8RG9pJO6wwYtE6kdUDauVW12wjOnGPRHhXa2D6IIrCXMAVpcYAjm7BTZxrjzGouHPQfZK1qRAkBMD+dfVfNMFdAh8raaDxki7fwiiuCh/+xe/cn+EEBVt511Q9jKB0n+UVyguRYeU6elm67Pqv5U48F6DllLFoaBAkEAiT7hvMxoS1nwgmtymI9MNJdW2j+LKzqeTbfgUX8/IS1ZkidlN+71AiMeZP3J+f6gK1+eaXpZP3oTi4QIjffOMQJANRBSztu3H7XMDoC1ZtVQ/hQvcgbI7xt7SqHLW7EKrUzxEWy3xwuPofPvNNA/n7JWfeLqLcGR9o3JxyA3oae0vw==";
    //将商品信息赋予AlixPayOrder的成员变量
    ZhiFuModel *fModel = [[ZhiFuModel alloc] init];
    fModel.partner = partner;
    fModel.seller = seller;
    fModel.tradeNO = [self getTradeNOFromBaseOrderNumber:userId]; //订单ID（由商家自行制定）
    fModel.productName = @"快递兔短信费"; //商品标题
    fModel.productDescription = [NSString stringWithFormat:@"短信条数%ld短信金额%ld",(long)_tiaoShu,(long)_jinE]; //商品描述
    fModel.amount = [NSString stringWithFormat:@"%ld",(long)_jinE]; //商品价格 @"0.01"
    NSString *notifyURL = [NSString stringWithFormat:CESHIZONG,DUANXINZHIFU];
    fModel.notifyURL = notifyURL; //回调URL
    
    fModel.service = @"mobile.securitypay.pay";
    fModel.paymentType = @"1";
    fModel.inputCharset = @"utf-8";
    fModel.itBPay = @"30m";
    fModel.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"KDTkuaidiyuan";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [fModel description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *resultStatus = resultDic[@"resultStatus"];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultStatus isEqualToString:@"9000"]) {
                NSLog(@"memo = %@",resultDic[@"memo"]);
                //进入支付成功界面
                [self paySuccess];
            }else if([resultStatus isEqualToString:@"6001"]){
                [self showAlert:@"交易中途放弃" isSure:YES];
            }else{
                [self showAlert:resultDic[@"memo"] isSure:YES];
            }
        }];
    }
}

-(void)paySuccess{
    ChongZhiChengGongVC *cvc = [[ChongZhiChengGongVC alloc] init];
    cvc.JinE = _jinE;
    cvc.TiaoShu = _tiaoShu;
    cvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cvc animated:YES];
}

-(void)btnXuanDuanXin:(UIButton *)btn{
    NSArray *arrJinE = @[@"30元",@"50元",@"100元",@"200元"];
    _lblJinE.text = arrJinE[btn.tag-201];
    NSArray *arrPayMoney = @[@30,@50,@100,@200];
    NSArray *arrPayStrip = @[@360,@720,@1700,@4000];
    _jinE = [arrPayMoney[btn.tag-201] integerValue];
    _tiaoShu = [arrPayStrip[btn.tag-201] integerValue];
    for (int i = 0; i<4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:201+i];
        [btn setBackgroundImage:[UIImage imageNamed:@"未选择短信"] forState:UIControlStateNormal];
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"已选择短信"] forState:UIControlStateNormal];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
