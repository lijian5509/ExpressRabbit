//
//  GengHuanCell.h
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol transIndexFromCell <NSObject>

-(void)transIndex:(NSInteger)index;

@end

@interface GengHuanCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgSelect;
@property (nonatomic,strong) UILabel *lblDetail;
@property (nonatomic,strong) UIButton *btnUpdate;
@property (nonatomic,assign) id<transIndexFromCell> delegate;

-(void)showData:(NSString *)str;

@end
