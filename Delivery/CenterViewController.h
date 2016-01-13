//
//  CenterViewController.h
//  Delivery
//
//  Created by 仙林 on 15/10/27.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderViewController.h"
#import "UserCenterViewController.h"

@interface CenterViewController : UIViewController

@property (nonatomic, strong)UIImageView * backImageView;

@property (nonatomic, strong)UINavigationController * orderVC;
@property (nonatomic, strong)UserCenterViewController * userVC;

@property (nonatomic, strong)OrderViewController * orderViewController;

@property (nonatomic, strong)UIPanGestureRecognizer * panGesture;


- (void)setupGesture;

- (void)presentUserView;

- (void)moveOrderViewToOriginalPosition;

- (instancetype)initWithRightView:(UIViewController *)leftVC
                     andMainView:(UINavigationController *)mainVC;

@end
