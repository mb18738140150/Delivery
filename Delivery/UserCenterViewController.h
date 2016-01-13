//
//  UserCenterViewController.h
//  Delivery
//
//  Created by 仙林 on 15/10/23.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherView.h"
@interface UserCenterViewController : UIViewController

@property (nonatomic, strong)UIView * headView;

@property (nonatomic, strong)UIImageView * iconImage;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * phoneNumberLabel;

@property (nonatomic, strong)OtherView * totalOrderview;
@property (nonatomic, strong)OtherView * reciveOrderView;
@property (nonatomic, strong)OtherView * massegeView;


@end
