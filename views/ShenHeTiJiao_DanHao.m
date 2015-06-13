//
//  ShenHeTiJiao_DanHao.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/16.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ShenHeTiJiao_DanHao.h"

@implementation ShenHeTiJiao_DanHao

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor(233, 233, 233);
    [self addTitile:@"审核订单"];
    [self addBarButtonItemWithNormalimageName:@"ic_back" target:self action:@selector(goBack) isLeft:YES andTitle:nil andTitleWidth:0];
    [self showUI];
}

-(void)showUI{
    //标题
    UILabel *lblTitle = [MyControl creatLabelWithFrame:CGRectMake(15, 30/2-12/2, SCREENWIDTH/2, 12) text:@"请扫描当天的3个快递单号"];
    lblTitle.font = [UIFont systemFontOfSize:12];
    lblTitle.textColor = MyColor(100, 100, 100);
    [self.view addSubview:lblTitle];
    //三个单号提交
    UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 45*3)];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    whiteBackView.tag = 501;
    for (int i = 0; i<3; i++) {
        //显示文字
        UILabel *lbl = [MyControl creatLabelWithFrame:CGRectMake(15, 45/2-15/2+45*i, SCREENWIDTH-100, 15) text:@""];
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.tag = 201 +i;
        [whiteBackView addSubview:lbl];
        //扫描
        UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(SCREENWIDTH-80-15, 45/2-30/2+45*i, 80, 30) target:self sel:@selector(btnOrder:) tag:301+i image:nil title:@"扫描单号"];
        [btn setTitleColor:MyColor(251, 78, 9) forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 4;
        btn.layer.borderColor = MyColor(251, 78, 9).CGColor;
        [whiteBackView addSubview:btn];
        if (i<2) {
            //灰线
            UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 45*(i+1), SCREENWIDTH-15, 1)];
            grayLineView.backgroundColor = MyColor(233, 233, 233);
            [whiteBackView addSubview:grayLineView];
        }
    }
    [self.view addSubview:whiteBackView];
    //提交按钮
    UIButton *btnSubmit = [MyControl creatButtonWithFrame:CGRectMake(15, whiteBackView.frame.origin.y+whiteBackView.frame.size.height+30, SCREENWIDTH-30, 43) target:self sel:@selector(btnSubmit:) tag:101 image:@"橙色按钮" title:nil];
    UILabel *lblYaoQing = [MyControl creatLabelWithFrame:CGRectMake(btnSubmit.frame.size.width/2-50, 5, 100, 30) text:@"提交审核"];
    lblYaoQing.textAlignment = NSTextAlignmentCenter;
    lblYaoQing.textColor = [UIColor whiteColor];
    lblYaoQing.font = [UIFont boldSystemFontOfSize:18];
    [btnSubmit addSubview:lblYaoQing];
    [self.view addSubview:btnSubmit];
}

#pragma mark - 扫描单号
-(void)btnOrder:(UIButton *)btn{
    NSLog(@"tag:%ld",(long)btn.tag);
    ScanOrderVC *svc = [[ScanOrderVC alloc] init];
    svc.index = btn.tag - 301;
    svc.hidesBottomBarWhenPushed = YES;
    svc.delegate = self;
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - 执行扫描单号回调代理方法
-(void)transStr:(NSString *)str andIndex:(NSInteger)index{
    UIView *whiteView = [self.view viewWithTag:501];
    //回调单号
    UILabel *targetLbl = (UILabel *)[whiteView viewWithTag:201+index];
    targetLbl.text = str;
    //改变button的文字
    UIButton *targetBtn = (UIButton *)[whiteView viewWithTag:301+index];
    [targetBtn setTitle:@"重新扫描" forState:UIControlStateNormal];
}

#pragma mark - 提交审核
-(void)btnSubmit:(UIButton *)btn{
    UIView *whiteView = [self.view viewWithTag:501];
    UILabel *lbl1 = (UILabel *)[whiteView viewWithTag:201];
    UILabel *lbl2 = (UILabel *)[whiteView viewWithTag:202];
    UILabel *lbl3 = (UILabel *)[whiteView viewWithTag:203];
    if (lbl1.text.length==0||lbl2.text.length==0||lbl3.text.length==0) {
        [self showAlert:@"请扫描完整的单号" isSure:YES];
    }else if ([lbl1.text isEqualToString:lbl2.text]||[lbl1.text isEqualToString:lbl3.text]||[lbl2.text isEqualToString:lbl3.text]){
        [self showAlert:@"有重复的单号" isSure:YES];
    }else{
        HUODONGZHISHIQI
        NSString *urlPath=[NSString stringWithFormat:CESHIZONG,WANSHANDINGDANHAO];
        GET_PLISTdICT
        NSString *phoneNumber=dictPlist[@"regMobile"];
        NSString *sign=[Helper addSecurityWithUrlStr:WANSHANDINGDANHAO];
        NSDictionary *dict=@{@"regMobile": phoneNumber,@"expressNoOne":lbl1.text,@"expressNoTwo":lbl2.text,@"expressNoThree":lbl3.text,@"publicKey":PUBLICKEY,@"sign":sign};
        AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
        [client postPath:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [tumblrHUD removeFromSuperview];
            [self downLoadSuccess:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlert:@"网络错误" isSure:YES];
            [tumblrHUD removeFromSuperview];
        }];
    }
}

-(void)downLoadSuccess:(id)responseObject{
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    if ([[NSString stringWithFormat:@"%@",dict[@"success"]] isEqualToString:@"1"]) {
        //扫描成功
        //跳转并且本地记录
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"finishCheck"];
        //设置代理回调隐藏扫描按钮
        [self.delegate hidenScanBtnFromScanView];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
