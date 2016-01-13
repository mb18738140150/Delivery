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
    // 创建请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    // 和服务器建立异步联接
//    NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.delegate refresh:dic];
    }];
    [task resume];
    
}


@end
