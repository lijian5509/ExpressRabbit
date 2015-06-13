//
//  HandWriteViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-12-1.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandWriteViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *_txtDanHao;
}

@property(nonatomic,copy)NSString *text;
@end
