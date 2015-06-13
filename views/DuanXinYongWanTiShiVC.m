//
//  DuanXinYongWanTiShiVC.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/17.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "DuanXinYongWanTiShiVC.h"

@implementation DuanXinYongWanTiShiVC
{
    UIView *_backView;
    NSArray *_arrShouMing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUI];
}

-(void)showUI{
    //父视图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _backView.backgroundColor = [UIColor colorWithRed:100/255.f green:100/255.f blue:100/255.f alpha:0.5];
    [self.view addSubview:_backView];
    //白色子视图
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(15, 15+25+30, SCREENWIDTH-30, 200)];
    whiteView.backgroundColor = MyColor(242, 242, 242);
    whiteView.layer.cornerRadius = 4;
    whiteView.layer.masksToBounds = YES;
    [_backView addSubview:whiteView];
    //短信已用完
    UILabel *lblTitle = [MyControl creatLabelWithFrame:CGRectMake(0, 30, whiteView.frame.size.width, 18) text:@"短信已用完"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont systemFontOfSize:18];
    [whiteView addSubview:lblTitle];
    if (self.caseFromMessage == 1) {
        _arrShouMing = @[@"您今天的免费短信已用完",@"立即充值,最低5分钱一条"];
    }else if(self.caseFromMessage ==2){
        _arrShouMing = @[@"未充值,免费短信用完",@"立即充值最低5分钱一条"];
    }
    for (int i = 0; i<_arrShouMing.count; i++) {
        UILabel *lblShouMing = [MyControl creatLabelWithFrame:CGRectMake(15, lblTitle.frame.origin.y+lblTitle.frame.size.height+15+(12+7)*i, whiteView.frame.size.width-30, 12) text:_arrShouMing[i]];
        lblShouMing.font = [UIFont systemFontOfSize:12];
        lblShouMing.textAlignment = NSTextAlignmentCenter;
        lblShouMing.tag = 201+i;
        lblShouMing.textColor = MyColor(150, 150, 150);
        [whiteView addSubview:lblShouMing];
    }
    //取消和充值
    UILabel *lblUnder = (UILabel *)[whiteView viewWithTag:201+_arrShouMing.count-1];
    CGFloat buttonWidth = (whiteView.frame.size.width - 15*3)/2;
    NSArray *arrTitle= @[@"取消",@"立即充值"];
    for (int i =0; i<2; i++) {
        UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(15+(buttonWidth +15)*i, lblUnder.frame.origin.y+lblUnder.frame.size.height+15, buttonWidth, 40) target:self sel:@selector(btnCancelOrPay:) tag:301+i image:nil title:arrTitle[i]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        if (i==0) {
            btn.backgroundColor = MyColor(150, 150, 150);
        }else{
            btn.backgroundColor = MyColor(255, 78, 9);
        }
        [whiteView addSubview:btn];
    }
    //重构底部View
    UIButton *btnUnder = (UIButton *)[self.view viewWithTag:301];
    CGRect backWhiteView = whiteView.frame;
    backWhiteView.size.height = btnUnder.frame.origin.y+ btnUnder.frame.size.height + 15;
    whiteView.frame = backWhiteView;
}

-(void)btnCancelOrPay:(UIButton *)btn{
    switch (btn.tag) {
        case 301:
        {
            self.view.hidden = YES;
        }
            break;
        case 302:
        {
            [self.delegate payMessage];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
