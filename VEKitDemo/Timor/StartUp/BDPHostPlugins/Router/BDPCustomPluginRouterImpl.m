//
//  BDPCustomPluginRouterImpl.m
//  App
//
//  Created by gejunchen.ChenJr on 2022/2/18.
//

#import "BDPCustomPluginRouterImpl.h"

#import <Timor/BDPTimorClient.h>
#import <Timor/BDPRouterPluginDelegate.h>

@interface BDPCustomPluginRouterImpl () <BDPRouterPluginDelegate>

@end

@implementation BDPCustomPluginRouterImpl

+ (id<BDPBasePluginDelegate>)sharedPlugin {
    static id<BDPBasePluginDelegate> instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (BOOL)bdp_openSchemaWithURL:(NSURL *)URL userInfo:(NSDictionary *)userInfo {
    return [[BDPTimorClient sharedClient] openWithURL:URL];
}

@end
