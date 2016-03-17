//
//  AFAppDotNetAPIClient.m
//  Delivery
//
//  Created by 仙林 on 16/3/16.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

@interface AFAppDotNetAPIClient ()
{
    //    UIAlertView * alert;
}
@property (nonatomic,  strong)UIAlertView * alert;
@end

static NSString *const AFAppDotNetAPIBaseURLAtring = @"https://api.app.net/";
@implementation AFAppDotNetAPIClient
+(instancetype)shareClientWithView:(UIView *)view
{
    static AFAppDotNetAPIClient * _shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [[AFAppDotNetAPIClient alloc]initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLAtring]];
        _shareClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        NSOperationQueue * queue = _shareClient.operationQueue;
        [_shareClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    //                    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
                    //                    [view addSubview:hud];
                    //
                    //                    hud.mode = MBProgressHUDModeIndeterminate;
                    //                    [hud showAnimated:YES whileExecutingBlock:^{
                    //                        sleep(1.25);
                    //                    } completionBlock:^{
                    //                        [hud removeFromSuperview];
                    //                    }];
                    [queue setSuspended:NO];
                    [_shareClient.alert performSelector:@selector(dismiss) withObject:nil];
                    //                    _shareClient.alert = nil;
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                {
                    [queue setSuspended:YES];
                    _shareClient.alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [_shareClient.alert show];
                }
                    break;
            }
        }];
        [_shareClient.reachabilityManager startMonitoring];
    });
    return _shareClient;
}
@end
