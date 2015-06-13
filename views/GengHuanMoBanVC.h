//
//  GengHuanMoBanVC.h
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ParentVC.h"
#import "GengHuanCell.h"
#import "GengHuanMoBanBianJiVC.h"

@protocol updateTextViewMessage <NSObject>

-(void)updateMessage:(NSString *)message;

@end

@interface GengHuanMoBanVC : ParentVC<UITableViewDataSource,UITableViewDelegate,transIndexFromCell,RefreshTableViewFromUpdateText>

@property (nonatomic,assign) id<updateTextViewMessage> delegate;

@end
