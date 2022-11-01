//
//  BDHotfixViewController.m
//  App
//
//  Created by bytedance on 2022/3/25.
//

#import "BDHotfixViewController.h"
#import <BDHotfix/BDHotfix.h>
#import <BDHotfix/BDHotfixPatch.h>
#import "OKDebugInfoViewController.h"
#import "OKDemoBaseViewController.h"


#import <OneKit/OKSectionData.h>

OK_STRINGS_EXPORT("OKDemoEntryItem","BDHotfixViewController")


static NSString *const BDHotfixLocalPatchKey = @"kBDHotfixPatchListResponse";

@interface BDHotfixViewController ()<BDHotfixDelegate>

@end

@implementation BDHotfixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"热修复";
}



- (NSString *)title
{
    return @"热修复";
}

- (NSString *)iconName
{
    return @"demo_hotfix";
}


- (NSArray<OKListCellModel *> *)models {
    __weak BDHotfixViewController *weakSelf = self;
    
    NSString *showBugsTitle = @"显示当前Bug";
    OKListCellModel *showBugs = [[OKListCellModel alloc] initWithTitle:showBugsTitle subTitle:nil imageName:@"bug" actionBlock:^{
        @try {
            NSString *str = [weakSelf bugFunc];
            [weakSelf showStringOnTextView:str title:showBugsTitle];
        }
        @catch (NSException *exception) {
            NSString *exceptionStr = exception.reason;
            exceptionStr = [NSString stringWithFormat:@"%@\n%@", exceptionStr, exception.callStackSymbols];
            [weakSelf showStringOnTextView:exceptionStr title:showBugsTitle];
        }
    }];
    
    NSString *syncTitle = @"从网络更新补丁";
    OKListCellModel *syncPatches = [[OKListCellModel alloc] initWithTitle:syncTitle subTitle:nil imageName:@"wifi" actionBlock:^{
        [[BDHotfix sharedInstance] setDelegate:self];
        [[BDHotfix sharedInstance] sync];
    }];
    
    NSString *deleteTitle = @"清除本地补丁";
    OKListCellModel *deletePatches = [[OKListCellModel alloc] initWithTitle: deleteTitle subTitle:nil imageName:@"clean" actionBlock:^{
        NSArray<NSDictionary *> *validPatches = [[NSUserDefaults standardUserDefaults] objectForKey:BDHotfixLocalPatchKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BDHotfixLocalPatchKey];
        [weakSelf showAlertWithMessage:[weakSelf deleteAndShowInfoForPatches:validPatches]];
    }];
    
    return @[showBugs, syncPatches, deletePatches];
}

- (NSString *)bugFunc {
    NSArray *array = [NSArray new];
    return [array objectAtIndex:0];
}

- (NSString *)deleteAndShowInfoForPatches:(NSArray<NSDictionary *> *)patches {
    NSString *baseInfo = [NSString stringWithFormat:@"%lu patch(es) deleted: \n", (unsigned long)patches.count];
    
    for (NSDictionary *d in patches) {
        BDHotfixPatchModel *patchModel = [BDHotfixPatchModel modelWithDictionary:d];
        [[NSFileManager defaultManager] removeItemAtPath:patchModel.storageDirectory error:nil];
        baseInfo = [NSString stringWithFormat: @"%@patchName:%@, patchId:%@, patchVersion:%@\n", baseInfo, patchModel.patchName, patchModel.patchId, patchModel.version];
    }
    return baseInfo;
}

- (void)showStringOnTextView:(NSString *)infoString title:(NSString *)title {
    OKDebugInfoViewController *vc = [[OKDebugInfoViewController alloc] init];
    vc.title = title;
    vc.content = infoString;
    vc.title = @"显示当前bug";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)BDHotfixDidFinishFetchingPatchList:(NSArray <BDHotfixPatchModel *> *)patchList withError:(NSError *)error {
    [self showAlertWithMessage:[self syncInfoForPatches:patchList]];
}

- (void)showAlertWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (NSString *)syncInfoForPatches:(NSArray <BDHotfixPatchModel *> *)patchList {
    NSString *baseInfo = [NSString stringWithFormat:@"%lu patch(es) received: \n", patchList.count];
    for (BDHotfixPatchModel *model in patchList) {
        baseInfo = [NSString stringWithFormat: @"%@patchName:%@, patchId:%@, patchVersion:%@\n", baseInfo, model.patchName, model.patchId, model.version];
    }
    return baseInfo;
}

/// @return 是否允许拉取热修包列表。可以返回NO以阻止SDK拉取热修包列表。
- (BOOL)BDHotfixWillStartFetchingPatchList {
    return YES;
}

/// @return 是否允许下载热修包。可以返回NO以阻止SDK下载此热修包。
- (BOOL)BDHotfixWillStartDownloadingPatch:(BDHotfixPatchModel *)patchModel {
    return YES;
}

/// 下载热修包完成的回调。
- (void)BDHotfixDidFinishDownloadingPatch:(BDHotfixPatch *)patch withError:(NSError *)error{
    
}

@end
