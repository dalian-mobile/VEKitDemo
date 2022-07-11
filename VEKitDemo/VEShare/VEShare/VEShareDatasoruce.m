//
//  VEShareDatasoruce.m
//  VEShare
//
//  Created by bytedance on 2022/3/30.
//

#import "VEShareDatasoruce.h"
#import "VEShareCustomContentItem.h"
#import <VEShare/VEShareSystemActivity.h>
#import <VESHare/VESystemShare.h>

@interface VEShareDatasoruce ()
@property (nonatomic, assign) CGFloat viewWidth;
@end

@implementation VEShareDatasoruce

- (instancetype)initWithWidth: (CGFloat) width {
    self = [super init];
    if (self) {
        self.viewWidth = width;
    }
    return self;
}

#pragma mark - shareManager dataSource
/// 修改面板渠道，面板展示前调用
/// @param array current contentItem array
/// @param panelContent display时传入的panelContent
- (NSArray *)resetPanelItems:(NSArray *)array panelContent:(VESharePanelContent *)panelContent
{
    VEShareCustomContentItem *contentItem = [self customContentItem];
    NSMutableArray *newArray;
    if ([array.firstObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *secondArray = array.lastObject;
        [secondArray addObject:contentItem];
        newArray = array.mutableCopy;
        [newArray replaceObjectAtIndex:newArray.count - 1 withObject:secondArray];
    } else {
        newArray = [[NSMutableArray alloc] init];
        [newArray addObject:array];
        [newArray addObject:@[contentItem]];
    }
    
    [newArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(VEShareBaseContentItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           [self configContentItem:obj];
        }];
    }];
    return newArray.copy;
}

/// 重设渠道数据，渠道点击后，请求分享数据前调用
/// @param contentItem 渠道contentItem
- (void)resetContentItemOriginalData:(VEShareBaseContentItem *)contentItem
{
    if ([[contentItem contentItemType] isEqualToString:@""]) { //VEActivityContentItemTypeWechatTimeLine
        //业务方根据自己的需求处理特定的item。
        contentItem.title = @"time line share";
    } else if ([[contentItem contentItemType] isEqualToString:VEShareActivityContentItemTypeSystem]) {
        VEShareSystemContentItem *sysItem = (VEShareSystemContentItem *)contentItem;
        sysItem.popoverRect = CGRectMake(_viewWidth / 2.0, 50, 0, 0);
        sysItem.systemActivityItems = @[[UIImage imageNamed:@"share_image"], [UIImage imageNamed:@"share_image"]];
        sysItem.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard];
        sysItem.shareFile = YES;
        sysItem.fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shareFile" ofType:@"pdf"]];
        sysItem.fileURL = [NSURL URLWithString:@"https://leo-online.fbcontent.cn/leo-gallery/pdf/58b5709d2656003f.pdf"];
        sysItem.fileName = @"shareFile.pdf";
    }
    else {
        contentItem.title = @"share title";
    }
}

/// 重设服务端数据，渠道点击后，请求分享数据成功后调用
/// @param contentItem 渠道contentItem
- (void)resetContentItemServerData:(VEShareBaseContentItem *)contentItem
{
    NSLog(@"");
    if ([[contentItem contentItemType] isEqualToString:VEShareActivityContentItemTypeSystem]) {
        VEShareSystemContentItem *sysItem = (VEShareSystemContentItem *)contentItem;
        sysItem.image = nil;
    }

}

- (VEShareCustomContentItem *)customContentItem
{
    VEShareCustomContentItem *contentItem = [[VEShareCustomContentItem alloc] init];
    contentItem.activityImage = [self imageNamed:@"avatar_toutiao"];
    contentItem.contentTitle = @"custom Title";
    contentItem.activityImageName = @"avatar_toutiao";
    contentItem.customTitle = @"test title";
    return contentItem;
}

- (void)configContentItem:(VEShareBaseContentItem *)contentItem
{

}

+ (NSString *)dictToString:(NSDictionary *)dict {
    NSString *myString;
    if (dict) {
        NSError * err;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
        myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return myString;
}

#pragma mark - resource helper
- (UIImage *)imageNamed:(NSString *)name {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *bundleURL = [mainBundle.resourceURL URLByAppendingPathComponent:@"VEShareDebugResources.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    UIImage *image = [UIImage imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
    return image;
}

@end
