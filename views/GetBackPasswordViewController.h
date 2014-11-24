//
//  GetBackPasswordViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-15.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetBackPasswordViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *testField;

- (IBAction)btnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *smallTopView;
@property (weak, nonatomic) IBOutlet UIButton *yanZhengBtn;

@end
