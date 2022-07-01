//
//  VECustomActivity.m
//  VEShare_Example
//
//  Created by 杨阳 on 2019/4/12.
//  Copyright © 2019 xunianqiang. All rights reserved.
//

#import "VEShareCustomActivity.h"
#import "VEShareManager.h"
#import <OneKit/ByteDanceKit.h>
#import <VEShare/VEShareMacros.h>

NSString * const VEShareActivityTypeUserCustom = @"VEShareActivityTypeUserCustom";

@implementation VEShareCustomActivity

//VEShareInit() {
//    [VEShareManager addUserDefinedActivity:[[VEShareCustomActivity alloc] init]];
//}

#pragma mark - activity protocol

- (NSString *)contentItemType
{
    return VEShareActivityContentItemTypeUserCustom;
}

- (NSString *)activityType
{
    return VEShareActivityContentItemTypeUserCustom;
}

- (NSString *)activityImageName
{
    if ([self.contentItem respondsToSelector:@selector(activityImageName)] && [self.contentItem activityImageName]) {
        return [self.contentItem activityImageName];
    } else {
        return @"copy_allshare";
    }
}

- (NSString *)contentTitle {
    if (self.contentItem.contentTitle.length > 0) {
        return self.contentItem.contentTitle;
    } else {
        return @"default title";
    }
}

- (NSString *)shareLabel {
    return @"shareLabel";
}

- (void)performActivityWithCompletion:(VEShareActivityCompletionHandler)completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"This is a custom action" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [[BTDResponder topViewController] presentViewController:alert animated:YES completion:nil];
    
    !completion ?: completion(self, nil, nil);
}

@end
