//
//  BalanceViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-24.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

//NSMutableArray *_dataArray;
//BOOL _isRefreshing;
//NSInteger _currenPage;
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)NSInteger currenPage;
@property (nonatomic,strong)NSMutableArray *dataArray;
//创建刷新
-(void)creatRefresh;
//解析数据
-(void)downloadSuccessWith:(id)responseObject;
//结束刷新
-(void)endRefreshing;
@property (nonatomic,retain)UITableView *tableview;

@end
