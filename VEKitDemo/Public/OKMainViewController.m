//
//  OKMainViewController.m
//  App
//
//  Created by bytedance on 2022/2/17.
//

#import "OKMainViewController.h"
#import <objc/runtime.h>
#import "OKDemoBaseViewController.h"

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;


@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = 36;
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 -  width/2, frame.size.height/2 - width/2 - 10, width, width)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 - 50, frame.size.height - 30 - 5, 100, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
        [self addSubview:self.imgView];
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        
    }
    return self;
}

@end


@interface OKMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
 
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *demoItems;

@end

@implementation OKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpFeed];
}

- (void)setUpUI
{
    self.navigationItem.title = @"MARS应用框架";
    self.navigationItem.backButtonTitle = @"";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:16]}];
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat spacing = 12;
    CGFloat itemWidth = (self.view.bounds.size.width - 4 * spacing)/3;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
//    layout.minimumLineSpacing = spacing;
//    layout.minimumInteritemSpacing = spacing;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    // 加内边距
    self.collectionView.contentInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    self.collectionView.alwaysBounceVertical = YES;
    
    
    
    //去除文字
     [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMax) forBarMetrics:UIBarMetricsDefault];
     //设置返回图片，防止图片被渲染变蓝，以原图显示
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundleURL = [bundle pathForResource:@"Public"
                                                          ofType:@"bundle"];
    NSBundle *podBundle = [NSBundle bundleWithPath:bundleURL];
    UIImage *backImage = [[UIImage imageNamed:@"back" inBundle:podBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     [UINavigationBar appearance].backIndicatorTransitionMaskImage = backImage;
     [UINavigationBar appearance].backIndicatorImage = backImage;
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage;
    self.navigationController.navigationBar.backIndicatorImage = backImage;

}

- (void)getItemClasses:(void(^)(Class class))actionBlock
{
    Protocol *protocol = @protocol(OKDemoEntryItemProtocol);

    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;

    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    for (int idx = 0; idx < numClasses; idx++)
    {
        Class class = classes[idx];
        if (class_getClassMethod(class, @selector(conformsToProtocol:)) && [class conformsToProtocol:protocol])
        {
            actionBlock(class);
        }
    }
    free(classes);
}


- (void)setUpFeed
{
    self.demoItems = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getItemClasses:^(__unsafe_unretained Class class) {
            dispatch_async(dispatch_get_main_queue(), ^{
                id<OKDemoEntryItemProtocol> item = [[class alloc] init];
                [self.demoItems addObject:@[item.title,item.iconName,item]];
                [self.collectionView reloadData];
            });
        }];
    });
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
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.demoItems[indexPath.row][0];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundleURL = [bundle pathForResource:@"Public"
                                                          ofType:@"bundle"];
    NSBundle *podBundle = [NSBundle bundleWithPath:bundleURL];
    NSString *name =  self.demoItems[indexPath.row][1];
    UIImage *image = [UIImage imageNamed: self.demoItems[indexPath.row][1] inBundle:podBundle compatibleWithTraitCollection:nil];
    cell.imgView.image = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = self.demoItems[indexPath.row][2];
    [self.navigationController pushViewController:vc animated:YES];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


@end
