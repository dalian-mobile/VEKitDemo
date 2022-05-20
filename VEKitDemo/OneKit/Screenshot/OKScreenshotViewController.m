//
//  OKScreenshotViewController.m
//

#import "OKScreenshotViewController.h"
#import <WebKit/WebKit.h>
#import <OneKit/OKSnapshotScroll.h>
#import <Photos/PHPhotoLibrary.h>
#import <OneKit/OKScreenshotTools.h>
#import "OKDemoBaseViewController.h"

@interface OKScreenshotViewController ()<OKDemoEntryItemProtocol>
@property (nonatomic,strong) WKWebView *webView;

@end

@implementation OKScreenshotViewController

- (void)viewDidLoad {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];

    NSString *urlStr = @"https://www.baidu.com/";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];//超时时间10秒
    //加载地址数据
    [self.webView loadRequest:request];

    self.title = @"截屏";
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    UIView *containerView0 = [[UIView alloc] initWithFrame:CGRectMake(0, -70, self.view.bounds.size.width, 70)];
    containerView0.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView0];
    
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
    containerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    containerView.layer.shadowRadius = 1;
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn0.frame = CGRectMake(16+8, 70/2 - 44/2, self.view.bounds.size.width/2 - 32, 44);
    btn1.frame = CGRectMake(16 + self.view.bounds.size.width/2-8, 70/2 - 44/2, self.view.bounds.size.width/2 - 32, 44);
    btn0.layer.cornerRadius = btn1.layer.cornerRadius = 4;
    btn0.titleLabel.font = [UIFont systemFontOfSize:16];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn0 setTitle: @"全屏截图" forState:UIControlStateNormal];
    [btn1 setTitle: @"webview截图" forState:UIControlStateNormal];
    
    btn0.backgroundColor = [UIColor colorWithRed:22/255.0 green:100/255.0 blue:255/255.0 alpha:1];
    btn1.backgroundColor = [UIColor colorWithRed:22/255.0 green:100/255.0 blue:255/255.0 alpha:1];
    [btn0 addTarget:self action:@selector(snapshotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(webviewSnapshotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:btn0];
    [containerView addSubview:btn1];

}



- (NSString *)title
{
    return @"截屏";
}

- (NSString *)iconName
{
    return @"screenshot";
}



- (void)snapshotBtnClick:(UIButton *)btn {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
          onMainThreadAsync(^{
            [OKSnapshotScroll screenSnapshot:[UIApplication sharedApplication].keyWindow finishBlock:^(UIImage *snapshotImage) {
              [self saveImage:snapshotImage];
            }];
          });
        }
    }];
}

- (void)webviewSnapshotBtnClick:(UIButton *)btn  {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
          onMainThreadAsync(^{
            [OKSnapshotScroll screenSnapshot:self.webView finishBlock:^(UIImage *snapshotImage) {
              [self saveImage:snapshotImage];
            }];
          });
        }
    }];
}



- (void)saveImage:(UIImage *)image {
  //save to photosAlbum
  UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
  if (error != NULL) {
      NSLog(@"save failed");
  } else {
      NSLog(@"save success");
  }
}

@end
