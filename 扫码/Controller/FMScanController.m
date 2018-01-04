//
//  FMScanController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/12/25.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "FMScanController.h"
#import "FMScanView.h"
#import <AVFoundation/AVFoundation.h>
#import "GKChargeController.h"


@interface FMScanController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, assign) CGRect mainRect;
@end

@implementation FMScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fm_navigationBar.hidden = YES;
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.session = [[AVCaptureSession alloc] init];

    
    FMScanView *scanView = [[FMScanView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scanView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"scan_back"] fontSize:10.0f titleColor:nil title:nil];
    backBtn.fm_size = CGSizeMake(70, 100);
    backBtn.fm_leftTop = CGPointMake(0, 0);
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scanView addSubview:backBtn];
    
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeSystem image:[UIImage imageNamed:@"light_off"] fontSize:10.0f titleColor:nil title:nil];
    [lightBtn setImage:[[UIImage imageNamed:@"light_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    lightBtn.fm_size = CGSizeMake(70, 100);
    lightBtn.fm_rightTop = CGPointMake(scanView.fm_width, 0);
    [lightBtn addTarget:self action:@selector(lightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scanView addSubview:lightBtn];
}

//闪光灯切换
-(void)lightBtnAction:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    
    if ([self.device hasTorch]) {
        BOOL locked = [self.device lockForConfiguration:nil];
        if (locked) {
            self.device.torchMode = btn.isSelected?AVCaptureTorchModeOn:AVCaptureTorchModeOff;
            [self.device unlockForConfiguration];
        }
    }
}

-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//扫描线动画
- (void)moveScanLine {
    
    if(self.line == nil){
        self.line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_line"]];
        self.line.hidden = YES;
        [self.view addSubview:self.line];
    }
    
    self.line.fm_top = self.mainRect.origin.y;
    self.line.fm_centerX = ScreenWidth / 2;
    self.line.hidden = NO;
    [UIView animateWithDuration:1.8 animations:^{
        self.line.fm_top = CGRectGetMaxY(self.mainRect)-5;
    } completion:^(BOOL finished) {
        self.line.hidden = YES;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(moveScanLine) userInfo:nil repeats:true];
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-相机”选项中，允许App访问你的相机。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
        [self.timer invalidate];
    }else {
        [self setupCamera];
//        [self moveScanLine];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
    [self.timer invalidate];
    self.timer = nil;
}

//配置摄像头
- (void)setupCamera {
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error != nil) {
        NSLog(@"error===%@",[error description]);
        return;
    }
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    if(self.previewLayer == nil){
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];

    CGRect cropRect = CGRectMake(0.12 * ScreenWidth, (ScreenHeight - 0.76*ScreenWidth) / 2, 0.76 * ScreenWidth, 0.76 * ScreenWidth);
    self.mainRect = cropRect;
    output.rectOfInterest = CGRectMake(cropRect.origin.y / ScreenHeight, cropRect.origin.x / ScreenWidth, cropRect.size.height / ScreenHeight, cropRect.size.width / ScreenWidth);
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    [self.session startRunning];
}

- (void)reStarting {
    [self moveScanLine];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(moveScanLine) userInfo:nil repeats:true];
    [self.session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [self.timer invalidate];
    [self.session stopRunning];
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *meta = (AVMetadataMachineReadableCodeObject *)metadataObjects[0];
        if (meta.stringValue) {
            
            GKChargeController *vc = [[GKChargeController alloc]init];
            vc.device_id = meta.stringValue;
            [self.navigationController pushViewController:vc animated:YES];
            
            NSMutableArray *vcArray =             [self.navigationController.viewControllers mutableCopy];
            [vcArray removeObjectAtIndex:vcArray.count - 2];
            [self.navigationController setViewControllers:vcArray];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
