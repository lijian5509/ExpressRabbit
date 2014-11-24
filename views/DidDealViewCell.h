//
//  DidDealViewCell.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-20.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DidDealViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)btnClicked:(UIButton *)sender;

@end
