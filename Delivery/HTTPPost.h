//
//  HTTPPost.h
//  Delivery
//
//  Created by 仙林 on 16/1/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPPostDelegate <NSObject>

- (void)refresh:(id)data;
@optional
- (void)failWithError:(NSError *)error;

@end

@interface HTTPPost : NSObject<NSURLSessionDelegate>
@property (nonatomic, assign) id<HTTPPostDelegate> delegate;
@property (nonatomic, strong)NSNumber * commend;
+(HTTPPost *)shareHTTPPost;
- (void)post:(NSString *)urlString HTTPBody:(NSData *)body;

@end
