//
//  InviteViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 15-3-9.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface InviteViewController : UIViewController<UITextFieldDelegate,UITextFieldDelegate,UIAlertViewDelegate,ABPeoplePickerNavigationControllerDelegate>

- (IBAction)btnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *messagelabel;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,copy) NSString *courierCode;

@end
