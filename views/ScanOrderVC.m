
//
//  ScanOrderVC.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/17.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "ScanOrderVC.h"

@implementation ScanOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

//重写底部UI
-(void)createButtonShenXingAndShanGuang{
    
}

//重写底部button触发事件
-(void)btnC:(UIButton *)btn{
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if ([metadataObjects count] >0){
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    //停止扫描
    [self.session stopRunning];
    //停止定时器
    [timer invalidate];
    //跳转
    [self.delegate transStr:stringValue andIndex:self.index];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
