//
//  OKStartUpUITask.m
//  OKStartUp
//
//  Created by chenshu on 2020/5/7.
//

#import "OKStartUpUITask.h"
#import "OKFeedViewController.h"

#import <OneKit/OKStartUpFunction.h>
#import "OKMainViewController.h"

OKAppTaskAddFunction () {
    [[OKStartUpUITask new] scheduleTask];
}

@implementation OKStartUpUITask

- (void)startWithLaunchOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.rootViewController = [self rootVC];
        [window makeKeyAndVisible];
        [UIApplication sharedApplication].delegate.window = window;
    });
}

- (UIViewController *)rootVC {
    Class claszz = NSClassFromString(@"VEMainTabBarController");
    if (claszz) {
        return [claszz new];
    }
    claszz = [OKMainViewController class];
    return [[UINavigationController alloc] initWithRootViewController:[claszz new]];
}

@end
