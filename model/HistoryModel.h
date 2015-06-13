//
//  HistoryModel.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-22.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "FatherModel.h"

@interface HistoryModel : FatherModel

@property (nonatomic,copy) NSString *smsContent;
@property (nonatomic,strong) NSNumber *createTime;
@property (nonatomic,copy) NSString *sendTelephone;
@property (nonatomic,strong) NSNumber *problemStatus;//1 失败 0成功
@property (nonatomic,strong) NSNumber *id;





@end
