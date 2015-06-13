//
//  ChongZhiChengGongVC.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ChongZhiChengGongVC.h"

@implementation ChongZhiChengGongVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor(233, 233, 233);
    [self addTitile:@"充值成功"];
    [self addBarButtonItemWithNormalimageName:@"ic_back" target:self action:@selector(goBack) isLeft:YES andTitle:nil andTitleWidth:0];
    [self showUI];
}

-(void)showUI{
    //白色背景
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 100)];
    whiteView.backgroundColor = [UIColor whiteColor];
    //充值成功图片
    UIImageView *imgChengGong = [MyControl creatImageViewWithFrame:CGRectMake(SCREENWIDTH/2-15-44, 26, 44, 44) imageName:@"充值成功" isCache:YES];
    [whiteView addSubview:imgChengGong];
    //充值成功文字
    UILabel *lblChengGong = [MyControl creatLabelWithFrame:CGRectMake(imgChengGong.frame.origin.x+imgChengGong.frame.size.width+15, 26, 100, 14) text:@"充值成功！"];
    [whiteView addSubview:lblChengGong];
    //充值的金额和条数
    NSString *strJinE = [NSString stringWithFormat:@"充值金额：%ld元",self.JinE];
    NSString *strTiaoShu = [NSString stringWithFormat:@"短信条数：%ld条",self.TiaoShu];
    NSArray *arrTitle = @[strJinE,strTiaoShu];
    for (int i = 0; i<2; i++) {
        UILabel *lbl = [MyControl creatLabelWithFrame:CGRectMake(lblChengGong.frame.origin.x, lblChengGong.frame.origin.y+lblChengGong.frame.size.height+7+15*i, 100, 10) text:arrTitle[i]];
        lbl.font = [UIFont systemFontOfSize:10];
        [whiteView addSubview:lbl];
    }
    [self.view addSubview:whiteView];
    //返回的按钮
    UIButton *btnFan = [MyControl creatButtonWithFrame:CGRectMake(15, whiteView.frame.origin.y+whiteView.frame.size.height+40, SCREENWIDTH-30, 43) target:self sel:@selector(goBack) tag:101 image:@"橙色按钮" title:nil];
    UILabel *lblYaoQing = [MyControl creatLabelWithFrame:CGRectMake(btnFan.frame.size.width/2-50, 5, 100, 30) text:@"返 回"];
    lblYaoQing.textAlignment = NSTextAlignmentCenter;
    lblYaoQing.textColor = [UIColor whiteColor];
    lblYaoQing.font = [UIFont boldSystemFontOfSize:18];
    [btnFan addSubview:lblYaoQing];
    [self.view addSubview:btnFan];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
