//
//  VEShareDelegateHandler.m
//  VEShare
//
//  Created by bytedance on 2022/3/30.
//

#import "VEShareDelegateHandler.h"
#import <VEShare/VEShareManager.h>
#import <OneKit/ByteDanceKit.h>

@implementation VEShareDelegateHandler

#pragma mark - share manager delegate

- (void)shareManager:(VEShareManager *)shareManager
         clickedWith:(id<VEShareActivityProtocol>)activity
          sharePanel:(id<VEActivityPanelControllerProtocol>)panelController {
    NSLog(@"click item");
}

- (void)shareManager:(VEShareManager *)shareManager willShareActivity:(id<VEShareActivityProtocol>)activity serverDataitem:(VEShareItem *)itemModel continueBlock:(void (^)(void))continueBlock
{
    
    NSLog(@"will share");
    continueBlock();
}

- (void)shareManager:(VEShareManager *)shareManager
       completedWith:(id<VEShareActivityProtocol>)activity
          sharePanel:(id<VEActivityPanelControllerProtocol>)panelController
               error:(NSError *)error
                desc:(NSString *)desc {
    NSLog(@"share completion");
    NSString *descString = (error == nil ? @"分享成功" : error.description);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:descString preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [[BTDResponder topViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)shareManager:(VEShareManager *)shareManager tokenShareDialogDidShowWith:(id<VEShareActivityProtocol>)activity {
    NSLog(@"");
}

- (void)shareManager:(VEShareManager *)shareManager sharePanelCancel:(id<VEActivityPanelControllerProtocol>)panelController
{
    NSLog(@"");
}

- (void)shareManager:(VEShareManager *)shareManager didLaunchOtherApp:(id<VEShareActivityProtocol>)activity {
    NSLog(@"");
}
@end
