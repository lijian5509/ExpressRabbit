//
//  ShareViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuanXinViewCell.h"
#import <AddressBookUI/AddressBookUI.h>


@interface ShareViewController : UITableViewController<UITextViewDelegate,AddTextDelegate,ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate>

@end
