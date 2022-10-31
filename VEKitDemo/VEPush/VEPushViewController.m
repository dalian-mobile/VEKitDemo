//
//  VERemoteConfigViewController.m
//  App
//
//  Created by bytedance on 2021/11/10.
//
#import "VEPushViewController.h"
#import <OneKit/OKServices.h>
#import <VEPush/VEPushService.h>
#import <OneKit/OKSectionData.h>

OK_STRINGS_EXPORT("OKDemoEntryItem","VEPushViewController")

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ButtonColor [UIColor colorWithRed:22/255.0 green:100/255.0 blue:255/255.0 alpha:1.0]
#define BackgroundColor [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0]
#define ButtonTop 300
#define ButtonLineHeight 45

@interface VEPushViewController ()

@property(nonatomic, retain) UILabel *vepnsToken;
@property(nonatomic, retain) UILabel *apnsToken;
@property(nonatomic, retain) UILabel *udid;
@property(nonatomic, retain) UILabel *switcherLabel;
@property(nonatomic, retain) UISwitch *switcher;
@property int buttonCount;

@end

@implementation VEPushViewController

- (NSString *)title
{
    return @"移动推送";
}

- (NSString *)iconName
{
    return @"demo_push";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.buttonCount = 0;
    
    self.switcherLabel =[[UILabel alloc] initWithFrame: CGRectMake(ScreenW*0.1, 100, ScreenW*0.8, 30)];
    self.switcherLabel.text = @"push switcher";
    [self.view addSubview:self.switcherLabel];

    self.switcher = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenW*0.5, 100, ScreenW*0.8, 30)];
    [self.switcher addTarget:self action:@selector(notificationStatusChanged:) forControlEvents:UIControlEventValueChanged];
    self.switcher.on = VEPushService.appNotifiable;
    [self.view addSubview:self.switcher];

    self.vepnsToken = [[UILabel alloc] initWithFrame: CGRectMake(ScreenW*0.1, 130, ScreenW*0.8, 30)];
    self.vepnsToken.lineBreakMode = NSLineBreakByWordWrapping;
    self.vepnsToken.numberOfLines = 0;
    [self.view addSubview:self.vepnsToken];

    self.udid = [[UILabel alloc] initWithFrame: CGRectMake(ScreenW*0.1, 160, ScreenW*0.8, 30)];
    self.udid.lineBreakMode = NSLineBreakByWordWrapping;
    self.udid.numberOfLines = 0;
    [self.view addSubview:self.udid];

    self.apnsToken = [[UILabel alloc] initWithFrame: CGRectMake(ScreenW*0.1, 190, ScreenW*0.8, 70)];
    self.apnsToken.lineBreakMode = NSLineBreakByWordWrapping;
    self.apnsToken.numberOfLines = 0;
    [self.view addSubview:self.apnsToken];
    
    [self addButton:@"绑定标签" action:@selector(bindTags)];
    [self addButton:@"解绑标签" action:@selector(unbindTags)];
    [self addButton:@"解绑所有标签" action:@selector(unbindAllTags)];
    [self addButton:@"查询标签" action:@selector(queryTags)];
    [self addButton:@"绑定别名" action:@selector(bindAlias)];
    [self addButton:@"解绑别名" action:@selector(unbindAlias)];
    [self addButton:@"绑定属性" action:@selector(bindAttributes)];
    [self addButton:@"解绑属性" action:@selector(unbindAttributes)];
    [self addButton:@"解绑所有属性" action:@selector(unbindAllAttributes)];
    [self addButton:@"查询属性" action:@selector(queryAttributes)];
    [self addButton:@"清除角标" action:@selector(cleanBadge)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.vepnsToken.text = [NSString stringWithFormat:@"ve push token: %@", VEPushService.vepnsToken];
    NSLog(@"[VEPushDemo] Vepns token: %@", VEPushService.vepnsToken);
    
    self.udid.text = [NSString stringWithFormat:@"udid: %@", [(id<OKUniqueDIDService>) OK_CENTER_OBJECT(OKUniqueDIDService) udid]];
    NSLog(@"[VEPushDemo] Udid: %@", [(id<OKUniqueDIDService>) OK_CENTER_OBJECT(OKUniqueDIDService) udid]);
    
    self.apnsToken.text = [NSString stringWithFormat:@"apns token: %@", VEPushService.apnsToken];
    NSLog(@"[VEPushDemo] Apns token: %@", VEPushService.apnsToken);
}

- (void) addButton:(NSString *)title action:(SEL)action
{
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.titleLabel.font = [UIFont systemFontOfSize:17];
    newButton.backgroundColor = ButtonColor;
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat buttonLeft = ScreenW*((self.buttonCount%2) ? 0.55 : 0.1);
    newButton.frame = CGRectMake(buttonLeft, ButtonTop+ButtonLineHeight*(int)(self.buttonCount/2), ScreenW*0.35, 30);
    [self.view addSubview:newButton];
    self.buttonCount++;
}


