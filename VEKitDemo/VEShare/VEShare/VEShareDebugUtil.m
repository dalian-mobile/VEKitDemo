//
//  VEShareDebugUtil.m
//  VEShare
//
//  Created by chenshu on 2020/6/8.
//

#import "VEShareDebugUtil.h"
#import <OneKit/ByteDanceKit.h>
#import <AdSupport/AdSupport.h>
#import <VESHare/VEQQShare.h>
#import <VESHare/VEWeChatShare.h>
#import <VESHare/VEAliShare.h>
#import <VESHare/VEDingTalkShare.h>
#import <VESHare/VEWeiboShare.h>
#import <VESHare/VEAwemeShare.h>
//#import "VERocketShare.h"
//#import "VEMayaShare.h"

//#if __has_include(<VEShareTwitterBusiness/VETwitterShare.h>)
//#import <VEShareTwitterBusiness/VETwitterShare.h>
//#endif

//#import "VEToutiaoShare.h"

static NSString *const qqOAuthAppID = @"101860283";
static NSString *const zhifubaoAuthAppID = @"2015083100244990";
static NSString *const weChatAuthAppID = @"wx1b85cc171cff41b3";
static NSString *const awemeAuthAppID = @"aw81ef9i0fe0a8y9";
static NSString *const weiboAuthAppID = @"2504490989";
static NSString *const dingTalkAuthAppID = @"dingoamfoom0wrwiyexx2z";


@implementation VEShareDebugUtil

+ (void)configSDKInitialize {
    //Lite的AppID
    [VEQQShare registerWithID:qqOAuthAppID universalLink:@"https://kcyc0.share2dlink.com"];
    [VEWeChatShare registerWithID:weChatAuthAppID universalLink:@"https://kcyc0.share2dlink.com"];
    [VEAliShare registerWithID:zhifubaoAuthAppID];
    [VEDingTalkShare registerWithID:dingTalkAuthAppID];
    [VEWeiboShare registerWithID:weiboAuthAppID];
    [VEAwemeShare registerWithID:awemeAuthAppID];
}

@end
