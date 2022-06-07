//
//  VEViewController.m
//  VESafeKeyboard
//
//  Created by Yifei Feng on 01/28/2022.
//  Copyright (c) 2022 Yifei Feng. All rights reserved.
//

#import "VESafeKeyboardViewController.h"
#import <VESafeKeyboard/VESafeKeyboardSet.h>

#import <OneKit/OKNetworkFetcher.h>
#import <OneKit/OKRequest.h>
#import <OneKit/OKRequestBuilder.h>
#import <OneKit/OKModel.h>

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ButtonColor [UIColor colorWithRed:22/255.0 green:100/255.0 blue:255/255.0 alpha:1.0]

#define UICOLOR_FROM_RGB_OxFF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef void (^NetworkCallback)(NSData *data, NSURLResponse *response, NSError *error);

@interface VESafeKeyboardViewController ()

@property(nonatomic ,strong) UITextField * firstResponderTextF;//记录将要编辑的输入框

@end

@implementation DecryptModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"statusCode": @"status_code",
        @"errorMsg": @"error_msg"
    };
}

@end

@implementation VESafeKeyboardViewController

- (NSString *)iconName {
    return @"keyboard";
}

- (NSString *)title {
    return  @"安全键盘";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //监听键盘展示和隐藏的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 触摸背景收起键盘
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    tap1.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tap1];
    
    CGFloat padding = 15 + 60;
    CGFloat top = 100;
    
    // theme change button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:UICOLOR_FROM_RGB_OxFF(0xDBE0E8)];
    button.layer.cornerRadius = 4;
    [button.layer setMasksToBounds:YES];
    button.frame = CGRectMake(ScreenW*0.1, top, ScreenW*0.8, 50);
    [button setTitleColor:UICOLOR_FROM_RGB_OxFF(0x1D2129) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:24];
    [button setTitle:@"切换主题" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onThemeChangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    VESafeTextField* tf1 = [[VESafeTextField alloc] initWithKeyboardType:VESafeKeyboardTypeNumber isRandom:NO isInputEcho:NO isKeyEcho:NO envCheckHandler:nil];
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    tf1.placeholder = @"纯数字键盘（无回显，有序）";
    tf1.frame = CGRectMake(ScreenW*0.1, top + padding * 1, ScreenW*0.8, 50);
    [self.view addSubview:tf1];
    
    VESafeTextField* tf2 = [[VESafeTextField alloc] initWithKeyboardType:VESafeKeyboardTypeNumberPoint isRandom:YES isInputEcho:NO isKeyEcho:YES envCheckHandler:nil];
    tf2.borderStyle = UITextBorderStyleRoundedRect;
    tf2.placeholder = @"点数字键盘（键盘回显）";
    tf2.frame = CGRectMake(ScreenW*0.1, top + padding * 2, ScreenW*0.8, 50);
    [self.view addSubview:tf2];
    
    VESafeTextField* tf3 = [[VESafeTextField alloc] initWithKeyboardType:VESafeKeyboardTypeNumberX isRandom:YES isInputEcho:YES isKeyEcho:NO envCheckHandler:nil];
    tf3.borderStyle = UITextBorderStyleRoundedRect;
    tf3.placeholder = @"X数字键盘（输入回显）";
    tf3.frame = CGRectMake(ScreenW*0.1, top + padding * 3, ScreenW*0.8, 50);
    [self.view addSubview:tf3];
    
    VESafeTextField* tf4 = [[VESafeTextField alloc] initWithKeyboardType:VESafeKeyboardTypeLetter isRandom:YES isInputEcho:YES isKeyEcho:YES envCheckHandler:nil];
    tf4.borderStyle = UITextBorderStyleRoundedRect;
    tf4.placeholder = @"字符键盘（全回显）";
    tf4.frame = CGRectMake(ScreenW*0.1, top + padding * 4, ScreenW*0.8, 50);
    [self.view addSubview:tf4];
    
    VESafeTextField* tf5 = [[VESafeTextField alloc] initWithKeyboardType:VESafeKeyboardTypeNumberABC isRandom:YES isInputEcho:NO isKeyEcho:NO envCheckHandler:^void(UITextField *textField, VEEnvCheckResult result) {
        NSMutableString *str = [NSMutableString stringWithFormat:@""];
        for(NSInteger numberCopy = result; numberCopy > 0; numberCopy >>= 1)
        {
            // Prepend "0" or "1", depending on the bit
            [str insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
        }
        
        NSString *labelText = [NSString stringWithFormat:@"安全问题类型：%@", str];
        UILabel *label = [self makeTextLabel:textField labelText:labelText];
        [self.view addSubview:label];
        [textField resignFirstResponder];
        
        if (result & VEEnvCheckScreenShot) {
            UIAlertController * alertVc =[UIAlertController alertControllerWithTitle:@"信息提示" message:@"为保证用户名,密码安全,请不要截屏或录屏!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * knowAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
            [alertVc addAction:knowAction];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
        return;
    }];
    tf5.borderStyle = UITextBorderStyleRoundedRect;
    tf5.placeholder = @"数字ABC键盘（安全监听）";
    tf5.frame = CGRectMake(ScreenW*0.1, top + padding * 5, ScreenW*0.8, 50);
    [self.view addSubview:tf5];
    
    VESafeTextField* tf6 = [[VESafeTextField alloc] initWithKeyboardType:VESafeKeyboardTypeLetterNumber isRandom:YES isInputEcho:NO isKeyEcho:NO envCheckHandler:nil];
    tf6.borderStyle = UITextBorderStyleRoundedRect;
    tf6.placeholder = @"数字字母键盘";
    tf6.frame = CGRectMake(ScreenW*0.1, top + padding * 6, ScreenW*0.8, 50);
    [self.view addSubview:tf6];
    
    VESafeTextField* tf7 = [[VESafeTextField alloc] initWithKeyboardType:VESafeKeyboardTypeSymbol isRandom:YES isInputEcho:NO isKeyEcho:NO envCheckHandler:nil];
    tf7.borderStyle = UITextBorderStyleRoundedRect;
    tf7.placeholder = @"符号键盘";
    tf7.frame = CGRectMake(ScreenW*0.1, top + padding * 7, ScreenW*0.8, 50);
    [self.view addSubview:tf7];
    
    VESafeTextField* tf8 = [[VESafeTextField alloc] initWithKeyboardType:VESafeKeyboardTypeFullSymbol isRandom:YES isInputEcho:NO isKeyEcho:NO envCheckHandler:nil];
    tf8.borderStyle = UITextBorderStyleRoundedRect;
    tf8.placeholder = @"全符号键盘";
    tf8.frame = CGRectMake(ScreenW*0.1, top + padding * 8, ScreenW*0.8, 50);
    [self.view addSubview:tf8];

    tf1.delegate = self;
    tf2.delegate = self;
    tf3.delegate = self;
    tf4.delegate = self;
    tf5.delegate = self;
    tf6.delegate = self;
    tf7.delegate = self;
    tf8.delegate = self;
}

- (void)dealloc{
    //移除键盘通知监听者
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onThemeChangeButtonClick:(UIButton *)sender {
    if (VESafeKeyboardTheme.themeStyle == VESafeKeyboardLightTheme) {
        [[VESafeKeyboardManager sharedInstance] setKeyboardTheme:VESafeKeyboardDarkTheme];
    } else {
        [[VESafeKeyboardManager sharedInstance] setKeyboardTheme:VESafeKeyboardLightTheme];
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
}

-(UILabel*)makeTextLabel:(UITextField*)textField labelText:(NSString*)labelText {
    CGPoint origin = textField.frame.origin;
    CGSize size = textField.frame.size;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(origin.x + 10, origin.y + size.height + 3, size.width, 20)];
    titleLabel.text = labelText;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [titleLabel setTextColor:UICOLOR_FROM_RGB_OxFF(0x505050)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    return titleLabel;
}

#pragma maek UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.firstResponderTextF = textField;//当将要开始编辑的时候，获取当前的textField
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.inputView == nil) {
        return;
    }
    
    if (textField.text == nil || textField.text.length == 0) {
        return;
    }
    
    VESafeTextField* veSafeTextField = (VESafeTextField*)textField;
    NSString *ciperText = [veSafeTextField getEncryptText];
    
    NSLog(@"ciperText: %@", ciperText);
    
    UILabel *titleLabel = [self makeTextLabel:textField labelText:@"解密中"];
    
    [self decrypt:ciperText label:titleLabel];
    
    [self.view addSubview:titleLabel];
}

#pragma mark : UIKeyboardWillShowNotification/UIKeyboardWillHideNotification
- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect rect = [self.firstResponderTextF.superview convertRect:self.firstResponderTextF.frame toView:self.view];//获取相对于self.view的位置
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];//获取弹出键盘的fame的value值
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:self.view.window];//获取键盘相对于self.view的frame ，传window和传nil是一样的
    CGFloat keyboardTop = keyboardRect.origin.y;
    NSNumber * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//获取键盘弹出动画时间值
    NSTimeInterval animationDuration = [animationDurationValue doubleValue];
    if (keyboardTop < CGRectGetMaxY(rect)) {//如果键盘盖住了输入框
        CGFloat gap = keyboardTop - CGRectGetMaxY(rect) - 10;//计算需要网上移动的偏移量（输入框底部离键盘顶部为10的间距）
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:animationDuration animations:^{
            weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, gap, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//获取键盘隐藏动画时间值
    NSTimeInterval animationDuration = [animationDurationValue doubleValue];
    if (self.view.frame.origin.y < 0) {//如果有偏移，当影藏键盘的时候就复原
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:animationDuration animations:^{
            weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
        }];
    }
}

#pragma mark : decrypt
// 接入统一网络
- (void)decrypt:(NSString*)text label:(UILabel *)label {
    if (!text) {
        return;
    }
    OKRequest *okRequest = [[[[[OKRequestBuilder new]
                               method:OKNetworkMethodPost]
                              url:@"https://xxx"]
                             setJsonBody:@{ @"encrypt_str": text}]
                            build];
    
    OKNetworkFetcher *fetcher = [OKNetworkFetcher new];
    [fetcher execute:okRequest
      withReturnType: DecryptModel.class // model class that confirm to OKModel category
       andCompletion:^(OKResult * _Nonnull result) {
        switch (result.metaType) {
            case OKResultFailure: {
                NSLog(@"Server error: %@", result.error);
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    label.text = @"demo的解密仅作示例参考，如有需要请联系MARS产品";
                }];
                return;
            }

            case OKResultSuccess: {
                OKResponse *response = (OKResponse *)result.value;
                if (!response) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        label.text = @"解密失败，response is null";
                    }];
                    return;
                }
                
                if ([response isResponseSuccess]) {
                    DecryptModel *model = (DecryptModel *)[response.input toObject];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response.body options:kNilOptions error:nil];
                    if ([model.statusCode isEqualToNumber:@0]) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            label.text = [[NSString alloc] initWithFormat:@"服务端结果: %@", model.password];
                        }];
                    } else {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            label.text = [NSString stringWithFormat:@"解密失败，error: %@", model.errorMsg];
                        }];
                    }
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        label.text = @"解密失败，code is not 200";
                    }];
                    return;
                }
            }
         }
    }];
}

@end
