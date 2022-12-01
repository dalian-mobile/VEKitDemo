//
//  VELocationDemoViewController.m
//  VEKitDemo
//
//  Created by bytedance on 2022/10/28.
//

#import "VELocationDemoViewController.h"
#import <OneKit/OKSectionData.h>
#import <INTULocationManager/INTULocationManager.h>
#import <CoreLocation/CLLocationManager.h>

OK_STRINGS_EXPORT("OKDemoEntryItem","VELocationDemoViewController")


@interface VELocationDemoViewController ()

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *contents;

@end

@implementation VELocationDemoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = @[@"点击获取定位信息",@"经度",@"纬度",@"国家",@"省",@"市/区",@"街道",@"地点"];
}

- (NSString *)title
{
    return @"定位";
}

- (NSString *)iconName
{
    return @"demo_location";
}

- (void)updateGeoMsg:(CLLocation *)location
{
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    [contents addObject:[@(location.coordinate.longitude) stringValue]];
    [contents addObject:[@(location.coordinate.latitude) stringValue]];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        // 反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (! error) {
                if ([placemarks count] > 0) {
                    CLPlacemark *placemark = [placemarks firstObject];
                    [contents addObject:placemark.country];
                
                    [contents addObject:[NSString stringWithFormat:@"%@%@",placemark.administrativeArea ?: @"",placemark.subAdministrativeArea ?: @""]];

                    [contents addObject:[NSString stringWithFormat:@"%@%@",placemark.locality ?: @"",placemark.subLocality ?: @""]];

                    
                    [contents addObject:[NSString stringWithFormat:@"%@%@",placemark.thoroughfare ?: @"",placemark.subThoroughfare ?: @""]];
                    
                    [contents addObject:placemark.name];
                    self.contents = contents;
                    
                } else if ([placemarks count] == 0) {
                    
                }
            } else {
               
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
}

- (void)refreshLocation
{
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    
    
    [locMgr performSelector:@selector(requestAuthorizationIfNeeded)];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:20 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            // A new updated location is available in currentLocation, and achievedAccuracy indicates how accurate this particular location is.
            [self updateGeoMsg:currentLocation];
            
        }
        else {
            // An error occurred, more info is available by looking at the specific status returned. The subscription has been kept alive.
            NSLog(@"Location Error:%ld",(long)status);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    if (indexPath.row > 0) {
        cell.detailTextLabel.text = self.contents[indexPath.row-1];
    }else{
        cell.detailTextLabel.text = nil;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self refreshLocation];
    }
}


@end
