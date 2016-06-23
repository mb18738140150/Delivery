//
//  SDBManager.m
//  Delivery
//
//  Created by 仙林 on 16/6/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "SDBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#define KDefaultDBName @"name.sqlite"

static SDBManager * shareSDManager = nil;

@implementation SDBManager

+(SDBManager *)defaultDBManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareSDManager = [[SDBManager alloc]init];
    });
    return shareSDManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createDBWithName:KDefaultDBName];
    }
    return self;
}
- (void)createDBWithName:(NSString *)name
{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    _name = [path stringByAppendingString:[NSString stringWithFormat:@"/%@", name]];
    [self connect];
}
- (void)connect
{
    if (!_database) {
        _database = [[FMDatabase alloc]initWithPath:_name];
    }
    if (![_database open]) {
        NSLog(@"打开数据库失败");
    }
}

- (void)close
{
    [_database close];
    shareSDManager = nil;
}
- (void)dealloc
{
    [self close];
}

@end
