//
//  ParentVC.h
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTumblrHud.h"
@interface ParentVC : UIViewController
{
    //加载动画
    AMTumblrHud *_tumblrHUD;
}
//创建导航条的标题
-(void)addTitile:(NSString *)title;

//创建导航栏的左的按钮
-(void)addBarButtonItemWithNormalimageName:(NSString *)imageNameN target:(id)target action:(SEL)action;

//创建导航栏的左右按钮
-(void)addBarButtonItemWithNormalimageName:(NSString *)imageNameN target:(id)target action:(SEL)action isLeft:(BOOL)isLeft andTitle:(NSString *)title andTitleWidth:(CGFloat)width;
//警示框
- (void)showAlert:(NSString *) _message isSure:(BOOL)sure;
//获取加载动画
-(void)addAnimation;
//结束加载动画
-(void)stopAnimation;
@end
