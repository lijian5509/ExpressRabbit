//
//  TradeDetailViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-24.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceModel.h"

@interface TradeDetailViewController : UIViewController

@property (nonatomic, copy) BalanceModel *model;

@property (weak, nonatomic) IBOutlet UILabel *serailLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end
