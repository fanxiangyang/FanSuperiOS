//
//  FanSuperShareView.h
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/6.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FanSuperShareView;
@protocol FanSuperShareViewDelegate <NSObject>

@optional
-(void)superShareView:(FanSuperShareView *) shareView buttonIndex:(NSInteger)buttonIndex;

@end

@interface FanSuperShareView : UIView

@property(nonatomic,weak)id<FanSuperShareViewDelegate>delegate;

//弹出分享界面
+(void)showShareView:(id<FanSuperShareViewDelegate>)delegate;

@end
