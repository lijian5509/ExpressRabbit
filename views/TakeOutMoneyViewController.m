//
//  TakeOutMoneyViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "TakeOutMoneyViewController.h"
#import "MessageCheckViewController.h"

@interface TakeOutMoneyViewController ()

@end

@implementation TakeOutMoneyViewController

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
    self.textField.delegate=self;
    [super viewDidLoad];
    [self showUI];
    [self requestData];
    
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"提现";
    self.nameLabel.text=self.dataArray[0];
    self.IdLabel.text=self.dataArray[3];
    NSString *weiHao=[self.dataArray[1] substringFromIndex:[self.dataArray[1] length]-4];
    self.bankLabel.text=[NSString stringWithFormat:@"%@尾号%@",self.dataArray[2],weiHao];
    
    //返回键、
    BACKKEYITEM;
    BACKVIEW;
}
-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 收键盘
SHOUJIANPAN;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

-(void)requestData{
    GET_PLISTdICT
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,HUOQUYUE];
    AFHTTPClient *aclient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    [aclient postPath:postUrl parameters:@{@"courierId":dictPlist[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
        if (isSuccess) {
            self.moneLabel.text=[NSString stringWithFormat:@"%.2f" ,[dict[@"result"] floatValue]];
            
        }else{
            [self showAlertViewWithMaessage:@"信息获取错误" title:@"提示" otherBtn:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton *)sender {//确认转出
    if (self.textField.text.length==0) {
        [self showAlertViewWithMaessage:@"请输入余额" title:@"警告" otherBtn:nil];
        [self.textField becomeFirstResponder];
        return;
    }
    if ([self.moneLabel.text  floatValue]<[self.textField.text floatValue]) {
        [self showAlertViewWithMaessage:@"提取金额大于现有余额,请重新操作" title:@"提示" otherBtn:nil];
        return;
    }
    
     MessageCheckViewController *message=[[MessageCheckViewController alloc]init];
    message.cashNum=self.textField.text;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:message animated:YES];
    
}
//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btnT, nil];
    [alert show];
}

@end
