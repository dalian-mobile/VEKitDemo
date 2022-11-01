//
//  VECampaignListViewController.m
//  App
//
//  Created by Ada on 2022/5/10.
//

#import "VECampaignListViewController.h"
#import "VECampaign/VECampaignManager.h"
#import <YYModel/YYModel.h>
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>
#import <OneKit/OKApplicationInfo.h>
#import <OneKit/OKSectionData.h>

OK_STRINGS_EXPORT("OKDemoEntryItem","VECampaignListViewController")

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ButtonColor [UIColor colorWithRed:22/255.0 green:100/255.0 blue:255/255.0 alpha:1.0]

@interface VEViewController : UIViewController

@end

@interface VEWKViewController : UIViewController

- (nonnull instancetype)initWithUrl:(NSURL *_Nonnull)url;

@end

@interface VEScanViewController : UIViewController

@end

@interface OpenUrlDelegate : NSObject <VECampaignDelegate>

@end

@implementation OpenUrlDelegate

- (BOOL)openUrl:(NSURL *)url {
    NSLog(@"url: %@",url);
    VEWKViewController *wkVc = [[VEWKViewController alloc] initWithUrl:url];
    UIApplication *app = UIApplication.sharedApplication;
    [(UINavigationController*)app.keyWindow.rootViewController pushViewController:wkVc animated:YES];
    return YES;
}

@end

@implementation VEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* triggerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    triggerButton.titleLabel.font = [UIFont systemFontOfSize:25];
    triggerButton.backgroundColor = ButtonColor;
    [triggerButton setTitle:@"触发事件" forState:UIControlStateNormal];
    [triggerButton addTarget:self action:@selector(trigger) forControlEvents:UIControlEventTouchUpInside];
    triggerButton.frame = CGRectMake(ScreenW*0.1, 100, ScreenW*0.8, 50);
    [self.view addSubview:triggerButton];

    UIButton* showCampaignsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showCampaignsButton.titleLabel.font = [UIFont systemFontOfSize:25];
    showCampaignsButton.backgroundColor = ButtonColor;
    [showCampaignsButton setTitle:@"获取活动数据" forState:UIControlStateNormal];
    [showCampaignsButton addTarget:self action:@selector(showCampaigns) forControlEvents:UIControlEventTouchUpInside];
    showCampaignsButton.frame = CGRectMake(ScreenW*0.1, 200, ScreenW*0.8, 50);
    [self.view addSubview:showCampaignsButton];
    
    UIButton* showRecordsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showRecordsButton.titleLabel.font = [UIFont systemFontOfSize:25];
    showRecordsButton.backgroundColor = ButtonColor;
    [showRecordsButton setTitle:@"获取活动记录" forState:UIControlStateNormal];
    [showRecordsButton addTarget:self action:@selector(showRecords) forControlEvents:UIControlEventTouchUpInside];
    showRecordsButton.frame = CGRectMake(ScreenW*0.1, 300, ScreenW*0.8, 50);
    [self.view addSubview:showRecordsButton];
    
    UIButton* showCountsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showCountsButton.titleLabel.font = [UIFont systemFontOfSize:25];
    showCountsButton.backgroundColor = ButtonColor;
    [showCountsButton setTitle:@"获取事件计数" forState:UIControlStateNormal];
    [showCountsButton addTarget:self action:@selector(showEventCounts) forControlEvents:UIControlEventTouchUpInside];
    showCountsButton.frame = CGRectMake(ScreenW*0.1, 400, ScreenW*0.8, 50);
    [self.view addSubview:showCountsButton];
    
    UIButton* cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanButton.titleLabel.font = [UIFont systemFontOfSize:25];
    cleanButton.backgroundColor = ButtonColor;
    [cleanButton setTitle:@"清除记录和计数" forState:UIControlStateNormal];
    [cleanButton addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
    cleanButton.frame = CGRectMake(ScreenW*0.1, 500, ScreenW*0.8, 50);
    [self.view addSubview:cleanButton];
}

