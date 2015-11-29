//
//  UIViewController+RootClass.h
//  Mitbbs_Forum
//
//  Created by 向阳凡 on 15/6/11.
//  Copyright (c) 2015年 未名空间. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RootClass)

/** 添加单击手势 */
-(void)fan_addTapGestureTarget:(id)target action:(SEL)action toView:(UIView *)tapView;
/** 根据不同的提示信息，创建警告框 */
-(void)fan_showAlertWithMessage:(NSString *)message delegate:(id)fan_delegate;
-(void)fan_showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)fan_delegate tag:(NSInteger)tag;


@end
