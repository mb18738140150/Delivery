//
//  CustomerView.h
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerView : UIView

@property (nonatomic, strong)UIImageView * addressImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * phoneLabel;
@property (nonatomic, strong)UIButton * phoneBT;
@property (nonatomic, strong)UILabel * arriveTimeLabel;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UIView * mealsView;
@property (nonatomic, strong)UILabel * remarkLabel;

- (void)creatMealViewWithArray:(NSMutableArray *)array;

@end
