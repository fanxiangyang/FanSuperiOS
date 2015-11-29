//
//  FanThreeLoginManager.m
//  Mitbbs_Forum
//
//  Created by 向阳凡 on 15/10/30.
//  Copyright © 2015年 未名空间. All rights reserved.
//

#import "FanThreeLoginManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <TwitterKit/TwitterKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "AFNetworking.h"

@implementation FanThreeLoginManager

+(FanThreeLoginManager *)standardManager{
    static FanThreeLoginManager *loginManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginManager=[[FanThreeLoginManager alloc]init];
        [loginManager regestLoginAppID];
    });
    return loginManager;
}

-(void)regestLoginAppID{
    self.qqOauth=[[TencentOAuth alloc]initWithAppId:@"1103439269" andDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginWithWeibo:) name:USNOTIFICATION__WEIBO_THIRDPART_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginWithWeiXin:) name:USNOTIFICATION__WEIXIN_THIRDPART_LOGIN object:nil];
}
#pragma mark - 登录
-(void)loginType:(FanLoginType)loginType{
    [self loginType:loginType delegate:nil];
}
-(void)loginType:(FanLoginType)loginType delegate:(id<FanThreeLoginManagerDelegate>)delegate{
    self.delegate=delegate;
    switch (loginType) {
        case FanLoginTypeQQ:
        {
            NSArray* permissions = [NSArray arrayWithObjects:
                                    kOPEN_PERMISSION_GET_USER_INFO,
                                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                    kOPEN_PERMISSION_ADD_ONE_BLOG,
                                    kOPEN_PERMISSION_ADD_TOPIC,
                                    kOPEN_PERMISSION_GET_INFO,
                                    nil];
            [self.qqOauth authorize:permissions inSafari:NO];

        }
            break;
        case FanLoginTypeFacebook:{
            FBSDKLoginManager *loginManger=[[FBSDKLoginManager alloc]init];
            [loginManger logOut];//解决因为没有退出，造成授权失败
            [loginManger logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]  fromViewController:_weak_ThreeLoginVC handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error) {
                    ShowMessage(error.localizedDescription);
                    NSLog(@"Process error:%@",error);
                } else if (result.isCancelled) {
                    NSLog(@"Cancelled");
                } else {
                    NSString *uid=[NSString stringWithFormat:@"facebook_%@", result.token.userID];
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(fanLoginResponse:type:)]) {
                        [self.delegate fanLoginResponse:uid type:FanLoginTypeFacebook];
                    }
                }
            }];
        }
            break;
        case FanLoginTypeTwitter:{
            [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
                if (session) {
                    NSString *uid=[NSString stringWithFormat:@"twitter_%@", session.userID];
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(fanLoginResponse:type:)]) {
                        [self.delegate fanLoginResponse:uid type:FanLoginTypeTwitter];
                    }
                } else {
                    NSLog(@"error: %@", [error localizedDescription]);
                    ShowMessage([error localizedDescription]);
                }
            }];
        }
            break;
        case FanLoginTypeWeibo:
        {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            //此信息必须在开放平台我的应用里面高级信息去设置,默认：http://
            request.redirectURI = @"http://www.mitbbs.com.cn";
            request.scope = @"all";
            request.userInfo = @{@"SSO_Form" : @"SendMessageToWeiboViewController",
                                 @"Other_Info_1" : [NSNumber numberWithInt:123],
                                 @"Other_Info_2" : @[@"obj1", @"obj2"],
                                 @"Other_Info_3" : @{@"key1": @"obj1", @"key2" : @"obj2"}
                                 };
//            request.shouldOpenWeiboAppInstallPageIfNotInstalled=YES;
            [WeiboSDK sendRequest:request];
            
        }
            break;
        case FanLoginTypeWX:
        {
//            appData.isMoreAuthorized=NO;
//            if (![WXApi isWXAppInstalled]) {
//                ShowMessage(@"没有找到微信客户端，无法继续")
//                return;
//            }
            
            //构造SendAuthReq结构体
            SendAuthReq* req =[[SendAuthReq alloc ] init ];
            req.scope = @"snsapi_userinfo" ;
            req.state = @"123" ;
            //第三方向微信终端发送一个SendAuthReq消息结构
            [WXApi sendReq:req];
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 退出登录或取消授权
-(void)logoutType:(FanLoginType)loginType{
    switch (loginType) {
        case FanLoginTypeQQ:
        {
            [self.qqOauth logout:self];
        }
            break;
        case FanLoginTypeTwitter:
        {
            [[Twitter sharedInstance]logOutGuest];
        }
            break;
        case FanLoginTypeFacebook:
        {
            FBSDKLoginManager *loginManger=[[FBSDKLoginManager alloc]init];
            [loginManger logOut];
            [FBSDKAccessToken setCurrentAccessToken:nil] ;
            [FBSDKProfile setCurrentProfile:nil];
        }
            break;
        case FanLoginTypeWeibo:
        {
//            [[Twitter sharedInstance]logOutGuest];
        }
            break;case FanLoginTypeWX:
        {
//            [[Twitter sharedInstance]logOutGuest];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 分享
-(void)shareModel:(FanShareModel *)shareModel type:(FanLoginType)loginType{
    switch (loginType) {
        case FanLoginTypeQQ:
        {
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:shareModel.shareLink]
                                        title:shareModel.shareTitle
                                        description:shareModel.shareDes
                                        previewImageURL:nil];
            
            //    [newsObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            //将内容分享到qq
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            //将内容分享到qzone
            //    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [self handleSendResult:sent];
        }
            break;
        case FanLoginTypeQQZone:
        {
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:shareModel.shareLink]
                                        title:shareModel.shareTitle
                                        description:shareModel.shareDes
                                        previewImageURL:nil];
            
            //    [newsObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            //将内容分享到qzone
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [self handleSendResult:sent];
        }
            break;
        case FanLoginTypeWeibo:{
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = @"http://www.mitbbs.com.cn";
            authRequest.scope = @"all";
            //消息体
            WBMessageObject *message = [WBMessageObject message];
            message.text=shareModel.shareTitle;
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = @"identifier1";
            webpage.title = shareModel.shareTitle;
            webpage.description = shareModel.shareDes;
            webpage.webpageUrl = shareModel.shareLink;
            message.mediaObject = webpage;
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            [WeiboSDK sendRequest:request];

        }
            break;
        case FanLoginTypeFacebook:{
            FBSDKShareLinkContent *content=[[FBSDKShareLinkContent alloc]init];
            content.contentURL=[NSURL URLWithString:shareModel.shareLink];
            content.contentTitle=shareModel.shareTitle;
            content.contentDescription=shareModel.shareDes;
            
            FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
            dialog.fromViewController = _weak_ThreeLoginVC;
            dialog.shareContent = content;
            dialog.mode = FBSDKShareDialogModeShareSheet;
            [dialog show];
        }
            break;
        case FanLoginTypeTwitter:{
            TWTRComposer *composer = [[TWTRComposer alloc] init];
            
            [composer setText:shareModel.shareTitle];
            [composer setURL:[NSURL URLWithString:shareModel.shareLink]];
            // Called from a UIViewController
            [composer showFromViewController:_weak_ThreeLoginVC completion:^(TWTRComposerResult result) {
                if (result == TWTRComposerResultCancelled) {
//                    NSLog(@"Tweet composition cancelled");
                }
                else {
                    NSLog(@"Sending Tweet!");
                }
            }];

        }
            break;
        case FanLoginTypeWX:{
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = shareModel.shareTitle;
            message.description = shareModel.shareDes;
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = shareModel.shareLink;
            
            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.message=message;
            req.bText = NO;
            req.scene = WXSceneSession;
            [WXApi sendReq:req];
        }
            break;
        case FanLoginTypeWXSession:{
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = shareModel.shareTitle;
            message.description = shareModel.shareDes;
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = shareModel.shareLink;
            
            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.message=message;
            req.bText = NO;
            req.scene = WXSceneTimeline;
            [WXApi sendReq:req];
        }
            break;
        case FanLoginTypeEmail:{
            //邮箱
            MFMailComposeViewController *mail=[[MFMailComposeViewController alloc]init];
            if ([MFMailComposeViewController canSendMail]) {
                [mail setSubject:shareModel.shareTitle];
//                [mail setToRecipients:@[@"1346569137@qq.com"]];
                [mail setMessageBody:shareModel.shareDes isHTML:NO];
                mail.mailComposeDelegate=self;
                
                [_weak_ThreeLoginVC presentViewController:mail animated:YES completion:^{
                    
                }];
            }else{
                ShowMessage(@"系统不支持邮件功能，或没有打开该功能！")
            }

        }
            break;
        default:
            break;
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:
        {
            ShowMessage(@"发送成功")
            [_weak_ThreeLoginVC dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
        case MFMailComposeResultCancelled:
        {
//            ShowMessage(@"用户关闭")
            [_weak_ThreeLoginVC dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
        case MFMailComposeResultFailed:
        {
            ShowMessage(@"发送失败，请重试")
        }
            break;
        case MFMailComposeResultSaved:
        {
            ShowMessage(@"保存成功")
            [_weak_ThreeLoginVC dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 腾讯 Delegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    NSLog(@"登录成功 accessToken:%@，openID:%@",self.qqOauth.accessToken,self.qqOauth.openId);
    NSString *uid=[NSString stringWithFormat:@"qzone_%@", [self.qqOauth openId]];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(fanLoginResponse:type:)]) {
        [self.delegate fanLoginResponse:uid type:FanLoginTypeQQ];
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@"用户关闭QQ登录！");
    }else{
        ShowMessage(@"授权失败,请重新授权")
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    ShowMessage(@"无网络连接，请设置网络")
}
//QQ分享结果提示
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            ShowMessage(@"App未注册")
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            ShowMessage(@"发送参数错误")
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            ShowMessage(@"未安装手Q")
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            ShowMessage(@"API接口不支持")
            break;
        }
        case EQQAPISENDFAILD:
        {
            ShowMessage(@"发送失败")
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark - get Set
-(void)setDelegate:(id<FanThreeLoginManagerDelegate>)delegate{
    _delegate=nil;
    _delegate=delegate;
}

-(void)tencentDidLogout{
    NSLog(@"退出QQ登录成功");
}
#pragma mark - 通知中心的方法，微信，微博

-(void)didLoginWithWeibo:(NSNotification *)notification{
    if (notification) {
        WBBaseResponse *response = notification.object;
        if ([response isKindOfClass:WBAuthorizeResponse.class]) {
            WBAuthorizeResponse *wbResponse =(WBAuthorizeResponse *)response;
            switch (wbResponse.statusCode) {
                case WeiboSDKResponseStatusCodeSuccess:{
                    NSString *uid = [NSString stringWithFormat:@"weibo_%@", wbResponse.userID];
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(fanLoginResponse:type:)]) {
                        [self.delegate fanLoginResponse:uid type:FanLoginTypeWeibo];
                    }
                    break;
                }
                case WeiboSDKResponseStatusCodeUserCancelInstall:
                case WeiboSDKResponseStatusCodeUserCancel:{
                    [Utility showHUD:@"用户取消第三方登陆"];
                    break;
                }
                default:{
                    [Utility showHUD:@"绑定异常，请重试"];
                    break;
                }
            }
        }
        
    }
}
//微信回应
- (void)didLoginWithWeiXin:(NSNotification *)notification{
    if (notification) {
        SendAuthResp *weiXinResponse = notification.object;
        if (weiXinResponse.code) {
            
            NSString *requestURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx7ef5fe4d8f7e0a5b&secret=657e374388aefa3eb94e67115c1b7e24&code=%@&grant_type=authorization_code", weiXinResponse.code];
            
            [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
                
                NSString *getUserInfoURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", [responseObject objectForKey:@"access_token"], [responseObject objectForKey:@"openid"]];
                
                [manager GET:getUserInfoURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSString *uid = [NSString stringWithFormat:@"weixin_%@", [responseObject objectForKey:@"unionid"]];
                    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(fanLoginResponse:type:)]) {
                        [self.delegate fanLoginResponse:uid type:FanLoginTypeWX];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    [Utility showHUD:@"绑定异常，请重试"];
                }];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                [Utility showHUD:@"绑定异常，请重试"];
            }];
        }
        else{
            [Utility showHUD:@"绑定异常，请重试"];
        }
    }
}


@end

#pragma mark - FanShareModel (分享类）
@implementation FanShareModel

-(instancetype)initWithShareTitle:(NSString *)title shareDescription:(NSString *)shareDes shareLink:(NSString *)shareLink shareImageURl:(NSString *)shareImageURL{
    self=[super init];
    if (self) {
        self.shareTitle=title;
        self.shareDes=shareDes;
        self.shareLink=shareLink;
        self.shareImageURl=shareImageURL;
    }
    return self;
}

@end
