//
//  JSBridgeDemoListViewController.m
//  App
//
//  Created by bytedance on 2022/2/18.
//

#import "JSBridgeDemoListViewController.h"
#import "WebViewDemoViewController.h"
#if __has_include(<VEH5Kit/OKUnifyBridgeAuthManager.h>)
#import <VEH5Kit/OKUnifyBridgeAuthManager.h>
#import <VEH5Kit/OKJSBridgeAuthManager.h>
#import <VEH5Kit/OKBridgeAuthModel.h>
#else
#import <OKJSBridgeToB/OKUnifyBridgeAuthManager.h>
#import <OKJSBridgeToB/OKJSBridgeAuthManager.h>
#import <OKJSBridgeToB/OKBridgeAuthModel.h>
#endif

#import <OneKit/OKServices.h>
#import <OneKit/OKApplicationInfo.h>
#import <OneKit/OKStartUpFunction.h>
#import <OneKit/OKServiceCenter.h>
#import "OKDebugInfoViewController.h"

@interface JSBridgeDemoListViewController ()

@end

@implementation JSBridgeDemoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"JSBridge";

}

- (void)requestJSB
{
    return;
    OKApplicationInfo *info = [OKApplicationInfo sharedInstance];
    NSString *evn = info.isInhouseApp ? @"1" : @"2";
    
    __block id<OKDeviceService> deviceService = [[OKServiceCenter sharedInstance] serviceForProtocol:@protocol(OKDeviceService)];
    NSDictionary *data = @{@"app_id" : info.appID,
                           @"env":evn,
                           @"os":@"2",
                           @"did":deviceService.deviceID ?: @"1"
    };
    [OKUnifyBridgeAuthManager configureWithAuthDomain:info.serviceInfo[@"services"][@"h5"][@"js_host"]
                                            accessKey:info.accessKey
                                            secretKey:info.secretKey
                                         commonParams:^NSDictionary *{
        return data;
    }];
    
}

- (NSString *)jsbRules
{
    OKJSBridgeAuthManager *manager = [OKJSBridgeAuthManager sharedManager];
    OKBridgeAuthPackage *pkg = [manager valueForKey:@"authPackage"];
    NSMutableDictionary *rules = [[NSMutableDictionary alloc] init];
    [pkg.content enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<OKBridgeAuthRule *> * _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
        [obj enumerateObjectsUsingBlock:^(OKBridgeAuthRule * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            rule[@"pattern"] = obj.pattern;
            rule[@"group"] = @[@"public",@"protected",@"private",@"secure"][obj.group];
            rule[@"includedMethods"] = obj.includedMethods;
            rule[@"excludedMethods"] = obj.excludedMethods;
        }];
        rules[key] = rule;
    }];
    
    return [NSString stringWithFormat:@"%@",rules];
}


- (NSString *)jsbMethods
{
    OKJSBridgeAuthManager *manager = [OKJSBridgeAuthManager sharedManager];
    NSMutableSet<NSString *> *publicMethods = [manager valueForKey:@"publicMethods"];
    NSMutableSet<NSString *> *protectedMethods = [manager valueForKey:@"protectedMethods"];
    NSMutableSet<NSString *> *privateMethods = [manager valueForKey:@"privateMethods"];
    NSString *result = [NSString stringWithFormat:@"publicMethods:%@ \n protectedMethods:%@ \n privateMethods:%@ \n",publicMethods,protectedMethods,privateMethods];
    
    return result;
}

- (NSArray<OKListCellModel *> *)models
{
    __weak typeof(self) weakSelf = self;
    return @[[[OKListCellModel alloc] initWithTitle:@"JSBridge调试页" imageName:@"debug" actionBlock:^{
                WebViewDemoViewController *webVC = [[WebViewDemoViewController alloc] init];
                webVC.url = @"https://mars-jsbridge.goofy-web.bytedance.com/debug#/";
                webVC.offlineEnable = NO;
                [self.navigationController pushViewController:webVC animated:YES];
             }],
             [[OKListCellModel alloc] initWithTitle:@"JSBridge默认示例" imageName:@"tag" actionBlock:^{
                 WebViewDemoViewController *webVC = [[WebViewDemoViewController alloc] init];
                 webVC.url = @"https://mars-jsbridge.goofy-web.bytedance.com/example#/";
                 webVC.offlineEnable = NO;
                 [self.navigationController pushViewController:webVC animated:YES];

             }],
//             [[OKListCellModel alloc] initWithTitle:@"JSBridge权限拉取" imageName:@"upload" actionBlock:^{
//                 [weakSelf requestJSB];
//             }],
             [[OKListCellModel alloc] initWithTitle:@"当前JSBridge权限" imageName:@"auth" actionBlock:^{
                 OKDebugInfoViewController *vc = [[OKDebugInfoViewController alloc] init];
                 vc.content = [weakSelf jsbRules];
                 vc.title = @"当前JSBridge权限";
                 [self.navigationController pushViewController:vc animated:YES];
             }],
             [[OKListCellModel alloc] initWithTitle:@"当前已注册JSBridge" imageName:@"people" actionBlock:^{
                 OKDebugInfoViewController *vc = [[OKDebugInfoViewController alloc] init];
                 vc.content = [weakSelf jsbMethods];
                 vc.title = @"JSBridge方法列表";
                 [self.navigationController pushViewController:vc animated:YES];
             }],
    ];
}


@end
