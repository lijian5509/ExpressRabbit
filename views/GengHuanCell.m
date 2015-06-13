//
//  GengHuanCell.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "GengHuanCell.h"

@implementation GengHuanCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self showUI];
    }
    return self;
}

-(void)showUI{
    self.imgSelect = [MyControl creatImageViewWithFrame:CGRectMake(10, 10, 16, 16) imageName:@"未选择模板" isCache:YES];
    self.lblDetail = [MyControl creatLabelWithFrame:CGRectMake(self.imgSelect.frame.origin.x+self.imgSelect.frame.size.width+10, 10, SCREENWIDTH-(self.imgSelect.frame.origin.x+self.imgSelect.frame.size.width+10+10+9*2+20), 20) text:nil];
    self.lblDetail.font = [UIFont systemFontOfSize:12];
    self.btnUpdate = [MyControl creatButtonWithFrame:CGRectMake(SCREENWIDTH-20-9*2, 0, 20+9*2, 44) target:self sel:@selector(btnSelect:) tag:901 image:nil title:nil];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"修改"];
    NSRange strRange = NSMakeRange(0, str.length);
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    UILabel *lblUpdate = [MyControl creatLabelWithFrame:CGRectMake(0, self.btnUpdate.frame.size.height/2-9/2, 18, 9) text:nil];
    lblUpdate.tag = 1001;
    lblUpdate.textColor = MyColor(38, 128, 254);
    lblUpdate.font = [UIFont systemFontOfSize:9];
    lblUpdate.attributedText = str;
    [self.btnUpdate addSubview:lblUpdate];
    
    [self.contentView addSubview:self.imgSelect];
    [self.contentView addSubview:self.lblDetail];
    [self.contentView addSubview:self.btnUpdate];
}

-(void)btnSelect:(UIButton *)btn{
    NSLog(@"%ld",btn.tag);
    [self.delegate transIndex:btn.tag];
}

-(void)showData:(NSString *)str{
    if (str.length>0) {
        self.lblDetail.text = str;
        //重构详情坐标
        CGRect frameLblDetail = self.lblDetail.frame;
        frameLblDetail.size.height = [Helper textHeightFromString:str width:SCREENWIDTH-(self.imgSelect.frame.origin.x+self.imgSelect.frame.size.width+10+10+9*2+20) fontsize:12];
        self.lblDetail.frame = frameLblDetail;
        //重构图片
        CGRect frameImg = self.imgSelect.frame;
        frameImg.origin.y = (10 + [Helper textHeightFromString:str width:SCREENWIDTH-(self.imgSelect.frame.origin.x+self.imgSelect.frame.size.width+10+10+9*2+20) fontsize:12] +10)/2 - 8;
        self.imgSelect.frame = frameImg;
        //重构修改
        CGRect frameUpdate = self.btnUpdate.frame;
        frameUpdate.size.height = 10 + [Helper textHeightFromString:str width:SCREENWIDTH-(self.imgSelect.frame.origin.x+self.imgSelect.frame.size.width+10+10+9*2+20) fontsize:12] +10;
        self.btnUpdate.frame = frameUpdate;
        
        UILabel *lbl = (UILabel *)[self.btnUpdate viewWithTag:1001];
        CGRect frameLblUpdate = lbl.frame;
        frameLblUpdate.origin.y = frameUpdate.size.height/2 - 9/2;
        lbl.frame = frameLblUpdate;
    }
}

@end
