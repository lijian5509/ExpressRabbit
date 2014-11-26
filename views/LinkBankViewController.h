//
//  LinkBankViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-25.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkBankViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNameTextField;
- (IBAction)btnClicked:(UIButton *)sender;

@end
