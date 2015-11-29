//
//  AppDelegate.m
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/4.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "FanQRCodeViewController.h"
#import "FanWebViewController.h"


@interface AppDelegate ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,WeiboSDKDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#pragma mark - 3D-Touch
    if (iOSVersion>=9) {
        UITraitCollection *traitCollection = [[UITraitCollection alloc]init];
        if (traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            NSLog(@"已经打开了3D Touch功能");
            //[self registerForPreviewingWithDelegate:self sourceView:self.window];
        }else if(traitCollection.forceTouchCapability == UIForceTouchCapabilityUnavailable){
            
            NSLog(@"并没有打开3D Touch功能");
        }else{
            NSLog(@"不知道有没有打开3D Touch功能");
        }
        if([application respondsToSelector:@selector(setShortcutItems:)]){
            //设置3D-Touch
            UIApplicationShortcutItem *item1=[[UIApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"拍照" localizedSubtitle:@"camera" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd] userInfo:nil];
            UIApplicationShortcutItem *item2=[[UIApplicationShortcutItem alloc]initWithType:@"2" localizedTitle:@"扫一扫" localizedSubtitle:@"sweep" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLocation] userInfo:nil];
            
            [application setShortcutItems:@[item1,item2]];
        }
    }
    
    //第三方
    //微信
    [WXApi registerApp:@"wx7ef5fe4d8f7e0a5b"];
    //微博登录key
//    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"2267068098"];
    
    [[FBSDKApplicationDelegate sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions];
    
    [Fabric with:@[[Twitter class]]];

    return YES;
}
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"3D_Item:%@",shortcutItem);
    if ([shortcutItem.type isEqualToString:@"1"]) {
        NSLog(@"拍照");
        //相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            [self loadSourceWithType:UIImagePickerControllerSourceTypeCamera];
            
        }else{
            //ShowMessage(@"相机不可用")
            [self loadSourceWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }else if([shortcutItem.type isEqualToString:@"2"]){
        NSLog(@"扫一扫");
        //相机
        FanQRCodeViewController *qrCoreVC=[[FanQRCodeViewController alloc]initWithBlock:^(NSString *resultSrt, BOOL isSuccess) {
            if (isSuccess) {
                NSLog(@"zbar网址：%@",resultSrt);
                if ([resultSrt hasPrefix:@"http"]) {
                    FanWebViewController *web=[[FanWebViewController alloc]init];
                    web.zbarUrl=resultSrt;
                    [(UINavigationController *)(self.window.rootViewController) pushViewController:web animated:YES];
                }else{
                    ShowMessage([resultSrt stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding])
                }
            }else{
                //[self showAlertWithMessage:@"扫描出错,请重新扫描!"];
                NSLog(@"没有扫描，或没有成功！");
            }
            
        }];
        [self.window.rootViewController presentViewController:qrCoreVC animated:YES completion:nil];
    }
}
#pragma mark - 判断相机相册
//让UIImagePickerController根据不同的type加载不同的资源
//UIImagePickerController 中封装了相机，相册库等系统资源
-(void)loadSourceWithType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=sourceType;
    picker.delegate=self;
    //是否对相册资源进行自动处理
    picker.allowsEditing=YES;
    
    //在程序中，对于picker习惯于通过模态化方式呈现出来
    [self.window.rootViewController presentViewController:picker animated:YES completion:^{
        
    }];
    
}
#pragma mark - 相机相册代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //UIImagePickerControllerOriginalImage取原图，UIImagePickerControllerEditedImage取编辑图片
//    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
}
#pragma mark - 微信代理
//微信需要
-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode==0) {
            [Utility showHUD:@"分享成功"];
        }else if(resp.errCode!=-2){
            [Utility showHUD:@"分享失败"];
        }
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]){
        if (resp.errCode==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:USNOTIFICATION__WEIXIN_THIRDPART_LOGIN object:resp];
        }else if(resp.errCode==-2){
            ShowMessage(@"取消授权")
        }else{
            ShowMessage(@"授权失败")
        }
    }
}
#pragma mark - 微博代理
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}
/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    switch (response.statusCode) {
        case 0:
        {
            if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:USNOTIFICATION__WEIBO_THIRDPART_LOGIN object:response];
            }else if([response isKindOfClass:[WBSendMessageToWeiboResponse class]]){
                ShowMessage(@"分享成功！")
            }
        }
            break;
        case -1:
        {
            //用户取消
        }
            break;
        case -2:
        {
            ShowMessage(@"发送失败")
        }
            break;
        case -3:
        {
            ShowMessage(@"授权失败")
        }
            break;
        case -4:
        {
            
        }
            break;
        case -8:
        {
            ShowMessage(@"分享失败")
            
        }
            break;
        case -99:
        {
            ShowMessage(@"不支持的请求")
        }
            break;
        default:
            ShowMessage(@"WeiboSDK,未知错误")
            break;
    }
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    if (YES == [WXApi handleOpenURL:url delegate:self])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    if (YES==[WeiboSDK handleOpenURL:url delegate:self]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    if([[url absoluteString] hasPrefix:@"fb358129877723499"]){
        return [[FBSDKApplicationDelegate sharedInstance]application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    if([[url absoluteString] hasPrefix:@"wb2267068098"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    //QQ tencent1104359320://qzapp/mqzone/0?generalpastboard=1  com.tencent.mqq
    if([[url absoluteString] hasPrefix:@"tencent1103439269"]){
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}
/**
 *  ios9新增加方法，用来替换上面两个方法
 *
 *  @param app     app description
 *  @param url     url description
 *  @param options options description
 *
 *  @return return value description
 */
//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//    return YES;
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
