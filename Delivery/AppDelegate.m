//
//  AppDelegate.m
//  Delivery
//
//  Created by 仙林 on 15/10/23.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "AppDelegate.h"
#import "CenterViewController.h"
#import "OrderViewController.h"
#import "UserCenterViewController.h"
#import "LoginViewController.h"
#import "JRSwizzle.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()<HTTPPostDelegate, BMKGeneralDelegate>
@property (nonatomic, strong)LoginViewController * loginVC;
@end

@implementation AppDelegate

static SystemSoundID shake_sound_male_id = 0;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 抽屉效果
    /*
     
     //    OrderViewController * orderVC = [[OrderViewController alloc]init];
     //    self.mainNavigationController = [[UINavigationController alloc]init];
     //    UserCenterViewController * userVC = [[UserCenterViewController alloc]init];
     //
     ////    self.centerVC = [[CenterViewController alloc]initWithRightView:userVC andMainView:self.mainNavigationController];
     //    self.centerVC = [[CenterViewController alloc]init];
     //    self.window.rootViewController = self.centerVC;251 84 8
     */
    
    
//    OrderViewController * orderVC = [[OrderViewController alloc]init];
//    self.mainNavigationController = [[UINavigationController alloc]initWithRootViewController:orderVC];
    self.loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:_loginVC];
    
    self.window.rootViewController = nav;
    
    
    [application setApplicationIconBadgeNumber:0];
    
    [self.window makeKeyAndVisible];
    
    // 初始化百度地图
    BMKMapManager * mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"1IuetZKXAwIv8oGEGpVbzo6f" generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图初始化失败");
    }
    
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    [APService setupWithOption:launchOptions];
    
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    
//    [NSThread sleepForTimeInterval:3];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    
    NSString * str = [APService registrationID];
    NSLog(@"RegistrationID = %@", str);
    [[NSUserDefaults standardUserDefaults]setObject:[APService registrationID] forKey:@"RegistrationID"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
    [self playSound];
    NSLog(@"__FUNC__ = %s", __func__);
    NSLog(@"%@", [userInfo description]);
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    if ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] containsString:@"你的帐号在别的设备登录"]) {
        UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的账号已在另一台设备登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
        
        UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"你点击了退出登录");
            [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogin"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Pwd"];
            [nav popToRootViewControllerAnimated:YES];
            
        }];
        
        UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString * passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"Pwd"];
            NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
            NSLog(@"你点击了重新登录");
            
            NSDictionary * jsonDic = nil;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"]) {
                jsonDic = @{
                            @"Pwd":passWord,
                            @"UserName":name,
                            @"Command":@1,
                            @"RegistrationID":[[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"],
                            @"DeviceType":@1
                            };
            }else
            {
                jsonDic = @{
                            @"Pwd":passWord,
                            @"UserName":name,
                            @"Command":@1,
                            @"RegistrationID":[NSNull null],
                            @"DeviceType":@1
                            };
            }
            NSString * jsonStr = [jsonDic JSONString];
            NSString * str = [NSString stringWithFormat:@"%@131139", jsonStr];
            NSLog(@"jsonStr = %@", str);
            NSString * md5Str = [str md5];
            NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
            HTTPPost * httpPost = [HTTPPost shareHTTPPost];
            [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
            httpPost.delegate = self;

        }];
        
        [alertcontroller addAction:cameraAction];
        [alertcontroller addAction:libraryAction];
        [nav presentViewController:alertcontroller animated:YES completion:nil];

        
    }else
    {
        [self playSound];
        
    }
    
    NSLog(@"completionHandler = %@", [userInfo description]);
    NSLog(@"__FUNC__ = %s", __func__);
    application.applicationIconBadgeNumber = 0;
}

- (void)refresh:(id)data
{
    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[dataDic objectForKey:@"Result"] isEqual:@1]) {
        
        
        [self registerRemoteNotification];
        NSString * registrationID = [APService registrationID];
        
        NSLog(@"********registrationID = %@", registrationID);
        [UserInfo shareUserInfo].userId = [dataDic objectForKey:@"UserId"];
        [UserInfo shareUserInfo].BusiId =[dataDic objectForKey:@"BusiId"];
        
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogin"] boolValue]) {
            [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"haveLogin"];//记录已经登录过
        }
    }else
    {
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:[dataDic objectForKey:@"ErrorMsg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
        [nav presentViewController:nameController animated:YES completion:nil];
    }
    
}
- (void)registerRemoteNotification
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)playSound
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"caf"];
    if (path) {
        //注册声音到系统
        NSURL * url = [NSURL fileURLWithPath:path];
        CFURLRef inFileURL = (__bridge CFURLRef)url;
        AudioServicesCreateSystemSoundID(inFileURL, &shake_sound_male_id);
    }
    AudioServicesPlaySystemSound(shake_sound_male_id);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);// 让手机震动
}


@end
