//
//  TTViewController.m
//  TTAppUpdateHelper
//
//  Created by bytedance on 04/11/2018.
//  Copyright (c) 2018 Bytedance.com All rights reserved.
//

/*
  这里简单的示例，方便业务方接入的时候参考，基本上按照以下方法实现即可
 */

#import "TTViewController.h"

# if __has_include(<VEAppUpdateHelper/TTAppUpdateHelperDefault.h>)

#import <VEAppUpdateHelper/TTAppUpdateHelperDefault.h>
#import <OneKit/OKServiceCenter.h>
#import <OneKit/OKApplicationInfo.h>
#import <OneKit/OKServices.h>
#import <OneKit/OKStartUpFunction.h>
#import "OKDemoBaseViewController.h"

@interface TTViewController ()<TTAppUpdateDelegate,OKDemoEntryItemProtocol>
@property (nonatomic, strong) TTAppUpdateHelperDefault *updateHelper;
@end

@implementation TTViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    self.title = @"发布服务";
//    [self update];
    CGFloat width = self.view.bounds.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 120) / 2, 120, 120, 120)];
    imageView.image = [UIImage imageNamed:@"bg-banner-func4"];
    [self.view addSubview:imageView];
    
    UILabel *checkTipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 8, width, 30)];
    checkTipLabel1.font = [UIFont systemFontOfSize:18];
    checkTipLabel1.textColor = [UIColor blackColor];
    checkTipLabel1.textAlignment = NSTextAlignmentCenter;
    checkTipLabel1.text = @"查看发布的新版本";
    [self.view addSubview:checkTipLabel1];
    
    UILabel *checkTipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(checkTipLabel1.frame) + 8, width, 30)];
    checkTipLabel2.font = [UIFont systemFontOfSize:14];
    checkTipLabel2.textColor = [UIColor grayColor];
    checkTipLabel2.textAlignment = NSTextAlignmentCenter;
    checkTipLabel2.text = @"发布服务是...";
    [self.view addSubview:checkTipLabel2];
    
    UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(checkTipLabel2.frame) + 24, width - 32, 48)];
    [checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [checkButton setTitle:@"点击查看" forState:UIControlStateNormal];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:checkButton];
}

- (NSString *)title
{
    return @"发布服务";
}

- (NSString *)iconName
{
    return @"publish";
}

- (void)checkButtonClicked:(UIButton *)btn {
    [self update];
}


- (void)update {
    if(!self.updateHelper) {
        __block id<OKDeviceService> deviceService = [[OKServiceCenter sharedInstance] serviceForProtocol:@protocol(OKDeviceService)];
        OKApplicationInfo *info = [OKApplicationInfo sharedInstance];
        TTAppUpdateHelperDefault *defaultHelper = [[TTAppUpdateHelperDefault alloc] initWithDeviceID:deviceService.deviceID
                                                                                                 aid:info.appID delegate:self];
        self.updateHelper = defaultHelper;
        self.updateHelper.callType = @(0);
        self.updateHelper.city = @"Shanghai";
        [defaultHelper startCheckVersion];
    }
}

#pragma mark TTAppUpdateDelegate
- (void)updateViewShouldShow:(TTAppUpdateTipView *)tipView model:(TTAppUpdateModel *)model {
    //弹窗开启弹窗，先判断url有效性
    if ([self verifyWebUrlAddress:model.downloadURL]) {
        [tipView show];
    }
    //弹窗关闭业务自己处理数据，不用处理tipView
}

- (void)updateViewShouldClosed:(TTAppUpdateTipView *)tipView {
    [tipView hide];
    self.updateHelper = nil;
}

- (BOOL)verifyWebUrlAddress:(NSString *)webUrl
{
    if (!webUrl) {
          return NO;
      }
    return [UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:webUrl]];
}
@end

# else

@implementation TTViewController

@end
# endif
