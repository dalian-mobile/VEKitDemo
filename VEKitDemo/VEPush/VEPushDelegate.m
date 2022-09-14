//
//  VEAppDelegate+VEPushDelegate.m
//  VEPushSDK_Example
//
//  Created by bytedance on 2021/10/14.
//  Copyright © 2021 chenchen.121. All rights reserved.
//

#import "VEPushDelegate.h"
#import <VEPush/VEPushService.h>

@implementation VEPushDelegate

- (BOOL)useNotificationServiceExtension{
    return YES;
}

- (void)handleAuthorizationResult:(BOOL)granted withError:(NSError *)error{
    NSLog(@"[VEPushDemo] Authorization result: %d", granted);
}

- (UNAuthorizationOptions) authorizationOptions{
    return UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
}

- (NSSet<UNNotificationCategory *> *) notificationCategory
{
    UNNotificationAction *send = [UNNotificationAction actionWithIdentifier:@"ENTER" title:@"Enter" options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *deny = [UNNotificationAction actionWithIdentifier:@"DENY" title:@"Deny" options:UNNotificationActionOptionDestructive];

    UNNotificationCategory *cat = [UNNotificationCategory categoryWithIdentifier:@"LocalTest" actions:@[send, deny] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    return [NSSet setWithObject:cat];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"[VEPushDemo] Register apns token successfully");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"[VEPushDemo] Fail to register apns token: %@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"[VEPushDemo] Silent notification: %@", userInfo);
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"[VEPushDemo] Did receive notification: %@", userInfo);
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"[VEPushDemo] Will present notification: %@", userInfo);
    if(@available(iOS 14.0, *)){
        completionHandler(UNNotificationPresentationOptionBanner);
    }else{
        completionHandler(UNNotificationPresentationOptionAlert);
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
    NSLog(@"[VEPushDemo] Open settings page");
}

@end
