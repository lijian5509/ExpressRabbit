//
//  CustomViewController.h
//  ZXingDemo
//
//  Created by zhangcheng on 13-3-27.
//  Copyright (c) 2013年 zhangcheng All rights reserved.
//
/*
版本说明
ZC封装的ZBar二维码SDK~1.1版本
 增加block回调，取消代理
ZC封装的ZBar二维码SDK~1.0版本初始建立
 
二维码编译顺序
Zbar编译
 需要添加AVFoundation  CoreMedia  CoreVideo QuartzCore libiconv

新增iOS7适配
 
 生成二维码
 拖拽libqrencode包进入工程，注意点copy
 添加头文件#import "QRCodeGenerator.h"
 imageView.image=[QRCodeGenerator qrImageForString:@"这个是什么" imageSize:imageView.bounds.size.width];
 */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderController.h"

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7
@class CustomViewController;

@protocol CustomViewControllerDelegate <NSObject>

@optional
- (void)customViewController:(CustomViewController *)controller didScanResult:(NSString *)result;
- (void)customViewControllerDidCancel:(CustomViewController *)controller;

@end

@interface CustomViewController : UIViewController <UIAlertViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,ZBarReaderDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) id<CustomViewControllerDelegate> delegate;

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, assign) BOOL isScanning;

@property (nonatomic,copy)void(^ScanResult)(NSString*result,BOOL isSucceed);
//初始化函数
-(id)initWithBlock:(void(^)(NSString*,BOOL))a;

//正则表达式对扫描结果筛选
+(NSString*)zhengze:(NSString*)str;
@end
