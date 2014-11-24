//
//  BalanceViewCell.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-24.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceModel.h"


@interface BalanceViewCell : UITableViewCell
//消息结果 转入，转出
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
//交易金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//交易时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//剩余余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (nonatomic,copy)BalanceModel *model;


@end
