//
//  FanQRCodeViewController.m
//  QRCode
//
//  Created by Fan on 15/5/7.
//  Copyright (c) 2015年 未名空间. All rights reserved.
//

#import "FanQRCodeViewController.h"

@interface FanQRCodeViewController ()

@end

@implementation FanQRCodeViewController
{
    UIImageView*_line;
}

-(instancetype)initWithBlock:(ScanResultBlock)scanResultBlock{
    if (self=[super init]) {
        self.scanResultBlock=scanResultBlock;
    }
    return self;
}
#pragma mark - 横屏，设置
//取消了横屏，原本横屏适配了，但是有时又不起作用，故强制不能横屏
-(BOOL)shouldAutorotate{
    return NO;
}
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
#pragma mark - 界面导航的显示与隐藏（兼容带导航的）
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar performSelector:@selector(setHidden:) withObject:nil]) {
        self.navigationController.navigationBar.hidden=YES;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.navigationController.navigationBar performSelector:@selector(setHidden:) withObject:nil]) {
        self.navigationController.navigationBar.hidden=NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //相机界面的定制在self.view上加载即可
    BOOL Custom= [UIImagePickerController
                  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断摄像头是否能用
    if (Custom) {
        [self initCapture];//启动摄像头
        [self createView];
    }else{
        [self showAlertWithMessage:@"摄像头不能启动\n请检查或重试 " taget:100];
    }
        // Do any additional setup after loading the view.
}
#pragma mark - 创建UI
-(void)createView{
    self.view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    //self.view.backgroundColor=[UIColor redColor];
    
    //取景框
    UIImage*image= [UIImage imageNamed:@"qrcode_scan_bg_Green_fan.png"];
    UIImageView*bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake((kWidth_QR-kHeight_QRRect)/2, 100, kHeight_QRRect, kHeight_QRRect)];
    bgImageView.contentMode=UIViewContentModeTop;
    bgImageView.clipsToBounds=YES;
    
    bgImageView.image=image;
    bgImageView.userInteractionEnabled=YES;
    [self.view addSubview:bgImageView];
    
    bgImageView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100+kHeight_QRRect, kWidth_QR, 30)];
    label.text = @"将取景框对准二维码，即可自动扫描。";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    label.font=[UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    label.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kHeight_QRRect, 2)];
    _line.image = [UIImage imageNamed:@"qrcode_scan_light_green_fan.png"];
    [bgImageView addSubview:_line];
    
    _line.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //加动画,别忘记移除
     [_line.layer addAnimation:[self fan_rockWithTime:1 fromY:0 toY:kHeight_QRRect repeatCount:INT_MAX] forKey:@"rock.Y"];
    //下方相册
    UIImageView*scanImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight_QR-100, kWidth_QR, 100)];
    scanImageView.image=[UIImage imageNamed:@"qrcode_scan_bar_fan.png"];
    scanImageView.userInteractionEnabled=YES;
    [self.view addSubview:scanImageView];
    NSArray*unSelectImageNames=@[@"qrcode_scan_btn_photo_nor_fan.png",@"qrcode_scan_btn_flash_nor_fan.png",@"qrcode_scan_btn_myqrcode_nor_fan.png"];
    NSArray*selectImageNames=@[@"qrcode_scan_btn_photo_down_fan.png",@"qrcode_scan_btn_flash_down_fan.png",@"qrcode_scan_btn_myqrcode_down_fan.png"];
    
    for (int i=0; i<unSelectImageNames.count; i++) {
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:unSelectImageNames[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImageNames[i]] forState:UIControlStateHighlighted];
        button.frame=CGRectMake(kWidth_QR/3*i, 0, kWidth_QR/3, 100);
        [scanImageView addSubview:button];
        if (i==0) {
            [button addTarget:self action:@selector(pressPhotoLibraryButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i==1) {
            [button addTarget:self action:@selector(flashLightClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i==2) {
//            button.hidden=NO;
//            NSLog(@"这里是我的二维码，当项目需要时可以增加回调");
            [button addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        button.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    scanImageView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    //假导航
    UIImageView*navImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth_QR, 64)];
    navImageView.image=[UIImage imageNamed:@"qrcode_scan_bar_fan.png"];
    navImageView.userInteractionEnabled=YES;
    [self.view addSubview:navImageView];
  
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50,20 , kWidth_QR-100, 44)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    titleLabel.text=@"扫一扫";
    [navImageView addSubview:titleLabel];
    
    
    navImageView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_pressed_fan.png"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor_fan.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(10,20, 44, 44)];
    [button addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}
#pragma mark 开启相机
- (void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    // 摄像头设备
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 设置输入口
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if (error || !captureInput) {
        NSLog(@"error: %@", [error description]);
        return;
    }
    // 会话session, 把输入口加入会话
    [self.captureSession addInput:captureInput];

    if (iOS7_8_QR) {
        // 设置输出口，加入session, 设置输出口参数
        AVCaptureMetadataOutput*_output=[[AVCaptureMetadataOutput alloc]init];
        // 使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        [self.captureSession addOutput:_output];
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
        if (!self.captureVideoPreviewLayer) {
            // 设置预览层信息
            self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
        self.captureVideoPreviewLayer.frame = self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //添加至视图
        [self.view.layer addSublayer: self.captureVideoPreviewLayer];
        [self.captureSession startRunning];
    }else{
        // 设置输出口，加入session, 设置输出口参数
        AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        captureOutput.alwaysDiscardsLateVideoFrames = YES;
        [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [captureOutput setVideoSettings:videoSettings];
        [self.captureSession addOutput:captureOutput];
        
        NSString* preset = 0;
        if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
            [UIScreen mainScreen].scale > 1 &&
            [inputDevice
             supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
                // NSLog(@"960");
                preset = AVCaptureSessionPresetiFrame960x540;
            }
        if (!preset) {
            // NSLog(@"MED");
            preset = AVCaptureSessionPresetMedium;
        }
        self.captureSession.sessionPreset = preset;
        
        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
        self.captureVideoPreviewLayer.frame = self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer: self.captureVideoPreviewLayer];
        
        //self.isScanning = YES;
        [self.captureSession startRunning];
        //'self.view.backgroundColor=[UIColor redColor];
    }
}
#pragma mark - 开启关闭闪光灯
-(void)flashLightClick:(UIButton *)btn{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.torchMode==AVCaptureTorchModeOff) {
        //闪光灯开启
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
    }else {
        //闪光灯关闭
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    
}
#pragma mark 选择相册
-(void)cameraClick:(UIButton *)button{
    [_line.layer removeAnimationForKey:@"rock.Y"];
    _line.frame = CGRectMake(0, 0, kHeight_QRRect, 2);
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
        [self.captureSession stopRunning];
    }];
}
- (void)pressPhotoLibraryButton:(UIButton *)button{
    [_line.layer removeAnimationForKey:@"rock.Y"];
    _line.frame = CGRectMake(0, 0, kHeight_QRRect, 2);
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{
        [self.captureSession stopRunning];
    }];
}
#pragma mark 点击导航取消,返回界面
- (void)pressCancelButton:(UIButton *)button
{
    //self.isScanning = NO;
    [self.captureSession stopRunning];
    [self.captureVideoPreviewLayer removeFromSuperlayer];
    self.scanResultBlock(@"界面返回",NO);
    [_line.layer removeAnimationForKey:@"rock.Y"];
    _line.frame = CGRectMake(0, 0, kHeight_QRRect, 2);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_line.layer removeAnimationForKey:@"rock.Y"];
    _line.frame = CGRectMake(0, 0, kHeight_QRRect, 2);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{
        [self fan_decodeImage_8_0:image];
    }];
    NSLog(@"开始解析图片");
}
//相册关闭
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"相册关闭");
    [_line.layer addAnimation:[self fan_rockWithTime:1 fromY:0 toY:kHeight_QRRect repeatCount:INT_MAX] forKey:@"rock.Y"];
    _line.frame = CGRectMake(0, 0, kHeight_QRRect, 2);
    [self dismissViewControllerAnimated:YES completion:^{
        [self.captureSession startRunning];
    }];
}
#pragma mark - ios7一下扫描的图片的转化
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    
    return image;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate_iOS6-触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
