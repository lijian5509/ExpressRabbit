//
//  TakeOutMoneyViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "TakeOutMoneyViewController.h"
#import "MessageCheckViewController.h"
#import "BankDetailViewController.h"

@interface TakeOutMoneyViewController ()

@end

@implementation TakeOutMoneyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArray=[[NSMutableArray alloc]init];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self showUI];
    [self requestData];
    self.textField.delegate=self;
    self.moneLabel.textColor=[UIColor colorWithRed:0 green:153/255.f blue:0 alpha:1];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [_dataArray removeAllObjects];
}
#pragma mark - 实现输入框协议
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame=CGRectMake(0, -70, self.view.frame.size.width, self.view.frame.size.height) ;
    }];

    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.view.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) ;
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length==0) {
        return YES;
    }
    char c=[string characterAtIndex:0];
    if (c<'0'||c>'9') {
        [self showAlertViewWithMaessage:@"输入字符不合法，请再次输入" title:@"提示" otherBtn:nil];
        return NO;
    }
    return YES;
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"提现";
    
    //返回键、
    BACKKEYITEM;
    BACKVIEW;
}
-(void)getBack{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

#pragma mark 收键盘
SHOUJIANPAN;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

-(void)requestData{
    if (self.dataArray.count!=0&&self.dataArray.count==5) {
        self.moneLabel.text=[NSString stringWithFormat:@"%.2f",[self.dataArray[0] floatValue]];
        self.nameLabel.text=[NSString stringWithFormat:@"%@",self.dataArray[1]];
        if ([self.dataArray[3] length]>5) {
            self.bankLabel.text=[NSString stringWithFormat:@"%@尾号%@",self.dataArray[2],[self.dataArray[3] substringFromIndex:[self.dataArray[3] length]-4]];
        }else{
            self.bankLabel.text=[NSString stringWithFormat:@"%@尾号%@",self.dataArray[2],self.dataArray[3]];
        }
        self.phoneLabel.text=[NSString stringWithFormat:@"%@***%@",[self.dataArray[4] substringToIndex:3],[self.dataArray[4] substringFromIndex:[self.dataArray[4] length]-4]];
        [[NSUserDefaults standardUserDefaults]setValue:_dataArray[4] forKey:@"bankMobile"];
        return;
    }
    
    GET_PLISTdICT
    NSString *postUrl=[NSString stringWithFormat:CESHIZONG,HUOQUYUE];
    NSString *sign=[Helper addSecurityWithUrlStr:HUOQUYUE];
    AFHTTPClient *aclient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    [aclient postPath:postUrl parameters:@{@"courierId":dictPlist[@"id"],@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
        if (isSuccess) {
            self.moneLabel.text=[NSString stringWithFormat:@"%.2f",[dict[@"result"] floatValue]];
        }else{
            [self showAlertViewWithMaessage:@"信息获取错误" title:@"提示" otherBtn:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertViewWithMaessage:@"网络错误" title:@"提示" otherBtn:nil];
    }];
    //查看银行卡是否绑定
    NSString *urlPatn=[NSString stringWithFormat:CESHIZONG,GETYINHANGKAXINXI];//得到银行卡信息
    NSString *sign1=[Helper addSecurityWithUrlStr:GETYINHANGKAXINXI];
    [aclient postPath:urlPatn parameters:@{@"courierId": dictPlist[@"id"],@"publicKey":PUBLICKEY,@"sign":sign1} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
        if (isSuccess) {
            [[NSUserDefaults standardUserDefaults]setValue:dict[@"result"][@"checkMobile"] forKey:@"bankMobile"];
#pragma mark - 注意修改
            if (dict[@"result"]!=[NSNull null]) {
                self.nameLabel.text=[NSString stringWithFormat:@"%@",dict[@"result"][@"cardName"]];
                NSString *bankStr=dict[@"result"][@"bankCard"];
                self.bankLabel.text=[NSString stringWithFormat:@"%@尾号%@",dict[@"result"][@"bankName"],[bankStr substringFromIndex:bankStr.length-4]];
                
                NSString *phoneStr=dict[@"result"][@"checkMobile"];
                self.phoneLabel.text=[NSString stringWithFormat:@"%@***%@",[phoneStr substringToIndex:3],[phoneStr substringFromIndex:phoneStr.length-4]];
            }
        }else{
            
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
    if (sender.tag==102) {
        BankDetailViewController *bank=[[BankDetailViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:bank animated:YES];
        return;
    }
    if (self.textField.text.length==0) {
        [self showAlertViewWithMaessage:@"请输入余额" title:@"提示" otherBtn:nil];
        [self.textField becomeFirstResponder];
        return;
    }
    
    if ([self.moneLabel.text  floatValue]<[self.textField.text floatValue]) {
        [self showAlertViewWithMaessage:@"提取金额大于现有余额,请重新操作" title:@"提示" otherBtn:nil];
        return;
    }
    if ([self.moneLabel.text  floatValue]==0) {
        [self showAlertViewWithMaessage:@"提现金额不能为0" title:@"提示" otherBtn:nil];
        return;
    }

    MessageCheckViewController *message=[[MessageCheckViewController alloc]init];
    message.cashNum=self.textField.text;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:message animated:YES];
}
//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}

@end
