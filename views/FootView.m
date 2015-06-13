//
//  footView.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-14.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "FootView.h"

@implementation FootView

- (void)awakeFromNib{
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 4;
}

@end
