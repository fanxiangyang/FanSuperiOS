//
//  FanRotateMenuView.h
//  EFAnimationMenu
//
//  Created by 向阳凡 on 15/7/9.
//  Copyright © 2015年 Jueying. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCircle_Width 100.0
#define kTIME_Fan 0.6
#define kScale_Fan 1.25


@protocol FanRotateMenuViewDelegate <NSObject>

-(void)fan_RotateButtonIndex:(NSInteger)buttonIndex;

@end

@interface FanRotateMenuView : UIView

@property (nonatomic, assign)NSInteger currentTag;
@property(nonatomic,strong)NSMutableArray *imageArray;
//@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,weak)id<FanRotateMenuViewDelegate>delegate;


-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray;


@end
