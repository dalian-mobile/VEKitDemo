//
//  BDPOKCustomStartUpTask.m
//  App
//
//  Created by gejunchen.ChenJr on 2022/2/18.
//

#import "BDPOKDemoStartUpTask.h"


#import "BDPCustomPluginLogImpl.h"
#import "BDPCustomPluginRouterImpl.h"
#import "BDPCustomPluginBasicInfoImpl.h"

#import <Timor/BDPTimorClientHostPlugins.h>

OKAppTaskAddFunction() {
    [[BDPOKDemoStartUpTask new] scheduleTask];
}

@implementation BDPOKDemoStartUpTask

- (void)startWithLaunchOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions
{
    BDPTimorClientHostPlugins.logPlugin = BDPCustomPluginLogImpl.class;
    BDPTimorClientHostPlugins.routerPlugin = BDPCustomPluginRouterImpl.class;
    BDPTimorClientHostPlugins.basicInfoPlugin = BDPCustomPluginBasicInfoImpl.class;
}

@end
