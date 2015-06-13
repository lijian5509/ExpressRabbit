//
//  ScanBarViewController.m
//  ExpressRabbit
//
//  Created by kuaiditu on 14-12-8.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "ScanBarViewController.h"
#import "HandWriteViewController.h"

@implementation ScanBarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"扫码"];
    [self setupCamera];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"扫码"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self showUI];
    BACKKEYITEM
    self.view.backgroundColor = [UIColor grayColor];
    [self showTiShi];
}
#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.title=@"扫描条形码";
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
}

-(void)showTiShi{
    //白框
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, 300)];
    imageView.image = [UIImage imageNamed:@"摄像头白框.png"];
    [self.view addSubview:imageView];
    //红线
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 260, 2)];
    _line.image = [UIImage imageNamed:@"红线.png"];
    [self.view addSubview:_line];
    //提示
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(10, 0+300, self.view.frame.size.width-10, 30)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.text=@"小贴士:请把条形码摆放在屏幕中间位置";
    [self.view addSubview:labIntroudction];
    //设置定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [self createButtonShenXingAndShanGuang];
}

-(void)createButtonShenXingAndShanGuang{
    //黑色背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height-40-64, self.view.frame.size.width-200, 40)];
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    //按钮
    NSArray *arr = @[@"打开摄像头_03.png",@"打开摄像头_04.png"];
    for (int i =0; i<2; i++) {
        UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(i*(self.view.frame.size.width-100), self.view.frame.size.height-40-64, 100, 40) target:self sel:@selector(btnC:) tag:101+i image:arr[i] title:@""];
        [self.view addSubview:btn];
    }
}

-(void)getBack{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

-(void)btnC:(UIButton *)btn{
    switch (btn.tag) {
        case 101://打开闪光灯
        {
            [_device lockForConfiguration:nil];
            
            if (!_isLightOn) {
                [_device setTorchMode:AVCaptureTorchModeOn];
                _isLightOn = YES;
            }else{
                [_device setTorchMode:AVCaptureTorchModeOff];
                _isLightOn = NO;
            }
            [_device unlockForConfiguration];
        }
            break;
        case 102://进入输入框
        {
            [timer invalidate];
            HandWriteViewController *hand=[[HandWriteViewController alloc]init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:hand animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)animation1{
    //计算红线移动的长度
    if (upOrdown == NO ) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 260, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 260, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

- (void)setupCamera{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    NSLog(@"[_session canAddInput:self.input]:%d",[_session canAddInput:self.input]);
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    NSLog(@"[_session canAddOutput:self.output]:%d",[_session canAddOutput:self.output]);
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(20,10,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    //停止扫描
    [_session stopRunning];
    //停止定时器
    [timer invalidate];
    //跳转
    HandWriteViewController *hand=[[HandWriteViewController alloc]init];
    hand.text = stringValue;
    hand.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:hand animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
