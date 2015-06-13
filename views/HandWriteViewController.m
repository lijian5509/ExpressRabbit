//
//  HandWriteViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-12-1.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "HandWriteViewController.h"
#import "ScanBarViewController.h"


@interface HandWriteViewController ()
{
    NSMutableArray *_dataArr;
    NSString *_presentCompany;
    NSInteger _presntCount;
    //保存plist文件的路径
    NSString *_filePath;
    //用动态数组保存快递兔快递员的上次选择的网点信息
    NSMutableArray *_infoArr;
    //存放选择前的View
    UIScrollView *_selectView;
    //存放选择后的View
    UIView *_selectBeforeView;
    //快递兔快递员上次的快递公司
    NSString *_last;
    NSMutableArray *_expressCompanyIdArr;
}
@end

@implementation HandWriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArr = [[NSMutableArray alloc] init];
        _infoArr = [[NSMutableArray alloc] init];
        _expressCompanyIdArr =[[NSMutableArray alloc]init];
        _presntCount = 100;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self showUI];
}
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"完善订单号";
    BACKKEYITEM;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    backView.backgroundColor = [UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1];
    UILabel *lblDanHao = [MyControl creatLabelWithFrame:CGRectMake(10, 5, 100, 20) text:@"请录入单号"];
    lblDanHao.textColor = [UIColor grayColor];
    [backView addSubview:lblDanHao];
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30+10, 1, 50)];
    lbl1.backgroundColor = [UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1];
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30+10, SCREENWIDTH-80, 1)];
    lbl2.backgroundColor = [UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1];
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30+10+50, SCREENWIDTH-80, 1)];
    lbl3.backgroundColor = [UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1];
    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(10+SCREENWIDTH-80, 30+10, 1, 50)];
    lbl4.backgroundColor = [UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1];
    //    UIImageView *imgWeiMa = [MyControl creatImageViewWithFrame:CGRectMake(20, 55, 40, 20) imageName:@"完善单号_10.png" isCache:YES];
    if (self.text) {
        _txtDanHao = [MyControl creatTextFieldWithFrame:CGRectMake(20, 50, SCREENWIDTH-150, 30) placeHolder:nil delegate:self tag:301];
        _txtDanHao.text=self.text;
    }else{
        _txtDanHao = [MyControl creatTextFieldWithFrame:CGRectMake(20, 50, SCREENWIDTH-150, 30) placeHolder:@"请输入单号" delegate:self tag:301];
    }
    _txtDanHao.keyboardType=UIKeyboardTypeNamePhonePad;
    _txtDanHao.borderStyle = UITextBorderStyleNone;
    UIButton *btnSao = [MyControl creatButtonWithFrame:CGRectMake(SCREENWIDTH-60, 42, 50, 50) target:self sel:@selector(btnTiao:) tag:101 image:@"完善单号_07.png" title:nil];
    
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 30)];
    backView2.backgroundColor = [UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1];
    UILabel *lblDanHao2 = [MyControl creatLabelWithFrame:CGRectMake(10, 5, 100, 20) text:@"请选择快递公司"];
    lblDanHao2.textColor = [UIColor grayColor];
    [backView2 addSubview:lblDanHao2];
    
    //_presentCompany 为传过来的公司的名称
    _presentCompany = [[NSUserDefaults standardUserDefaults]stringForKey:@"logisticsCompanyId"];
    if ([_presentCompany isEqualToString:@"快递兔"]) {
        _presentCompany=@"顺丰快递";
    }
    [self loadWuliuData:_presentCompany];
    
    UIButton *btnQueRenLuRu = [MyControl creatButtonWithFrame:CGRectMake(57, SCREENHEIGHT-113, SCREENWIDTH-114, 36) target:self sel:@selector(btnPush:) tag:901 image:@"" title:@"确认录入"];
    [btnQueRenLuRu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnQueRenLuRu.backgroundColor = [UIColor colorWithRed:251/255.f green:100/255.f blue:9/255.f alpha:1];
    btnQueRenLuRu.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:backView2];
    [self.view addSubview:btnSao];
    [self.view addSubview:_txtDanHao];
    [self.view addSubview:lbl3];
    [self.view addSubview:lbl4];
    [self.view addSubview:lbl2];
    [self.view addSubview:lbl1];
    [self.view addSubview:backView];
    [self.view addSubview:btnQueRenLuRu];
    _filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Info.plist"];
}
//确认的代码
-(void)btnPush:(UIButton *)btn{
    btn.enabled = NO;
    if (_txtDanHao.text.length == 0) {
        [self showAlert:@"单号不能为空" isSure:YES];
        btn.enabled = YES;
        return;
    }
    [btn setTitle:@"正在提交..." forState:UIControlStateNormal];
    _infoArr = [NSMutableArray arrayWithContentsOfFile:_filePath];
    if (_infoArr==nil) {
        _infoArr = [[NSMutableArray alloc] init];
        [_infoArr addObject:_presentCompany];
    }else{
        [_infoArr removeAllObjects];
        [_infoArr addObject:_presentCompany];
    }
    //写入plist文件中
    [_infoArr writeToFile:_filePath atomically:YES];
    AFHTTPClient *client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@" "]];
    NSString *urlPath=[NSString stringWithFormat:CESHIZONG,WANSHANGDINGDAN];
    NSString *expresscompanyId=[[NSUserDefaults standardUserDefaults]valueForKey:@"expresscompanyId"];
    for (int i=0; i<_dataArr.count; i++) {
        NSString *str=_dataArr[i];
        if ([str isEqualToString:_presentCompany]) {
            expresscompanyId = _expressCompanyIdArr[i];
        }
    }
    HUODONGZHISHIQI
    NSString *sign=[Helper addSecurityWithUrlStr:WANSHANGDINGDAN];
    [client postPath:urlPath parameters:@{@"orderId": [[NSUserDefaults standardUserDefaults]stringForKey:@"orderId"],@"expressOrderNo":_txtDanHao.text,@"logisticsCompanyId":expresscompanyId,@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        BOOL isSuccess=[(NSNumber *)dict[@"success"] boolValue];
        btn.enabled = YES;
        [tumblrHUD removeFromSuperview];
        [btn setTitle:@"确认录入" forState:UIControlStateNormal];
        if (isSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
            [self showAlert:@"提交成功" isSure:YES];
            [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
        }else{
            [self showAlert:@"录入失败" isSure:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tumblrHUD removeFromSuperview];
        btn.enabled = YES;
        [btn setTitle:@"确认录入" forState:UIControlStateNormal];
        [self showAlert:@"网络错误" isSure:YES];
    }];
}

-(void)loadWuliuData:(NSString *)str{
    NSString *postPath = [NSString stringWithFormat:CESHIZONG,ALLWULIU];
    NSString *sign=[Helper addSecurityWithUrlStr:ALLWULIU];
    AFHTTPClient *aClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [aClient postPath:postPath parameters:@{@"publicKey":PUBLICKEY,@"sign":sign} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray *arr = res[@"result"];
        for (NSDictionary *dict in arr) {
            [_dataArr addObject:dict[@"name"]];
            [_expressCompanyIdArr addObject:dict[@"id"]];
        }
        _selectView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 130, SCREENWIDTH, SCREENHEIGHT-130-64)];
        _selectView.backgroundColor=[UIColor whiteColor];
        _selectView.contentSize = CGSizeMake(SCREENWIDTH, _dataArr.count*40);
        [self.view addSubview:_selectView];
        
        for (int i=0; i<_dataArr.count; i++) {
            UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(0, 40*i, SCREENWIDTH, 40) target:self sel:@selector(btnCl:) tag:201+i image:@"" title:@""];
            UILabel *lblTitle = [MyControl creatLabelWithFrame:CGRectMake(40, 10, 100, 20) text:_dataArr[i]];
            lblTitle.font = [UIFont systemFontOfSize:20];
            lblTitle.tag = 501+i;
            UIImageView *imgYuan = [MyControl creatImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"img_33_10.png" isCache:YES];
            imgYuan.tag = 601+i;
            UILabel *lblLine = [MyControl creatLabelWithFrame:CGRectMake(0, btn.frame.size.height-1, SCREENWIDTH, 1) text:@""];
            lblLine.backgroundColor = [UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1];
            if (i==0) {
                UIImageView *imgYuan = [MyControl creatImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"img_33_03.png" isCache:YES];
                UILabel *lbl = [MyControl creatLabelWithFrame:CGRectMake(SCREENWIDTH/3*2-40, 13, 100, 15) text:@"选择其他快递公司"];
                UIImageView *imgV = [MyControl creatImageViewWithFrame:CGRectMake(SCREENWIDTH/3*2+60, 15, 20, 10) imageName:@"完善单号_箭头上.png" isCache:YES];
                lbl.font = [UIFont systemFontOfSize:12];
                lbl.textColor = [UIColor grayColor];
                [btn addSubview:imgYuan];
                [btn addSubview:imgV];
                [btn addSubview:lbl];
            }
            [btn addSubview:lblLine];
            [btn addSubview:imgYuan];
            [btn addSubview:lblTitle];
            [_selectView addSubview:btn];
        }
        //先隐藏选择好的界面
        _selectView.hidden = YES;
        for (int i =0; i<_dataArr.count; i++) {
            if ([str isEqualToString:_dataArr[i]]) {
                _presntCount = i;
                break;
            }
        }
        //读上一次快递兔快递员选择的快递类型 进而读取当前需要选择的快递类型
        if (_presntCount==100) {
            
            _last = [NSMutableArray arrayWithContentsOfFile:_filePath][0];
            for (int i =0; i<_dataArr.count; i++) {
                if ([_last isEqualToString:_dataArr[i]]) {
                    _presntCount = i;
                    break;
                }
            }
            if (_last==nil) {//当快递兔快递员第一次进入的时候，给你个默认的提示
                _last = @"请选择公司";
            }
            //快递兔快递员 重新选择公司
            [self reSelectCompany:_last];
        }else{
            //快递公司 重新选择公司
            [self reSelectCompany:_presentCompany];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"----%@",error);
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    }];
}

