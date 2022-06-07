//
//  VEViewController.h
//  VESafeKeyboard
//
//  Created by Yifei Feng on 01/28/2022.
//  Copyright (c) 2022 Yifei Feng. All rights reserved.
//

#import <OneKit/OKModel.h>
#import "OKDemoBaseViewController.h"

@import UIKit;

@interface VESafeKeyboardViewController : OKDemoBaseViewController<UITextFieldDelegate, OKDemoEntryItemProtocol>

@end

@interface DecryptModel : NSObject

@property (nonatomic, strong) NSNumber *statusCode;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, copy) NSString *password;

@end

