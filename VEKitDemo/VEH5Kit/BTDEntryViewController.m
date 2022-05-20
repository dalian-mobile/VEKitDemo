//
//  BTDEntryViewController.m
//  App
//
//  Created by bytedance on 2021/4/27.
//

#import "BTDEntryViewController.h"
#import "BTDViewController.h"
#import "BDNativeWebViewController.h"
#import "BDWebPreloadDemoViewController.h"
#import <VEH5Kit/VEH5KitManager.h>
#import "OKDebugToast.h"
#import "BDBlankDetectViewController.h"

#if __has_include(<FLEX/FLEXManager.h>)
#import <FLEX/FLEXManager.h>
#endif

@interface BTDEntryViewController ()

@end

@implementation BTDEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"H5容器Demo";
#if __has_include(<FLEX/FLEXManager.h>)
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"FLEX" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
#endif

}

- (void)rightBarButtonAction {
#if __has_include(<FLEX/FLEXManager.h>)
    [[FLEXManager sharedManager] showExplorer];
#endif
}

#pragma mark - getter
// 重写父类的getter
- (NSMutableArray *)feedModels {
    NSMutableArray *models = [super feedModels];
    if (!models) {
        __weak typeof(self) wself = self;
        NSArray *tmpModels = @[
            [[BDModelSectionHeader alloc] initWithSectionName:@"功能测试" desc:@""],
            [[BDFeedModel alloc] initWithTitle:@"调试页面" actionBlock:^{
                __auto_type vc = [BTDViewController new];
                vc.btd_type = BTDDebugType_debug;
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            [[BDFeedModel alloc] initWithTitle:@"示例页面" actionBlock:^{
                __auto_type vc = [BTDViewController new];
                vc.btd_type = BTDDebugType_example;
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            [[BDFeedModel alloc] initWithTitle:@"示例页面(离线化)" actionBlock:^{
                __auto_type vc = [BTDViewController new];
                vc.btd_type = BTDDebugType_example;
                vc.offlineEnable = YES;
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            [[BDFeedModel alloc] initWithTitle:@"清理平台离线包" actionBlock:^{
                [[VEH5KitManager sharedInstance] clearOfflineResources];
                [self.view bds_toastShow:@"已清除平台离线包"];
            }],
            [[BDFeedModel alloc] initWithTitle:@"同层渲染(图片)" actionBlock:^{
                BDNativeWebViewController *vc = [BDNativeWebViewController new];
                vc.type = BDNativeWebViewControllerTypeImage;
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            [[BDFeedModel alloc] initWithTitle:@"同层渲染(视频)" actionBlock:^{
                BDNativeWebViewController *vc = [BDNativeWebViewController new];
                vc.type = BDNativeWebViewControllerTypeVideo;
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            [[BDFeedModel alloc] initWithTitle:@"资源预加载" actionBlock:^{
                BDWebPreloadDemoViewController *vc = [BDWebPreloadDemoViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            [[BDFeedModel alloc] initWithTitle:@"白屏检测" actionBlock:^{
                BDBlankDetectViewController *vc = [BDBlankDetectViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            }]
        ];
        
        
        models = [NSMutableArray arrayWithArray:tmpModels];
        [self setFeedModels:models];
    }
    return models;
}

@end
