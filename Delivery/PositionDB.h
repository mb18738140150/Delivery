//
//  PositionDB.h
//  Delivery
//
//  Created by 仙林 on 16/6/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionModel.h"
#import "FMDatabase.h"
@interface PositionDB : NSObject
{
    FMDatabase * _db;
}

//+(CollectStroeDB *)shareCollectStoreDB;

//添加
- (BOOL) insert:(PositionModel *)model;

// 删除
- (BOOL) deletemodel:(PositionModel *)model;

// 更新
- (BOOL)updateModel:(PositionModel *)model;

// 检索列表
- (BOOL)retrieveList:(PositionModel *)model;

// 获取列表
- (NSArray *)getPositionModels;

@end
