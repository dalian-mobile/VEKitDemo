//
//  VECustomContentItem.h
//  VEShare_Example
//
//  Created by 杨阳 on 2019/4/12.
//  Copyright © 2019 xunianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VEShare/VEActivityContentItemProtocol.h>
#import <VEShare/VEShareBaseContentItem.h>

extern NSString *const VEShareActivityContentItemTypeUserCustom;

@interface VEShareCustomContentItem : VEShareBaseContentItem <VEActivityContentItemSelectedDigProtocol>

@property (nonatomic, copy) NSString *customTitle;

//考虑Button的select状态和计数
@property (nonatomic, assign) BOOL banDig;
@property (nonatomic, assign) int64_t count;
//考虑Button的select状态和计数
@property (nonatomic, assign) BOOL selected;
@end
