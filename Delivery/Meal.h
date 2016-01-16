//
//  Meal.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/27.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meal : NSObject


@property (nonatomic, copy)NSString * name;
@property (nonatomic, assign)int  count;
@property (nonatomic, assign)double  money;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
