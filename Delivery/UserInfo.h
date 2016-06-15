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
@property (nonatomic, assign)int isAgent ;
// 商家ID
@property (nonatomic, strong)NSNumber * BusiId;
//@property (nonatomic, copy)NSString * registrationID;

// 是否开启后台定位
@property (nonatomic, assign)BOOL isOpenthebackgroundposition;

- (void)setUserInfoWithDictionary:(NSDictionary *)dic;
@end
