//
//  FanThreeLoginManager.h
//  Mitbbs_Forum
//
//  Created by 向阳凡 on 15/10/30.
//  Copyright © 2015年 未名空间. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <MessageUI/MessageUI.h>

/**
 *  第三方登录类型
 */
typedef NS_ENUM(NSInteger,FanLoginType) {
    /**
     *  QQ
     */
    FanLoginTypeQQ=1,
    /**
     *  QQ空间
     */
    FanLoginTypeQQZone,
    /**
     *  微信
     */
    FanLoginTypeWX,
    /**
     *  微信朋友圈
     */
    FanLoginTypeWXSession,
    /**
     *  微博
     */
    FanLoginTypeWeibo,
    /**
     *  Facebook
     */
    FanLoginTypeFacebook,
    /**
     *  Twitter
     */
    FanLoginTypeTwitter,
    /**
     *  邮件
     */
    FanLoginTypeEmail
};

@protocol FanThreeLoginManagerDelegate <NSObject>

@optional
-(void)fanLoginResponse:(id)response type:(FanLoginType)loginType ;
-(void)fanShareResponse:(id)response type:(FanLoginType)loginType ;

@end



@class FanShareModel;

@interface FanThreeLoginManager : NSObject<TencentSessionDelegate,MFMailComposeViewControllerDelegate>


@property(nonatomic,weak)id<FanThreeLoginManagerDelegate>delegate;

@property(nonatomic,strong)TencentOAuth *qqOauth;

/**
 *  当需要弹出界面时，必须传此值，login:Facebook，share:Twitter,Facebook,邮箱
 */
@property(nonatomic,weak)  id weak_ThreeLoginVC;



+(FanThreeLoginManager *)standardManager;

-(void)loginType:(FanLoginType)loginType;
-(void)loginType:(FanLoginType)loginType delegate:(id<FanThreeLoginManagerDelegate>)delegate;
-(void)logoutType:(FanLoginType)loginType;
-(void)shareModel:(FanShareModel *)shareModel type:(FanLoginType)loginType;

@end

/**
 *  分享的model
 */
@interface FanShareModel : NSObject

@property(nonatomic,copy)NSString *appName;//app的名字
@property(nonatomic,copy)NSString *shareTitle;//标题
@property(nonatomic,copy)NSString *shareDes;//content
@property(nonatomic,copy)NSString *shareLink;//分享链接
@property(nonatomic,copy)NSString *shareImageURl;
@property(nonatomic,strong)UIImage *shareImage;//分享的图片
@property(nonatomic,copy)NSString *appendText;//追加文本

-(instancetype)initWithShareTitle:(NSString *)title shareDescription:(NSString *)shareDes shareLink:(NSString *)shareLink shareImageURl:(NSString *)shareImageURL;

@end
