//
//  VEShareViewController.m
//  VEShare
//
//  Created by xunianqiang on 03/01/2019.
//  Copyright (c) 2019 xunianqiang. All rights reserved.
//

#import "VEShareViewController.h"
#import <VEShare/VEShareManager.h>
#import <VESHare/VESharePanelContent.h>
//#import <VEQQFriendContentItem.h>
#import <VESHare/VEWechatTimelineContentItem.h>
#import <VESHare/VEWechatContentItem.h>
//#import <VEQQFriendContentItem.h>
//#import <VEQQZoneContentItem.h>
//#import <VESinaWeiboContentItem.h>
//#import "VEShareSequenceManager.h"
//#import "VECopyContentItem.h"
//#import "VEZhiFuBaoContentItem.h"
//#import "VESMSContentItem.h"
//#import "VEAwemeContentItem.h"
//#import "VEImageMarkAdapter.h"
#import "VEShareCustomContentItem.h"
//#import <TTNetworkManager/TTNetworkManager.h>
#import <objc/message.h>
//#import <VEShare/UIColor+UGExtension.h>
//#import "VETokenShareDialogService.h"
//#import "VEImageShareDialogService.h"
//#import "VETelegramShare.h"
//#import <VEShare/VEVideoMarkAnalysisManager.h>
#import <VEShare/VEVideoImageShare.h>
//#if __has_include(<VEShareFacebookBusiness/VEFacebookContentItem.h>)
//#import <VEShareFacebookBusiness/VEFacebookContentItem.h>
//#endif

//#import <VEShare/VEWhatsAppContentItem.h>
//
//#if __has_include(<VEShareFacebookBusiness/VEMessengerContentItem.h>)
//#import <VEShareFacebookBusiness/VEMessengerContentItem.h>
//#endif

#import "VEShareDebugUtil.h"
//
//#if __has_include(<DoraemonKit/DoraemonManager.h>)
//#import <DoraemonKit/DoraemonManager.h>
//#endif

#import <VEShare/VEShareBaseUtil.h>
#import <OneKit/ByteDanceKit.h>
#import <VEShare/VEShareData.h>
#import "VEShareDatasoruce.h"
#import "VEShareDelegateHandler.h"

@interface VEShareViewController () <UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate, //VEVideoShareDialogServiceDelegate,
                                    UIPickerViewDataSource,
                                    UIPickerViewDelegate,
                                    UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) VEShareManager *shareManager;
@property (nonatomic, strong) VEShareDatasoruce *dataSource;
@property (nonatomic, strong) VEShareDelegateHandler *handler;

@property (nonatomic, assign) CGFloat bottomTop;
@property (nonatomic, strong) UITextField *field;
@property (nonatomic, strong) UITextField *groupIDField;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation VEShareViewController

- (void)setUp {
    _shareManager = [VEShareManager new];
    _dataSource = [[VEShareDatasoruce alloc] initWithWidth:self.view.btd_width];
    _handler = [VEShareDelegateHandler new];
    _shareManager.dataSource = _dataSource;
    _shareManager.delegate = _handler;
}

- (NSString *)iconName
{
    return @"spot";
}

- (NSString *)title
{
    return @"分享";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGes];
    
    [self configOtherThings];
    [self configButton];
    NSString *appid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"SSAppID"];

}

- (void)tapAction:(UIGestureRecognizer *)ges {
    [self.field resignFirstResponder];
    [self.groupIDField resignFirstResponder];
}

- (void)configOtherThings {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_scrollView];

    _field = [[UITextField alloc] initWithFrame:CGRectMake(100, 50, 200, 50)];
    _field.layer.borderWidth = 0.5;
    _field.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _field.text = @"1926_test_sdk_local";
//    _field.textColor = [UIColor blackColor];
    
    _groupIDField = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_field.frame) + 20, 200, 50)];
    _groupIDField.layer.borderWidth = 0.5;
    _groupIDField.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _groupIDField.text = @"6600955525821628931";
