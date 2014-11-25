//
//  NoBillViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-25.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "NoBillViewController.h"

@interface NoBillViewController ()

@end

@implementation NoBillViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
        {
            ShareViewController *share=[[ShareViewController alloc]init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:share animated:YES];
        }
            break;
        case 102:
        {
            [self showAlertViewWithMaessage:@"您的余额为零" title:@"提示" otherBtn:nil];
        }
            break;

        default:
            break;
    }
}
//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btnT, nil];
    [alert show];
}

@end
