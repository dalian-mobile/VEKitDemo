//
//  OffLineDemoViewController.m
//  App
//
//  Created by bytedance on 2022/2/18.
//

#import "OffLineDemoViewController.h"
#import "OKDebugInfoViewController.h"
#import <VEH5Kit/VEH5KitManager.h>
#if __has_include(<VEH5Kit/IESGurdResourceMetadataStorage.h>)
#import <VEH5Kit/IESGurdResourceMetadataStorage.h>
#endif
#import "WebViewDemoViewController.h"

@interface OffLineDemoViewController ()

@property (nonatomic,strong) NSString *url;
@property (nonatomic,assign) CGFloat loadTimeWithCache;
@property (nonatomic,assign) CGFloat loadTimeWithOutCache;

@end

@implementation OffLineDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"离线包";
    self.url = @"https://mars-jsbridge.goofy-web.bytedance.com/example#/";
}
#if __has_include(<VEH5Kit/IESGurdResourceMetadataStorage.h>)

- (NSString *)getCurrentOfflinePackages
{
    NSMutableString *channels = [[NSMutableString alloc] init];
    [[IESGurdResourceMetadataStorage copyActiveMetadataDictionary] enumerateKeysAndObjectsUsingBlock:^(NSString *accessKey, NSDictionary<NSString *,IESGurdActivePackageMeta *> *obj, BOOL *stop) {
//                NSMutableDictionary *localInfos = [NSMutableDictionary dictionary];
        [obj enumerateKeysAndObjectsUsingBlock:^(NSString *channel, IESGurdActivePackageMeta *meta, BOOL *stop) {
            [channels appendString: channel];
            [channels appendString: @","];
        }];
    }];
    
    if (channels.length > 0) {
        return [channels substringToIndex:channels.length - 1];
    }
    
    return channels.copy;
}


- (NSString *)getPackagesContent
{
    NSMutableDictionary *packagesContent = [[NSMutableDictionary alloc] init];
    [[IESGurdResourceMetadataStorage copyActiveMetadataDictionary] enumerateKeysAndObjectsUsingBlock:^(NSString *accessKey, NSDictionary<NSString *,IESGurdActivePackageMeta *> *obj, BOOL *stop) {
        NSMutableDictionary *eachPackage = [[NSMutableDictionary alloc] init];
        [obj enumerateKeysAndObjectsUsingBlock:^(NSString *channel, IESGurdActivePackageMeta *meta, BOOL *stop) {
            NSMutableDictionary *eachMeta = [[NSMutableDictionary alloc] init];
            eachMeta[@"version"] = [@(meta.version) stringValue];
            eachMeta[@"packageID"] = [@(meta.packageID) stringValue];
            eachMeta[@"packageType"] = [@(meta.packageType) stringValue];
            eachMeta[@"md5"] = meta.md5;
            eachMeta[@"active"] = @"1";
            [eachPackage setObject:eachMeta forKey:channel];
        }];
        
        [packagesContent setObject:eachPackage forKey:accessKey];
        
    }];
    [[IESGurdResourceMetadataStorage copyInactiveMetadataDictionary] enumerateKeysAndObjectsUsingBlock:^(NSString *accessKey, NSDictionary<NSString *,IESGurdActivePackageMeta *> *obj, BOOL *stop) {
        NSMutableDictionary *eachPackage = [[NSMutableDictionary alloc] init];
        [obj enumerateKeysAndObjectsUsingBlock:^(NSString *channel, IESGurdActivePackageMeta *meta, BOOL *stop) {
            NSMutableDictionary *eachMeta = [[NSMutableDictionary alloc] init];
            eachMeta[@"version"] = [@(meta.version) stringValue];
            eachMeta[@"packageID"] = [@(meta.packageID) stringValue];
            eachMeta[@"packageType"] = [@(meta.packageType) stringValue];
            eachMeta[@"md5"] = meta.md5;
            eachMeta[@"active"] = @"0";
            [eachPackage setObject:eachMeta forKey:channel];
        }];
        
        [packagesContent setObject:eachPackage forKey:accessKey];
        
    }];
    return [NSString stringWithFormat:@"%@",packagesContent];
}


- (NSString *)getOfflineLoadTime
{
    if (self.loadTimeWithCache > 0) {
        return [NSString stringWithFormat:@"加载耗时:%.2f",self.loadTimeWithCache];
    }
    return nil;
}

- (NSString *)getOfflineLoadTimeWithoutCache
{
    if (self.loadTimeWithOutCache) {
        return [NSString stringWithFormat:@"加载耗时:%.2f",self.loadTimeWithOutCache];
    }
    return nil;
}

- (NSArray<OKListCellModel *> *)models
{
    __weak typeof(self) weakSelf = self;
    return @[
        [[OKListCellModel alloc] initWithTitle:@"当前离线包" subTitle:[self getCurrentOfflinePackages] imageName:@"zip" actionBlock:^{
            OKDebugInfoViewController *vc = [[OKDebugInfoViewController alloc] init];
            vc.content = [self getPackagesContent];
            vc.title = @"离线包详情";
            [self.navigationController pushViewController:vc animated:YES];
        }],
        [[OKListCellModel alloc] initWithTitle:@"无离线包页面加载" subTitle:[self getOfflineLoadTimeWithoutCache] imageName:nil actionBlock:^{
            WebViewDemoViewController *webVC = [[WebViewDemoViewController alloc] init];
            webVC.url = weakSelf.url;
            webVC.offlineEnable = NO;
            [self.navigationController pushViewController:webVC animated:YES];
            webVC.finishBlock = ^(NSTimeInterval loadTime) {
                weakSelf.loadTimeWithOutCache = loadTime;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            };
        }],
        [[OKListCellModel alloc] initWithTitle:@"有离线包页面加载" subTitle:[self getOfflineLoadTime] imageName:nil actionBlock:^{
            WebViewDemoViewController *webVC = [[WebViewDemoViewController alloc] init];
            webVC.url = weakSelf.url;
            webVC.offlineEnable = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            webVC.finishBlock = ^(NSTimeInterval loadTime) {
                weakSelf.loadTimeWithCache = loadTime;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            };
        }],
        [[OKListCellModel alloc] initWithTitle:@"下载离线包" imageName:@"download" actionBlock:^{
            [[VEH5KitManager sharedInstance] updateOfflineResources:^(BOOL succeed) {
                if (succeed) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else{
                    NSLog(@"down load failed!");
                }
            }];
        }],
        [[OKListCellModel alloc] initWithTitle:@"清空离线包" imageName:@"clean" actionBlock:^{
            [[VEH5KitManager sharedInstance] clearOfflineResources];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }],
        
        [[OKListCellModel alloc] initWithTitle:@"修改页面URL" subTitle:self.url imageName:@"config" actionBlock:^{
            [weakSelf showInputAlert];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }],
    ];
}



- (void)showInputAlert
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"修改页面URL" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alt addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = self.url;
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UITextField *inputInfo = alt.textFields.firstObject;
        weakSelf.url = inputInfo.text;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }];

    [alt addAction:cancelAction];
    [alt addAction:okAction];

    [self presentViewController:alt animated:YES completion:^{
        
    }];
}

#endif

@end
