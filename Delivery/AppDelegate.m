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
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"


#import "OrderDetailController.h"
#import "OrderViewController.h"
#import "Mapcontroller.h"

#define MAPKEY   1IuetZKXAwIv8oGEGpVbzo6f
#define NET_IS_Unreachable @"Networkisunreachable"

//NSString * const LoginAndStartUDP = @"LoginAndStartUDP";

@interface AppDelegate ()<HTTPPostDelegate, BMKGeneralDelegate, GCDAsyncUdpSocketDelegate, MAMapViewDelegate>
{
    //这个socket用来做发送使用 当然也可以接收
    GCDAsyncUdpSocket *sendUdpSocket;
}
@property (nonatomic, strong)NSTimer * timer;
@property (nonatomic, strong)NSTimer * registIdTimer;
@property (nonatomic, strong)LoginViewController * loginVC;
@property (nonatomic, assign)int counter;
@end

@implementation AppDelegate

static SystemSoundID shake_sound_male_id = 0;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [AFAppDotNetAPIClient shareClientWithView:self.window];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self createClientUdpSocket];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(udpAction:) name:LoginAndStartUDP object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopCllocation:) name:NET_IS_Unreachable object:nil];
    
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
    
    Mapcontroller * mapVC = [[Mapcontroller alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:self.loginVC];
    
    
    self.window.rootViewController = nav;
    
    
    [application setApplicationIconBadgeNumber:0];
    
    [self.window makeKeyAndVisible];
    
    // 初始化百度地图
    BMKMapManager * mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"c9kH5svEujsgd5tYaViwHnrR" generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图初始化失败");
    }
    
    // 初始化腾讯地图
//    [[QMapServices sharedServices] setApiKey:@"HZ4BZ-JX7RF-M6BJ7-NQRVB-HX3SH-TGF4Z"];
//    [[QMSSearchServices sharedServices] setApiKey:@"HZ4BZ-JX7RF-M6BJ7-NQRVB-HX3SH-TGF4Z"];
    
    [MAMapServices sharedServices].apiKey = @"11ce5c3cc2c7353240532288a5f63425";
    [AMapSearchServices sharedServices].apiKey = @"11ce5c3cc2c7353240532288a5f63425";
    [AMapNaviServices sharedServices].apiKey =@"11ce5c3cc2c7353240532288a5f63425";
    
    // 初始化语音包
    [self configIFlySpeech];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }else
    {
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:JPappKey channel:JPchannel apsForProduction:isProductionJP advertisingIdentifier:nil];
    
//    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
//    [APService setupWithOption:launchOptions];
    
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    
//    [NSThread sleepForTimeInterval:3];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    
//    if (launchOptions != nil) {
//        NSDictionary * dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (dictionary != nil) {
//            ;
//        }
//    }

    return YES;
}

- (void)configIFlySpeech
{
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",@"57577fea",@"20000"]];
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
}

