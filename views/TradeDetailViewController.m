//
//  TradeDetailViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-24.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "TradeDetailViewController.h"

@interface TradeDetailViewController ()

@end

@implementation TradeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.model=[[BalanceModel alloc]init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
    [self giveData];

}

#pragma mark - 显示界面
-(void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsLandscapePhone];
    self.title=@"交易详情";
    BACKKEYITEM
    
    self.moneyLabel.textColor=[UIColor colorWithRed:0 green:153/255.f blue:0 alpha:1];
}
//返回键
-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -赋值

-(void)giveData{
    BalanceModel *model=[[BalanceModel alloc]init];
    model=self.model;
    
    NSLog(@"%@",self.model);
    self.serailLabel.text=model.serialNumber;
    if ([model.processStatus intValue]==0) {
        self.statusLabel.text=@"处理中";
    }else if ([model.processStatus intValue]==1){
        self.statusLabel.text=@"失败";
    }else{
        self.statusLabel.text=@"成功";
    }
    
    if ([model.processType intValue]==0) {
        self.typeLabel.text=@"提现";
        self.moneyLabel.text=[NSString stringWithFormat:@"-%.2f",[model.dealMoney floatValue]];
        self.moneyLabel.textColor=[UIColor orangeColor];
    }else{
        self.typeLabel.text=@"转入";
        self.moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[model.dealMoney floatValue]];
        self.moneyLabel.textColor=[UIColor colorWithRed:0 green:153/255.f blue:0 alpha:1];
    }
    self.balanceLabel.text=[NSString stringWithFormat:@"%.2f",[model.balance floatValue]];
    self.timeLabel.text=[Helper dateStringFromNumberString:[model.createTime stringValue]];
    if ((id)model.baseOrderNo ==[NSNull null]) {
        self.orderLabel.text = [model.baseOrderNo stringValue];
    }else{
        self.orderLabel.text=@"无";
    }
    self.detailLabel.text=model.detail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
