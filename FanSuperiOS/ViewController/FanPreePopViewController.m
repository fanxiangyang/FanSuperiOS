//
//  FanPreePopViewController.m
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/5.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import "FanPreePopViewController.h"

@interface FanPreePopViewController ()<UIPreviewActionItem>

@property(nonatomic,strong)UIImageView *touchImageView;

@end

@implementation FanPreePopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchImageView=[[UIImageView alloc]init];//WithFrame:CGRectMake(0, 0, 300, 400)];
    self.touchImageView.userInteractionEnabled=YES;
    self.touchImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.touchImageView.backgroundColor=[UIColor orangeColor];
    self.touchImageView.clipsToBounds=YES;
    self.touchImageView.image=[UIImage imageNamed:@"peerImage.png"];
    [self.view addSubview:self.touchImageView];
    
    
    [self.view fan_addConstraints:self.touchImageView edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0) layoutType:FanLayoutAttributeAll viewSize:CGSizeMake(0, 0)];

    // Do any additional setup after loading the view.
}
-(NSArray<id<UIPreviewActionItem>>*)previewActionItems{
    UIPreviewAction *shareAction=[UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    UIPreviewAction *shareAction1=[UIPreviewAction actionWithTitle:@"赞" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    UIPreviewAction *shareAction2=[UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    return @[shareAction,shareAction1,shareAction2];
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

@end