#pragma mark - 极光推送自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
//    NSLog(@"content = %@", content);
    NSDictionary * dic = [self dictionaryWithJsonString:content];
    
    if ([[dic objectForKey:@"PushUseType"] intValue] == 4000) {
        [self playSound];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [dic objectForKey:@"Contents"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
        
        if ([nav.viewControllers.lastObject isMemberOfClass:[OrderViewController class]]) {
            OrderViewController * orderVc = nav.viewControllers.lastObject;
            if (orderVc.segment.selectedSegmentIndex == 0) {
                [orderVc.nOrderTableView.header beginRefreshing];
            }
        }
        
    }else if ([[dic objectForKey:@"PushUseType"] intValue] == 3002)
    {
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
            httpPost.commend = [jsonDic objectForKey:@"Command"];
            [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
            httpPost.delegate = self;
            
        }];
        
        [alertcontroller addAction:cameraAction];
        [alertcontroller addAction:libraryAction];
        [nav presentViewController:alertcontroller animated:YES completion:nil];
        
        
    }else if ([[dic objectForKey:@"PushUseType"] intValue] == 4001) {
        [self playSound1];
        
        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
        
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", [dic objectForKey:@"Title"]] message:[NSString stringWithFormat:@"%@", [dic objectForKey:@"Contents"]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            OrderDetailController * orderVc = [[OrderDetailController alloc]init];
            orderVc.orderID = [dic objectForKey:@"OrderId"];
            [nav pushViewController:orderVc animated:YES];
        }];
        [nameController addAction:cancleAction];
        
        [nav presentViewController:nameController animated:YES completion:nil];
        
    }else if ([[dic objectForKey:@"PushUseType"] intValue] == 4002) {
        
        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
        
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", [dic objectForKey:@"Title"]] message:[NSString stringWithFormat:@"%@", [dic objectForKey:@"Contents"]] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        
        [nav presentViewController:nameController animated:YES completion:nil];
        
        if (nav.viewControllers.count >1) {
            OrderViewController * orderVc = [nav.viewControllers objectAtIndex:1];
            [orderVc refreshOrderCountWith:[dic objectForKey:@"Contents"]];
        }
        
//        UILongPressGestureRecognizer
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [dic objectForKey:@"Contents"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
    
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    NSLog(@"………………***%@, &&&%@, ^^^%@", [dic description], extras, customizeField1);
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - upd向后台实时发送用户位置
-(void)createClientUdpSocket{
    dispatch_queue_t dQueue = dispatch_queue_create("client udp socket", NULL);
    
    //1.创建一个 udp socket用来和服务器端进行通讯
    sendUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dQueue socketQueue:nil];
    
    //2.banding一个端口(可选),如果不绑定端口, 那么就会随机产生一个随机的电脑唯一的端口
    //端口数字范围(1024,2^16-1)
    [sendUdpSocket bindToPort:8085 error:nil];
    
    //3.等待接收对方的消息
    [sendUdpSocket receiveOnce:nil];
    
//    if ([sendUdpSocket isIPv6]) {
//        NSLog(@"支持IPv6");
//    }else
//    {
//        NSLog(@"不支持IPv6");
//    }
    
}

- (void)udpAction:(NSNotification *)notification
{
    if ([UserInfo shareUserInfo].isOpenthebackgroundposition) {
        
        NSString *host = HOST_UDP;
        uint16_t port = PORT_UDP;
        if (![sendUdpSocket isClosed]) {
            
        }else
        {
            [sendUdpSocket connectedHost];
        }
        
        [[AMapSearchm shareSearch] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            [UserLocation shareLocation].coordinate2D = locationCorrrdinate;
            
            NSString *msg = @"我再发送消息";
            msg = [msg stringByAppendingFormat:@"lat%f**lon%f", [UserLocation shareLocation].coordinate2D.latitude, [UserLocation shareLocation].coordinate2D.longitude];
            
            NSDictionary * dic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Longitude":@([UserLocation shareLocation].coordinate2D.longitude),
                                   @"Latitude":@([UserLocation shareLocation].coordinate2D.latitude)
                                   };
            
            msg = [dic JSONString];
            
            NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
            
            [sendUdpSocket sendData:data toHost:host port:port withTimeout:30 tag:100];
        }];
        
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(sendLocaion) userInfo:nil repeats:YES];
        [self.timer fire];
       
    }else
    {
        [sendUdpSocket close];
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

- (void)sendLocaion
{
//    NSLog(@"定时器走动，从新定位");
    NSString *host = HOST_UDP ;
    uint16_t port = PORT_UDP;
    
    [[AMapSearchm shareSearch]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        [UserLocation shareLocation].coordinate2D = locationCorrrdinate;
        
        NSString *msg = @"我再发送消息";
        msg = [msg stringByAppendingFormat:@"lat%f**lon%f", [UserLocation shareLocation].coordinate2D.latitude, [UserLocation shareLocation].coordinate2D.longitude];
        
        NSDictionary * dic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Longitude":@([UserLocation shareLocation].coordinate2D.longitude),
                               @"Latitude":@([UserLocation shareLocation].coordinate2D.latitude)
                               };
        
        msg = [dic JSONString];
        
//        NSLog(@"lat%f**lon%f", [UserLocation shareLocation].coordinate2D.latitude, [UserLocation shareLocation].coordinate2D.longitude);
        
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        
        [sendUdpSocket sendData:data toHost:host port:port withTimeout:30 tag:200];
    }];
    
    
//    [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//        [UserLocation shareLocation].coordinate2D = locationCorrrdinate;
//        
//        
//        NSString *msg = @"我再发送消息";
//        msg = [msg stringByAppendingFormat:@"lat%f**lon%f", [UserLocation shareLocation].coordinate2D.latitude, [UserLocation shareLocation].coordinate2D.longitude];
//        
//        NSDictionary * dic = @{
//                               @"UserId":[UserInfo shareUserInfo].userId,
//                               @"Longitude":@([UserLocation shareLocation].coordinate2D.longitude),
//                               @"Latitude":@([UserLocation shareLocation].coordinate2D.latitude)
//                               };
//        
//        msg = [dic JSONString];
//        
//        NSLog(@"lat%f**lon%f", [UserLocation shareLocation].coordinate2D.latitude, [UserLocation shareLocation].coordinate2D.longitude);
//        
//        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
//        
//        [sendUdpSocket sendData:data toHost:host port:port withTimeout:5 tag:200];
//    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString * str = [JPUSHService registrationID];
    
    if (str.length != 0) {
        [[NSUserDefaults standardUserDefaults]setObject:[JPUSHService registrationID] forKey:@"RegistrationID"];
    }else
    {
        self.registIdTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(getRegistrationID) userInfo:nil repeats:YES];
        [self.registIdTimer fire];
    }
    
    
    NSLog(@"RegistrationID = %@", str);
}

