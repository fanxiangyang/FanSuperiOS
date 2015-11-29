//
//  FanGesturePasswordViewController.m
//  
//
//  Created by 向阳凡 on 15/7/2.
//
//

#import "FanGesturePasswordViewController.h"

@interface FanGesturePasswordViewController ()

@end

@implementation FanGesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:39/255.0 blue:54/255.0 alpha:1];
    FanGesturePasswordView *gpView=[[FanGesturePasswordView alloc]init];
                                    //WithFrame:CGRectMake(20, 100, kWidth_GP-40, kWidth_GP-40)];
    gpView.delegate=self;
    gpView.fan_LineColor=[UIColor yellowColor];
    [self.view addSubview:gpView];
    
    [self.view fan_addConstraintsCenter:gpView viewSize:CGSizeMake(kWidth-40, kWidth-40)];
    
    // Do any additional setup after loading the view.
}
-(void)fanGesturePasswordView:(FanGesturePasswordView *)gesturePasswordView didEndDragWithPassword:(NSString *)password{
    NSLog(@"密码：%@",password);
    if ([password isEqualToString:@"1375"]) {
        gesturePasswordView.viewState=FanLockNodeViewStateSuccess;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        gesturePasswordView.viewState=FanLockNodeViewStateWarning;
    }
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
