//
//  BDPOKListViewController.m
//  App
//
//  Created by gejunchen.ChenJr on 2022/5/8.
//

#import "BDPOKListViewController.h"

#import "BDPOKScanCodeViewController.h"
#import <Timor/BDPTimorClient.h>

#import <OneKit/OKSectionData.h>

OK_STRINGS_EXPORT("OKDemoEntryItem","BDPOKListViewController")



@interface BDPOKListViewController ()

@end

@implementation BDPOKListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小程序 Demo";
    // Do any additional setup after loading the view.
}

- (NSString *)title
{
    return @"小程序";
}

- (NSString *)iconName
{
    return @"demo_timor";
}


- (void)openTimorDemo
{
    NSURL *url = [NSURL URLWithString:@"marsmp://microapp?app_id=maba3b17aeaf427ab3&bdp_log=%7B%22launch_from%22%3A%22scan%22%7D&scene=12452&version=v2&version_type=current&bdpsum=92f184c"];
    [BDPTimorClient.sharedClient openWithURL:url];
}

- (NSArray<OKListCellModel *> *)models
{
    @weakify(self);
    return @[
        [[OKListCellModel alloc] initWithTitle:@"打开小程序 demo" imageName:@"rc1" actionBlock:^{
            @strongify(self)
            [self openTimorDemo];
        }],
        [[OKListCellModel alloc] initWithTitle:@"扫码打开小程序" imageName:@"rc1" jumpVC:BDPOKScanCodeViewController.class]
    ];
}


@end
