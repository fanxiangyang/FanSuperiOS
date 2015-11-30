//
//  FanHeader.h
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/4.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#ifndef FanHeader_h
#define FanHeader_h



#define iOSVersion   ([[UIDevice currentDevice]systemVersion].floatValue)
#define kWidth (([UIScreen mainScreen].bounds.size.width)>([UIScreen mainScreen].bounds.size.height)?([UIScreen mainScreen].bounds.size.height):([UIScreen mainScreen].bounds.size.width))
#define kHeight (([UIScreen mainScreen].bounds.size.height)>([UIScreen mainScreen].bounds.size.width)?([UIScreen mainScreen].bounds.size.height):([UIScreen mainScreen].bounds.size.width))


//显示提示信息1.5秒
#define ShowMessage(msg) [Utility showHUD:msg];
#define ShowMessageTime(msg,time) [Utility showHUD:msg afterDelay:time];
#define ShowIMPMessageTime(msg,time) [Utility showIMPHUD:msg afterDelay:time];




#ifdef DEBUG
# define FanLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define FanLog(...);
#endif





#define USNOTIFICATION__WEIBO_THIRDPART_LOGIN @"Weibo_Third_Party_Login"
#define USNOTIFICATION__WEIXIN_THIRDPART_LOGIN @"WeiXin_Third_Party_Login"


#endif /* FanHeader_h */
