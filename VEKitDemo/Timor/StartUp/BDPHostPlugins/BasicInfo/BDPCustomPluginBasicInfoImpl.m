//
//  BDPCustomPluginBasicInfoImpl.m
//  App-Debug
//
//  Created by gejunchen.ChenJr on 2022/5/8.
//

#import "BDPCustomPluginBasicInfoImpl.h"

#import <Timor/BDPBasicInfoPluginDelegate.h>

#import <OneKit/OKServices.h>
#import <OneKit/OKServiceCenter.h>
#import <OneKit/OKApplicationInfo.h>

@interface BDPCustomPluginBasicInfoImpl () <BDPBasicInfoPluginDelegate>

@end

@implementation BDPCustomPluginBasicInfoImpl

+ (id<BDPBasePluginDelegate>)sharedPlugin
{
    static id<BDPBasePluginDelegate> instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (NSDictionary *)bdp_registerApplicationInfo
{
    return @{
        BDPAppNameKey : OKApplicationInfo.sharedInstance.appName,
        BDPAppVersionKey : OKApplicationInfo.sharedInstance.appVersion
    };
}

- (NSString *)bdp_appId
{
    return OKApplicationInfo.sharedInstance.appID;
}

- (NSString *)bdp_deviceId
{
    // can change it to your own device system
    id<OKDeviceService> deviceService = OK_CENTER_OBJECT(OKDeviceService);
    return deviceService.deviceID;
}

- (void)onSDKLicenseVerifyFail:(NSError *)error
{
    NSLog(@"verify error: %@",error);
}

@end
