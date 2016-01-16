//
//  NewOrderModel.m
//  Delivery
//
//  Created by 仙林 on 16/1/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "NewOrderModel.h"
#import "Meal.h"
@implementation NewOrderModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (NSMutableArray *)mealArray
{
    if (!_mealArray) {
        self.mealArray = [NSMutableArray array];
    }
    return _mealArray;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"MealList"]) {
        NSArray * mealList = (NSArray *)value;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * dic in mealList) {
            Meal * meal = [[Meal alloc] initWithDictionary:dic];
            [array addObject:meal];
        }
        self.mealArray = array;
    }
}


@end
