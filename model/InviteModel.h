//
//  InviteModel.h
//  ExpressRabbit
//
//  Created by kuaiditu on 15-3-10.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteModel : FatherModel
@property (nonatomic,copy)NSNumber *id;//邀请记录的id
@property (nonatomic,copy)NSString *invitedMobile;//邀请者的手机号
@property (nonatomic,copy)NSNumber *createTime;//邀请的时间
@property (nonatomic,copy)NSNumber *isSuccess;//邀请是否成功

@end
