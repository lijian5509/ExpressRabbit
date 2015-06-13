//
//  EditBankCardViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-26.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBankCardViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumFiled;
- (IBAction)btnClicked:(UIButton *)sender;

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *lineView1;

@property (weak, nonatomic) IBOutlet UIImageView *lineView2;
@property (weak, nonatomic) IBOutlet UIImageView *lineView3;

@end
