//
//  HisCell.h
//  历史记录
//
//  Created by 快递兔 on 14-12-2.
//  Copyright (c) 2014年 快递兔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"
#import "MyControl.h"
#import "Helper.h"
@interface HisCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *lblChengGong;
@property (nonatomic,strong) UILabel *lblFaSongShiJian;
@property (nonatomic,strong) UILabel *lblNeiRong;
@property (nonatomic,strong) UILabel *lblDianHua;
@property (nonatomic,strong) UILabel *lblBackLine2;

-(void)showData:(HistoryModel *)model;

@end
