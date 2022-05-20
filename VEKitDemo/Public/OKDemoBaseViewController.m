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
