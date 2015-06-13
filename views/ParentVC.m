//
//  ParentVC.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ParentVC.h"

@implementation ParentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.userInteractionEnabled =YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = 0;
}

-(void)addTitile:(NSString *)title{
    self.title = title;
}

-(void)addBarButtonItemWithNormalimageName:(NSString *)imageNameN target:(id)target action:(SEL)action{
    [self addBarButtonItemWithNormalimageName:imageNameN target:target action:action isLeft:YES andTitle:nil andTitleWidth:0];
}

-(void)addBarButtonItemWithNormalimageName:(NSString *)imageNameN target:(id)target action:(SEL)action isLeft:(BOOL)isLeft andTitle:(NSString *)title andTitleWidth:(CGFloat)width{
    if (isLeft) {
        UIButton *button =[MyControl creatButtonWithFrame:CGRectMake(0, 0, 12, 20) target:target sel:action tag:20001 image:nil title:nil];
        [button setImage:[[UIImage imageNamed:imageNameN] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
    }else{
        UIButton *button =[MyControl creatButtonWithFrame:CGRectMake(0, 0, width, 17) target:target sel:action tag:20002 image:nil title:title];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setImage:[[UIImage imageNamed:imageNameN] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = item;
    }
}

//加入友盟统计
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:self.title];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addAnimation{
    //活动指示器
    [_tumblrHUD removeFromSuperview];
    _tumblrHUD = [[AMTumblrHud alloc] initWithFrame:CGRectMake((CGFloat) ((self.view.frame.size.width - 55) * 0.5),
                                                               (CGFloat) ((self.view.frame.size.height - 20) * 0.5), 55, 20)];
    _tumblrHUD.hudColor = UIColorFromRGB(0x000212);//[UIColor magentaColor];
    [self.view addSubview:_tumblrHUD];
    [_tumblrHUD showAnimated:YES];
}

-(void)stopAnimation{
    [_tumblrHUD removeFromSuperview];
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *) _message isSure:(BOOL)sure{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    if (sure) {
        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:YES];
        
    }
    [promptAlert show];
}
@end
