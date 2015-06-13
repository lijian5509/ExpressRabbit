//
//  FixBankCheckViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-26.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixBankCheckViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)btnClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *smallTitleView;

@property(nonatomic,retain)NSMutableArray *dataArray;

@property(nonatomic)NSInteger count;//参数有值  代表提交新的银行卡

@end
