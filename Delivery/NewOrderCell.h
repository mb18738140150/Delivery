//
//  NewOrderCell.h
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewOrderModel.h"
#import "TotlePriceView.h"
#import "CustomerView.h"
#import "ShopView.h"
@interface NewOrderCell : UITableViewCell

@property (nonatomic, strong)NewOrderModel * orderModel;
@property (nonatomic, strong)TotlePriceView * totlePriceView;
@property (nonatomic, strong)CustomerView * customerView;
@property (nonatomic, strong)ShopView * shopView;

- (void)createSubView:(CGRect)frame mealCoutn:(NewOrderModel *)mealModel;
+ (CGFloat)cellHeightWithMealCount:(NewOrderModel *)mealModel;
@end