-(void)notificationStatusChanged:(UISwitch *)sender
{
    VEPushService.appNotifiable = sender.on;
}

-(void)cleanBadge
{
    [VEPushService setBadgeNumber:-1];
}

- (void)bindTags{
    [self modifyWithLabel:@"Bind tags"];
}

- (void)unbindTags{
    [self modifyWithLabel:@"Unbind tags"];
}

- (void)unbindAllTags{
    [self unbindAllWithLabel:@"Unbind all tags"];
}

- (void)bindAlias{
    [self modifyWithLabel:@"Bind alias"];
}

- (void)unbindAlias{
    [self unbindAllWithLabel:@"Unbind alias"];
}

- (void)bindAttributes{
    [self modifyWithLabel:@"Bind attributes"];
}

- (void)unbindAttributes{
    [self modifyWithLabel:@"Unbind attributes"];
}

- (void)unbindAllAttributes{
    [self unbindAllWithLabel:@"Unbind all attributes"];
}

- (void)queryTags{
    [self queryWithLabel:@"Query tags"];
}

- (void)queryAttributes{
    [self queryWithLabel:@"Query attributes"];
}

- (void)modifyWithLabel:(NSString *)label{
    NSString *title;
    NSString *placeholder;
    if([label hasSuffix:@"tags"]){
        title = @"请输入标签";
        placeholder = @"tag1 tag2 ...";
    }else if([label hasSuffix:@"alias"]){
        title = @"请输入别名";
        placeholder = @"alias";
    }else if([label isEqualToString:@"Bind attributes"]){
        title = @"请输入属性键值对";
        placeholder = @"k1:v1 k2:v2 ...";
    }else if([label isEqualToString:@"Unbind attributes"]){
        title = @"请输入属性名";
        placeholder = @"k1 k2 ...";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
    }];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *input = alertController.textFields.firstObject.text;
        void(^ callback)(NSString *) = ^(NSString *errMsg) {
            NSString *message = errMsg;
            if(!message){
                message = [NSString stringWithFormat:@"%@ %@ successfully!", label, input];
            }
            NSLog(@"message: %@",message);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        };
        
        if([label isEqualToString:@"Bind tags"]){
            NSArray *tags = [input componentsSeparatedByString:@" "];
            [VEPushService bindTags:tags withCallback:callback];
        }else if([label isEqualToString:@"Unbind tags"]){
            NSArray *tags = [input componentsSeparatedByString:@" "];
            [VEPushService unbindTags:tags withCallback:callback];
        }else if([label isEqualToString:@"Bind attributes"]){
            NSArray *kvs = [input componentsSeparatedByString:@" "];
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            for(NSString *kv in kvs){
                NSArray *items = [kv componentsSeparatedByString:@":"];
                if(items.count == 2){
                    attrs[items[0]] = items[1];
                }
            }
            [VEPushService bindAttributes:attrs withCallback:callback];
        }else if([label isEqualToString:@"Unbind attributes"]){
            NSArray *keys = [input componentsSeparatedByString:@" "];
            [VEPushService unbindAttributes:keys withCallback:callback];
        }else if([label isEqualToString:@"Bind alias"]){
            [VEPushService bindAlias:input withCallback:callback];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)unbindAllWithLabel:(NSString *)label{
    void(^ callback)(NSString *) = ^(NSString *errMsg) {
        NSString *message = errMsg;
        if(!message){
            message = [NSString stringWithFormat:@"%@ successfully!", label];
        }
        NSLog(@"message: %@",message);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    };
    
    if([label isEqualToString:@"Unbind all tags"]){
        [VEPushService unbindAllTagsWithCallback:callback];
    }else if([label isEqualToString:@"Unbind all attributes"]){
        [VEPushService unbindAllAttributesWithCallback:callback];
    }else if([label isEqualToString:@"Unbind alias"]){
        [VEPushService unbindAliasWithCallback:callback];
    }
}

- (void)queryWithLabel:(NSString *)label{
    void(^ callback)(NSString *, NSString *) = ^(NSString *errMsg, NSString *resp) {
        NSString *message = errMsg ? errMsg : resp;
        NSLog(@"message: %@",message);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    };
    
    if([label isEqualToString:@"Query attributes"]){
        [VEPushService queryAttributesWithCallback:^(NSString *errMsg, NSDictionary *attributes) {
            __block NSString *msg = @"";
            [attributes enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
                msg = [msg stringByAppendingFormat:@"%@:%@ ", key, obj];
            }];
            callback(errMsg, msg);
        }];
    }else if([label isEqualToString:@"Query tags"]){
        [VEPushService queryTagsWithCallback:^(NSString *errMsg, NSArray *tags) {
            __block NSString *msg = @"";
            for(NSString *tag in tags){
                msg = [msg stringByAppendingFormat:@"%@ ", tag];
            }
            callback(errMsg, msg);
        }];
    }
}

@end