-(void)reSelectCompany:(NSString *)str{
    for (int i=0; i<_dataArr.count; i++) {
        UIImageView *imgV = (UIImageView *)[self.view viewWithTag:601+i];
        imgV.image = [UIImage imageNamed:@"img_33_10.png"];
    }
    UIImageView *presentImage = (UIImageView *)[self.view viewWithTag:_presntCount+601];
    presentImage.image = [UIImage imageNamed:@"img_33_03.png"];
    
    //再显示选择后的界面
    _selectBeforeView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, SCREENWIDTH, 40)];
    UILabel *lblTitle = [MyControl creatLabelWithFrame:CGRectMake(40, 10, 100, 20) text:str];
    lblTitle.tag =1001;
    lblTitle.font = [UIFont systemFontOfSize:20];
    UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40) target:self sel:@selector(btnShow) tag:801 image:@"" title:@""];
    UIImageView *imgYuan = [MyControl creatImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"img_33_03.png" isCache:YES];
    UILabel *lbl = [MyControl creatLabelWithFrame:CGRectMake(SCREENWIDTH/3*2-40, 13, 100, 15) text:@"选择其他快递公司"];
    UIImageView *imgV = [MyControl creatImageViewWithFrame:CGRectMake(SCREENWIDTH/3*2+60, 15, 20, 10) imageName:@"完善单号_箭头.png" isCache:YES];
    imgV.tag = 1002;
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.textColor = [UIColor grayColor];
    [btn addSubview:lblTitle];
    [btn addSubview:imgYuan];
    [btn addSubview:imgV];
    [btn addSubview:lbl];
    [_selectBeforeView addSubview:btn];
    [self.view addSubview:_selectBeforeView];
}

