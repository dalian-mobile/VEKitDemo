//
//  OKMainViewController.m
//  App
//
//  Created by bytedance on 2022/2/17.
//

#import "OKMainViewController.h"
#import <objc/runtime.h>
#import "OKDemoBaseViewController.h"

#import <TYCyclePagerView/TYCyclePagerView.h>
#import <TYCyclePagerView/TYPageControl.h>
#import <SDWebImage/SDWebImage.h>
#import <VERemoteConfig/VERemoteConfigManager.h>

#import <OneKit/OKSectionData.h>

OK_STRINGS_EXPORT("VEAPPTabControllers","OKMainViewController")


@implementation UIViewController(item)

- (NSString *)iconName
{
    return @"";
}
- (NSString *)title
{
    return @"";
}

@end

@interface SliderCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) CALayer *gradientLayer;

@end

@implementation SliderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc] init];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
        [self addSubview:self.imgView];
        
        
        [self addBgGradientLayer];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgView.frame = self.bounds;
    self.titleLabel.frame = CGRectMake(16, self.bounds.size.height - 18 - 24, 300, 24);
//    self.gradientLayer.frame = CGRectMake(0, self.bounds.size.height - 60, self.bounds.size.width, 60);
}

- (void)addBgGradientLayer {
    UIColor *startColor = [UIColor blackColor];
    UIColor *endColor = [UIColor blackColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, self.bounds.size.height - 60, self.bounds.size.width, 60);
    gradientLayer.colors = @[(__bridge id)[startColor colorWithAlphaComponent:0.0].CGColor,
                             (__bridge id)[endColor colorWithAlphaComponent:1.0].CGColor];
    gradientLayer.startPoint = CGPointMake(.0, .0);
    gradientLayer.endPoint = CGPointMake(.0, 1.0);
    gradientLayer.opacity = 0.6;
    self.gradientLayer = gradientLayer;
    [self.layer addSublayer:gradientLayer];
}

@end


@interface OKMainCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation OKMainCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = 48;
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 -  width/2, frame.size.height/2 - width/2 - 10, width, width)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 - 50, frame.size.height - 30, 100, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
        [self addSubview:self.imgView];
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
    }
    return self;
}

@end


@interface OKMainCollectionReusableView : UICollectionReusableView

@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UIButton *infoButton;
@end

@implementation OKMainCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 100, 20)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.text = @"MARS能力集";
        self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
        [self addSubview:self.titleLabel];
//
//        Class webVC = NSClassFromString(@"VEWebContainerViewController");
//        if (webVC) {
//            self.infoButton = [UIButton buttonWithType:UIButtonTypeSystem];
//            self.infoButton.frame = CGRectMake(110, 16, 90, 20);
//            [self.infoButton setTitle:@"| 开源组件声明" forState:UIControlStateNormal];
//            self.infoButton.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
//            [self.infoButton setTitleColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
//            [self addSubview:self.infoButton];
//            self.backgroundColor = [UIColor whiteColor];
//        }
        

    }
    return self;
}


@end


#define BACKGROUND_COLOR [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#define PAGER_VIEW_HEIGHT (160.0/325.0)*kScreenWidth

#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f
/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)

@interface OKMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TYCyclePagerViewDelegate,TYCyclePagerViewDataSource>
 
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *demoItems;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) TYCyclePagerView *pagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (nonatomic,strong) NSArray *contents;

@end

@implementation OKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpFeed];
  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    VERemoteConfigManager *manager = [VERemoteConfigManager sharedInstance];
    if ([manager valueForKey:@"fetcher"]) {
        [self loadPagerData];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadPagerData];
        }) ;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (NSString *)tabImage
{
    return @"tab-home";
}

- (NSString *)tabTitle
{
    return @"首页";
}

- (void)setUpUI
{
   
    self.navigationItem.title = @"首页";
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationItem.backButtonTitle = @"";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:16]}];
    
    [self addPagerView];
    [self addPageControl];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat spacing = 12;
    CGFloat itemWidth = (self.view.bounds.size.width - 5 * spacing)/4;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth+30);
