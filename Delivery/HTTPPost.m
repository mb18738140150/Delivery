//
//  HTTPPost.m
//  Delivery
//
//  Created by 仙林 on 16/1/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "HTTPPost.h"

static HTTPPost * httpPost = nil;

@interface HTTPPost ()

@property (nonatomic, retain)NSMutableData * data;
@property (nonatomic, retain)NSMutableArray * dataArray;

@end

@implementation HTTPPost

+(HTTPPost *)shareHTTPPost
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpPost = [[HTTPPost alloc]init];
    }) ;
    return httpPost;
}

- (void)post:(NSString *)urlString HTTPBody:(NSData *)body
{
    /*
     stringByAddingPercentEscapesUsingEncoding(只对 `#%^{}[]|\"<> 加空格共14个字符编码，不包括”&?”等符号), ios9将淘汰，建议用stringByAddingPercentEncodingWithAllowedCharacters方法
     
     URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
     
     URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
     
     URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
     
     URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
     
     URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
     
     URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
     */
    NSString * newUrlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:newUrlStr];
    NSLog(@"urlStr = %@", urlString);
    // 创建请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    // 和服务器建立异步联接
    
//    [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"***data = %@", data);
        if (error) {
            
            // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.delegate failWithError:error];
            });
                NSLog(@"++++++=%@", error);
            
        }else
        {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //            NSLog(@"*****%@", [dic description]);
            // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.delegate refresh:dic];
            });
        }
//        if (data) {
//            
//            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
////            NSLog(@"*****%@", [dic description]);
//            // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                [self.delegate refresh:dic];
//            });
//        }
    }];
    
    [task resume];
    
}


@end
