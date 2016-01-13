# FanSuperiOS
many animation，Native threeLogin（多种动画，原生第三方登录，分享）

###  1.动画 
*各种动画，及画图结合
*查看项目路径下gif图片
![动画](https://github.com/fanxiangyang/FanSuperiOS/iOS1.gif)
```
#pragma mark - CATransition基本动画
/**动画切换页面的效果(CATransition)

*此方法用于任意View的layer层上面
*subType 方向 kCATransitionFromBottom ....
*subtypes: kCAAnimationCubic迅速透明移动,cube 3D立方体翻页 pageCurl从一个角翻页，
*          pageUnCurl反翻页，rippleEffect水波效果，suckEffect缩放到一个角,oglFlip中心立体翻转
*          (kCATransitionFade淡出，kCATransitionMoveIn覆盖原图，kCATransitionPush推出，kCATransitionReveal卷轴效果)
*/
+(CATransition *)fan_transitionAnimationWithSubType:(NSString *)subType withType:(NSString *)xiaoguo duration:(CGFloat)duration;


#pragma mark - CABasicAnimation动画
/**永久闪烁的动画：动画时间（秒）*/
+(CABasicAnimation *)fan_opacityForever_Animation:(float)time;
/**有闪烁次数的动画:次数+动画时间（秒）*/
+(CABasicAnimation *)fan_opacityTimes_Animation:(float)repeatTimes durTimes:(float)time;
/**横向移动:移动距离(fromX--toX)+动画时间（秒）*/
+(CABasicAnimation *)fan_moveXWithTime:(float)time fromX:(float)fromX toX:(float)toX;
/**纵向移动:移动距离(fromY--toY)+动画时间（秒）*/
+(CABasicAnimation *)fan_moveYWithTime:(float)time fromY:(float)fromY toY:(float)toY;
/**点移动:移动的是偏移量*/
+(CABasicAnimation *)fan_movepoint:(CGPoint )point;
/**动画放大和缩小:放大倍数+动画次数 */
+(CABasicAnimation *)fan_scaleMax:(float)multiple orginMin:(float)orginMultiple durTimes:(float)time Rep:(float)repeatTimes;
/**组合动画:动画时间+动画次数 */
+(CAAnimationGroup *)fan_groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes; //组合动画

/** 旋转绕Z轴

* dur 时间
* degree旋转角度
* direction方向(0-1)
* repeatCount次数
*/
+(CABasicAnimation *)fan_rotationTime:(float)dur degree:(float)degree directionZ:(float)directionZ repeatCount:(int)repeatCount;
/** 围绕三维坐标轴旋转（单个动画时间+3D)

*第一个参数是旋转角度(pi/2正向，1.5pi逆向），后面三个参数形成一个围绕其旋转的向量(x,y,z)，起点位置由UIView的center属性标识。
*CATransform3D t = CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z);
*/
+(CABasicAnimation *)fan_rotationTime:(float)dur transform3D:(CATransform3D)transform3D;

/**左右晃动:是偏移量移动*/
+(CABasicAnimation *)fan_rockWithTime:(float)time fromX:(float)fromX toX:(float)toX repeatCount:(int)repeatCount;
/**上下晃动:是偏移量移动*/
+(CABasicAnimation *)fan_rockWithTime:(float)time fromY:(float)fromY toY:(float)toY repeatCount:(int)repeatCount;

#pragma mark - CAKeyframeAnimation动画
/**路径动画（点的移动，圆，曲线）

*path 路径
*time 持续的时间
*repeatTimes 重复的次数
*/
+(CAKeyframeAnimation *)fan_keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes; //路径动画
/**左右摇晃,图标的抖动:抖动宽度+强度*/
+(CAKeyframeAnimation * )fan_shakeAnimationWidth:(float)shakeWidth sigleDuration:(float)sigleDuration;


#pragma mark - 其他辅佐方法
/**快速获得视图相对屏幕的坐标*/
+ (CGRect)fan_relativeFrameForScreenWithView:(UIView *)v;
```

### 2.原生第三方登录，分享
*实现QQ，微信，微博，Facebook，Twitter原生第三方登录分享
*查看项目路径下gif图片
![原生登录和分享](https://github.com/fanxiangyang/FanSuperiOS/iOS2.gif)
```
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
```
###其他功能
*纯代码Autolayout
*常用工厂类方法Utility.m
*3D-Touch功能
*封装系统的二维码功能


###开发环境

* OS X 10.11.1
* Xcode Version 7.1 

####有问题请直接在文章下面留言。
####喜欢此系列文章可以点击上面右侧的 Star 哦，变成 Unstar 就可以了！ 
###开发人：凡向阳
####Email:fanxiangyang_heda@163.com
