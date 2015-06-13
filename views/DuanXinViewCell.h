//
//  DuanXinViewCell.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DuanXinViewCell;

@protocol AddTextDelegate <NSObject>

-(void)addTextField:(DuanXinViewCell *)message;

-(void)removeTextViewWith:(DuanXinViewCell *)message;

@end



@interface DuanXinViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn1;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) id<AddTextDelegate>textDelegate;

- (IBAction)btnClicked:(UIButton *)sender;

@property (strong, nonatomic)  UIView *inputView;

@property(nonatomic ,strong) NSString *phoneText;

@property (nonatomic) BOOL isValid;


@end
