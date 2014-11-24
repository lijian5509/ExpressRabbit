//
//  ScanCodeViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-13.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ScanCodeViewController : UIViewController<ZBarReaderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
- (IBAction)btnClicked:(UIButton *)sender;

@end
