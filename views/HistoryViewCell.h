//
//  HistoryViewCell.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-14.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *litterImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineView;


@end
