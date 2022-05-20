//
//  OKDebugInfoViewController.m
//  App
//
//  Created by bytedance on 2022/2/18.
//

#import "OKDebugInfoViewController.h"

@interface OKDebugInfoViewController ()

@property (nonatomic,strong) UITextView *textView;

@end

@implementation OKDebugInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.editable = NO;
    self.textView.scrollEnabled = YES;
    [self.view addSubview:self.textView];
    self.textView.text = self.content;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.textView.text = content;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
