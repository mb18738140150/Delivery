//
//  GiveupReasonView.h
//  Delivery
//
//  Created by 仙林 on 16/6/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GiveUpBlock)(NSString * reasonStr);

@interface GiveupReasonView : UIView

- (void)giveuporder:(GiveUpBlock)Block;

- (void)show;

@end
