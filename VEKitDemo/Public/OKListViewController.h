//
//  OKListViewController.h
//  App
//
//  Created by bytedance on 2022/2/18.
//

#import <UIKit/UIKit.h>
#import "OKDemoBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OKListCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;  //可以为空，自动布局
@property (nonatomic, copy) NSString *imageName; //可以为空，自动布局
@property (nonatomic, copy) dispatch_block_t actionBlock;  //点击的行为
@property (nonatomic, strong) Class jumpVC;  //跳转push的VC
@property (nonatomic, copy) NSArray <OKListCellModel *> *jumpModels; //可以嵌套简单的页面跳转

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName jumpVC:(Class)jumpVC;
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName actionBlock:(dispatch_block_t)actionBlock;
- (instancetype)initWithTitle:(NSString *)title subTitle:(nullable NSString *)subTitle imageName:(NSString *)imageName actionBlock:(dispatch_block_t)actionBlock;
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle imageName:(NSString *)imageName jumpVC:(Class)jumpVC;
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle imageName:(NSString *)imageName jumpVC:(Class)jumpVC jumpModels:(NSArray <OKListCellModel *>*)jumpModels;


@end



@interface OKListViewController : OKDemoBaseViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray <OKListCellModel *> *models;

/// override to register a different cell
- (void)registerTableViewCell;

/// override to provide a different cell reuse id
/// usually no need to override this
- (NSString *)cellReuseID1;

@end

NS_ASSUME_NONNULL_END
