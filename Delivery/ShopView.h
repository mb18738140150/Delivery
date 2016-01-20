//
//  ShopView.h
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopView : UIView

@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * phone;

@property (nonatomic, strong)UIImageView * addressImageView;
@property (nonatomic, strong)UIButton * addressBT;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * phoneLabel;
@property (nonatomic, strong)UILabel * payStateLabel;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UILabel * orderTimeLB;
@property (nonatomic, strong)UIButton *phoneBT;

@end
