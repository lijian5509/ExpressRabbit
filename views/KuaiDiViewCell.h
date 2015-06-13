//
//  KuaiDiViewCell.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-13.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KuaiDiModel.h"

@interface KuaiDiViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *goImageView;

@property (weak, nonatomic) IBOutlet UIImageView *promptView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) KuaiDiModel *model;


@end
