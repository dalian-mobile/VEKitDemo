//
//  BDTestIntroducerViewController.m
//  rangersAppLogObjCExample
//
//  Created by 朱元清 on 2020/8/17.
//  Copyright © 2020 bytedance. All rights reserved.
//  各测试项的分流入口

#import "BDFeedModel.h"
#import "BDFeedModelDictionary.h"
#import "BDTesterControllers.h"
#import <AdSupport/AdSupport.h>
//#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <RangersAppLog/RangersAppLog.h>

#import "OKDemoBaseViewController.h"

#import <OneKit/OKSectionData.h>

OK_STRINGS_EXPORT("OKDemoEntryItem","BDTestIntroducerViewController")


@interface BDTestIntroducerViewController ()

@end

static NSString *cellReuseID = @"testIntro_1";

@implementation BDTestIntroducerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航首页";
    
//    BDAutoTrackAuthorizationStatus status = [BDAutoTrackIDFA authorizationStatus];
    [BDAutoTrackIDFA requestAuthorizationWithHandler:^(BDAutoTrackAuthorizationStatus status) {
        NSLog(@"%@", @(status));
    }];
    NSString *idfa = [ASIdentifierManager.sharedManager advertisingIdentifier].UUIDString;
    NSLog(@"%@", idfa);
}


- (NSString *)title
{
    return @"埋点上报";
}

- (NSString *)iconName
{
    return @"demo_applog";
}



#pragma mark - getter
// 重写父类的getter
- (NSMutableArray *)feedModels {
    NSMutableArray *models = [super feedModels];
    if (!models) {
        __weak typeof(self) wself = self;
        NSArray *tmpModels = @[
            [[BDModelSectionHeader alloc] initWithSectionName:@"功能测试" desc:@""],
            [[BDFeedModel alloc] initWithTitle:@"测试DataFinder功能" actionBlock:^{
                __auto_type vc = [[BDFinderTesterImp alloc] init];
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            [[BDFeedModel alloc] initWithTitle:@"测试DataPlayer功能" actionBlock:^{
                __auto_type vc = [[BDPlayerTesterImp alloc] init];
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            
            [[BDModelSectionHeader alloc] initWithSectionName:@"兼容性测试" desc:@""],
            [[BDFeedModel alloc] initWithTitle:@"测试UI库兼容性" actionBlock:^{
                __auto_type vc = [[BDUICompatibilityTesterSuite alloc] init];
                [wself.navigationController pushViewController:vc animated:YES];
            }],
            
            [[BDModelSectionHeader alloc] initWithSectionName:@"H5相关测试" desc:@""],
            [[BDFeedModel alloc] initWithTitle:@"内嵌H5页面走原生上报" actionBlock:^{
                __auto_type vc = [[BDNativeH5TesterImpViewController alloc] init];
                [wself.navigationController pushViewController:vc animated:YES];
            }]
        ];
        
        models = [NSMutableArray arrayWithArray:tmpModels];
        [self setFeedModels:models];
    }
    return models;
}


@end
