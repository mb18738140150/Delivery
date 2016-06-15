//
//  AMapSearchm.h
//  Delivery
//
//  Created by 仙林 on 16/6/6.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LocationBlock1)(CLLocationCoordinate2D locationCorrrdinate);
typedef void(^CoorDinateBlock)(CLLocationCoordinate2D coordinate);
typedef void(^AddressBlock)(NSString * address);
typedef void(^SearchFaileBlock)();

@interface AMapSearchm : NSObject


+(AMapSearchm *)shareSearch;

- (void)getLocationCoordinate:(LocationBlock1)locationBlock;

- (void)getaddressWithCoordinate:(CLLocationCoordinate2D )coordinate complate:(AddressBlock)addressBlock failed:(SearchFaileBlock)faile;

- (void)getCoordinateWithAddress:(NSString *)address complate:(CoorDinateBlock)coordinateBlock failed:(SearchFaileBlock)faile;

@end
