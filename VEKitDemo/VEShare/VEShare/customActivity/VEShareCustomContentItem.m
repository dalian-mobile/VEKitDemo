//
//  VECustomContentItem.m
//  VEShare_Example
//
//  Created by 杨阳 on 2019/4/12.
//  Copyright © 2019 xunianqiang. All rights reserved.
//

#import "VEShareCustomContentItem.h"

NSString * const VEShareActivityContentItemTypeUserCustom = @"VEShareActivityContentItemTypeUserCustom";

@implementation VEShareCustomContentItem

@synthesize contentTitle = _contentTitle, activityImage = _activityImage, activityImageName = _activityImageName;

- (NSString *)contentItemType
{
    return VEShareActivityContentItemTypeUserCustom;
}

@end
