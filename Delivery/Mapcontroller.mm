//
//  Mapcontroller.m
//  Delivery
//
//  Created by 仙林 on 16/1/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "Mapcontroller.h"
#import "AppDelegate.h"

#define TOP_SPACE 10

@interface Mapcontroller ()<BMKMapViewDelegate, BMKGeoCodeSearchDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong)BMKMapView * mapView;
@property (nonatomic, strong)BMKGeoCodeSearch * geoCodeSearch;
@property (nonatomic, strong)BMKLocationService * locService;

// 客户信息
@property (nonatomic, strong)UILabel * namelabel;
@property (nonatomic, strong)UILabel * addressLabel;

@end

@implementation Mapcontroller

- (void)viewDidLoad
{
    self.navigationItem.title = @"地图信息";
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 130)];
    _mapView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    _mapView.height = self.view.height - 70;
    _mapView.delegate = self;
    _mapView.zoomLevel = 18.5;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showMapScaleBar = YES;
    [_mapView setTrafficEnabled:YES];
    [_mapView setMapType:BMKMapTypeStandard];
    [self.view addSubview:_mapView];
    
    // 根据收到的地址,按位置发起geo检索
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.address = self.address;
    BOOL flag = [_geoCodeSearch geoCode:geocodeSearchOption];
    if (flag) {
        NSLog(@"geo检索发送成功");
    }else
    {
        NSLog(@"geo检索发送失败");
    }
    
    // 根据手机自己定位功能，得到经纬度，传给百度地图，来进行定位
    
//    NSDictionary* testdic = BMKConvertBaiduCoorFrom(self.coordinate2D,BMK_COORDTYPE_GPS);
//    CLLocationCoordinate2D coordinate2d = BMKCoorDictionaryDecode(testdic);
//    
//    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
//    BOOL reverseGeoFlag;
//    reverseGeoCodeSearchOption.reverseGeoPoint = coordinate2d;
//    
//    NSLog(@"dic = %@, coordinate2D.latitude = %f, coordinate2D.longitude = %f",[testdic description], coordinate2d.latitude, coordinate2d.longitude);
//    
//    reverseGeoFlag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
//    if(reverseGeoFlag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
    
    self.locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    UIView * bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, _mapView.bottom, self.view.width, 70);
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    self.namelabel = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE, TOP_SPACE, bottomView.width - 80, 25)];
    _namelabel.text = _name;
    [bottomView addSubview:_namelabel];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_namelabel.left, _namelabel.bottom, _namelabel.width, _namelabel.height)];
    _addressLabel.text = _address;
    _addressLabel.numberOfLines = 0;
    [bottomView addSubview:_addressLabel];
    
    CGSize size = CGSizeMake(self.addressLabel.width, 1000);
    CGRect rect = [_address boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    if (rect.size.height + 5 < 25) {
        ;
    }else
    {
        int height = rect.size.height + 5 - 25;
        _addressLabel.height = rect.size.height + 5;
        _mapView.height = self.view.height - 130 - height;
        bottomView.frame = CGRectMake(0, _mapView.bottom, self.view.width, 70 + height);
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(_namelabel.right, _namelabel.top, 1, _namelabel.height + _addressLabel.height)];
    line.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:line];
    
    UIButton * phoneBT = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBT.frame = CGRectMake(line.right + 9, (bottomView.height - 50)/ 2, 50, 50);
    [phoneBT setBackgroundImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
    phoneBT.backgroundColor = [UIColor clearColor];
    [phoneBT addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:phoneBT];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geoCodeSearch.delegate = self;
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _locService.delegate = nil;
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    NSLog(@"error = %u", error);
    
    if (error == 5) {
        NSLog(@"*****没找到检索结果");
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，暂未搜索到指定位置，系统默认显示为当前位置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        // 没找到检索结果，添加配送员的定位位置
        [_locService startUserLocationService];
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.showsUserLocation = YES;
    }
    
    if (error == 0) {
        // 检索成功添加标注
        NSLog(@"*****检索成功");
        BMKPointAnnotation * item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
    }
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    NSLog(@"%u", error);
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        //        result.addressDetail.district
//        NSLog(@"处理结果2 %@, %@, %@ %@", result.address, result.addressDetail.streetName, result.addressDetail.streetNumber, result.addressDetail.district);
        BMKPointAnnotation * item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        
        NSLog(@"%f, %f", result.location.latitude, result.location.longitude);
        
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        //        self.lon = self.coor.longitude;
        //        self.lat = self.coor.latitude;
    }else {
        NSLog(@"抱歉，未找到结果");
    }
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location != nil) {
        NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        [_mapView updateLocationData:userLocation];
        // 添加一个pointAnnotation
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = userLocation.location.coordinate;
        annotation.title = userLocation.title;
        
        [_mapView addAnnotation:annotation];
        _mapView.centerCoordinate = userLocation.location.coordinate;
        
    }
}

// 根据animation生成对应的view
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    // 根据指定标识查找一个可被复用的标注view，一般在delegate中使用，用从函数来代替申请一个新的view
    BMKPinAnnotationView * annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.pinColor = BMKPinAnnotationColorRed;
    }
    
    annotationView.animatesDrop = YES;
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}


#pragma mark - 拨打电话
- (void)phoneAction:(UIButton *)button
{
    AppDelegate * appdelegate = [UIApplication sharedApplication].delegate;
    NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.phone]);
    UIWebView *callWebView = [[UIWebView alloc]init];
    NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phone]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [appdelegate.window addSubview:callWebView];
}

@end
