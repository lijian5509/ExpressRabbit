//
//  GengHuanMoBanBianJiVC.h
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ParentVC.h"

@protocol RefreshTableViewFromUpdateText <NSObject>

-(void)updateText;

@end

@interface GengHuanMoBanBianJiVC : ParentVC<UITextViewDelegate>

@property (nonatomic,copy) NSString *strUpdateText;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) id<RefreshTableViewFromUpdateText> delegate;

@end
