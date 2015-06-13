//
//  GeRenTableViewCell.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "GeRenTableViewCell.h"

@implementation GeRenTableViewCell

- (void)awakeFromNib
{
    CGRect frame=self.lineView.frame;
    frame.size.height=0.5;
    self.lineView.frame=frame;
    [self.contentView bringSubviewToFront:self.lineView];
}

@end