//    _groupIDField.textColor = [UIColor blackColor];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_groupIDField.frame) + 20, 200, 20)];
    tipLabel.text = @"token, image, sdk, sys, video";
    tipLabel.font = [UIFont systemFontOfSize:14];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(170, CGRectGetMaxY(tipLabel.frame) + 20, 200, 50)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    UILabel *pickerTip = [[UILabel alloc] initWithFrame:CGRectMake(0, _pickerView.frame.origin.y, 220, 50)];
    pickerTip.text = @"SDK分享类型选择：上下滑ta ->";
    pickerTip.textAlignment = NSTextAlignmentRight;
    pickerTip.font = [UIFont systemFontOfSize:14];
    
    [_scrollView addSubview:self.field];
    [_scrollView addSubview:self.groupIDField];
    [_scrollView addSubview:tipLabel];
    [_scrollView addSubview:self.pickerView];
    [_scrollView addSubview:pickerTip];
    
    self.bottomTop = CGRectGetMaxY(_pickerView.frame) + 50;
    
    if (@available(iOS 13.0, *)) {
        _scrollView.backgroundColor = [UIColor systemBackgroundColor];
        _groupIDField.textColor = [UIColor labelColor];
        _groupIDField.backgroundColor = [UIColor systemBackgroundColor];
        _field.textColor = [UIColor labelColor];
        _field.backgroundColor = [UIColor systemBackgroundColor];
        tipLabel.textColor = [UIColor labelColor];
        pickerTip.textColor = [UIColor labelColor];
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        _scrollView.backgroundColor = [UIColor whiteColor];
        _groupIDField.textColor = [UIColor lightGrayColor];
        _groupIDField.backgroundColor = [UIColor whiteColor];
        _field.textColor = [UIColor lightGrayColor];
        _field.backgroundColor = [UIColor whiteColor];
        tipLabel.textColor = [UIColor lightGrayColor];
        pickerTip.textColor = [UIColor lightGrayColor];
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)configButton {
    NSArray *btnTitleSel = @[
                             @[@"方式一面板展示", @"oldBeginShare"],
                             @[@"方式二面板展示", @"highLevelBeginShare"],
                             @[@"外露微信分享", @"outsideWechatShare"],
                             @[@"外露朋友圈分享", @"outsideTimelineShare"],
//                             @[@"展示debug入口", @"showDebugKit"],
//                             @[@"清空沙盒", @"cleanSandbox"],
                             ];

    [btnTitleSel enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:obj[0] forState:UIControlStateNormal];
        BOOL inFirstCol = (idx % 2 == 0);
        btn.frame = CGRectMake(inFirstCol ? 20 : 210, self.bottomTop + (idx / 2) * 70, 170, 50);
        btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:NSSelectorFromString(obj[1]) forControlEvents:UIControlEventTouchUpInside];

        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(btn.frame));
    }];
}

#pragma mark - eventsystem


- (void)outsideWechatShare {
    VESharePanelContent *content = [[VESharePanelContent alloc] init];
    content.panelID = self.field.text;
    content.resourceID = self.groupIDField.text;
    content.shareContentItem = [self wxItem];
    [self.shareManager shareToContent:content presentingViewController:self];
}

- (void)outsideTimelineShare {
    VESharePanelContent *content = [[VESharePanelContent alloc] init];
    content.panelID = self.field.text;
    content.resourceID = self.groupIDField.text;
    content.shareContentItem = [self pyqItem];
    [self.shareManager shareToContent:content presentingViewController:self];
}

//http://10.2.195.239:10304/bytedance/log/

- (id<VEShareActivityProtocol>)activityProcess:(id<VEShareActivityProtocol>)activity {
    VEShareCustomContentItem *contentItem = (VEShareCustomContentItem *)activity.contentItem;
    contentItem.customTitle = @"";
    return activity;
}

- (NSString *)groupId {
    return self.field.text.length > 0 ? self.field.text : self.field.placeholder;
}

- (void)oldBeginShare {
    VEShareBaseContentItem *contentItem = [VEShareBaseContentItem new];
    contentItem.title = @"Share title";
    contentItem.desc = @"Share desc";
    contentItem.webPageUrl = @"https://www.toutiao.com";
    contentItem.defaultShareType = VEShareWebPage;

    VESharePanelContent *content = [VESharePanelContent new];
    //面板ID需提前配置，详见【前置工作】
    //或使用本地模式，详见【分享技术相关文档-本地模式】
    content.panelID = @"1926_test_sdk_local";
    //resourceid，涉及分享数据请求。如果仅需要分享本地数据，详见【本地模式】。本地模式不需要传该字段
    //content.resourceID = YOUR_RESOURCE_ID;
    content.cancelBtnText = @"取消";
    content.shareContentItem = contentItem;
    [self.shareManager displayPanelWithContent:content];
}

- (void)highLevelBeginShare {
    VEShareBaseContentItem *contentItem = [self baseContentItem];
    VESharePanelContent *content = [VESharePanelContent new];
    content.banShareToken = NO;
    content.panelID = self.field.text;
    content.resourceID = self.groupIDField.text;
    content.cancelBtnText = @"取消";
    
    content.requestExtraData =  @{@"client_extra" : [self.class dictToString:@{@"test": @"testvalue",}],
                                  @"need_image_token": @(1),
    };
    contentItem.clientExtraData = @{@"testkey" : @"testvalue"};

    content.shareContentItem = contentItem;
    content.disableRequestShareInfo = NO;
    [self.shareManager displayPanelWithContent:content];
}

#pragma mark - get

