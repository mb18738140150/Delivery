//
//  CLLocation+YCLocation.h
//  Delivery
//
//  Created by 仙林 on 16/3/7.
//  Copyright © 2016年 仙林. All rights reserved.
//

/*
 从CLLocationManager取出来的经纬度放到mapView上显示，是错误的！
 从CLLocationManager取出来的经纬度去Google Maps API做逆地址解析，是错的！
 从MKMapView取出来的经纬度去Google Maps API做逆地址解析终于对了。去百度地图做逆地址解析，依旧是错的！
 从上面两处取得经纬度放到百度地图上显示都是错的
 
 分为 地球坐标系，火星坐标系（iOS mapView 高德， 国内Google，搜搜、阿里云 都是火星坐标系），百度坐标（百度地图数据主要都是四维图新提供的）
 
 火星坐标：MKMapView
 地球坐标：CLLocationManager
 
 当用到CLLocationManager得到的数据转化为火星坐标系，MKMapView不用处理
 
 API                坐标系
 百度地图API         百度坐标
 腾讯搜搜地图API      火星坐标
 搜狐搜狗地图API      搜狗坐标
 阿里云地图API       火星坐标
 图吧MapBar地图API   图吧坐标
 高德MapABC地图API   火星坐标
 灵图51ditu地图API   火星坐标
 
 */

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (YCLocation)

// 从地图坐标转化到火星坐标
- (CLLocation*)locationMarsFromEarth;
// 从火星坐标转化到百度坐标
- (CLLocation*)locationBaiduFromMars;
// 从百度坐标到火星坐标
- (CLLocation*)locationMarsFromBaidu;


@end
