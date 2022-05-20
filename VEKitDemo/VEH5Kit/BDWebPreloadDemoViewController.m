//
//  BDWebPreloadDemoViewController.m
//  BDWebKit_Example
//
//  Created by wealong on 2020/1/5.
//  Copyright © 2020 li keliang. All rights reserved.
//

#import "BDWebPreloadDemoViewController.h"


#if __has_include(<VEH5Kit/BDWebViewOfflineManager.h>)
#import <VEH5Kit/BDWebViewPreloadManager.h>
#else
#import <BDPreloadSDKToB/BDWebViewPreloadManager.h>
#endif

#import <VEH5Kit/VEH5Kit.h>



@interface BDWebPreloadDemoViewController ()

@property (strong, nonatomic) VEH5WebView *webView;

@end

@implementation BDWebPreloadDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *preloadArray = @[@"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/ed6c66e56ceff59a786e861c7c8d3873a6e0081d/pages/_app.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/ed6c66e56ceff59a786e861c7c8d3873a6e0081d/pages/home.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/runtime/webpack-f2bb5d9d0894ed2bf86f.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/chunks/framework.02051909e0f1ada25890.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/chunks/a7078b245d75f5bdb956f005252af8f4613f8046.b6400ba11cdeb1e7bb78.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/chunks/a2f8c104e10ad0758ca4e0abe352a84157efb219.29298ea9b270e4ce2c08.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/chunks/53c722d2c2810f389b2466dae31b9fa651ff1c55.f11877f42ab5098b0bb7.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/chunks/a3f3ff8e4e00ef753a12fd7bce874dedeaf8fd66.523dd40259c6a6e7de00.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/chunks/2086989f800cec60732d4c550d0b1306cdc13fa7.1218ff5c6854c2454f53.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/runtime/main-39263248c98a1e40cbcf.js",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/images/3-9ea22bd593086f432ab75ee6c95c37de.png",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/images/0-390b5def140dc370854c98b8e82ad394.png",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/images/1-b4afd269ffb0ba19bd1dd33e3ed5cec3.png",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/images/2-468bb0555d827d48bce4e178f085bf90.png",
                              @"https://lf1-cdn-tos.bytescm.com/obj/static/ies/bytedance_official/_next/static/images/zh-5-ae0af3f048628a4a6703d58084a28014.jpg",
                              @""];
    for (NSString *preloadRes in preloadArray) {
        [[BDWebViewPreloadManager sharedInstance] fetchDataForURLString:preloadRes headerField:@{} cacheDuration:60 * 60 queuePriority:NSOperationQueuePriorityNormal completion:^(NSError * _Nonnull error) {
            if (error) {
                NSLog(@"[MARS]:preload %@ error %@", preloadRes, error);
            }else{
                NSLog(@"[MARS]:preload %@ success %@", preloadRes, error);
            }
        }];
    }
    
//    self.webView = [BDWKPrecreator.defaultPrecreator takeWebView];
    self.webView = [[VEH5WebView alloc] initWithFrame:self.view.bounds withOfflineEnable:YES];
//    self.webView.frame = self.view.bounds;
    [self.view addSubview:self.webView];
    NSString *TESTURL = nil;
    TESTURL = @"https://www.bytedance.com/"; // 如果 response header 有问题页面会有问题
    [[BDWebViewPreloadManager sharedInstance] fetchDataForURLString:TESTURL headerField:@{} cacheDuration:60 * 60 queuePriority:NSOperationQueuePriorityNormal completion:^(NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:TESTURL]]];
        });
    }];
}


@end
