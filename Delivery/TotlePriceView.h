//
//  TotlePriceView.h
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NullityBlock)();

@interface TotlePriceView : UIView

@property (nonatomic, copy)NSString * totalPrice;
@property (nonatomic, strong)UILabel * totlePriceLabel;
@property (nonatomic, strong)UIButton * nullityButton;
@property (nonatomic, strong)UIButton * detailsButton;
@property (nonatomic, strong)UIButton * startDeliveryBT;

- (void)nulityOrderAction:(NullityBlock)block;

@end
