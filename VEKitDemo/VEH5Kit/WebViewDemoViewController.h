//
//  WebViewDemoViewController.h
//  App
//
//  Created by bytedance on 2022/2/21.
//

#import "OKDemoBaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^WebViewDemoFinishBlock)(NSTimeInterval loadTime);

@interface WebViewDemoViewController : OKDemoBaseViewController

@property (nonatomic ,assign) BOOL offlineEnable;
@property (nonatomic ,strong) NSString *url;
@property (nonatomic ,copy) WebViewDemoFinishBlock finishBlock;


@end

NS_ASSUME_NONNULL_END
