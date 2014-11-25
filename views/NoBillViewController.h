//
//  NoBillViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-25.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoBillViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
- (IBAction)btnClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *cashLabel;

@end
