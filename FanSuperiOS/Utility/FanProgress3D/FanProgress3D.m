//
//  FanProgress3D.m
//  FirstAF
//
//  Created by qianfeng on 14-10-24.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "FanProgress3D.h"
#import "UIView+FanAutoLayout.h"

@implementation FanProgress3D
{
    UIImageView *_rotateView;
    UIImageView *_rotateView2;
    UIImageView *_centerView;
    UILabel *_titleLabel;
    NSTimer *fadeOutTimer;
    UIView *_maskView;
}
- (id)init
{
    self = [super init];
    if (self) {
        _rotateView = [[UIImageView alloc] init];
        _rotateView2 = [[UIImageView alloc] init];
        _centerView = [[UIImageView alloc] init];
        _titleLabel=[[UILabel alloc]init];
          _maskView=[[UIView alloc]init];
        [self configUI];
    }
    return self;
}
-(void)configUI{
    _maskView.layer.masksToBounds=YES;
    _maskView.layer.cornerRadius=10;
    _maskView.frame=CGRectMake(0, 0, 110, 100) ;
    _maskView.backgroundColor=[UIColor blackColor];
    CGRect smallFrame=CGRectMake((110-70)/2, 0, 70, 70);
    _centerView.frame =smallFrame;
    [_centerView setImage:[UIImage imageNamed:@"loading_bkgnd.png"]];
    
    
    _rotateView.frame =smallFrame;
    [_rotateView setImage:[UIImage imageNamed:@"loading_circle.png"]];
    
    
    _rotateView2.frame = smallFrame;
    [_rotateView2 setImage:[UIImage imageNamed:@"loading_circle.png"]];
    
    
    _titleLabel.frame=CGRectMake(10, 60, 90, 35);
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth=YES;
    _titleLabel.numberOfLines=0;
    _titleLabel.textColor=[UIColor whiteColor];
    //_titleLabel.font=[UIFont systemFontOfSize:12];
    
    [_maskView addSubview:_centerView];
    [_maskView addSubview:_rotateView];
    [_maskView addSubview:_rotateView2];
    [_maskView addSubview:_titleLabel];
}
static  FanProgress3D *manager;
+(FanProgress3D *)shareManager{
    if (manager==nil) {
        manager=[[FanProgress3D alloc]init ];//WithFrame:CGRectZero];
    }
    return manager;
}
+ (void)showInView:(UIView*)view{
    [[FanProgress3D shareManager] showInView:view status:nil];
}
+ (void)showInView:(UIView*)view status:(NSString*)message{
    [[FanProgress3D shareManager] showInView:view status:message];
}
+ (void)dismiss{
    [[FanProgress3D shareManager] dismiss];
}
+ (void)dismissWithStatus:(NSString *)message afterDelay:(NSTimeInterval)seconds{
    [[FanProgress3D shareManager]dismissWithStatus:message afterDelay:seconds];
}


- (void)showInView:(UIView*)view status:(NSString*)message{
    //修改 _maskView.center=view.center;(因为在界面上偏下）
    _maskView.center=CGPointMake(view.center.x, view.center.y-30);
    
    [view addSubview:_maskView];
    
    _maskView.translatesAutoresizingMaskIntoConstraints=NO;
    //字典里面的变量可以在格式字符里面替代
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_maskView);
    //[[_maskView superview] fan_addConstraintsCenter:_maskView viewSize:CGSizeMake(110, 100)];
    //宽度110
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_maskView(110)]" options:0 metrics:nil views:views]];
    //高度
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[maskView(100)]" options:0 metrics:nil views:@{@"maskView":_maskView}]];
    //垂直居中
    [view addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //水平居中
    [view addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    _titleLabel.text=message?message:@"加载中...";

    
    //中间画面
    [self addAnimationInView:_centerView duration:0.5 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0.1)];
    //圆圈
    [self addAnimationInView:_rotateView duration:0.5 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0.1)];
    //圆圈
    [self addAnimationInView:_rotateView2 duration:0.4 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0.1)];

}
-(void)dismiss{
    [self fan_removeAllAutoLayout];
    [_maskView removeFromSuperview];
}
//移除所有约束
- (void)fan_removeAllAutoLayout{
    [_maskView removeConstraints:_maskView.constraints];
    for (NSLayoutConstraint *constraint in _maskView.superview.constraints) {
        if ([constraint.firstItem isEqual:self]) {
            [_maskView.superview removeConstraint:constraint];
        }
    }
}
- (void)dismissWithStatus:(NSString *)message afterDelay:(NSTimeInterval)seconds {
    
    if(fadeOutTimer != nil){
        [fadeOutTimer invalidate];
        fadeOutTimer = nil;
    }
    _titleLabel.text=message?message:@"加载完成！";
    [self stopAnation];
    fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    
}
#pragma mark - 核心动画，哪个View产生动画，动画速度（秒）
-(void)addAnimationInView:(UIView *)view duration:(NSTimeInterval)timeInterval valueWithCATransform3D:(CATransform3D)transform3D{
    //核心内容
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    //角度，x,y,z,参数
    animation.toValue = [NSValue valueWithCATransform3D:transform3D];
    animation.duration = timeInterval;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    [view.layer addAnimation:animation forKey:@"animation"];
}
//停止动画
-(void)stopAnation{
    [_centerView.layer removeAnimationForKey:@"animation"];
    [_rotateView.layer removeAnimationForKey:@"animation"];
    [_rotateView2.layer removeAnimationForKey:@"animation"];


//    //中间画面
//    [self addAnimationInView:_centerView duration:0 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0)];
//    //圆圈
//    [self addAnimationInView:_rotateView duration:0 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0)];
//    //圆圈
//    [self addAnimationInView:_rotateView2 duration:0 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0)];
}

#pragma mark - dealloc 释放定时器
- (void)dealloc{
    if(fadeOutTimer != nil){
        [fadeOutTimer invalidate];
        fadeOutTimer = nil;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//#pragma mark - 根据label的内容，计算字符串的大小
////根据换行方式和字体的大小，已经计算的范围来确定字符串的size
//-(CGSize)currentSizeWith:(NSString*)text{
//    CGFloat version=[[UIDevice currentDevice].systemVersion floatValue];
//    CGSize size;
//    //计算size， 7之后有新的方法
//    if (version>=7.0) {
//        //得到一个设置字体属性的字典
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
//        //optinos 前两个参数是匹配换行方式去计算，最后一个参数是匹配字体去计算
//        //attributes 传入的字体
//        //boundingRectWithSize 计算的范围
//        size=[text boundingRectWithSize:CGSizeMake(250, 20) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
//    }else{
//        //ios7以前
//        //根据字号和限定范围还有换行方式计算字符串的size，label中的font 和linbreak要与此一致
//        //CGSizeMake(215, 999) 横向最大计算到215，纵向Max999
//        size=[text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 20) lineBreakMode:NSLineBreakByCharWrapping];
//    }
//    return size;
//}
@end
