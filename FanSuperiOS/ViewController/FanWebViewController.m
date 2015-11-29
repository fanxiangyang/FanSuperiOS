//
//  FanWebViewController.m
//  FanSuperiOS
//
//  Created by 向阳凡 on 15/11/6.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import "FanWebViewController.h"
#import "FanProgress3D.h"

@interface FanWebViewController ()<UIWebViewDelegate>

@end

@implementation FanWebViewController
{
    UIWebView *_webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //刷新按钮
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWebView)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;//对webView有影响
    
    NSURL *url=[NSURL URLWithString:_zbarUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-49)];
    //_webView.backgroundColor=[UIColor redColor];
    _webView.delegate=self;
    //_webView.opaque=NO;
    _webView.scalesPageToFit=YES;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    [self.view fan_addConstraints:_webView edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0) layoutType:FanLayoutAttributeAll viewSize:CGSizeMake(0, 0)];
    

    // Do any additional setup after loading the view.
}
//刷新
-(void)refreshWebView{
    [_webView reload];
}
#pragma mark - uiwebview delegate
//开始加载
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [FanProgress3D showInView:self.view status:@"加载中...."];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [FanProgress3D dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [FanProgress3D dismissWithStatus:@"请检查网络，刷新或返回重试" afterDelay:3];
}
-(void)dealloc{
    [FanProgress3D dismiss];
    _webView.delegate=nil;
    [_webView stopLoading];
    [_webView removeFromSuperview];
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
