//
//  BankDetailViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "BankDetailViewController.h"
#import "EditBankCardViewController.h"
#import "FixBankCheckViewController.h"

@interface BankDetailViewController ()

@end

@implementation BankDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
    [self requestData];//请求数据
    CGRect rect1=self.lineView1.frame;
    rect1.size.height=0.5;
    self.lineView1.frame=rect1;
    CGRect rect2=self.lineView2.frame;
    rect2.size.height=0.5;
    self.lineView2.frame=rect2;
    CGRect rect3=self.lineView3.frame;
    rect3.size.height=0.5;
    self.lineView3.frame=rect3;
    
}
#pragma mark - 摆UI界面
- (void)showUI{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"银行卡详情";
    //返回键、
    BACKKEYITEM;
    BACKVIEW;
    UIButton *bianJiBtn=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 50, 40) target:self sel:@selector(editorBtn) tag:201 image:nil title:@"编辑"];
    bianJiBtn.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [bianJiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:bianJiBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

//请求数据
-(void)requestData{
    GET_PLISTdICT
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,GETYINHANGKAXINXI];
    NSString *sign=[Helper addSecurityWithUrlStr:GETYINHANGKAXINXI];
    AFHTTPClient *acient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    [acient postPath:postUrl parameters:@{@"courierId": dictPlist[@"id"],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
        if (isSuccess) {
            [self downloadSuccessWith:responseObject];
        }else{
            [self showAlert:@"请求有误" isSure:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertViewWithMaessage:@"网络异常" title:@"提示" otherBtn:nil];
    }];
}
//返回
-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//编辑
-(void)editorBtn{
    if (self.nameLabel.text==nil) {
        return;
    }
    NSArray *dataArray=@[self.nameLabel.text,self.bankCardNumLabel.text,self.bankNameLabel.text,self.phoneNumberLabel.text];
    FixBankCheckViewController *fix=[[FixBankCheckViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    fix.dataArray=[NSMutableArray arrayWithArray:dataArray];
    [self.navigationController pushViewController:fix animated:YES];
}

- (void)downloadSuccessWith:(id)response{
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    self.nameLabel.text=dict[@"result"][@"cardName"];
    self.bankCardNumLabel.text=dict[@"result"][@"bankCard"];
    self.bankNameLabel.text=dict[@"result"][@"bankName"];
    self.phoneNumberLabel.text=dict[@"result"][@"checkMobile"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
