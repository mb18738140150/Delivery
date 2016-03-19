//
//  PoiAnnotation.m
//  QMapSearchDemo
//
//  Created by xfang on 14/11/17.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "PoiAnnotation.h"

@implementation PoiAnnotation

- (instancetype)initWithPoiData:(QMSBaseResult *)poiData
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.poiData = poiData;
    
    return self;
}

@end
