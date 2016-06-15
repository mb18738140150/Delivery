//
//  CCLocationManager.m
//  Delivery
//
//  Created by 仙林 on 16/3/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "CCLocationManager.h"
#import "CLLocation+YCLocation.h"

@interface CCLocationManager  ()
{
//    CLLocationManager * _manager;
}

@property (nonatomic, strong)CLLocationManager * manager;
@property (nonatomic, copy)LocationBlock locationBlock;
@property (nonatomic, copy)NSStringBlock cityBlock;
@property (nonatomic, copy)NSStringBlock addressblock;
@property (nonatomic, copy)LocationErrorBlock errorBlock;
@end


@implementation CCLocationManager

+(CCLocationManager *)shareLocation
{
    static dispatch_once_t pred = 0;
    __strong static id _shareObject = nil;
    dispatch_once(&pred, ^{
        _shareObject = [[CCLocationManager alloc]init];
    });
    return _shareObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults * standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:CCLastLongitude];
        float latitude = [standard floatForKey:CCLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.lastCity = [standard objectForKey:CCLastCity];
        self.lastAddress = [standard objectForKey:CCLastAddress];
        
        }
    return self;
}
// 获取经纬度
- (void)getLocationCoordinate:(LocationBlock)locationBlock
{
    self.locationBlock = [locationBlock copy];
    [self startLocation];
    
}
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressblock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressblock = [addressBlock copy];
    [self startLocation];
}
//获取省市
- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    for (CLLocation * location in locations) {
//        NSLog(@"****latitude = %f***longitude = %f", location.coordinate.latitude, location.coordinate.longitude);
    }
//NSLog(@"定位成功");
    CLLocation * newLocation = [locations objectAtIndex:0];
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLLocation * location = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//    CLLocation * marsLoction =   [location locationMarsFromEarth];
//    marsLoction = [marsLoction locationBaiduFromMars];
    CLLocation * marsLoction = [location locationMarsFromEarth];// 转化为高德坐标
//    CLLocation * marsLoction = location;
    CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:marsLoction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark * placemark = [placemarks objectAtIndex:0];
            _lastCity = placemark.locality;
            [standard setObject:_lastCity forKey:CCLastCity];
            _lastAddress = placemark.name;
        }
        
        if (_cityBlock) {
            _cityBlock(_lastCity);
            _cityBlock = nil;
        }
        if (_addressblock) {
            _addressblock(_lastAddress);
            _addressblock = nil;
        }
        
    }];
    
    _lastCoordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude, marsLoction.coordinate.longitude);
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }
    [standard setObject:@(marsLoction.coordinate.latitude) forKey:CCLastLatitude];
    [standard setObject:@(marsLoction.coordinate.longitude) forKey:CCLastLongitude];
    
    [_manager stopUpdatingLocation];
    
}

- (void)startLocation
{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        if (_manager != nil) {
            _manager.delegate = self;
            [_manager startUpdatingLocation];
//            NSLog(@"开始定位");
        }else
        {
            self.manager = [[CLLocationManager alloc]init];
            _manager.delegate = self;
            _manager.desiredAccuracy = kCLLocationAccuracyBest;
            [_manager requestAlwaysAuthorization];
            _manager.distanceFilter = 100;
            [_manager startUpdatingLocation];
//            NSLog(@"重新生成了 manager");
        }
    }else
    {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
    NSLog(@"定位失败");
    
}
-(void)stopLocation
{
    _manager = nil;
}
@end
