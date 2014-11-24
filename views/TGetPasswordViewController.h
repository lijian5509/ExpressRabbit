//
//  TGetPasswordViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-18.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TGetPasswordViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *smallTopView;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordText;
- (IBAction)btnClicked:(UIButton *)sender;

@end
