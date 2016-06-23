//
//  SDBManager.h
//  Delivery
//
//  Created by 仙林 on 16/6/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@interface SDBManager : NSObject
{
    NSString * _name;
}
@property (nonatomic, readonly)FMDatabase * database;

+(SDBManager *)defaultDBManager;
- (void)close;

@end
