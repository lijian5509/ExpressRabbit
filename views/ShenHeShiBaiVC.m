//
//  ShenHeShiBaiVC.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/16.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ShenHeShiBaiVC.h"
#import "FillMessageViewController.h"

@implementation ShenHeShiBaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor(233, 233, 233);
    [self addTitile:@"审核失败"];
    [self addBarButtonItemWithNormalimageName:@"ic_back" target:self action:@selector(goBack) isLeft:YES andTitle:nil andTitleWidth:0];
    [self showUI];
}

-(void)showUI{
    [self.view addSubview:[self getWhiteView]];
    UIView *whiteView = [self getWhiteView];
    for (int i = 0; i<2; i++) {
        UILabel *lbl = [MyControl creatLabelWithFrame:CGRectMake(15, whiteView.frame.origin.y +whiteView.frame.size.height + 25+(12+7)*i, SCREENWIDTH-30, 12) text:@"您的申请未通过！"];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.tag = 101+i;
        lbl.textColor = MyColor(100, 100, 100);
        if (i==1) {
            NSString *strDianHua = @"客服电话：4000-509-502";
            lbl.attributedText = [strDianHua selfFont:12 selfColor:MyColor(100, 100, 100) LightText:@"4000-509-502" LightFont:12 LightColor:MyColor(38, 128, 254)];
            lbl.tag = 101+i;
        }
        [self.view addSubview:lbl];
    }
    UILabel *lblFiail = (UILabel *)[self.view viewWithTag:102];
    //重新提交的按钮
    UIButton *btnFan = [MyControl creatButtonWithFrame:CGRectMake(15, lblFiail.frame.origin.y+lblFiail.frame.size.height+30, SCREENWIDTH-30, 43) target:self sel:@selector(btnChongXin:) tag:101 image:@"橙色按钮" title:nil];
    UILabel *lblYaoQing = [MyControl creatLabelWithFrame:CGRectMake(btnFan.frame.size.width/2-50, 5, 100, 30) text:@"重新提交"];
    lblYaoQing.textAlignment = NSTextAlignmentCenter;
    lblYaoQing.textColor = [UIColor whiteColor];
    lblYaoQing.font = [UIFont boldSystemFontOfSize:18];
    [btnFan addSubview:lblYaoQing];
    [self.view addSubview:btnFan];
}

-(UIView *)getWhiteView{
    UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 80)];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    //白色view的内容
    UIImageView *img = [MyControl creatImageViewWithFrame:CGRectMake(65, whiteBackView.frame.size.height/2-44/2, 44, 44) imageName:@"新审核图片" isCache:YES];
    [whiteBackView addSubview:img];
    //审核中
    UILabel *lblShenHe = [MyControl creatLabelWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width+10, img.frame.origin.y+15, 100, 15) text:@"审核失败！"];
    lblShenHe.font = [UIFont systemFontOfSize:15];
    [whiteBackView addSubview:lblShenHe];
    return whiteBackView;
}

-(void)goBack{
    if (self.isOderManager) {
        [self changeRootViewController];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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

-(void)btnChongXin:(UIButton *)btn{
    FillMessageViewController *fvc = [[FillMessageViewController alloc] init];
    fvc.hidesBottomBarWhenPushed = YES;
    fvc.isCheckFinal = YES;
    fvc.isOderManager = self.isOderManager;
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
