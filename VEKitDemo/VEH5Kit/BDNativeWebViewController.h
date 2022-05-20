//
//  BDNativeWebViewController.h
//  App
//
//  Created by bytedance on 2021/12/3.
//

#import <UIKit/UIKit.h>
#import "OKDemoBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BDNativeWebViewControllerType) {
    BDNativeWebViewControllerTypeImage,
    BDNativeWebViewControllerTypeVideo,
};




@interface BDNativeWebViewController : OKDemoBaseViewController

@property (nonatomic,assign) BDNativeWebViewControllerType  type;

@end

@interface BDNativeWebVideoViewController : BDNativeWebViewController

@end

NS_ASSUME_NONNULL_END