- (VEWechatContentItem *)wxItem {
    VEWechatContentItem *item = [[VEWechatContentItem alloc] init];
    item.title = @"test title";
    item.desc = @"test desc";
    item.thumbImage = [self imageNamed:@"avatar_toutiao"];
    item.imageUrl = @"https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/49/e9/b6/49e9b669-8a2d-02f7-d663-83e46af99569/AppIcon-News-0-1x_U007emarketing-0-0-85-220-6.png/1200x630wa.png";
    item.webPageUrl = @"https://job.toutiao.com/2018/spring_referral/?token=YZuVtdKxO5JM70NYwGV06Q%3D%3D&key=MjI0MjIsMzIzNzEsMzIyNzg%3D";

    item.defaultShareType = VEShareWebPage;

    item.groupID = [self groupId];
    item.clickMode = VESharePlatformClickModeSmooth;
    return item;
}

- (VEWechatTimelineContentItem *)pyqItem {
    VEWechatTimelineContentItem *item = [[VEWechatTimelineContentItem alloc] init];

    item.title = @"test title";
    item.desc = @"test desc";
    item.thumbImage = [self imageNamed:@"avatar_toutiao"];
    item.imageUrl = @"https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/49/e9/b6/49e9b669-8a2d-02f7-d663-83e46af99569/AppIcon-News-0-1x_U007emarketing-0-0-85-220-6.png/1200x630wa.png";
    item.webPageUrl = @"https://job.toutiao.com/2018/spring_referral/?token=YZuVtdKxO5JM70NYwGV06Q%3D%3D&key=MjI0MjIsMzIzNzEsMzIyNzg%3D";
    item.defaultShareType = VEShareWebPage;

    item.groupID = [self groupId];

    item.activityImageName = @"pyq_allshare";
    item.clickMode = VESharePlatformClickModeSmooth;
    return item;
}


#pragma mark - VEVideoShareDialogServiceDelegate

- (void)videoShareSaveSucceedDialogDidClick:(BOOL)confirm panelID:(NSString *)panelID
{
    
}

- (void)videoShareSaveSucceedDialogDidShowWithPanelID:(NSString *)panelID
{
    
}

- (void)videoSharePreviewDialogDidShowWithPanelID:(NSString *)panelID
{
    
}

- (void)videoSharePreviewDialogDidClick:(BOOL)confirm panelID:(NSString *)panelID
{
    
}

- (void)videoShareAlbumAuthorizationDialogDidShowWithPanelID:(NSString *)panelID
{
    
}

- (void)videoShareAlbumAuthorizationDialogDidClick:(BOOL)confirm panelID:(NSString *)panelID
{
    
}

#pragma mark - picker delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 6;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    switch (row) {
        case 0:
            title = @"纯文本";
            break;
        case 1:
            title = @"链接";
            break;
        case 2:
            title = @"图片";
            break;
        case 3:
            title = @"视频";
            break;
        case 4:
            title = @"文件(微信)";
            break;
        case 5:
            title = @"小程序(微信)";
            break;
        default:
            break;
    }
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

#pragma mark - action
- (void)cleanSandbox {
    [VEVideoImageShare cleanSandbox];
}

- (UIImage *)imageNamed:(NSString *)name {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *bundleURL = [mainBundle.resourceURL URLByAppendingPathComponent:@"VEShareDebugResources.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    UIImage *image = [UIImage imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
    return image;
}

- (VEShareType)getShareType {
    NSInteger selected = [self.pickerView selectedRowInComponent:0];
    VEShareType shareType = VEShareText;
    switch (selected) {
        case 0:
            shareType = VEShareText;
            break;
        case 1:
            shareType = VEShareWebPage;
            break;
        case 2:
            shareType = VEShareImage;
            break;
        case 3:
            shareType = VEShareVideo;
            break;
        default:
            break;
    }
    return  shareType;
}

- (VEShareBaseContentItem *)baseContentItem
{
    VEShareBaseContentItem *contentItem = [VEShareBaseContentItem new];
    contentItem.desc = @"test desc";
//       contentItem.webPageUrl = @"https://job.toutiao.com/2018/spring_referral/?token=YZuVtdKxO5JM70NYwGV06Q%3D%3D&key=MjI0MjIsMzIzNzEsMzIyNzg%3D";
    contentItem.webPageUrl = @"https://toutiao.com?scheme=snssdk%3a%2f%2fxigua_live%3froom_id%3d345";
    contentItem.clickMode = VESharePlatformClickModeSmooth;
    contentItem.presentVC = self;
    contentItem.defaultShareType = [self getShareType];
    contentItem.thumbImage = [self imageNamed:@"avatar_toutiao"];
    contentItem.image = [self imageNamed:@"share_image"];
    contentItem.imageUrl = @"https://clipart-best.com/img/mario/mario-clip-art-5.png";
    contentItem.videoURL = @"https://aweme.snssdk.com/aweme/v1/play/?video_id=v0200f7c0000bgkns9tjfrms37ecnq30&line=0&app_id=13";
    return contentItem;
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
@end
