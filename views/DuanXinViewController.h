//
//  DuanXinViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuanXinViewCell.h"

@interface DuanXinViewController : UITableViewController<UITextViewDelegate,AddTextDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UILabel *wordLabel;
@property (nonatomic,strong)UILabel *messageLabel;


@end
