//
//  PoiAnnotation.h
//  QMapSearchDemo
//
//  Created by xfang on 14/11/17.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>

@interface PoiAnnotation : NSObject<QAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) QMSBaseResult *poiData;


- (instancetype) initWithPoiData:(QMSBaseResult *)poiData;
@end
