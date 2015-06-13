//
//  MessageCheckViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCheckViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
- (IBAction)btnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *smallTitleView;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (nonatomic, copy) NSString *cashNum;

@property (nonatomic, retain)NSMutableArray *dataArray;



@end
