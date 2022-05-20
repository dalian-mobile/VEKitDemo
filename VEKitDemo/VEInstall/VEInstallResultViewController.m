//
//  VEInstallResultViewController.m
//  App
//
//  Created by KiBen on 2021/10/15.
//

#import "VEInstallResultViewController.h"
#import <OneKit/OKServices.h>

@interface VEInstallResultViewController () <VEInstallObserverProtocol>
@property (nonatomic, weak) UITextView *textView;
@end

@implementation VEInstallResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.editable = NO;
    [self.view addSubview:textView];
    self.textView = textView;
    
    [_install removeObserver:self];
    [_install addObserver:self];
    [_install registerDevice];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        id<OKDeviceService> deviceService = [[OKServiceCenter sharedInstance] serviceForProtocol:@protocol(OKDeviceService)];
        NSLog(@"viewDidAppear VEInstallStartUpTask  %@", deviceService.deviceID);
    });
}

- (void)install:(VEInstall *)install didRegisterDeviceWithResponse:(VEInstallRegisterResponse *)registerReponse {
    self.textView.text = [registerReponse description];
}

- (void)install:(VEInstall *)install didRegisterDeviceFailWithError:(NSError *)error {
    self.textView.text = [NSString stringWithFormat:@"didRegisterDeviceFailWithError: %@", error];
}

- (void)install:(VEInstall *)install didActivateDeviceWithResponse:(BOOL)isActivated {
    self.textView.text = [NSString stringWithFormat:@"%@\n\n激活状态:%d", self.textView.text, isActivated];
}

- (void)install:(VEInstall *)install didActivateDeviceFailWithError:(NSError *)error {
    self.textView.text = [NSString stringWithFormat:@"didActivateDeviceFailWithError: %@", error];
}

@end
