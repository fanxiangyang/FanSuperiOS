//
//  FanRotateMenuView.m
//  EFAnimationMenu
//
//  Created by 向阳凡 on 15/7/9.
//  Copyright © 2015年 Jueying. All rights reserved.
//

#import "FanRotateMenuView.h"

@implementation FanRotateMenuView
{
    NSInteger circleCount;
    CGFloat centery;
    CGFloat centerx;
}

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray{
    self=[super initWithFrame:frame];
    if (self) {
        self.imageArray=[imageArray mutableCopy];
        circleCount=imageArray.count;
        [self configUI];
    }
    return self;
}
-(void)configUI{
    centery =CGRectGetWidth(self.frame)/2;
    centerx = CGRectGetHeight(self.frame)/2;
    
    for (NSInteger i = 0;i < circleCount;i++) {
        CGFloat tmpy =  centery + kCircle_Width*cos(2.0*M_PI *i/circleCount);
        CGFloat tmpx =	centerx - kCircle_Width*sin(2.0*M_PI *i/circleCount);

        UIButton *circleButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [circleButton setBackgroundImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        //[circleButton setBackgroundImage:[UIImage imageNamed:[self.imageArray[i] stringByAppendingFormat:@"%@", @"_hover"]] forState:UIControlStateHighlighted];
        
        circleButton.frame = CGRectMake(0.0, 0.0,kCircle_Width+10,kCircle_Width+10);
        circleButton.center = CGPointMake(tmpx,tmpy);        
        CGFloat Scalenumber = fabs(i - circleCount/2.0)/(circleCount/2.0);
        if (Scalenumber < 0.3) {
            Scalenumber = 0.4;
        }
        circleButton.layer.transform= CATransform3DScale (CATransform3DIdentity, Scalenumber*kScale_Fan,Scalenumber*kScale_Fan, 1);
         //circleButton.layer.transform= CATransform3DScale (CATransform3DIdentity, 0.4,0.4, 1);
        [circleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        circleButton.tag=100+i;
        [self addSubview:circleButton];
        circleButton.layer.cornerRadius=57;
        circleButton.layer.masksToBounds=YES;
        
    }
    self.currentTag=100+0;
}
-(void)buttonClick:(UIButton *)btn{
    if (self.currentTag  == btn.tag) {
        NSLog(@"自定义处理事件:%ld",btn.tag-100);
        if (_delegate&&[_delegate respondsToSelector:@selector(fan_RotateButtonIndex:)]) {
            [_delegate fan_RotateButtonIndex:btn.tag-100];
        }
        return;
    }
    //取相对值
    NSInteger t =[self getIemViewTag:btn.tag];

    for (NSInteger i = 0;i<circleCount;i++ ) {
        UIView *view = [self viewWithTag:100+i];
        
        [view.layer addAnimation:[self moveanimation:100+i number:t] forKey:@"position"];
        [view.layer addAnimation:[self setscale:100+i clicktag:btn.tag-100] forKey:@"transform"];
        
    }
    self.currentTag  = btn.tag;
}
- (CAAnimation*)moveanimation:(NSInteger)tag number:(NSInteger)num {
    // CALayer
    UIView *view = [self viewWithTag:tag];
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animation];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,view.layer.position.x,view.layer.position.y);
    
    NSInteger p =[self getIemViewTag:tag];
    CGFloat f = 2.0*M_PI  - 2.0*M_PI *p/circleCount;
    CGFloat h = f + 2.0*M_PI *num/circleCount;
    CGFloat tmpy =  centery + kCircle_Width*cos(h);
    CGFloat tmpx =	centerx - kCircle_Width*sin(h);
    view.center = CGPointMake(tmpx,tmpy);
    
    CGPathAddArc(path,nil,centerx, centery,kCircle_Width,f+ M_PI/2,f+ M_PI/2 + 2.0*M_PI *num/circleCount,0);
    animation.path = path;
    CGPathRelease(path);
    animation.duration = kTIME_Fan;
    animation.repeatCount = 1;
    animation.calculationMode = @"paced";
    return animation;
}
- (CAAnimation*)setscale:(NSInteger)tag clicktag:(NSInteger)clicktag {
    //这里面的逻辑有点乱:假设（0，1，2，3，4）
    //选中2时：原始第i个View 走i=(5-2+i)%5下面算法
    /** CGFloat Scalenumber = fabs(i - circleCount/2.0)/(circleCount/2.0);
    if (Scalenumber < 0.3) {
        Scalenumber = 0.4;
    }
     */

    //from
    CGFloat Scalenumber1=fabs((circleCount-(self.currentTag-100)+(tag-100))%circleCount+ - circleCount/2.0)/(circleCount/2.0);
    if (Scalenumber1 < 0.3) {
        Scalenumber1 = 0.4;
    }
    //to
    CGFloat Scalenumber = fabs((circleCount-clicktag+(tag-100))%circleCount - circleCount/2.0)/(circleCount/2.0);
    if (Scalenumber < 0.3) {
        Scalenumber = 0.4;
    }
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = kTIME_Fan;
    animation.repeatCount =1;
    
    CATransform3D dtmp = CATransform3DScale(CATransform3DIdentity,Scalenumber*kScale_Fan, Scalenumber*kScale_Fan, 1.0);
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity,Scalenumber1*kScale_Fan,Scalenumber1*kScale_Fan, 1.0)];
    animation.toValue = [NSValue valueWithCATransform3D:dtmp ];
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}
- (NSInteger)getIemViewTag:(NSInteger)tag {
    
    if (self.currentTag >tag){
        return self.currentTag  - tag;
    } else {
        return circleCount  - tag + self.currentTag ;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
