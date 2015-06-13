//
//  OrderDetailViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-11-28.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KuaiDiModel.h"

@interface OrderDetailViewController : UIViewController
- (IBAction)btnClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *eneteringButton;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;//基础订单号

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendPhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *receiveAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *receivePhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *distensLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@property (nonatomic,strong) KuaiDiModel *model;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *addressBackView;

@property (weak, nonatomic) IBOutlet UIImageView *grayView;

@property (weak, nonatomic) IBOutlet UIImageView *grayView1;


@end
