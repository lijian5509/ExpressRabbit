//
//  DidDealViewCell.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-20.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "DidDealViewCell.h"

@implementation DidDealViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClicked:(UIButton *)sender {
    [sender setTitle:@"取件" forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@"2_10"] forState:UIControlStateNormal];
}
@end
