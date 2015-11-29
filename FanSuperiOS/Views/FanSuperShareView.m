//
//  FanSuperShareView.m
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/6.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import "FanSuperShareView.h"
#import "FanAnimationToll.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

#define FanShareViewHight (155+90+90)

@interface FanSuperShareView()
/** 背景View*/
@property(nonatomic,strong)UIView *blackAlphView;
/** 内容View*/
@property(nonatomic,strong)UIView *shareView;

@end

@implementation FanSuperShareView

+(void)showShareView:(id<FanSuperShareViewDelegate>)delegate{
    FanSuperShareView *shareView=[[FanSuperShareView alloc]init];
    shareView.delegate=delegate;
    [shareView show];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.frame=CGRectMake(0, 0, kWidth, kHeight);
        [self createShareUI];
    }
    return self;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.frame=CGRectMake(0, 0, kWidth, kHeight);

        [self createShareUI];
    }
    return self;
}
-(void)createShareUI{
    self.blackAlphView=[[UIView alloc]initWithFrame:self.frame];
    self.blackAlphView.backgroundColor=[UIColor blackColor];
    self.blackAlphView.alpha=0.5;
    [self.blackAlphView.layer addAnimation:[FanAnimationToll fan_transitionAnimationWithSubType:kCATransitionFromTop withType:kCATransitionFade duration:0.3f] forKey:@"animation"];
    [self addSubview:self.blackAlphView];
    
    _shareView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-FanShareViewHight, kWidth, FanShareViewHight)];
    _shareView.backgroundColor=[UIColor whiteColor];
    [_shareView.layer addAnimation:[FanAnimationToll fan_transitionAnimationWithSubType:kCATransitionFromTop withType:kCATransitionMoveIn duration:0.3f] forKey:@"animation"];
    [self addSubview:_shareView];
    
    CGFloat btn_width = 57;
    CGFloat btn_heigt = 70;
    CGFloat space_width = (kWidth-3*btn_width)/4;
    CGFloat space_heigt = 20;
    NSArray *titleArray=@[@"QQ",@"QQ空间",@"微信好友",@"微信朋友圈",@"新浪微博",@"Facebook",@"Twitter",@"邮件"];
    NSArray*imageArray=@[@"image_tencent_qq.png",@"QQKJ_share.png",@"WeiXin_share.png",@"WeiXinQ_share.png",@"Sina_share.png",@"FaceBook_share.png",@"Twitter_share.png",@"Email_share.png"];
    for (int i = 0; i <titleArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(space_width+(i%3)*(btn_width+space_width), space_heigt+(i/3)*(btn_heigt+space_heigt), btn_width, btn_heigt)];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 13, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(btn_width+10, -1*btn_width, 0, 0);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:btn];
//        if (i == 0 || i == 1) {
//            if (![QQApiInterface isQQInstalled]) {
//                btn.enabled=NO;
//            }
//        }
        if (i==2||i==3) {
            if (![WXApi isWXAppInstalled]) {
                btn.enabled = NO;
            }
        }
    }
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setFrame:CGRectMake(0, FanShareViewHight-45, kWidth, 45)];
    cancelBtn.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:cancelBtn];

}
-(void)shareBtnClick:(UIButton*)btn{
    if ([_delegate respondsToSelector:@selector(superShareView:buttonIndex:)]) {
        [_delegate superShareView:self buttonIndex:btn.tag-100];
    }
    self.delegate=nil;
    [self removeFromSuperview];
    
}
-(void)show{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - 移除View
-(void)removeSelfView{
    [_shareView setFrame:CGRectMake(0, kHeight, kWidth, FanShareViewHight)];
//    _shareView.alpha=0;
    [_shareView.layer addAnimation:[FanAnimationToll fan_transitionAnimationWithSubType:kCATransitionFromBottom withType:kCATransitionMoveIn duration:0.3f] forKey:@"animation"];
    
    self.blackAlphView.alpha=0;
    [self.blackAlphView.layer addAnimation:[FanAnimationToll fan_transitionAnimationWithSubType:kCATransitionFromBottom withType:kCATransitionFade duration:0.3f] forKey:@"animation"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3f];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint=[[touches anyObject]locationInView:self];
    if (touchPoint.y<kHeight-FanShareViewHight) {
        [self removeSelfView];
    }
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
