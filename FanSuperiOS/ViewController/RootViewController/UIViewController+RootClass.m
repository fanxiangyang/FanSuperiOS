//
//  UIViewController+RootClass.m
//  Mitbbs_Forum
//
//  Created by 向阳凡 on 15/6/11.
//  Copyright (c) 2015年 未名空间. All rights reserved.
//

#import "UIViewController+RootClass.h"

@implementation UIViewController (RootClass)


-(void)fan_addTapGestureTarget:(id)target action:(SEL)action toView:(UIView *)tapView{
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapView.userInteractionEnabled=YES;
    [tapView addGestureRecognizer:imageTapGesture];
}

//根据不同的提示信息，创建警告框
-(void)fan_showAlertWithMessage:(NSString *)message delegate:(id)fan_delegate{
    [self fan_showAlertWithTitle:@"温馨提示" message:message delegate:fan_delegate tag:0];
}
//根据不同的提示信息，创建警告框
-(void)fan_showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)fan_delegate tag:(NSInteger)tag{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title?title:@"温馨提示" message:message delegate:fan_delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=tag;
    [alert show];
}

@end
