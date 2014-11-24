//
//  LJFScollerViewController.h
//  英雄联盟
//
//  Created by qianfeng on 14-9-28.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJFScollerViewController : UIViewController

-(id)initWithViewControllers:(NSArray *)controllers withTitle:(NSArray *)titles;
@property(nonatomic)NSInteger currentIndex;
@end
