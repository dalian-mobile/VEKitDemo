//
//  VEShareDatasoruce.h
//  VEShare
//
//  Created by bytedance on 2022/3/30.
//

#import <Foundation/Foundation.h>
#import <VEShare/VEShareManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEShareDatasoruce : NSObject<VEShareManagerDataSource>

- (instancetype)initWithWidth: (CGFloat) width;
@end

NS_ASSUME_NONNULL_END
