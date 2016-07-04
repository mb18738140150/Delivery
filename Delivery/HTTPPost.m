//
//  HTTPPost.m
//  Delivery
//
//  Created by 仙林 on 16/1/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "HTTPPost.h"
#import "AppDelegate.h"
static HTTPPost * httpPost = nil;

@interface HTTPPost ()

@property (nonatomic, retain)NSMutableData * data;
@property (nonatomic, retain)NSMutableArray * dataArray;
@property (nonatomic, strong)UIView * loadFileView;

@property (nonatomic, copy)NSString * urlString;
@property (nonatomic, strong)NSData * body;

@end

@implementation HTTPPost

+(HTTPPost *)shareHTTPPost
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpPost = [[HTTPPost alloc]init];
        httpPost.commend = @0;
        [httpPost addLoadFailedView];
    }) ;
    return httpPost;
}

- (void)post:(NSString *)urlString HTTPBody:(NSData *)body
{
    self.urlString = urlString;
    self.body = body;
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
        if (error) {
            
            if (error.code == -1009) {
                ;
            }
            // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                NSError * error1 = [NSError errorWithDomain:@"" code:10000 userInfo:@{@"Reason":@"服务器连接失败", @"Command":self.commend}];
                [self.delegate failWithError:error1];
                
                if (self.commend.intValue == 9 || self.commend.intValue == 3 || self.commend.intValue == 2) {
                    [self showLoadFailImage];
                }
                
                
            });
                NSLog(@"++++++=%@", error);
            
        }else
        {
            if (self.loadFileView) {
                [self.loadFileView removeFromSuperview];
            }
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //            NSLog(@"*****%@", [dic description]);
            // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (dic == nil) {
                    
                    NSError * error = [NSError errorWithDomain:@"" code:10000 userInfo:@{@"Reason":@"服务器处理失败", @"Command":self.commend}];
                    [self.delegate failWithError:error];
                    
                }else
                {
                    [self.delegate refresh:dic];
                }
            });
        }
    }];
    
    [task resume];
    
}

- (void)addLoadFailedView
{
    self.loadFileView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView * loadFiledImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.loadFileView.width, self.loadFileView.height)];
    loadFiledImageView.image = [UIImage imageNamed:@"loadFailed.png"];
    loadFiledImageView.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    [self.loadFileView addSubview:loadFiledImageView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.loadFileView.centerX - 50, self.loadFileView.centerY + 50, 100, 50);
    [button setTitle:@"点击从新加载" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadDataAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loadFileView addSubview:button];
    
}
- (void)showLoadFailImage
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    
    [delegate.window addSubview:self.loadFileView];
}

- (void)loadDataAction:(UIButton * )button
{
    [self post:self.urlString HTTPBody:self.body];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
}

@end