-(void)btnShow{
    //NSLog(@"show all list");
    [_txtDanHao resignFirstResponder];
    [_selectBeforeView setHidden:YES];
    [_selectView setHidden:NO];
}

//选择当前的公司
-(void)btnCl:(UIButton *)btn{
    //NSLog(@"%d",btn.tag);
    UILabel *lbl = (UILabel *)[self.view viewWithTag:btn.tag-201+501];
    //传值到当前公司
    _presentCompany = lbl.text;
    
    for (int i=0; i<_dataArr.count; i++) {
        UIImageView *imgV = (UIImageView *)[self.view viewWithTag:601+i];
        imgV.image = [UIImage imageNamed:@"img_33_10.png"];
    }
    UIImageView *presentImage = (UIImageView *)[self.view viewWithTag:btn.tag-201+601];
    presentImage.image = [UIImage imageNamed:@"img_33_03.png"];
    [_selectBeforeView setHidden:NO];
    UILabel *lblS = (UILabel *)[self.view viewWithTag:1001];
    lblS.text = _presentCompany;
    [_selectView setHidden:YES];
}
//跳转函数
-(void)btnTiao:(UIButton *)btn{
    btn.enabled=NO;
    self.hidesBottomBarWhenPushed=NO;
    ScanBarViewController *scan=[[ScanBarViewController alloc]init];
    [self.navigationController pushViewController:scan animated:YES];
    btn.enabled=YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_txtDanHao resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtDanHao resignFirstResponder];
    return YES;
}

-(void)getBack{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    
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
