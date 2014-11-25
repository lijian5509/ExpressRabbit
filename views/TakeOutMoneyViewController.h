//
//  TakeOutMoneyViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeOutMoneyViewController : UIViewController<UITextFieldDelegate>
- (IBAction)btnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *moneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IdLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (nonatomic, copy) NSMutableArray *dataArray;




@end
