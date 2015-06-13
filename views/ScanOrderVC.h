//
//  ScanOrderVC.h
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/17.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ScanBarViewController.h"

@protocol transStringAndIndex <NSObject>

-(void)transStr:(NSString *)str andIndex:(NSInteger)index;

@end

@interface ScanOrderVC : ScanBarViewController

@property (nonatomic,assign) id<transStringAndIndex> delegate;
@property (nonatomic,assign) NSInteger index;

@end
