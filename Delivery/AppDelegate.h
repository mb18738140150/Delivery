//
//  AppDelegate.h
//  Delivery
//
//  Created by 仙林 on 15/10/23.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
//#import <QMapKit/QMapKit.h>
//#import <QMapSearchKit/QMapSearchKit.h>


static NSString *JPappKey = @"7b1b53d9f0f4d4a8b498320c";
static NSString *JPchannel = @"App Store";
static BOOL isProductionJP = true;
//extern NSString * const LoginAndStartUDP;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong)CenterViewController * centerVC;
@property (nonatomic, strong)UINavigationController * mainNavigationController;

@property (nonatomic, assign)__block    UIBackgroundTaskIdentifier bgTask;

@end