- (void)getRegistrationID
{
    NSString * str = [JPUSHService registrationID];
    if (str) {
        [self.registIdTimer invalidate];
        self.registIdTimer = nil;
        [[NSUserDefaults standardUserDefaults]setObject:[JPUSHService registrationID] forKey:@"RegistrationID"];
        
        NSString * passtr = [[NSUserDefaults standardUserDefaults]objectForKey:@"Pwd"];
        NSString * namestr = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
        
        if (passtr.length!=0 && namestr.length!=0) {
            NSDictionary * jsonDic = @{
                                       @"Pwd":passtr,
                                       @"UserName":namestr,
                                       @"Command":@1,
                                       @"RegistrationID":[[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"],
                                       @"DeviceType":@1
                                       };
            NSString * jsonStr = [jsonDic JSONString];
            NSString * str = [NSString stringWithFormat:@"%@131139", jsonStr];
            NSLog(@"jsonStr = %@", str);
            NSString * md5Str = [str md5];
            NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
            HTTPPost * httpPost = [HTTPPost shareHTTPPost];
            httpPost.commend = [jsonDic objectForKey:@"Command"];
            httpPost.delegate = self;
            [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
//    [self playSound];
    NSLog(@"__FUNC__ = %s", __func__);
    NSLog(@"%@", [userInfo description]);
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSLog(@"*******%@", [userInfo description]);
//    
//    if ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] containsString:@"你的帐号在别的设备登录"]) {
//        UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的账号已在另一台设备登录" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
//        
//        UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"你点击了退出登录");
//            [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogin"];
//            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Pwd"];
//            [nav popToRootViewControllerAnimated:YES];
//            
//        }];
//        
//        UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            NSString * passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"Pwd"];
//            NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
//            NSLog(@"你点击了重新登录");
//            
//            NSDictionary * jsonDic = nil;
//            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"]) {
//                jsonDic = @{
//                            @"Pwd":passWord,
//                            @"UserName":name,
//                            @"Command":@1,
//                            @"RegistrationID":[[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"],
//                            @"DeviceType":@1
//                            };
//            }else
//            {
//                jsonDic = @{
//                            @"Pwd":passWord,
//                            @"UserName":name,
//                            @"Command":@1,
//                            @"RegistrationID":[NSNull null],
//                            @"DeviceType":@1
//                            };
//            }
//            NSString * jsonStr = [jsonDic JSONString];
//            NSString * str = [NSString stringWithFormat:@"%@131139", jsonStr];
//            NSLog(@"jsonStr = %@", str);
//            NSString * md5Str = [str md5];
//            NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
//            HTTPPost * httpPost = [HTTPPost shareHTTPPost];
//            httpPost.commend = [jsonDic objectForKey:@"Command"];
//            [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
//            httpPost.delegate = self;
//
//        }];
//        
//        [alertcontroller addAction:cameraAction];
//        [alertcontroller addAction:libraryAction];
//        [nav presentViewController:alertcontroller animated:YES completion:nil];
//
//        
//    }else
//    {
//        [self playSound];
//        
//    }
    
    NSLog(@"completionHandler = %@", [userInfo description]);
    NSLog(@"__FUNC__ = %s", __func__);
    application.applicationIconBadgeNumber = 0;
}

- (void)refresh:(id)data
{
    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[dataDic objectForKey:@"Result"] isEqual:@1]) {
        
        
        [self registerRemoteNotification];
        NSString * registrationID = [JPUSHService registrationID];
        
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
        [JPUSHService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [JPUSHService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [JPUSHService
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
    
    if ([UserInfo shareUserInfo].isOpenthebackgroundposition) {
        [self backgroundHandler];
    }
    self.counter = 0;
    
}
- (void)backgroundHandler {
    
    //    self.loca.locationSpace = YES; //这个属性设置再后台定位的时间间隔 自己在定位类中加个定时器就行了
    
    UIApplication * app = [UIApplication sharedApplication];

    //声明一个任务标记 可在.h中声明为全局的  __block    UIBackgroundTaskIdentifier bgTask;
//    __block    UIBackgroundTaskIdentifier bgTask;
    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_bgTask != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:_bgTask];
                _bgTask = UIBackgroundTaskInvalid;
                
            }
        });
        
    }];
    // 开始执行长时间后台执行的任务 项目中启动后定位就开始了 这里不需要再去执行定位 可根据自己的项目做执行任务调整
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while (1) {
//            NSLog(@"counter:%d", _counter++);
            sleep(2);
        }
        
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if (_bgTask != UIBackgroundTaskInvalid) {
        [application endBackgroundTask:_bgTask];
        _bgTask = UIBackgroundTaskInvalid;
    }

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// 进程杀死时候会调用该方法
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"程序被杀死");
}