- (void)trigger{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入事件名"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"eventName";
    }];


    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"触发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[VECampaignManager sharedInstance] triggerEvent:alertController.textFields.firstObject.text];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showCampaigns{
    NSDictionary<NSString *, id> *centers = [[VECampaignManager sharedInstance] performSelector:@selector(centers)];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [centers enumerateKeysAndObjectsUsingBlock:^(NSString *key, id center, BOOL *stop) {
        id cacher = [center performSelector:@selector(cacher)];
        NSArray *campaigns = [cacher performSelector:@selector(getCampaigns)];
        NSMutableArray *campaignJsons = [NSMutableArray array];
        for(id campaign in campaigns){
            [campaignJsons addObject:[campaign performSelector:@selector(yy_modelToJSONObject)]];
        }
        data[key] = campaignJsons;
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:[NSString stringWithFormat:@"活动数据: %@", data]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showEventCounts{
    NSDictionary<NSString *, id> *centers = [[VECampaignManager sharedInstance] performSelector:@selector(centers)];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [centers enumerateKeysAndObjectsUsingBlock:^(NSString *key, id center, BOOL *stop) {
        id cacher = [center performSelector:@selector(cacher)];
        data[key] = [cacher performSelector:@selector(getEventCounts)];
    }];

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:[NSString stringWithFormat:@"事件计数: %@", data]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showRecords{
    NSDictionary<NSString *, id> *centers = [[VECampaignManager sharedInstance] performSelector:@selector(centers)];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [centers enumerateKeysAndObjectsUsingBlock:^(NSString *key, id center, BOOL *stop) {
        id recorder = [center performSelector:@selector(recorder)];
        data[key] = [recorder performSelector:@selector(getRecordList)];
    }];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:[NSString stringWithFormat:@"活动记录: %@", data]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clean{
    NSDictionary<NSString *, id> *centers = [[VECampaignManager sharedInstance] performSelector:@selector(centers)];
    [centers enumerateKeysAndObjectsUsingBlock:^(NSString *key, id center, BOOL *stop) {
        id recorder = [center performSelector:@selector(recorder)];
        id cacher = [center performSelector:@selector(cacher)];
        [recorder performSelector:@selector(cleanRecords)];
        [cacher performSelector:@selector(cleanEventCounts)];
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"清除成功"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)scan{
    [self.navigationController pushViewController:[VEScanViewController new] animated:YES];
}

@end


@interface VEWKViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *url;

@end

@implementation VEWKViewController

- (instancetype)initWithUrl:(NSURL *)url{
    if(self = [super init]){
        _url = url;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.view addSubview:self.webView];
}

@end

@interface VEScanViewController() <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *dataOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation VEScanViewController

- (CGRect)scanArea{
    CGFloat scanWidth = self.view.frame.size.width * 0.75;
    CGFloat scanHeight = scanWidth;
    CGRect scanRect = CGRectMake((self.view.frame.size.width - scanWidth)/2, (self.view.frame.size.height - scanHeight)/2, scanWidth, scanHeight);
    return scanRect;
}

- (UIView *)maskView{
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.frame];
    maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    UIBezierPath *fullBezierPath = [UIBezierPath bezierPathWithRect:self.view.frame];
    UIBezierPath *scanBezierPath = [UIBezierPath bezierPathWithRect:[self scanArea]];
    [fullBezierPath appendPath:[scanBezierPath  bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = fullBezierPath.CGPath;
    maskView.layer.mask = shapeLayer;
    return maskView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"Init device input error: %@",error);
        return;
    }
    
    _dataOutput = [[AVCaptureMetadataOutput alloc]init];
    [_dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.deviceInput]) {
        [_session addInput:self.deviceInput];
    }
    if ([_session canAddOutput:self.dataOutput]){
        [_session addOutput:self.dataOutput];
        if (![self.dataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            NSLog(@"The camera does not surpport QRCode.");
            return;
        }
        self.dataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.frame;
    
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.view addSubview:[self maskView]];
    [self.session startRunning];
    self.dataOutput.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:[self scanArea]];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray<AVMetadataMachineReadableCodeObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        NSString *result = [metadataObjects.firstObject stringValue];
        NSLog(@"Scan result: %@", result);
        
        [[VECampaignManager sharedInstance] fetchPreviewCampaign:result];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end


@interface VECampaignListViewController()

@end

@implementation VECampaignListViewController

- (NSString *)title
{
    return @"运营投放";
}

- (NSString *)iconName
{
    return @"demo_compaign";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"运营投放";
    VECampaignManager *manager = [VECampaignManager sharedInstance];
    manager.campaignDelegate = [OpenUrlDelegate new];
}


- (NSArray<OKListCellModel *> *)models
{
    return @[[[OKListCellModel alloc] initWithTitle:@"扫码预览" imageName:@"rc1" jumpVC:[VEScanViewController class]],
    [[OKListCellModel alloc] initWithTitle:@"API调用测试" imageName:@"rc2" jumpVC:[VEViewController class]],
    ];
}

@end
