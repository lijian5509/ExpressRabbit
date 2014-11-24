//
//  BalanceModel.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-24.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "FatherModel.h"

@interface BalanceModel : FatherModel

@property (nonatomic,copy)NSNumber *createTime;    //交易时间
@property (nonatomic,copy)NSNumber *processStatus; //流转状态  0处理中 1失败 2成功
@property (nonatomic,copy)NSNumber *id;            //用户id
@property (nonatomic,copy)NSString *serialNumber;  //流水单号
@property (nonatomic,copy)NSNumber *processType;   //交易类型  0：提现  1：转入
@property (nonatomic,copy)NSNumber *dealMoney;     //交易金额
@property (nonatomic,copy)NSNumber *balance;       //剩余金额
@property (nonatomic,copy)NSString *detail;        //交易详情
@property (nonatomic,copy)NSNumber *baseOrderNo;   //基础订单号


@end
