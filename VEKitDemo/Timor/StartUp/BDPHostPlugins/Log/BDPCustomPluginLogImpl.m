//
//  BDPCustomPluginLogImpl.m
//  App
//
//  Created by gejunchen.ChenJr on 2022/2/18.
//

#import "BDPCustomPluginLogImpl.h"

#import <Timor/BDPLogPluginDelegate.h>

@interface BDPCustomPluginLogImpl () <BDPLogPluginDelegate>

@end

@implementation BDPCustomPluginLogImpl

+ (id<BDPBasePluginDelegate>)sharedPlugin
{
    static dispatch_once_t onceToken;
    static BDPCustomPluginLogImpl *logImpl = nil;
    dispatch_once(&onceToken, ^{
        logImpl = [[BDPCustomPluginLogImpl alloc] init];
    });
    return logImpl;
}

- (void)bdp_logWithModel:(BDPLogModel *)model {
    NSLog(@"%s %s %d %@", model.filename, model.funcName, model.line, model.content);
}

@end
