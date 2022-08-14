//
//  OneKitPrivacyStartUpTask.m
//  VEKitDemo
//
//  Created by bytedance on 2022/7/18.
//

#import "OneKitPrivacyStartUpTask.h"
#import <OneKit/OneKitApp.h>
#import <LGAlertView/LGAlertView.h>

#define ONEKIT_PRIVACY_TRYED_KEY @"VEOneKitPrivacyTryed"

OKAppTaskAddFunction () {
    [[OneKitPrivacyStartUpTask new] scheduleTask];
}


@interface OneKitPrivacyStartUpTask()<UITextViewDelegate,LGAlertViewDelegate>

@end

@implementation OneKitPrivacyStartUpTask

- (void)startWithLaunchOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions
{
    if ([OneKitApp requirePrivacy]) {
        BOOL has_tryed = [[NSUserDefaults standardUserDefaults] boolForKey:ONEKIT_PRIVACY_TRYED_KEY];
        if (!has_tryed) {
            [self tryGrantPrivacy];
        }
    }
}

- (void)tryGrantPrivacy
{
    
    NSString *content = @"<p>请充分阅读并理解</p> <p><a href = 'www.bytedance.com'>《隐私政策》</a>和<a href = 'www.bytedance.com'>《用户协议》</a></p> \
    <p>1.我们对您的个人信息的收集/保存/使用/对外提供/保护等规则条款，以及您的用户权利等条款</p>  \
    <p>2.约定我们的限制责任、免责条款</p> \
    <p>3.其他以颜色或加粗进行标识的重要条款。</p> \
    <p>如您同意以上协议内容，请点击“同意”，开始使用我们的产品和服务!</p> ";
    
    UITextView *textView = [[[UITextView alloc] init] initWithFrame:CGRectMake(0, 0, 200, 250)];
    NSAttributedString *contentStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    textView.attributedText = contentStr;
    textView.bounds = CGRectMake(0, 0, 200, 200);
    LGAlertView *alertView = [[LGAlertView alloc] initWithViewAndTitle:@"隐私" message:nil style:LGAlertViewStyleAlert view:textView buttonTitles:@[@"不同意",@"同意"] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        if (index == 1) {
            [OneKitApp grantPrivacy];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ONEKIT_PRIVACY_TRYED_KEY];
        }else{
            // not granted..
        }
    } cancelHandler:nil destructiveHandler:nil];
//    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(nonnull LGAlertView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title
{

}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    return YES;
}


@end
