//
//  ShenHeTiJiao_DanHao.h
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/16.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ParentVC.h"
#import "ScanOrderVC.h"

@protocol hidenScanBtn <NSObject>

-(void)hidenScanBtnFromScanView;

@end

@interface ShenHeTiJiao_DanHao : ParentVC<transStringAndIndex>
@property (nonatomic,assign) id<hidenScanBtn> delegate;

@end
