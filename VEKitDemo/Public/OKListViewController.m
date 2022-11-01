//
//  OKListViewController.m
//  App
//
//  Created by bytedance on 2022/2/18.
//

#import "OKListViewController.h"

@implementation OKListCellModel

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName jumpVC:(Class)jumpVC
{
    return [self initWithTitle:title subTitle:nil imageName:imageName jumpVC:jumpVC];

}

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName actionBlock:(dispatch_block_t)actionBlock
{
    return [self initWithTitle:title subTitle:nil imageName:imageName actionBlock:actionBlock];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(nullable NSString *)subTitle imageName:(NSString *)imageName actionBlock:(dispatch_block_t)actionBlock
{
    if (self = [super init]) {
        self.title = title;
        self.subTitle = subTitle;
        self.imageName = imageName;
        self.actionBlock = actionBlock;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle imageName:(NSString *)imageName jumpVC:(Class)jumpVC
{
    return [self initWithTitle:title subTitle:nil imageName:imageName jumpVC:jumpVC jumpModels:nil];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle imageName:(NSString *)imageName jumpVC:(Class)jumpVC jumpModels:(NSArray <OKListCellModel *>*)jumpModels;
{
    if (self = [super init]) {
        self.title = title;
        self.subTitle = subTitle;
        self.imageName = imageName;
        self.jumpVC = jumpVC;
        self.jumpModels = jumpModels;
    }
    return self;
}

@end


@interface OKListCell : UITableViewCell

@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *arrowImgView;

- (void)setModel:(OKListCellModel *)model;

@end

@implementation OKListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat cellHeight = 80;
        CGFloat border = 8;
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(16, border, [UIScreen mainScreen].bounds.size.width - 32, 80)];
        [self addSubview:self.containerView];
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.containerView.layer.cornerRadius = 4;

        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 24, 32, 32)];
//        self.imgView.backgroundColor = [UIColor yellowColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+32+16, cellHeight/2 - 20/2, 200, 20)];
//        self.titleLabel.backgroundColor = [UIColor redColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:16];
        [self.containerView addSubview:self.imgView];
        [self.containerView addSubview:self.titleLabel];
        
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat arrowWidth = 16;
        self.arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 16 - arrowWidth - 16 * 2, cellHeight/2 - arrowWidth/2, arrowWidth, arrowWidth)];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *bundleURL = [bundle pathForResource:@"Public" ofType:@"bundle"];
        NSBundle *podBundle = [NSBundle bundleWithPath:bundleURL];
        self.arrowImgView.image = [UIImage imageNamed:@"arrow" inBundle:podBundle compatibleWithTraitCollection:nil];
        [self.containerView addSubview:self.arrowImgView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setModel:(OKListCellModel *)model
{
    self.titleLabel.text = model.title;
    if (model.imageName) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *bundleURL = [bundle pathForResource:@"Public" ofType:@"bundle"];
        NSBundle *podBundle = [NSBundle bundleWithPath:bundleURL];
        self.imgView.image = [UIImage imageNamed:model.imageName inBundle:podBundle compatibleWithTraitCollection:nil];
    }else{
        CGRect frame = self.titleLabel.frame;
        frame.origin.x = 16;
        self.titleLabel.frame = frame;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.titleLabel.frame = CGRectMake(16+32+16, 80/2 - 20/2, 200, 20);
    self.titleLabel.text = nil;
    self.imgView.image = nil;
}

@end

@interface OKListSubTitleCell : OKListCell

@property (nonatomic,strong) UILabel *subTitleLabel;

@end

@implementation OKListSubTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat cellHeight = 80;
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16+32+16, cellHeight/2 - 20/2 + 13, 200, 20)];
        self.subTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.subTitleLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
        self.subTitleLabel.textColor = [UIColor lightGrayColor];
        [self.containerView addSubview:self.subTitleLabel];
        self.titleLabel.frame = CGRectMake(16+32+16, cellHeight/2 - 20/2 - 12, 200, 20);
    }
    return self;
}

- (void)setModel:(OKListCellModel *)model
{
    [super setModel:model];
    if (!model.imageName) {
        CGRect frame = self.titleLabel.frame;
        frame.origin.x = 16;
        self.titleLabel.frame = frame;
        CGRect frame2 = self.subTitleLabel.frame;
        frame2.origin.x = 16;
        self.subTitleLabel.frame = frame2;
    }
    self.subTitleLabel.text = model.subTitle;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.subTitleLabel.text = nil;
    self.titleLabel.frame = CGRectMake(16+32+16, 80/2 - 20/2 - 12, 200, 20);
    self.subTitleLabel.frame = CGRectMake(16+32+16, 80/2 - 20/2  + 13, 200, 20);
}

@end


@interface OKListViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation OKListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self registerTableViewCell];
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
}

- (void)registerTableViewCell {
    [self.tableView registerClass:[OKListCell class] forCellReuseIdentifier:[self cellReuseID1]];
    [self.tableView registerClass:[OKListSubTitleCell class] forCellReuseIdentifier:[self cellReuseID2]];

}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OKListCellModel *model = [self.models objectAtIndex:indexPath.row];
    OKListCell *cell;
    if (model.subTitle) {
        cell = [tableView dequeueReusableCellWithIdentifier:[self cellReuseID2]];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:[self cellReuseID1]];
    }
    [cell setModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // handle VC push
    OKListCellModel *model = [self.models objectAtIndex:indexPath.row];
    if (model.actionBlock) {
        model.actionBlock();
    }else if (model.jumpVC){
        UIViewController *vc = [[model.jumpVC alloc] init];
        if (model.jumpModels) {
            OKListViewController *listVC = (OKListViewController *)vc;
            listVC.models = model.jumpModels;
        }
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80 + 16;
}


#pragma mark - cell reuse ID
- (NSString *)cellReuseID1 {
    return @"base_cellReuseIDTitle";
}
- (NSString *)cellReuseID2 {
    return @"base_cellReuseIDSubtitle";
}

@end
