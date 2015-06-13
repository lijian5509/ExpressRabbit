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
-(void)setModel:(KuaiDiModel *)model{
    if ([model.fromCityName isEqualToString:@"其他城市"]) {
        model.fromCityName=@"";
    }
    if ([model.fromDistrictName isEqualToString:@"不限"]) {
        model.fromDistrictName=@"";
    }
#pragma mark - 修改
    self.addressLabel.text=[NSString stringWithFormat:@"%@%@",model.fromDistrictName,model.fromAddress];
    self.phoneLabel.text=model.senderTelephone;
    self.timeLabel.text=[Helper dateStringFromNumberString:[model.xdDate stringValue]];
    
}


@end
