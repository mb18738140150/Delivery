//
//  UserLocation.m
//  UDP通讯
//
//  Created by 仙林 on 16/5/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "UserLocation.h"

@implementation UserLocation

+(UserLocation *)shareLocation
{
    static dispatch_once_t pred = 0;
    __strong static id _shareObject = nil;
    dispatch_once(&pred, ^{
        _shareObject = [[UserLocation alloc]init];
    });
    return _shareObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults * standard = [NSUserDefaults standardUserDefaults];
        
        self.coordinate2D = (CLLocationCoordinate2D){0.0, 0.0};
        self.searchCoordinate = (CLLocationCoordinate2D){0.0, 0.0};
        self.searchAddress = nil;
    }
    return self;
}

@end
