//
//  FanQRCodeViewController.h
//  QRCode
//
//  Created by 凡向阳 on 15/5/7.
//  Copyright (c) 2015年 未名空间. All rights reserved.
//




/**
 *  二维码扫描
 *  
 *  1.支持iOS7.0+的二维码扫描，相册图片扫描目前只支持iOS8.0+
 *  2.该ViewController支持push,present,并对屏幕进行了适配
 *
 */




#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
/**
 *  扫描的block回调
 *
 *  @param resultSrt 扫描信息
 *  @param isSuccess 是否成功
 *
 *  @return void
 */
typedef void(^ScanResultBlock)(NSString* resultSrt,BOOL isSuccess);


#define iOS7_8_QR [[[UIDevice currentDevice] systemVersion]floatValue]>=7
#define kWidth_QR ([UIScreen mainScreen].bounds.size.width)
#define kHeight_QR ([UIScreen mainScreen].bounds.size.height)
#define kHeight_QRRect 250  //取景框的高度

@interface FanQRCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>
/**
 *  预览层Layer
 */
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
/**
 *  会话session
 */
@property (nonatomic, strong) AVCaptureSession *captureSession;
/**
 *  black回调
 */
@property(nonatomic ,copy)ScanResultBlock scanResultBlock;
#pragma mark - 外部调用方法
/**
 *  扫描二维码的ViewController
 *
 *  @param scanResultBlock scanResultBlock:返回扫描信息+是否成功
 *
 *  @return self
 */
-(instancetype)initWithBlock:(ScanResultBlock)scanResultBlock;

@end
