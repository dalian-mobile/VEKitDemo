//
//  VECustomActivity.h
//  VEShare_Example
//
//  Created by 杨阳 on 2019/4/12.
//  Copyright © 2019 xunianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VEShare/VEShareActivityProtocol.h>
#import <VEKitDemo/VEShareCustomContentItem.h>

extern NSString *const VEShareActivityTypeUserCustom;

@interface VEShareCustomActivity : NSObject <VEShareActivityProtocol>

@property (nonatomic, strong) VEShareCustomContentItem *contentItem;

@end
