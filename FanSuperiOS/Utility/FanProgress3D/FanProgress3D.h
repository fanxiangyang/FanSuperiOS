//
//  FanProgress3D.h
//  FirstAF
//
//  Created by qianfeng on 14-10-24.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

/*
 版本1.0，2014-10-24
 1.可以根据自己的需要，自己去改颜色，和label颜色
 2.提示信息，title不易太长，尽量20字以下
 
 
 更新：1.优化动画部分
 
 
 版本2.0 2015-10-17
 1.添加对横屏的适配
 */




#import <UIKit/UIKit.h>


#define FanProgress3DWidth ([UIScreen mainScreen].bounds.size.width)
#define FanProgress3DHeight ([UIScreen mainScreen].bounds.size.height)


@interface FanProgress3D : NSObject
/**
 *  显示加载等待
 *
 *  @param view 展示View
 */
+ (void)showInView:(UIView*)view;
//正在加载，在那个View上
+ (void)showInView:(UIView*)view status:(NSString*)message;
//消失
+ (void)dismiss; // simply dismiss the HUD with a fade+scale out animation
//几秒后消失（包括成功和失败都可以调用）
+ (void)dismissWithStatus:(NSString *)message afterDelay:(NSTimeInterval)seconds;

@end
