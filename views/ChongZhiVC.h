//
//  ChongZhiVC.h
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ParentVC.h"
#import "ZhiFuModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
@interface ChongZhiVC : ParentVC

@property (nonatomic,copy) NSString *strMobile;
@property (nonatomic,copy) NSString *strName;
@property (nonatomic,assign) NSInteger duanXinShengYu;

@end
