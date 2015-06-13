//
//  KuaiDiViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-12-2.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"


@interface KuaiDiViewController : UITableViewController

@property(nonatomic,strong)NSMutableArray *dataArray;//数据源数组
@property(nonatomic)BOOL isRefreshing;//记录刷新状态
@property(nonatomic,strong)UIImageView *backView;//没有订单数为空时显示

@property(nonatomic)NSInteger page;//当前页码  1为首页
@property(nonatomic,copy)NSString *orderStatus;//订单状态



- (void)requetUrlForData;//请求数据
- (void)refreshingData;//刷新数据
- (void)endRefreshing;//结束刷新
- (void)downloadDataSuccess:(id)resultData;//下载成功解析数据


@end
