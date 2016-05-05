//
//  UICustomSwitch.h
//  Delivery
//
//  Created by 仙林 on 16/4/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _UISwitchSlider : UIView
@end

@interface UICustomSwitch : UISwitch

- (void) setLeftLabelText: (NSString *) labelText;
- (void) setRightLabelText: (NSString *) labelText;

@end
