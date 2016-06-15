//
//  OrderDetailController.h
//  Delivery
//
//  Created by 仙林 on 16/1/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)();

@interface OrderDetailController : UIViewController
@property (nonatomic, copy)NSString * orderID;
@property (nonatomic, assign)int deliveried;
//@property (nonatomic)CLLocationCoordinate2D cllocationCoordinate;

- (void)refreshData:(RefreshBlock)block;

@end
