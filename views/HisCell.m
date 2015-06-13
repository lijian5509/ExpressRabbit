//
//  HisCell.m
//  历史记录
//
//  Created by 快递兔 on 14-12-2.
//  Copyright (c) 2014年 快递兔. All rights reserved.
//

#import "HisCell.h"

@implementation HisCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    UILabel *lblBack = [MyControl creatLabelWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,20) text:@""];
    lblBack.backgroundColor = [UIColor colorWithRed:233.f/255.0 green:233.f/255.0 blue:233.f/255.0 alpha:1];
    self.imgV = [MyControl creatImageViewWithFrame:CGRectMake(15, 20+5, 15, 15) imageName:@"历史信息_03.png" isCache:YES];
    
    self.lblChengGong = [MyControl creatLabelWithFrame:CGRectMake(35, 20, 100, 30) text:@"发送成功"];
    self.lblChengGong.font=[UIFont systemFontOfSize:14];
    self.lblChengGong.textColor = [UIColor grayColor];
    
    self.lblFaSongShiJian = [MyControl creatLabelWithFrame:CGRectMake(self.contentView.frame.size.width-180, 20, 170, 30) text:@""];
    
    self.lblFaSongShiJian.font=[UIFont systemFontOfSize:12];
    self.lblFaSongShiJian.textAlignment=NSTextAlignmentRight;
    self.lblFaSongShiJian.textColor =[UIColor grayColor];
    
    UILabel *lblBackLine1 = [MyControl creatLabelWithFrame:CGRectMake(0, 20+30, self.contentView.frame.size.width, 1) text:@""];
    lblBackLine1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"虚线_02"]];
    
    self.lblNeiRong = [MyControl creatLabelWithFrame:CGRectMake(15, 20+30+1, self.contentView.frame.size.width-30, 20) text:@""];
    self.lblNeiRong.numberOfLines=0;
    self.lblNeiRong.font=[UIFont systemFontOfSize:13];
    self.lblNeiRong.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblBackLine2 = [MyControl creatLabelWithFrame:CGRectMake(0, 20+20+1+30, self.contentView.frame.size.width, 1) text:@""];
    self.lblBackLine2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"虚线_02"]];
    
    self.lblDianHua = [MyControl creatLabelWithFrame:CGRectMake(15, 20+20+1+30+1, self.contentView.frame.size.width-30, 20) text:@""];
    
    self.lblDianHua.numberOfLines=0;
    self.lblDianHua.font=[UIFont systemFontOfSize:13];
    self.lblDianHua.lineBreakMode = NSLineBreakByCharWrapping;
    self.lblDianHua.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.lblNeiRong];
    [self.contentView addSubview:self.lblDianHua];
    [self.contentView addSubview:self.lblFaSongShiJian];
    [self.contentView addSubview:self.lblChengGong];
    [self.contentView addSubview:self.imgV];
    [self.contentView addSubview:lblBackLine1];
    [self.contentView addSubview:self.lblBackLine2];
    [self.contentView addSubview:lblBack];
}

-(void)showData:(HistoryModel *)model{
    if (model) {
        if([model.problemStatus boolValue]){//短信发送失败
            
            self.imgV.image=[UIImage imageNamed:@"发送短信_03"];
            self.lblChengGong.text=@"发送失败";
        }else{
            self.imgV.image=[UIImage imageNamed:@"历史信息_03"];
            self.lblChengGong.text=@"发送成功" ;
        }
        
        self.lblFaSongShiJian.text= [NSString stringWithFormat:@"发送时间:%@",[Helper dateStringFromNumberString:[model.createTime stringValue]]];
        self.lblNeiRong.text =[NSString stringWithFormat:@"%@",model.smsContent];
        self.lblDianHua.text = [NSString stringWithFormat:@"发送至:%@",[Helper phoneFromSendTelphone:model.sendTelephone]];
        //计算坐标
        CGRect lbltext = CGRectMake(15, 20+30+1, self.contentView.frame.size.width-30, 20);
        lbltext.size.height = [Helper textHeightFromString:self.lblNeiRong.text width:self.contentView.frame.size.width-30 fontsize:13];
        if (lbltext.size.height<20) {
            lbltext.size.height=20;
        }
        self.lblNeiRong.frame = lbltext;
        self.lblNeiRong.lineBreakMode = NSLineBreakByCharWrapping;
        CGFloat lblLength = lbltext.origin.y +lbltext.size.height;
        
        CGRect lblLine2 = self.lblBackLine2.frame;
        lblLine2.origin.y =lblLength;
        self.lblBackLine2.frame = lblLine2;
        CGRect lblDianHua2 = self.lblDianHua.frame;
        lblDianHua2.origin.y = 1 + lblLength;
        lblDianHua2.size.height = [Helper textHeightFromString:self.lblDianHua.text width:self.contentView.frame.size.width-30 fontsize:13];
        if (lblDianHua2.size.height<20) {
            lblDianHua2.size.height=20;
        }
        self.lblDianHua.frame =lblDianHua2;
        
    }
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
