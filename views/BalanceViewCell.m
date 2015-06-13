//
//  BalanceViewCell.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-24.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "BalanceViewCell.h"

@implementation BalanceViewCell

- (void)awakeFromNib
{

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BalanceModel *)model{
    if ([model.processType intValue]==0) {//提现
        if ([model.processStatus intValue]==0) {//流转状态  0处理中 1失败 2成功
            self.resultLabel.text=@"处理中";
        }else if ([model.processStatus intValue]==1){
            self.resultLabel.text=@"提现失败";
        }else{
            self.resultLabel.text=@"提现成功";
        }
        self.moneyLabel.text=[NSString stringWithFormat:@"-%@", [model.dealMoney stringValue]];
        self.moneyLabel.textColor=[UIColor orangeColor];
    }else{
        if ([model.processStatus intValue]==0) {//流转状态  0处理中 1失败 2成功
            self.resultLabel.text=@"处理中";
        }else if ([model.processStatus intValue]==1){
            self.resultLabel.text=@"转入失败";
        }else{
            self.resultLabel.text=@"转入成功";
        }
        self.moneyLabel.text=[NSString stringWithFormat:@"+%@", [model.dealMoney stringValue]];
        self.moneyLabel.textColor=[UIColor cyanColor];
        self.moneyLabel.textColor=[UIColor colorWithRed:0 green:153/255.f blue:0 alpha:1];
    }
    self.timeLabel.text=[Helper dateStringFromNumberString:[model.createTime stringValue]];
    self.balanceLabel.text=[NSString stringWithFormat:@"余额:%@",[model.balance stringValue]];
    

}

@end
