//
//  TabBarViewController.h
//  快递兔-终
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController

+(TabBarViewController *)shareTabBar;

-(void)creatSystemBar;

@property(nonatomic,strong) UIImageView *TabImageView;


@end
