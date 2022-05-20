//
//  VEInstallTestViewController.m
//  App
//
//  Created by KiBen on 2021/10/14.
//

#import "VEInstallTestViewController.h"
#import "VEInstallResultViewController.h"
#import <VEInstall/VEInstallURLChina.h>
#import <OneKit/OKApplicationInfo.h>
#import "OKDemoBaseViewController.h"

@interface VEInstallTestViewController ()<OKDemoEntryItemProtocol>

@end

@implementation VEInstallTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    VEInstallConfig *config = [VEInstallConfig sharedInstance];
    config.appID = @"189693";
    config.channel = @"local test";
    config.name = @"VEInstallDemo";
    config.userUniqueID = @"1086";
    config.encryptEnable = NO;
    config.URLService = [VEInstallURLChina class];
    config.customHeaderBlock = ^NSDictionary<NSString *,id> *{
        return @{
            @"key1" : @"value1"
        };
    };
}

- (NSString *)title
{
    return @"设备注册组件";
}

- (NSString *)iconName
{
    return @"debug";
}

#pragma mark - getter
// 重写父类的getter
- (NSMutableArray *)feedModels {
    NSMutableArray *models = [super feedModels];
    if (!models) {
        __weak typeof(self) wself = self;
        NSArray *tmpModels = @[
            [[BDModelSectionHeader alloc] initWithSectionName:@"功能测试" desc:@""],
            [[BDFeedModel alloc] initWithTitle:@"全局实例" actionBlock:^{
                __auto_type vc = [[VEInstallResultViewController alloc] init];
                vc.install = [VEInstallManager defaultInstall];
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            [[BDFeedModel alloc] initWithTitle:@"多实例场景获取" actionBlock:^{
                __auto_type vc = [[VEInstallResultViewController alloc] init];
                vc.install = [VEInstallManager installForAppID:@"189693"];
                [wself.navigationController pushViewController:vc animated:YES];
            }],
        ];
        
        models = [NSMutableArray arrayWithArray:tmpModels];
        [self setFeedModels:models];
    }
    return models;
}
@end
