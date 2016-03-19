//
//  Mapcontroller.h
//  Delivery
//
//  Created by 仙林 on 16/1/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Mapcontroller : UIViewController

@property (nonatomic, copy)NSString * address;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * phone;

@property (nonatomic)CLLocationCoordinate2D coordinate2D;

@end
