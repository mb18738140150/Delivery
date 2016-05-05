//
//  MealDetailsView.h
//  TinyOrder
//
//  Created by 仙林 on 16/3/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealDetailsView : UIView

@property (nonatomic, copy)NSString * nametext;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * countLabel;
@property (nonatomic, strong)UILabel * priceLabel;

@end
