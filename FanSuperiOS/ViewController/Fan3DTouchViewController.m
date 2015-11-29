//
//  Fan3DTouchViewController.m
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/5.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import "Fan3DTouchViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "FanPreePopViewController.h"

@interface Fan3DTouchViewController ()<UIActionSheetDelegate,UIViewControllerPreviewingDelegate,UIPreviewActionItem>
@property(nonatomic,strong)UIImageView *touchImageView;
@end

@implementation Fan3DTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //验证指纹
    [self authLoginTouchID];

    
    //创建按压Touch
    self.touchImageView=[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-200)/2, 50, 200, 300)];
    self.touchImageView.userInteractionEnabled=YES;
    self.touchImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.touchImageView.backgroundColor=[UIColor orangeColor];
    self.touchImageView.clipsToBounds=YES;
    self.touchImageView.image=[UIImage imageNamed:@"peerImage.png"];
    [self.view addSubview:self.touchImageView];
    //注册3D Touch
    if ([self respondsToSelector:@selector(registerForPreviewingWithDelegate:sourceView:)]) {
        [self registerForPreviewingWithDelegate:self sourceView:self.touchImageView];
    }
    
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"UIActionSheet" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth=YES;
    button.frame=CGRectMake(kWidth/2-150, kHeight-100, 100, 40);
    button.tag=100;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 =[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"UIAlertController" forState:UIControlStateNormal];
    button1.frame=CGRectMake(kWidth/2+50, kHeight-100, 100, 40);
    button1.tag=101;
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.titleLabel.adjustsFontSizeToFitWidth=YES;
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    // Do any additional setup after loading the view.
}
#pragma mark - 3D-Touch 指纹识别
-(BOOL)authLoginTouchID{
    if (iOSVersion<8) {
        return NO;
    }
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"请使用您的指纹验证！";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self showAlert:@"密码验证成功"];
                }];
            }else{
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self showAlert:[NSString stringWithFormat:@"密码验证失败：%@",error.localizedDescription]];
                }];
            }
        }];
    }else{
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
        [self showAlert:[NSString stringWithFormat:@"密码验证失败：%@",error.localizedDescription]];
    }
    return YES;
}
-(void)showAlert:(NSString *)message{
    if (iOSVersion>=8) {
        UIAlertController *act=[UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [act addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [act addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:act animated:YES completion:^{
            
        }];
        
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
#pragma mark - UIActionSheet
-(void)buttonClick:(UIButton *)btn{
    if (btn.tag==100) {
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"我是actionSheet" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"OK" otherButtonTitles:@"🐴",@"🍎", nil];
        [actionSheet showFromToolbar:self.navigationController.toolbar];
    }else{
        if (iOSVersion>=8) {
            UIAlertController *act=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"我是UIAlertControler" preferredStyle:UIAlertControllerStyleActionSheet];
            [act addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [act addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [act addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            
            [self presentViewController:act animated:YES completion:^{
                
            }];
            
        }
    }
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0){
    FanPreePopViewController *childVC = [[FanPreePopViewController alloc] init];
    childVC.preferredContentSize = CGSizeMake(300.0f,400.0f);
    childVC.view.backgroundColor=[UIColor greenColor];
    //按压资源高透区域
    CGRect rect = CGRectMake(0, 0, 200,300);
    previewingContext.sourceRect = rect;
    return childVC;
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0){
    [self showViewController:viewControllerToCommit sender:self];
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
