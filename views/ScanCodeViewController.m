//
//  ScanCodeViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-13.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomViewController.h"

@interface ScanCodeViewController ()
{
    BOOL _torchIsOn;//闪光灯状态
    ZBarReaderViewController *_readerViewController;
}
@end

@implementation ScanCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _torchIsOn=NO;
    //扫描二维码
    _readerViewController = [ZBarReaderViewController new];
    _readerViewController.readerDelegate = self;
    [_readerViewController.scanner setSymbology: ZBAR_QRCODE
                          config: ZBAR_CFG_ENABLE
                              to: 0];
    _readerViewController.sourceType=UIImagePickerControllerSourceTypeCamera;
    _readerViewController.readerView.zoom = 1.0;
    [self presentViewController:_readerViewController animated:YES completion:nil];
    [self showUI];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"扫描条形码";
    BACKKEYITEM;
}
-(void)getBack{
    self.hidesBottomBarWhenPushed=NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 101://打开闪关灯
        {
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            if ([device hasTorch] && [device hasFlash]){
                
                [device lockForConfiguration:nil];
                if (!_torchIsOn) {//开启
                    [device setTorchMode:AVCaptureTorchModeOn];
                    [device setFlashMode:AVCaptureFlashModeOn];
                    _torchIsOn = YES;;
                } else {//关闭
                    [device setTorchMode:AVCaptureTorchModeOff];
                    [device setFlashMode:AVCaptureFlashModeOff];
                    _torchIsOn = NO;
                }
                [device unlockForConfiguration];
            }
        }
            break;
        case 102://手动输入
        {
            
            
        }
            break;

        case 103://相册
        {
            CustomViewController *cs=[[CustomViewController alloc]initWithBlock:^(NSString *result, BOOL isSucceed) {
                if (isSucceed) {
                    NSLog(@"%@",result);
                }
            }];
            [self presentViewController:cs animated:YES completion:nil];
        }
            break;

            
        default:
            break;
    }
}
//获取图片
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    NSLog(@"%@", info);
    // UIImagePickerControllerOriginalImage 原始图片
    // UIImagePickerControllerEditedImage 编辑后图片
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
       for (symbol in results) {
        NSLog(@"%@",symbol.data);
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photoImageView.image=image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
