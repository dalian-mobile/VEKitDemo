//
//  BDBlankDetectViewController.m
//  App
//
//  Created by bytedance on 2021/12/9.
//

#import "BDBlankDetectViewController.h"
#import <VEH5Kit/VEH5Kit.h>
#if __has_include(<VEH5Kit/BDWebViewBlankDetect.h>)
#import <VEH5Kit/BDWebViewBlankDetect.h>
#else
#import <BDWebKitToB/BDWebViewBlankDetect.h>
#endif

@interface BDBlankDetectViewController ()
@property (strong, nonatomic) VEH5WebView *webView;

@end

@implementation BDBlankDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[VEH5WebView alloc] initWithFrame:self.view.bounds withOfflineEnable:NO];
    [self.view addSubview:self.webView];
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [BDWebViewBlankDetect detectBlankByOldSnapshotWithView:self.webView CompleteBlock:^(BOOL isBlank, UIImage * _Nonnull image, NSError * _Nonnull error) {
                if (isBlank) {
                    self.navigationItem.title = [NSString stringWithFormat:@"[白屏检测结果]:YES"];
                }else{
                    self.navigationItem.title = [NSString stringWithFormat:@"[白屏检测结果]:NO"];
                }
                NSLog(@"[BDBlankDetect]:%d",isBlank);
            }];
        });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
