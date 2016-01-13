//
//  UserInfo.h
//  Delivery
//
//  Created by 仙林 on 16/1/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
+ (UserInfo *)shareUserInfo;
@property (nonatomic, strong)NSNumber * userId;
@property (nonatomic, copy)NSString * userName;
@property (nonatomic, copy)NSString * icon;
@property (nonatomic, copy)NSString * StroeName;

//@property (nonatomic, copy)NSString * registrationID;

- (void)setUserInfoWithDictionary:(NSDictionary *)dic;
@end
