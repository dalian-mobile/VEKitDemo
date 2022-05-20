//
//  OKDemoBaseViewController.h
//  App
//
//  Created by bytedance on 2022/2/18.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol OKDemoEntryItemProtocol
- (NSString *)iconName;
- (NSString *)title;
@end



@interface OKDemoBaseViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
