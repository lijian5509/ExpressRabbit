//
//  DuanXinYongWanTiShiVC.h
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/17.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ParentVC.h"

@protocol goPayFromMessage <NSObject>

-(void)payMessage;

@end

@interface DuanXinYongWanTiShiVC : ParentVC

@property (nonatomic,assign) NSInteger caseFromMessage;
@property (nonatomic,assign) id<goPayFromMessage> delegate;

@end
