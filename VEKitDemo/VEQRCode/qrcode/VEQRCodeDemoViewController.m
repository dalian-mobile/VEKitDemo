//
//  VEQRCodeDemoViewController.m
//  VEKitDemo
//
//  Created by bytedance on 2022/10/11.
//

#import "VEQRCodeDemoViewController.h"
#import <SGQRCode/SGQRCode.h>
#import "UIViewController+OKDebugAlert.h"


#import <OneKit/OKSectionData.h>

OK_STRINGS_EXPORT("OKDemoEntryItem","VEQRCodeDemoViewController")



@interface VEQRCodeDemoViewController ()<SGScanCodeDelegate, SGScanCodeSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    SGScanCode *scanCode;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation VEQRCodeDemoViewController

- (NSString *)title
{
    return @"扫描二维码";
}

- (NSString *)iconName
{
    return @"demo_qrcode";
}



- (void)dealloc {
    [self stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stop];
}

- (void)start {
    [scanCode startRunning];
    [self.scanView startScanning];
}

- (void)stop {
    [scanCode stopRunning];
    [self.scanView stopScanning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configUI];
    [self configScanCode];
}

- (void)configUI {
    [self.view addSubview:self.scanView];

    [self.view addSubview:self.bottomView];
}

- (void)configScanCode {
    scanCode = [[SGScanCode alloc] init];
    if (![scanCode checkCameraDeviceRearAvailable]) {
        return;;
    }
    scanCode.delegate = self;
    scanCode.sampleBufferDelegate = self;
    scanCode.preview = self.view;
}

- (void)scanCode:(SGScanCode *)scanCode result:(NSString *)result {
    [self stop];
    if ([result hasPrefix:@"http"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
    } else {
        [self bdd_showAlertWithMessage:result];
    }
}


- (SGScanView *)scanView {
    if (!_scanView) {
        SGScanViewConfigure *configure = [[SGScanViewConfigure alloc] init];
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(x, y, w, h) configure:configure];
        
        CGFloat scan_x = 0;
        CGFloat scan_y = 0.18 * self.view.frame.size.height;
        CGFloat scan_w = self.view.frame.size.width - 2 * x;
        CGFloat scan_h = self.view.frame.size.height - 2.55 * scan_y;
        _scanView.scanFrame = CGRectMake(scan_x, scan_y, scan_w, scan_h);

        __weak typeof(self) weakSelf = self;
        _scanView.doubleTapBlock = ^(BOOL selected) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (selected) {
                [strongSelf->scanCode setVideoZoomFactor:4.0];
            } else {
                [strongSelf->scanCode setVideoZoomFactor:1.0];
            }
        };
    }
    return _scanView;
}


- (void)album_action {
    [SGPermission permissionWithType:SGPermissionTypePhoto completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    NSLog(@"第一次授权成功");
                    [self _enterImagePickerController];
                } else {
                    NSLog(@"第一次授权失败");
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            [self _enterImagePickerController];
        } else if (status == SGPermissionStatusDenied) {
            NSLog(@"VEQRPermissionStatusDenied");
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
            if (app_Name == nil) {
                app_Name = [infoDict objectForKey:@"CFBundleName"];
            }
            
            NSString *messageString = [NSString stringWithFormat:@"[前往：设置 - 隐私 - 照片 - %@] 允许应用访问", app_Name];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        } else if (status == SGPermissionStatusRestricted) {
            NSLog(@"VEQRPermissionStatusRestricted");
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }];
}

- (void)_enterImagePickerController {
    [self stop];

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - - UIImagePickerControllerDelegate 的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self start];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [scanCode readQRCode:image completion:^(NSString *result) {
        if (result == nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self start];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([result hasPrefix:@"http"]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
                } else {
                    [self bdd_showAlertWithMessage:result];
                }
            }];
        }
    }];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        CGFloat h = 100;
        CGFloat x = 0;
        CGFloat y = self.view.frame.size.height - h;
        CGFloat w = self.view.frame.size.width;
        _bottomView.frame = CGRectMake(x, y, w, h);
        _bottomView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
        
        UIButton *lab = [UIButton buttonWithType:UIButtonTypeSystem];
        [lab setTitle:@"打开相册" forState:UIControlStateNormal];
        lab.titleLabel.textAlignment = NSTextAlignmentCenter;
        [lab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lab.frame = CGRectMake(0, 0, w, h - 34);
        [lab addTarget:self action:@selector(album_action) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:lab];
    }
    return _bottomView;
}

@end
