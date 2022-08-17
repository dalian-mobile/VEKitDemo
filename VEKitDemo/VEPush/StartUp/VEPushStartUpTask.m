//
//  VEPushStartUpTask.m
//  App
//
//  Created by yifei Feng on 2022/5/24.
//

#import "VEPushStartUpTask.h"
#import <OneKit/OKStartUpFunction.h>
#import <OneKit/OKApplicationInfo.h>
#import "VEPushDelegate.h"
#import <VEPush/VEPushService.h>

OKAppTaskAddFunction () {
    [[VEPushStartUpTask new] scheduleTask];
}

@implementation VEPushStartUpTask

- (void)startWithLaunchOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [VEPushService registerApnsTokenWithDelegate: [VEPushDelegate new]];
}

@end
