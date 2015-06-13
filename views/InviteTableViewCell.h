//
//  InviteTableViewCell.h
//  ExpressRabbit
//
//  Created by kuaiditu on 15-3-9.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteModel.h"

@interface InviteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *inviteMobile;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteResult;

@property (nonatomic,strong) InviteModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *grayLine;

@end
