//
//  NewOrderModel.h
//  Delivery
//
//  Created by 仙林 on 16/1/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewOrderModel : NSObject

@property (nonatomic, copy)NSString * orderId;
@property (nonatomic, copy)NSString * orderTime;
@property (nonatomic, assign)int payType;
// shop
@property (nonatomic, copy)NSString * busiName;
@property (nonatomic, copy)NSString * busiPhone;
@property (nonatomic, copy)NSString * busiAddress;
// custom
@property (nonatomic, copy)NSString * customerName;
@property (nonatomic, copy)NSString * customerPhone;
@property (nonatomic, copy)NSString * hopeTime;
@property (nonatomic, copy)NSString * customerAddress;
@property (nonatomic, copy)NSString * remark;
@property (nonatomic, copy)NSString * gift;
@property (nonatomic, strong)NSNumber * allMoney;
@property (nonatomic, strong)NSMutableArray * mealArray;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
