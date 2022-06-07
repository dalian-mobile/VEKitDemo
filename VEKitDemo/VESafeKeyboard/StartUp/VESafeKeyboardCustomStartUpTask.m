//
//  VESafeKeyboardCustomStartUpTask.m
//  App
//
//  Created by yifei Feng on 2022/5/26.
//

#import "VESafeKeyboardCustomStartUpTask.h"
#import <OneKit/OKStartUpFunction.h>
#import <OneKit/OKApplicationInfo.h>
#import <VESafeKeyboard/VESafeKeyboardManager.h>

OKAppTaskAddFunction () {
    [[VESafeKeyboardCustomStartUpTask new] scheduleTask];
}

@implementation VESafeKeyboardCustomStartUpTask

- (instancetype) init {
    self = [super init];
    if (self) {
        self.offering = [NSSet setWithArray:@[@protocol(VESafeKeyboardProtocol)]];
    }
    return self;
}

- (void)startWithLaunchOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    VESafeKeyboardManager *manager = [VESafeKeyboardManager sharedInstance];
    [manager enableDebug:YES];
    [manager setStartCallback:^(NSError * _Nonnull error) {
        NSLog(@"CustomCallback: VESafeKeyboard init failed.");
    }];
}

@end
