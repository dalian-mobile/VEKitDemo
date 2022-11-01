//
//  OKDemoBaseViewController.m
//  App
//
//  Created by bytedance on 2022/2/18.
//

#import "OKDemoBaseViewController.h"

@interface OKDemoBaseViewController ()

@end

@implementation OKDemoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backButtonTitle = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    
//
//    //去除文字
//     [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMax) forBarMetrics:UIBarMetricsDefault];
//     //设置返回图片，防止图片被渲染变蓝，以原图显示
//
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//    NSString *bundleURL = [bundle pathForResource:@"Public"
//                                                          ofType:@"bundle"];
//    NSBundle *podBundle = [NSBundle bundleWithPath:bundleURL];
//    UIImage *backImage = [[UIImage imageNamed:@"back" inBundle:podBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//     [UINavigationBar appearance].backIndicatorTransitionMaskImage = backImage;
//     [UINavigationBar appearance].backIndicatorImage = backImage;
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage;
//    self.navigationController.navigationBar.backIndicatorImage = backImage;
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
