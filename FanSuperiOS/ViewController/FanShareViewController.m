//
//  FanShareViewController.m
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/6.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import "FanShareViewController.h"
#import "FanSuperShareView.h"
#import "FanThreeLoginManager.h"

@interface FanShareViewController ()<FanThreeLoginManagerDelegate,FanSuperShareViewDelegate>

@end

@implementation FanShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.qqIamgeView.tag=100;
    [self fan_addTapGestureTarget:self action:@selector(tapLogin:) toView:self.qqIamgeView];
    self.weixinImageView.tag=101;
    [self fan_addTapGestureTarget:self action:@selector(tapLogin:) toView:self.weixinImageView];
    self.weiboImageView.tag=102;
    [self fan_addTapGestureTarget:self action:@selector(tapLogin:) toView:self.weiboImageView];
    self.facebookImageView.tag=103;
    [self fan_addTapGestureTarget:self action:@selector(tapLogin:) toView:self.facebookImageView];
    self.twitterImageView.tag=104;
    [self fan_addTapGestureTarget:self action:@selector(tapLogin:) toView:self.twitterImageView];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)tapLogin:(UIGestureRecognizer *)tap{
    switch (tap.view.tag-100) {
        case 0:
        {
            [[FanThreeLoginManager standardManager]loginType:FanLoginTypeQQ delegate:self];
        }
            break;
        case 1:
        {
            [[FanThreeLoginManager standardManager]loginType:FanLoginTypeWX delegate:self];
        }
            break;
        case 2:
        {
            [[FanThreeLoginManager standardManager]loginType:FanLoginTypeWeibo delegate:self];
        }
            break;
        case 3:
        {
            [FanThreeLoginManager standardManager].weak_ThreeLoginVC=self;
            [[FanThreeLoginManager standardManager]loginType:FanLoginTypeFacebook delegate:self];
        }
            break;
        case 4:
        {
            [[FanThreeLoginManager standardManager]loginType:FanLoginTypeTwitter delegate:self];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 第三方管理类的回调
-(void)fanLoginResponse:(id)response type:(FanLoginType)loginType{
    NSString *str=[NSString stringWithFormat:@"第三方登录成功：%@",response];
    ShowMessage(str)
}
-(void)fanShareResponse:(id)response type:(FanLoginType)loginType{
    ShowMessage(@"分享成功")
}

#pragma mark - FanSuperShareViewDelegate
-(void)superShareView:(FanSuperShareView *)shareView buttonIndex:(NSInteger)buttonIndex{
    NSString *urlStr=[NSString stringWithFormat:@"https://github.com/fanxiangyang"];
    FanShareModel *shareModel=[[FanShareModel alloc]initWithShareTitle:@"分享标题" shareDescription:@"分享内容" shareLink:urlStr shareImageURl:nil];
    shareModel.appendText=@"分享来自iOS版";
    [FanThreeLoginManager standardManager].weak_ThreeLoginVC=self;
    [[FanThreeLoginManager standardManager]shareModel:shareModel type:buttonIndex+1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareClick:(id)sender {
    [FanSuperShareView showShareView:self];
    
}
@end
