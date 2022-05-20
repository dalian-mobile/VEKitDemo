//
//  VERemoteConfigViewController.m
//  App
//
//  Created by Ada on 2021/11/10.
//

#import "VERemoteConfigViewController.h"
# if __has_include(<VERemoteConfig/VERemoteConfigManager.h>)

#import <VERemoteConfig/VERemoteConfigManager.h>
#import <VERemoteConfig/TestPageViewController.h>

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ButtonColor [UIColor colorWithRed:22/255.0 green:100/255.0 blue:255/255.0 alpha:1.0]
#define BackgroundColor [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0]

@interface VERemoteConfigViewController ()

@property (nonatomic, strong) VERemoteConfigManager *manager;

@end

@implementation VERemoteConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.manager = [VERemoteConfigManager sharedInstance];
//    VERemoteConfigInfo *info = [VERemoteConfigInfo new];
//    info.host = @"XXX";
//    info.deviceID = @"XXX";
//    info.appKey = @"XXX";
//    info.appSecret = @"XXX";
//    info.interval = XXX;
//    info.channel = @"XXX";
//    [self.manager setUp:info];
//    [self.manager setInterval:XXX];
    
    UIButton* testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.titleLabel.font = [UIFont systemFontOfSize:25];
    testButton.backgroundColor = ButtonColor;
    [testButton setTitle:@"测试页面" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    testButton.frame = CGRectMake(ScreenW*0.1, 100, ScreenW*0.8, 50);
    [self.view addSubview:testButton];
    
    UIButton* fetchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fetchButton.titleLabel.font = [UIFont systemFontOfSize:25];
    fetchButton.backgroundColor = ButtonColor;
    [fetchButton setTitle:@"拉取远程配置" forState:UIControlStateNormal];
    [fetchButton addTarget:self action:@selector(fetch) forControlEvents:UIControlEventTouchUpInside];
    fetchButton.frame = CGRectMake(ScreenW*0.1, 170, ScreenW*0.8, 50);
    [self.view addSubview:fetchButton];
    
    UIButton* stringButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stringButton.titleLabel.font = [UIFont systemFontOfSize:25];
    stringButton.backgroundColor = ButtonColor;
    [stringButton setTitle:@"get string" forState:UIControlStateNormal];
    [stringButton addTarget:self action:@selector(getString) forControlEvents:UIControlEventTouchUpInside];
    stringButton.frame = CGRectMake(ScreenW*0.1, 240, ScreenW*0.8, 50);
    [self.view addSubview:stringButton];
    
    UIButton* boolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    boolButton.titleLabel.font = [UIFont systemFontOfSize:25];
    boolButton.backgroundColor = ButtonColor;
    [boolButton setTitle:@"get bool" forState:UIControlStateNormal];
    [boolButton addTarget:self action:@selector(getBool) forControlEvents:UIControlEventTouchUpInside];
    boolButton.frame = CGRectMake(ScreenW*0.1, 310, ScreenW*0.8, 50);
    [self.view addSubview:boolButton];
    
    UIButton* intButton = [UIButton buttonWithType:UIButtonTypeCustom];
    intButton.titleLabel.font = [UIFont systemFontOfSize:25];
    intButton.backgroundColor = ButtonColor;
    [intButton setTitle:@"get int" forState:UIControlStateNormal];
    [intButton addTarget:self action:@selector(getInt) forControlEvents:UIControlEventTouchUpInside];
    intButton.frame = CGRectMake(ScreenW*0.1, 380, ScreenW*0.8, 50);
    [self.view addSubview:intButton];
    
    UIButton* floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatButton.titleLabel.font = [UIFont systemFontOfSize:25];
    floatButton.backgroundColor = ButtonColor;
    [floatButton setTitle:@"get float" forState:UIControlStateNormal];
    [floatButton addTarget:self action:@selector(getFloat) forControlEvents:UIControlEventTouchUpInside];
    floatButton.frame = CGRectMake(ScreenW*0.1, 450, ScreenW*0.8, 50);
    [self.view addSubview:floatButton];
    
    UIButton* getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    getButton.titleLabel.font = [UIFont systemFontOfSize:25];
    getButton.backgroundColor = ButtonColor;
    [getButton setTitle:@"get variable" forState:UIControlStateNormal];
    [getButton addTarget:self action:@selector(getVariable) forControlEvents:UIControlEventTouchUpInside];
    getButton.frame = CGRectMake(ScreenW*0.1, 520, ScreenW*0.8, 50);
    [self.view addSubview:getButton];
    
    UIButton* containButton = [UIButton buttonWithType:UIButtonTypeCustom];
    containButton.titleLabel.font = [UIFont systemFontOfSize:25];
    containButton.backgroundColor = ButtonColor;
    [containButton setTitle:@"contain key" forState:UIControlStateNormal];
    [containButton addTarget:self action:@selector(containsKey) forControlEvents:UIControlEventTouchUpInside];
    containButton.frame = CGRectMake(ScreenW*0.1, 590, ScreenW*0.8, 50);
    [self.view addSubview:containButton];
    
    UIButton* showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showButton.titleLabel.font = [UIFont systemFontOfSize:25];
    showButton.backgroundColor = ButtonColor;
    [showButton setTitle:@"展示本地配置数据" forState:UIControlStateNormal];
    [showButton addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    showButton.frame = CGRectMake(ScreenW*0.1, 660, ScreenW*0.8, 50);
    [self.view addSubview:showButton];

}

-(NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


- (void)show{
    id cacher = [self.manager performSelector:@selector(cacher)];
    NSDictionary *data = [cacher performSelector:@selector(getAllData)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:[NSString stringWithFormat:@"local config: %@", [self dataTOjsonString:data]]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

- (void)test{
    TestPageViewController *vc = [[TestPageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fetch{
    [self.manager fetchConfigsWithCheckInterval:NO callback:^(NSError *error){
        NSString *message;
        if(error){
            message = @"fetch failed";
        }else{
            message = @"fetch succeed";
        }
        NSLog(@"message: %@",message);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            [self presentViewController:alert animated:YES completion:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        });
        
    }];
}

- (void)getString{
    [self getObjectOfType:STRING];
}

- (void)getInt{
    [self getObjectOfType:INT];
}

- (void)getFloat{
    [self getObjectOfType:FLOAT];
}

- (void)getBool{
    [self getObjectOfType:BOOLEAN];
}

- (void)getVariable{
    [self getObjectOfType:-1];
}

- (void)containsKey{
    [self getObjectOfType:-2];
}

- (void)getObjectOfType:(VEDataType)type{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入Key"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"key";
    }];


    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *key = alertController.textFields.firstObject;
        NSString *message;
        switch (type) {
            case STRING:
                message = [self.manager getString:key.text withDefault:nil];
                break;
            case INT:
                message = [NSString stringWithFormat:@"%ld",[self.manager getInt:key.text withDefault:0]];
                break;
            case FLOAT:
                message = [NSString stringWithFormat:@"%f",[self.manager getFloat:key.text withDefault:0]];
                break;
            case BOOLEAN:
                message = [self.manager getBool:key.text withDefault:NO] ? @"true" : @"false";
                break;
        }
        if(!message){
            if(type == -1){
                VEVariable *variable = [self.manager get:key.text];
                message = [NSString stringWithFormat:@"value = %@\ntype = %@",[self valueToString:variable],variable.type];
            }else if(type == -2){
                message = [self.manager containsKey:key.text] ? @"true" : @"false";
            }else{
                message = @"";
            }
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [self presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)valueToString:(VEVariable *)variable{
    if([variable.type isEqualToString:@"string"]){
        return variable.value;
    } else if ([variable.type isEqualToString:@"bool"]){
        return [variable.value boolValue] ? @"true" : @"false";
    } else{
        return [variable.value stringValue];
    }
}

@end

# else

@implementation VERemoteConfigViewController

@end
# endif
