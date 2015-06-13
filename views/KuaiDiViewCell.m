//
//  KuaiDiViewCell.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-13.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "KuaiDiViewCell.h"

#import "UserLocationManager.h"

@implementation KuaiDiViewCell

- (void)awakeFromNib
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDis) name:@"dis" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setModel:(KuaiDiModel *)model{
    self.goImageView.image=[UIImage imageNamed:@"我的订单_06"];
    self.promptView.hidden=NO;
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
    if ([model.readFlag intValue]==1) {
        self.promptView.hidden=YES;
        self.goImageView.image=[UIImage imageNamed:@"个人中心-设置_08"];
        
    }
    if (model.addressLat==NULL) {
        self.distanceLabel.text=@"无位置信息";
    }else{
        float addressDis=[[UserLocationManager shareManager]getDistanceWithMuDiC1La:[model.addressLat floatValue] andC1Long:[model.addressLng floatValue]];
        self.distanceLabel.text=[NSString stringWithFormat:@"%.2fkm",addressDis/1000];
    }
    
}



@end