//    layout.minimumLineSpacing = spacing;
//    layout.minimumInteritemSpacing = spacing;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, PAGER_VIEW_HEIGHT-10, self.view.bounds.size.width, self.view.bounds.size.height - PAGER_VIEW_HEIGHT - kTabBarHeight * 2) collectionViewLayout:layout];
    // 加内边距
    self.collectionView.contentInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[OKMainCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[OKMainCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = BACKGROUND_COLOR;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];


    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 24, 700)];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.layer.cornerRadius = 6;
    self.whiteView.userInteractionEnabled = NO;
//    [self.collectionView addSubview:self.whiteView];
    [self.collectionView insertSubview:self.whiteView atIndex:0];
}


- (void)setUpFeed
{
    self.demoItems = [[NSMutableArray alloc] init];
    NSArray *clsNames = [OKSectionData exportedStringsForKey:@"OKDemoEntryItem"];
    [clsNames enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class cls = NSClassFromString(obj);
        UIViewController *item = [[cls alloc] init];
        [self.demoItems addObject:@[item.title,item.iconName,item]];
    }];
    
    CGFloat spacing = 12;
    CGFloat itemWidth = (self.view.bounds.size.width - 5 * spacing)/4;
    CGFloat itemHeight = itemWidth+30;
    CGFloat whiteHeight = itemHeight * ((self.demoItems.count + 3) / 4) + 80;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = self.whiteView.frame;
        self.whiteView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, whiteHeight);
        [self.collectionView reloadData];
        [self.collectionView sendSubviewToBack:self.whiteView];
//    });

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.demoItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OKMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.demoItems[indexPath.row][0];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundleURL = [bundle pathForResource:@"Public"
                                                          ofType:@"bundle"];
    NSBundle *podBundle = [NSBundle bundleWithPath:bundleURL];
    NSString *name =  self.demoItems[indexPath.row][1];
    UIImage *image = [UIImage imageNamed:self.demoItems[indexPath.row][1] inBundle:podBundle compatibleWithTraitCollection:nil];
    cell.imgView.image = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = self.demoItems[indexPath.row][2];
    [self.navigationController pushViewController:vc animated:YES];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 40);
}
 
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        OKMainCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
//        [view.infoButton addTarget:self action:@selector(tapOpensourceBtn) forControlEvents:UIControlEventTouchUpInside];

        return view;
    }
    return nil;
}

#pragma mark - page


- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, PAGER_VIEW_HEIGHT)];
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 5.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    pagerView.backgroundColor = BACKGROUND_COLOR;
    [pagerView registerClass:[SliderCollectionViewCell class] forCellWithReuseIdentifier:@"cell2"];
    [self.view addSubview:pagerView];
    self.pagerView = pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.numberOfPages = 0;
//    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [self.pagerView addSubview:pageControl];
    _pageControl = pageControl;

    pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 36, CGRectGetWidth(_pagerView.frame), 20);

}

- (void)loadPagerData {
    VERemoteConfigManager *manager = [VERemoteConfigManager sharedInstance];
    [manager fetchConfigsWithCheckInterval:YES callback:^(NSError * _Nullable error) {
        NSString *result = [manager getString:@"news.list" withDefault:@""];
        if (result) {
            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (!error && [jsonObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)jsonObj;
                self.contents = dic[@"content"];
                dispatch_async(dispatch_get_main_queue(), ^{
                self.pageControl.numberOfPages = self.contents.count;
                    [self.pagerView reloadData];
                    [self.collectionView sendSubviewToBack:self.whiteView];
//                    [self.pageControl layoutSubviews];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView sendSubviewToBack:self.whiteView];
        });
    }];
 
}


- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView
{
    return self.contents.count;
}

- (__kindof UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    SliderCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndex:index];
    NSDictionary *entry = self.contents[index];
    NSString *imageUrl = entry[@"image"];
    NSString *title = entry[@"title"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    cell.titleLabel.text = title;
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView
{
    TYCyclePagerViewLayout *layout= [[TYCyclePagerViewLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width - 26, PAGER_VIEW_HEIGHT - 20);
    layout.itemSpacing = 20;
    //layout.minimumAlpha = 0.3;
    layout.itemHorizontalCenter = YES;
    return layout;
}


- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    self.pageControl.currentPage = toIndex;
}

/**
pagerView did selected item cell
*/
- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    NSDictionary *entry = self.contents[index];
    NSString *url = entry[@"url"];
    
    Class webVC = NSClassFromString(@"VEWebContainerViewController");
    UIViewController *vc = [[webVC alloc] init];
    [vc performSelector:@selector(setUrl:) withObject:url];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
