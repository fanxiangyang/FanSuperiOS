//
//  FanShareViewController.h
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/6.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FanShareViewController : UIViewController
- (IBAction)shareClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *qqIamgeView;
@property (weak, nonatomic) IBOutlet UIImageView *weixinImageView;
@property (weak, nonatomic) IBOutlet UIImageView *weiboImageView;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImageView;

@end
