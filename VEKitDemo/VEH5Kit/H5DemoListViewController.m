//
//  H5DemoListViewController.m
//  App
//
//  Created by bytedance on 2022/2/18.
//

#import "H5DemoListViewController.h"
#import "JSBridgeDemoListViewController.h"
#import "OffLineDemoViewController.h"
#import "BDNativeWebViewController.h"
#import "BDBlankDetectViewController.h"
#import "BDWebPreloadDemoViewController.h"

#import <OneKit/OKSectionData.h>

OK_STRINGS_EXPORT("OKDemoEntryItem","H5DemoListViewController")


@interface H5DemoListViewController ()

@end

@implementation H5DemoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"H5服务";
    // Do any additional setup after loading the view.
}

- (NSString *)title
{
    return @"H5服务";
}

- (NSString *)iconName
{
    return @"demo_h5";
}

- (NSArray<OKListCellModel *> *)models
{
    NSArray *nativecomps = @[[[OKListCellModel alloc] initWithTitle:@"同层渲染(图片)" imageName:@"stack" jumpVC:[BDNativeWebViewController  class]],
                             [[OKListCellModel alloc] initWithTitle:@"同层渲染(视频)" imageName:@"stack" jumpVC:[BDNativeWebVideoViewController class]]
    ];
    
    NSArray *otherComps = @[[[OKListCellModel alloc] initWithTitle:@"白屏检测" imageName:@"hotfix" jumpVC:[BDBlankDetectViewController                           class]],
                             [[OKListCellModel alloc] initWithTitle:@"预加载" imageName:@"hotfix" jumpVC:[BDWebPreloadDemoViewController class]]
    ];
    
    return @[[[OKListCellModel alloc] initWithTitle:@"离线包" imageName:@"package" jumpVC:[OffLineDemoViewController class]],
    [[OKListCellModel alloc] initWithTitle:@"JSBridge" imageName:@"jsb" jumpVC:[JSBridgeDemoListViewController class]],
    [[OKListCellModel alloc] initWithTitle:@"同层渲染" subTitle:nil imageName:@"stack" jumpVC:[OKListViewController class] jumpModels:nativecomps],
    [[OKListCellModel alloc] initWithTitle:@"其它工具" subTitle:nil imageName:@"hotfix" jumpVC:[OKListViewController class] jumpModels:otherComps],
    ];
}

@end
