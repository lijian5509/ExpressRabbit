//
//  KuaiDiViewCell.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-13.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "KuaiDiViewCell.h"

@implementation KuaiDiViewCell

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
