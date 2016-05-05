//
//  OtherView.h
//  Delivery
//
//  Created by 仙林 on 15/10/23.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UICustomSwitch;
@interface OtherView : UIView

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * detalsLabel;
@property (nonatomic, copy)NSString * detailStr;
@property (nonatomic, strong)UISwitch * detailButton;


@end
