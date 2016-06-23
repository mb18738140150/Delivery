//
//  UserLocation.h
//  UDP通讯
//
//  Created by 仙林 on 16/5/4.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UserLocation : NSObject

@property (nonatomic, assign)CLLocationCoordinate2D coordinate2D;

@property (nonatomic, assign)CLLocationCoordinate2D searchCoordinate;
@property (nonatomic, assign)CLLocationCoordinate2D shopSearchCoordinate;
@property (nonatomic, copy)NSString * searchAddress;
@property (nonatomic, copy)NSString * city;

+(UserLocation *)shareLocation;
@end
