//
//  BDPOKScanCodeViewController.m
//  TTMicroAppDemo
//
//  Created by 杨启航 on 2020/12/18.
//

#import "BDPOKScanCodeViewController.h"
#import <AVKit/AVKit.h>
#import <WebKit/WebKit.h>

#import <Timor/BDPTimorClient.h>

#ifndef WeakSelf
    #define WeakSelf __weak typeof(self) wself = self
#endif
 
#ifndef StrongSelfIfNilReturn
    #define StrongSelfIfNilReturn \
    __strong typeof(wself) self = wself;\
    if (!self) {\
        return;\
    }
#endif

@interface BDPOKScanCodeViewController () <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WKNavigationDelegate>

@property (nonatomic, copy) void(^completion)(UIViewController*, NSString *, NSError *);
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *deviceOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation BDPOKScanCodeViewController

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        WeakSelf;
        self.completion = ^(UIViewController *vc, NSString *res, NSError *error) {
            StrongSelfIfNilReturn;
            if (res != nil) {
                [self handleURLString:res];
            }
        };
        self.session = [[AVCaptureSession alloc] init];
        self.deviceOutput = [[AVCaptureMetadataOutput alloc] init];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(onOpenAlbum:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initCamera];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

#pragma mark - Camera

- (void)initCamera {
    if (![self checkCamera]) return;
    if (self.session.isRunning) return;
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    [self.deviceOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }
    if ([self.session canAddOutput:self.deviceOutput]) {
        [self.session addOutput:self.deviceOutput];
    }
    self.deviceOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = kCAGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    [self.session startRunning];
}

- (BOOL)checkCamera {
    NSInteger count = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
    if (count < 1) return NO;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return NO;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self showAlert:@"无相机权限"];
        return NO;
    }
    return YES;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [self.session stopRunning];
    AVMetadataMachineReadableCodeObject *data = [metadataObjects firstObject];
    if (data == nil) return;
    NSString *result = [data stringValue];
    if (result == nil) return;
    self.completion(self, result, nil);
}

#pragma mark - Album

- (void)onOpenAlbum:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image == nil) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    CIImage *img = [CIImage imageWithCGImage:image.CGImage];
    if (img == nil) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    CIQRCodeFeature *feature = (CIQRCodeFeature *)[[detector featuresInImage:img] firstObject];
    if (feature != nil && [feature isKindOfClass:[CIQRCodeFeature class]]) {
        WeakSelf;
        [picker dismissViewControllerAnimated:YES completion:^{
            StrongSelfIfNilReturn;
            self.completion(self, feature.messageString, nil);
        }];
        return;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - handler

- (void)handleURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        WKWebView *webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:[WKWebViewConfiguration new]];
        webview.navigationDelegate = self;
        [self.view addSubview:webview];
        [webview loadRequest:[NSURLRequest requestWithURL:url]];
    } else {
        [self handleResultString:urlString];
    }
    
}

- (void)handleResultString:(NSString *)str {
    NSURLComponents *url = [[NSURLComponents alloc] initWithString:str];
    if (url == nil) return;
    if ([url.host isEqualToString:@"microapp"] || [url.host isEqualToString:@"tmatest" ]) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [BDPTimorClient.sharedClient openWithURL:url.URL];
        }];
        [CATransaction commit];
    }
//    url.scheme = @"sslocal";

}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.request.URL != nil) {
        [self handleResultString:navigationAction.request.URL.absoluteString];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - Helpers

- (void)showAlert:(NSString *)str {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:act];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