- (void)playSound
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"newDelivery" ofType:@"caf"];
    
    NSLog(@"path = %@", path);
    
    if (path) {
        //注册声音到系统
        NSURL * url = [NSURL fileURLWithPath:path];
        CFURLRef inFileURL = (__bridge CFURLRef)url;
//        AudioServicesCreateSystemSoundID(inFileURL, &shake_sound_male_id);
        OSStatus err =  AudioServicesCreateSystemSoundID(inFileURL,&shake_sound_male_id);
        if (err != kAudioServicesNoError) {
            NSLog(@"Cound not load %@, error code %@", url, err);
        }

        
    }
    AudioServicesPlaySystemSound(shake_sound_male_id);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);// 让手机震动
}
- (void)playSound1
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"tipDelivery" ofType:@"caf"];
    
    NSLog(@"path = %@", path);
    
    if (path) {
        //注册声音到系统
        NSURL * url = [NSURL fileURLWithPath:path];
        CFURLRef inFileURL = (__bridge CFURLRef)url;
        //        AudioServicesCreateSystemSoundID(inFileURL, &shake_sound_male_id);
        OSStatus err =  AudioServicesCreateSystemSoundID(inFileURL,&shake_sound_male_id);
        if (err != kAudioServicesNoError) {
            NSLog(@"Cound not load %@, error code %@", url, err);
        }
        
        
    }
    AudioServicesPlaySystemSound(shake_sound_male_id);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);// 让手机震动
}

//-(void) playSound
//
//{
//    NSString *path = nil;
//    
//    path = [[NSBundle mainBundle] pathForResource:@"tangshi" ofType:@"caf"];
//    
//    if (path) {
//        //注册声音到系统
//        NSURL *url = [NSURL fileURLWithPath:path];
//        CFURLRef inFileURL = (__bridge CFURLRef)url;
//        OSStatus err =  AudioServicesCreateSystemSoundID(inFileURL,&shake_sound_male_id);
//        if (err != kAudioServicesNoError) {
//            NSLog(@"Cound not load %@, error code %@", url, err);
//        }
//        
//        AudioServicesPlaySystemSound(shake_sound_male_id);
//        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
//        NSLog(@"走了******");
//    }
//    
//    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
//    
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
//    
//}

#pragma mark -GCDAsyncUdpSocketDelegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    if (tag == 100) {
        NSLog(@"表示标记为100的数据发送完成了");
    }else
    {
//        NSLog(@"表示标记为200的数据发送完成了");
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
    
    if (![sendUdpSocket isClosed]) {
        NSLog(@"断开链接了");
    }else
    {
        [sendUdpSocket connectedHost];
    }
    
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    
    NSLog(@"didNotConnect失败原因 %@", error.userInfo);
}
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"udpSocketDidClose失败原因 %@", error.userInfo);
    NSString * str = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    NSLog(@"%@", str);
//    if ([str containsString:@"Network is unreachable"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NET_IS_Unreachable object:nil userInfo:nil];
//    }
}

//- (void)stopCllocation:(NSNotification *)notification
//{
//    
//    if (_bgTask != UIBackgroundTaskInvalid) {
//        UIApplication * app = [UIApplication sharedApplication];
//        [app endBackgroundTask:_bgTask];
//        _bgTask = UIBackgroundTaskInvalid;
//        NSLog(@"停止后台实时定位");
//    }
//}


-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 继续来等待接收下一次消息
    NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, s);
    [sock receiveOnce:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendBackToHost:ip port:port withMessage:s];
    });
}

-(void)sendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)s{
    
    [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        [UserLocation shareLocation].coordinate2D = locationCorrrdinate;
        
        NSString *msg = @"我再发送消息";
        msg = [msg stringByAppendingFormat:@"lat%f**lon%f", [UserLocation shareLocation].coordinate2D.latitude, [UserLocation shareLocation].coordinate2D.longitude];
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        
//        [sendUdpSocket sendData:data toHost:ip port:port withTimeout:30 tag:200];
    }];
    
    
}


- (void)dealloc
{
    sendUdpSocket = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:LoginAndStartUDP object:nil];
}

@end
