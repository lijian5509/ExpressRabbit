//
//  KuaiDiModel.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-12-2.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "FatherModel.h"

@interface KuaiDiModel : FatherModel

@property (nonatomic,copy)NSNumber *id;
@property (nonatomic,copy)NSString *orderNo;//小订单号
@property (nonatomic,copy)NSString *orderStatus;//订单状态
@property (nonatomic,copy)NSString *fromProvinceName;//来自哪个省份
@property (nonatomic,copy)NSString *fromCityName;//城市名   其他城市
@property (nonatomic,copy)NSString *fromDistrictName;//区域名   //不限
@property (nonatomic,copy)NSString *fromAddress;//取件地址
@property (nonatomic,copy)NSString *toProvinceName;//发到哪个省份
@property (nonatomic,copy)NSString *toCityName;//至  城市名    其他城市
@property (nonatomic,copy)NSString *toDistrictName;// 至 区域名   不限
@property (nonatomic,copy)NSString *toAddress;//  收件地址
@property (nonatomic,copy)NSString *senderName;//发  姓名
@property (nonatomic,copy)NSString *senderTelephone;// 发 电话
@property (nonatomic,strong)NSNumber *xdDate;// 发日期
@property (nonatomic,copy)NSString *receiverName;// 收 姓名
@property (nonatomic,copy)NSString *receiverTelephone;//收 电话
@property (nonatomic,copy)NSString *netsiteName;//网点名称
@property (nonatomic,strong)NSNumber *readFlag;//是否查看 0 未读 1已读
@property (nonatomic,copy)NSString *content;  //备注 nsnull
@property (nonatomic,copy)NSString *addressLng;//经度
@property (nonatomic,copy)NSString *addressLat;//维度
@property (nonatomic,copy)NSString *expressOrderNo;//快递公司单号
@property (nonatomic,strong)NSDictionary *courier;//快递员信息
@property (nonatomic,strong)NSDictionary *expressCompany;
@property (nonatomic,copy)NSString *baseOrderNo;//基础订单号
@property (nonatomic,strong)NSDictionary *logisticsCompany;//录入单号用


- (BOOL)isStatusNumBiggerThanAnother:(KuaiDiModel *)mdel;

- (BOOL)isTimeNumBiggerThanAnother:(KuaiDiModel *)mdel;
@end
