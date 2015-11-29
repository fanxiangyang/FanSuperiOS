//
//  ViewController.m
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/4.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import "ViewController.h"
#import "FanRotateMenuView.h"
#import "FanGesturePasswordViewController.h"
#import "Fan3DTouchViewController.h"
#import "FanSwiperBleViewController.h"
#import "FanShareViewController.h"

@interface ViewController ()<FanRotateMenuViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    
    self.view.backgroundColor=[UIColor colorWithRed:77.0/255.0 green:208.0/255.0 blue:201.0/255.0 alpha:1];
    
    
    NSArray *dataArray = @[@"image_tencent_qq.png", @"Sina_share.png", @"FaceBook_share.png", @"WeiXin_share.png", @"Twitter_share.png"];
    
    FanRotateMenuView *rotateMenuView=[[FanRotateMenuView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width) imageArray:[dataArray mutableCopy]];
    rotateMenuView.delegate=self;
//    rotateMenuView.backgroundColor=[UIColor colorWithRed:77.0/255.0 green:208.0/255.0 blue:201.0/255.0 alpha:1];
    [self.view addSubview:rotateMenuView];
    
    [self.view fan_addConstraintsCenter:rotateMenuView viewSize:CGSizeMake(kWidth, kWidth)];
    
//     Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - FanRotateMenuViewDelegate
-(void)fan_RotateButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            //密码解锁
            FanGesturePasswordViewController *passVC=[[FanGesturePasswordViewController alloc]init];
            [self.navigationController pushViewController:passVC animated:YES];
            
        }
            break;
        case 1:
        {
            Fan3DTouchViewController *touchVC=[[Fan3DTouchViewController alloc]init];
            [self.navigationController pushViewController:touchVC animated:YES];
        }
            break;

        case 2:
        {
            FanSwiperBleViewController *swipVC=[[FanSwiperBleViewController alloc]init];
            [self.navigationController pushViewController:swipVC animated:YES];
        }
            break;

        case 3:
        {
            FanShareViewController *shareVC=[[FanShareViewController alloc]initWithNibName:@"FanShareViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:shareVC animated:YES];
        }
            break;
        case 4:
        {
            
        }
            break;

            
        default:
            break;
    }}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
