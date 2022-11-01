//
//  VERemoteConfigListViewController.m
//  App
//
//  Created by Ada on 2022/3/17.
//

#import "VERemoteConfigListViewController.h"
# if __has_include(<VERemoteConfig/VERemoteConfigManager.h>)

#import "VERemoteConfigViewController.h"
#import "VERemoteConfig/TestPageViewController.h"

#import <OneKit/OKSectionData.h>

OK_STRINGS_EXPORT("OKDemoEntryItem","VERemoteConfigListViewController")



@interface VERemoteConfigListViewController ()

@end

@implementation VERemoteConfigListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"远程配置";
    // Do any additional setup after loading the view.
}

- (NSString *)title
{
    return @"远程配置";
}

- (NSString *)iconName
{
    return @"demo_config";
}


- (NSArray<OKListCellModel *> *)models
{
    return @[[[OKListCellModel alloc] initWithTitle:@"配置发布测试页面" imageName:@"rc1" jumpVC:[TestPageViewController class]],
    [[OKListCellModel alloc] initWithTitle:@"API调用测试" imageName:@"rc2" jumpVC:[VERemoteConfigViewController class]],
    ];
}

@end
#else
@implementation VERemoteConfigListViewController
@end
#endif
