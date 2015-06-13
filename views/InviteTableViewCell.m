//
//  InviteTableViewCell.m
//  ExpressRabbit
//
//  Created by kuaiditu on 15-3-9.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "InviteTableViewCell.h"

@implementation InviteTableViewCell

- (void)awakeFromNib {
    // Initialization code
    CGRect grayLine = self.grayLine.frame;
    grayLine = CGRectMake(0, 48.5, 320, 0.5);
    self.grayLine.frame = grayLine;
}

- (void)setModel:(InviteModel *)model{
    self.inviteMobile.text =[NSString stringWithFormat:@"邀请:%@",model.invitedMobile];
    self.timeLabel.text = [Helper fullDateStringFromNumberString:[model.createTime stringValue]];
    if ([model.isSuccess boolValue]) {//邀请成功
        NSString *content = @"邀请成功+2元";
        NSAttributedString *string = [content selfFont:15 selfColor:[UIColor darkGrayColor] LightText:@"+2元" LightFont:15 LightColor:[UIColor orangeColor]];
        self.inviteResult.attributedText = string;
    }else{
        self.inviteResult.text = @"邀请已发送";
    }
}
@end
