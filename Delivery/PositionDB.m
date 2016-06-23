//
//  PositionDB.m
//  Delivery
//
//  Created by 仙林 on 16/6/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "PositionDB.h"

#define TableName @"Position"
static PositionDB * positionManager = nil;

@implementation PositionDB
- (instancetype)init
{
    self = [super init];
    if (self) {
        _db = [SDBManager defaultDBManager].database;
        [self createDataBase];
    }
    return self;
}

- (void)createDataBase
{
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'", TableName]];
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    BOOL existTable = !!count;
    if (existTable) {
        NSLog(@"数据库已经存在");
    }else
    {
        // 创建数据库
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (userID integer,positionType integer)", TableName];
        BOOL res = [_db executeUpdate:sql];
        if (res) {
            NSLog(@"数据库创建成功");
        }else
        {
            NSLog(@"数据库创建失败");
        }
        
    }
}

// 插入数据源
- (BOOL)insert:(PositionModel *)model
{
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT OR REPLACE INTO %@", TableName];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
    if (model.userId) {
        [keys appendString:@"userID,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInt:model.userId]];
    }
    if (model.positionType) {
        [keys appendString:@"positionType,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInt:model.positionType]];
    }
    
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@", [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"], [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    if ([_db executeUpdate:query withArgumentsInArray:arguments]) {
        NSLog(@"插入数据成功");
        return YES;
    }else
    {
        NSLog(@"插入数据失败");
        return NO;
    }
}

// 更改
- (BOOL)updateModel:(PositionModel *)model
{
    if ([_db executeUpdate:@"UPDATE Position SET positionType = ? WHERE userID = ?",[NSNumber numberWithInt:model.positionType],[NSNumber numberWithInt:model.userId]]) {
        NSLog(@"%d, %d", model.userId, model.positionType);
    }
    
   return [_db executeUpdate:@"UPDATE Position SET positionType = ? WHERE userID = ?",[NSNumber numberWithInt:model.positionType],[NSNumber numberWithInt:model.userId]];
}

// 删除
- (BOOL)deletemodel:(PositionModel *)model
{
    return  [_db executeUpdate:@"DELETE FROM Position WHERE userID = ?",[NSNumber numberWithInt:model.userId]];
}

// 检索

- (BOOL)retrieveList:(PositionModel *)model
{
    FMResultSet * set = [_db executeQuery:@"SELECT * FROM Position"];
    BOOL ishave = NO;
    while ([set next]) {
        int userid = [[set stringForColumn:@"userID"] intValue];
        if (model.userId == userid) {
            ishave = YES;
            return  ishave;
        }
    }
    return ishave;
}

// 获取positionModels
- (NSArray *)getPositionModels
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",TableName];
    
    FMResultSet * re = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[re columnCount]];
    while ([re next]) {
        PositionModel * positionModel = [[PositionModel alloc]init];
        positionModel.userId = [[re stringForColumn:@"userID"] intValue];
        positionModel.positionType = [[re stringForColumn:@"positionType"] intValue];
        [array addObject:positionModel];
    }
    return array;
    
}

@end
