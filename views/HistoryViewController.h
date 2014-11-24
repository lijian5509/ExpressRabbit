//
//  HistoryViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-14.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UITableViewController
{
    NSMutableArray *_dataArray;
    NSInteger _currentPage;
    BOOL _isRefreshinging;
}
//结束刷新
- (void)endRefreshing;
//创建刷新
- (void)refreshTableview;

@end
