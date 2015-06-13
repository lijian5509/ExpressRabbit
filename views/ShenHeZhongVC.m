//
//  ShenHeZhongVC.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/16.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ShenHeZhongVC.h"

@implementation ShenHeZhongVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor(233, 233, 233);
    [self addTitile:@"审核中"];
    [self addBarButtonItemWithNormalimageName:@"ic_back" target:self action:@selector(goBack) isLeft:YES andTitle:nil andTitleWidth:0];
    [self showUI];
}

-(void)showUI{
    [self.view addSubview:[self getWhiteView]];
    UIView *whiteView = [self getWhiteView];
    [self getViewFromWhiteView:whiteView];
}

-(void)getViewFromWhiteView:(UIView *)whiteView{
    NSArray *arrText = @[@"您的申请提交成功，我们将尽快为您审核",@"您也可以扫描所在网点的3个快递单号，这样可以",@"更快通过审核！"];
    for (int i = 0; i<arrText.count; i++) {
        UILabel *lbl = [MyControl creatLabelWithFrame:CGRectMake(15, whiteView.frame.origin.y +whiteView.frame.size.height + 25+(12+7)*i, SCREENWIDTH-30, 12) text:arrText[i]];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.tag = 101+i;
        lbl.textColor = MyColor(100, 100, 100);
        [self.view addSubview:lbl];
    }
    UILabel *lblFiail = (UILabel *)[self.view viewWithTag:103];
    //扫描单号的按钮
    //先判断是否扫描过
    NSString *isScan = [[NSUserDefaults standardUserDefaults] valueForKey:@"finishCheck"];
    NSLog(@"isScan:%@",isScan);
    if ([isScan isEqualToString:@"0"]) {
        UIButton *btnFan = [MyControl creatButtonWithFrame:CGRectMake(15, lblFiail.frame.origin.y+lblFiail.frame.size.height+30, SCREENWIDTH-30, 43) target:self sel:@selector(btnSaoMiao:) tag:201 image:@"橙色按钮" title:nil];
        UILabel *lblYaoQing = [MyControl creatLabelWithFrame:CGRectMake(btnFan.frame.size.width/2-50, 5, 100, 30) text:@"扫描单号"];
        lblYaoQing.textAlignment = NSTextAlignmentCenter;
        lblYaoQing.textColor = [UIColor whiteColor];
        lblYaoQing.font = [UIFont boldSystemFontOfSize:18];
        [btnFan addSubview:lblYaoQing];
        [self.view addSubview:btnFan];
    }
}

-(void)btnSaoMiao:(UIButton *)btn{
    ShenHeTiJiao_DanHao *svc = [[ShenHeTiJiao_DanHao alloc] init];
    svc.hidesBottomBarWhenPushed = YES;
    svc.delegate = self;
    [self.navigationController pushViewController:svc animated:YES];
}

-(UIView *)getWhiteView{
    UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 80)];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    //白色view的内容
    UIImageView *img = [MyControl creatImageViewWithFrame:CGRectMake(65, whiteBackView.frame.size.height/2-44/2, 44, 44) imageName:@"新审核图片" isCache:YES];
    [whiteBackView addSubview:img];
    //审核中
    UILabel *lblShenHe = [MyControl creatLabelWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width+10, img.frame.origin.y+5, 100, 15) text:@"账号审核中"];
    lblShenHe.font = [UIFont systemFontOfSize:15];
    [whiteBackView addSubview:lblShenHe];
    //客服电话
    UILabel *lblDianHua = [MyControl creatLabelWithFrame:CGRectMake(lblShenHe.frame.origin.x, lblShenHe.frame.origin.y+15+10, 200, 12) text:@""];
    NSString *strDianHua = @"客服电话：4000-509-502";
    lblDianHua.attributedText = [strDianHua selfFont:12 selfColor:MyColor(100, 100, 100) LightText:@"4000-509-502" LightFont:12 LightColor:MyColor(38, 128, 254)];
    [whiteBackView addSubview:lblDianHua];
    return whiteBackView;
}

-(void)goBack{
    if (self.isOderManager) {
        [self changeRootViewController];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)changeRootViewController{
    TabBarViewController *tab=[TabBarViewController shareTabBar];
    [tab.view reloadInputViews];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *app2=app.delegate;
    app2.window.rootViewController=tab;
    [tab creatSystemBar];
    tab.selectedIndex=0;
}

#pragma mark - 执行代理方法进行隐藏
-(void)hidenScanBtnFromScanView{
    UIButton *btn = (UIButton *)[self.view viewWithTag:201];
    btn.hidden = YES;
    self.isOderManager = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
