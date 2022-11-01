//
//  APMStartUpTask.m
//  App
//
//  Created by bytedance on 2021/4/25.
//

#import "APMStartUpTask.h"
#import <RangersAPM/RangersAPM.h>
#import <RangersAPM/RangersAPM+DebugLog.h>
#import <OneKit/OKStartUpFunction.h>
#import <OneKit/OKApplicationInfo.h>

# ifndef APP_ID_FOR_RANGERS_APM
# define APP_ID_FOR_RANGERS_APM info.appID
# endif

OKAppTaskAddFunction () {
    [[APMStartUpTask new] scheduleTask];
}


@implementation APMStartUpTask


- (instancetype)init {
    self = [super init];
    if (self) {
        self.dependencies = [NSSet setWithArray:@[@protocol(OKPrivacyGrantNode)]];
    }
    
    return self;
}

- (void)startWithLaunchOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    OKApplicationInfo *info = [OKApplicationInfo sharedInstance];
    // APM Init
    RangersAPMConfig *apmConfig = [RangersAPMConfig configWithAppID:APP_ID_FOR_RANGERS_APM];
    apmConfig.channel = info.channel;
    apmConfig.deviceIDSource = RAPMDeviceIDSourceFromAPMService;
    
    // APM Log
    [RangersAPM allowDebugLogUsingLogger:nil];
    [RangersAPM startWithConfig:apmConfig];
}
@end
