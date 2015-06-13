//
//  KuaiDiModel.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-12-2.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "KuaiDiModel.h"

@implementation KuaiDiModel

- (BOOL)isStatusNumBiggerThanAnother:(KuaiDiModel*)model{
    return [self.readFlag intValue] > [model.readFlag intValue] ;
}
- (BOOL)isTimeNumBiggerThanAnother:(KuaiDiModel *)mdel{
    
    return [self.xdDate longValue]<[mdel.xdDate longValue];
}

@end