//    NSLog(captureOutput)
    [self fan_decodeImage_8_0:image];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate//iOS7_8_QR下触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        self.scanResultBlock(metadataObject.stringValue,YES);
    }
    
    [self.captureSession stopRunning];
    [_line.layer removeAnimationForKey:@"rock.Y"];
    _line.frame = CGRectMake(0, 0, kHeight_QRRect, 2);
    NSLog(@"扫描解析成功");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 对图像进行解码
- (void)fan_decodeImage_8_0:(UIImage *)image
{
    if ([[[UIDevice currentDevice] systemVersion]floatValue]<8.0) {
        [self showAlertWithMessage:@"您的手机系统不支持该功能，请升级到iOS8！"];
        return;
    }
    CIImage *ciImage=[CIImage imageWithCGImage:image.CGImage];
    CIDetector *detector=[CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features=[detector featuresInImage:ciImage];
    for (CIFeature * qrFeature in features) {
        if ([qrFeature isKindOfClass:[CIQRCodeFeature class]]) {
            CIQRCodeFeature *qrf=(CIQRCodeFeature *)qrFeature;
           // NSLog(@"------%@--------",qrf.messageString);
            
            [self.captureSession stopRunning];
            [_line.layer removeAnimationForKey:@"rock.Y"];
            _line.frame = CGRectMake(0, 0, kHeight_QRRect, 2);
            self.scanResultBlock(qrf.messageString,YES);
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
    }
    self.scanResultBlock(@"解析失败",NO);
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 其他
//根据不同的提示信息，创建警告框
-(void)showAlertWithMessage:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
//根据不同的提示信息，创建警告框
-(void)showAlertWithMessage:(NSString *)message taget:(NSInteger)taget{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alert.tag=100;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - 上下晃动的动画
-(CABasicAnimation *)fan_rockWithTime:(float)time fromY:(float)fromY toY:(float)toY repeatCount:(int)repeatCount
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animation setFromValue:[NSNumber numberWithFloat:fromY]];
    animation.toValue=[NSNumber numberWithFloat:toY];
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    
    animation.repeatCount=repeatCount;//动画重复次数
    animation.autoreverses=YES;//是否自动重复
    
    return animation;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
