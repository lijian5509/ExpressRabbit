//
//  CheckPhoneViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckPhoneViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UIImageView *smallTitleView;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;

- (IBAction)btnClicked:(UIButton *)sender;

@property (nonatomic,copy)NSMutableArray *dataArray;


@end
