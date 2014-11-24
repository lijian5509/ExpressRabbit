//
//  HandViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-13.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "HandViewController.h"

@interface HandViewController ()
{
    UIView *_inputView;
}
@end

@implementation HandViewController

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
    [self showUI];
    self.textView.delegate=self;
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"扫描条形码";
    BACKKEYITEM;//返回
    UIButton *right=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 40, 30) target:self sel:@selector(done) tag:102 image:nil title:@"完成"];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:right];;
    self.navigationItem.rightBarButtonItem=rightItem;
    //设置二级键盘
    _inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _inputView.tag=1001;
    _inputView.backgroundColor=[UIColor whiteColor];
    UIButton *figureBtn=[MyControl creatButtonWithFrame:CGRectMake(20, 5, 60, 30) target:self sel:@selector(btnClicked:) tag:201 image:nil title:@"数字"];
    figureBtn.backgroundColor=[UIColor blueColor];
    figureBtn.titleLabel.textColor=[UIColor whiteColor];
    UIButton *letterBtn=[MyControl creatButtonWithFrame:CGRectMake(80, 5, 60, 30) target:self sel:@selector(btnClicked:) tag:202 image:nil title:@"字母"];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 1, 1 });
    letterBtn.layer.borderWidth=1;
    letterBtn.layer.borderColor=borderColorRef;
    figureBtn.layer.borderColor=borderColorRef;
    figureBtn.layer.borderWidth=1;
    letterBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    figureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    UIButton *doneBtn=[MyControl creatButtonWithFrame:CGRectMake(260, 5, 60, 30) target:self sel:@selector(done) tag:203 image:nil title:@"完成"];
     doneBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [_inputView addSubview:letterBtn];
    [_inputView addSubview:figureBtn];
    [_inputView addSubview:doneBtn];
    self.textView.keyboardType=UIKeyboardTypeNumberPad;
    
    self.textView.inputAccessoryView=_inputView;

}
-(void)btnClicked:(UIButton *)btn{

    switch (btn.tag) {
        case 201:
        {
            
            [btn setBackgroundColor:[UIColor blueColor]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIButton *button=(UIButton *)[_inputView viewWithTag:202];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            button.backgroundColor=[UIColor whiteColor];
            [self.textView resignFirstResponder];
            self.textView.keyboardType=UIKeyboardTypeNumberPad;
            [self.textView becomeFirstResponder];
        }
            break;
        case 202:
        {
            [btn setBackgroundColor:[UIColor blueColor]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIButton *button=(UIButton *)[_inputView viewWithTag:201];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            button.backgroundColor=[UIColor whiteColor];
            [self.textView resignFirstResponder];
            self.textView.keyboardType=UIKeyboardTypeDefault;
            [self.textView becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}
-(void)done{
    [self.textView resignFirstResponder];
}
-(void)getBack{
    self.hidesBottomBarWhenPushed=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -实现text代理协议

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.bounds=CGRectMake(0, 150, 320,self.view.bounds.size.height);
    [UIView commitAnimations];
    if ([textField.text isEqualToString:@"请输入单号"]) {
        textField.text=@"";
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.bounds=CGRectMake(0, 0, 320,self.view.bounds.size.height);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
