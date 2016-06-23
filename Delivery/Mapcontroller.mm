//
//  Mapcontroller.m
//  Delivery
//
//  Created by 仙林 on 16/1/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "Mapcontroller.h"
#import "AppDelegate.h"
#import "Toast+UIView.h"

#import <AudioToolbox/AudioToolbox.h>

#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

//#import <QMapKit/QMapKit.h>
//#import <QMapSearchKit/QMapSearchKit.h>
//#import "PoiAnnotation.h"

#define TOP_SPACE 10
#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

typedef NS_ENUM(NSInteger, NavigationTypes)
{
    NavigationTypeNone = 0,
    NavigationTypeSimulator, // 模拟导航
    NavigationTypeGPS,       // 实时导航
};

typedef NS_ENUM(NSInteger, TravelTypes)
{
    TravelTypeCar = 0,      // 驾车方式
    TravelTypeWalk,         // 步行方式
};


@interface Mapcontroller ()< MAMapViewDelegate, AMapNaviViewControllerDelegate, AMapNaviManagerDelegate, IFlySpeechSynthesizerDelegate>
{
//    QPinAnnotationView * _annotationView;
}
@property (nonatomic, strong)MAMapView * mapview;
@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic, strong) AMapNaviPoint* startPoint;
@property (nonatomic, strong) AMapNaviPoint* endPoint;
@property (nonatomic) BOOL calRouteSuccess; // 指示是否算路成功

@property (nonatomic) NavigationTypes naviType;
@property (nonatomic) TravelTypes travelType;
// 腾讯地图
//@property (nonatomic, strong) QMapView * qMapView;
//@property (nonatomic, strong) QMSSearcher * mapSearcher;
//@property (nonatomic, strong) QMSSuggestionResult * suggestionResult;
//@property (nonatomic, strong) QMSGeoCodeSearchResult * geoResult;
//@property (nonatomic, strong) QMSReverseGeoCodeSearchResult *reGeoResult;
//@property (nonatomic, assign) CLLocationCoordinate2D longPressedCoordinate;


// 百度地图
//@property (nonatomic, strong)BMKMapView * mapView;
//@property (nonatomic, strong)BMKGeoCodeSearch * geoCodeSearch;
//@property (nonatomic, strong)BMKLocationService * locService;

// 客户信息
@property (nonatomic, strong)UILabel * namelabel;
@property (nonatomic, strong)UILabel * addressLabel;

@end

@implementation Mapcontroller

- (void)viewDidLoad
{
    self.navigationItem.title = @"地图信息";
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_black.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complateAction:)];
//    NSDictionary * titleAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                       NSForegroundColorAttributeName:[UIColor blackColor]
//                                       };
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开始导航" style:UIBarButtonItemStylePlain target:self action:@selector(startNaviAction:)];
    NSDictionary * titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor blackColor], NSBackgroundColorAttributeName:[UIColor redColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
    
    [self initNaviPoints];
    self.travelType = TravelTypeWalk;
    
    // 百度地图
    
//    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 130)];
//    _mapView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
////    _mapView.height = self.view.height - 70;
////    _mapView.delegate = self;
//    _mapView.zoomLevel = 18.5;
//    _mapView.userTrackingMode = BMKUserTrackingModeNone;
//    _mapView.showMapScaleBar = YES;
//    [_mapView setTrafficEnabled:YES];
//    [_mapView setMapType:BMKMapTypeStandard];
////    [self.view addSubview:_mapView];
//    
    // 根据收到的地址,按位置发起geo检索
//    self.geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
////    _geoCodeSearch.delegate = self;
//    
//    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    geocodeSearchOption.address = self.address;
//    BOOL flag = [_geoCodeSearch geoCode:geocodeSearchOption];
//    if (flag) {
//        NSLog(@"geo检索发送成功");
//    }else
//    {
//        NSLog(@"geo检索发送失败");
//    }
//    
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
    
//    self.locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
    
    
    
    // 腾讯地图
//    self.qMapView = [[QMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 70)];
//    self.qMapView.delegate = self;
//    [self.view addSubview:self.qMapView];
//    self.qMapView.showsUserLocation = NO;
//    self.qMapView.zoomLevel = 16;
////    if (IOS7)
////    {
////        self.automaticallyAdjustsScrollViewInsets = NO;
////    }
//    // 根据地址发起地理编码检索
//    self.mapSearcher = [[QMSSearcher alloc]initWithDelegate:self];
//    QMSGeoCodeSearchOption * geoOption = [[QMSGeoCodeSearchOption alloc]init];
////    self.address = @"郑州市，科苑小区";
//    [geoOption setAddress:self.address];
////    [geoOption setRegion:@"北京"];
//    [self.mapSearcher searchWithGeoCodeSearchOption:geoOption];
    
    
    
    
    
    [MAMapServices sharedServices].apiKey = @"11ce5c3cc2c7353240532288a5f63425";
    [AMapSearchServices sharedServices].apiKey = @"11ce5c3cc2c7353240532288a5f63425";
    [AMapNaviServices sharedServices].apiKey =@"11ce5c3cc2c7353240532288a5f63425";
    self.mapview = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 70)];
    self.mapview.delegate = self;
    self.mapview.zoomLevel = 18;
    [self.view addSubview:self.mapview];
    self.naviManager = [[AMapNaviManager alloc]init];
    self.naviManager.delegate = self;
    [self initAnnotations];
    
    if (self.iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
//    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressMapView:)];
//    [self.view addGestureRecognizer:longPressGesture];
    
    UIView * bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, _mapview.bottom - 64 , self.view.width, 70);
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    self.namelabel = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE, TOP_SPACE, bottomView.width - 80, 25)];
    _namelabel.text = _name;
    [bottomView addSubview:_namelabel];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_namelabel.left, _namelabel.bottom, _namelabel.width, _namelabel.height)];
    _addressLabel.text = _address;
//    _addressLabel.text = @"适度腐败科技部错技能了十多年可能是对付sjhfbsjrbldrbskjskdjkffksdjbfksskjebf kjvs款了";
    _addressLabel.numberOfLines = 0;
    [bottomView addSubview:_addressLabel];
    
    CGSize size = CGSizeMake(self.addressLabel.width, 1000);
    CGRect rect = [_addressLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    NSLog(@"*****%f", rect.size.height);
    if (rect.size.height  < 25) {
    }else
    {
        int height = rect.size.height  - 25;
        _addressLabel.height = rect.size.height ;
        _mapview.height = self.view.height - 70 - height;
        bottomView.frame = CGRectMake(0, _mapview.bottom - 64, self.view.width, 70 + height);
    }
    
//    NSLog(@"self.view.height = %f****qmapView.height = %f***qmapView.bottom = %f ***bottomView.top = %f", self.view.height, _qMapView.height,_qMapView.bottom, bottomView.top );
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(_namelabel.right, _namelabel.top, 1, _namelabel.height + _addressLabel.height)];
    line.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:line];
    
    UIButton * phoneBT = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBT.frame = CGRectMake(line.right + 9, (bottomView.height - 50)/ 2, 50, 50);
    [phoneBT setBackgroundImage:[UIImage imageNamed:@"dianhua.png"] forState:UIControlStateNormal];
    phoneBT.backgroundColor = [UIColor clearColor];
    [phoneBT addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:phoneBT];
}

// 客户路径规划
- (void)initNaviPoints
{
    self.startPoint = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].coordinate2D.latitude longitude:[UserLocation shareLocation].coordinate2D.longitude];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].searchCoordinate.latitude longitude:[UserLocation shareLocation].searchCoordinate.longitude];
    
    NSLog(@"JJJJJ");
}
- (void)initAnnotations
{
    NavPointAnnotation *beginAnnotation = [[NavPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    beginAnnotation.title        = @"起始点";
    beginAnnotation.navPointType = NavPointAnnotationStart;
    
    [self.mapview addAnnotation:beginAnnotation];
    
    NavPointAnnotation *endAnnotation = [[NavPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
    endAnnotation.title        = @"终点";
    endAnnotation.navPointType = NavPointAnnotationEnd;
    
    [self.mapview addAnnotation:endAnnotation];
    
    [self.mapview setCenterCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    
}
// 商家路径规划
- (void)initNaviPointsShop
{
    self.startPoint = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].coordinate2D.latitude longitude:[UserLocation shareLocation].coordinate2D.longitude];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].shopSearchCoordinate.latitude longitude:[UserLocation shareLocation].shopSearchCoordinate.longitude];
    
    NSLog(@"JJJJJ");
}
- (void)initAnnotationsShop
{
    NavPointAnnotation *beginAnnotation = [[NavPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    beginAnnotation.title        = @"起始点";
    beginAnnotation.navPointType = NavPointAnnotationStart;
    
    [self.mapview addAnnotation:beginAnnotation];
    
    NavPointAnnotation *endAnnotation = [[NavPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
    endAnnotation.title        = @"终点";
    endAnnotation.navPointType = NavPointAnnotationEnd;
    
    [self.mapview addAnnotation:endAnnotation];
    
    [self.mapview setCenterCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [self calculateWalkRout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 高德地图
- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil)
    {
        return;
    }
    
    // 清除旧的overlays
//    [self.mapview removeOverlays:self.mapview.overlays];
    
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.mapview addOverlay:polyline];
}
#pragma mark - AMapNaviManager Delegate
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
    _calRouteSuccess = YES;
    
    if (self.endPoint.latitude != [UserLocation shareLocation].shopSearchCoordinate.latitude) {
        [self initNaviPointsShop];
        [self initAnnotationsShop];
        [self calculateWalkRout];
    }
}
- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error;
{
    NSLog(@"路径规划失败");
    _calRouteSuccess = NO;
    [self.view makeToast:@"路径规划失败"
                duration:2.0
                position:[NSValue valueWithCGPoint:CGPointMake(160, 240)]];
}
- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error
{
    NSLog(@"error:{%@}",error.localizedDescription);
}
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
//    [super naviManager:naviManager didPresentNaviViewController:naviViewController];
    
    if (self.naviType == NavigationTypeGPS)
    {
        [self.naviManager startGPSNavi];
    }
    else if (self.naviType == NavigationTypeSimulator)
    {
        [self.naviManager startEmulatorNavi];
    }
}

- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController
{
//    [super naviManager:naviManager didDismissNaviViewController:naviViewController];
}

- (void)naviManagerNeedRecalculateRouteForYaw:(AMapNaviManager *)naviManager
{
    NSLog(@"NeedReCalculateRouteForYaw");
}
- (void)naviManager:(AMapNaviManager *)naviManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager
{
    NSLog(@"DidEndEmulatorNavi");
}

- (void)naviManagerOnArrivedDestination:(AMapNaviManager *)naviManager
{
    NSLog(@"OnArrivedDestination");
}

- (void)naviManager:(AMapNaviManager *)naviManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint");
}
- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation
{
    //    NSLog(@"didUpdateNaviLocation");
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviInfo:(AMapNaviInfo *)naviInfo
{
    //    NSLog(@"didUpdateNaviInfo");
}

- (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager
{
    //    NSLog(@"GetSoundPlayState");
    
    return 0;
}
- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    if (soundStringType == AMapNaviSoundTypePassedReminder)
    {
        //用系统自带的声音做简单例子，播放其他提示音需要另外配置
        AudioServicesPlaySystemSound(1009);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [_iFlySpeechSynthesizer startSpeaking:soundString];
        });
    }
}

- (void)naviManagerDidUpdateTrafficStatuses:(AMapNaviManager *)naviManager
{
    NSLog(@"DidUpdateTrafficStatuses");
}

#pragma mark - AManNaviViewController Delegate

- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviType != NavigationTypeNone)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self.iFlySpeechSynthesizer stopSpeaking];
        });
        
        [self.naviManager stopNavi];
    }
    
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}

- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
}

- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    [self.naviManager readNaviInfoManual];
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NavPointAnnotation class]]) {
        static NSString * annotationIdentifier = @"annotationIdentifier";
        
        MAPinAnnotationView * pointAnnotationView = (MAPinAnnotationView*)[self.mapview dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil) {
            pointAnnotationView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        
        pointAnnotationView.animatesDrop = NO;
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.draggable = NO;
        
        NavPointAnnotation * navAnnotation = (NavPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NavPointAnnotationStart) {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
        }else if (navAnnotation.navPointType == NavPointAnnotationEnd)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
        }
        return pointAnnotationView;
    }
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineView * polylineView = [[MAPolylineView alloc]initWithPolyline:overlay];
        polylineView.lineWidth = 5.0f;
        polylineView.strokeColor = [UIColor redColor];
        if (self.endPoint.latitude != [UserLocation shareLocation].shopSearchCoordinate.latitude) {
            polylineView.strokeColor = [UIColor blueColor];
        }
        return polylineView;
    }
    return nil;
}


#pragma mark - iFlySpeechSynthesizer Delegate

- (void)onCompleted:(IFlySpeechError *)error
{
    NSLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
}
#pragma mark - 腾讯地图
/*
//- (void)mapViewWillStartLocatingUser:(QMapView *)mapView
//{
//    NSLog(@"开始定位");
//}
//- (void)mapViewDidStopLocatingUser:(QMapView *)mapView
//{
//    NSLog(@"停止定位");
//}
//- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
//{
//    NSLog(@"刷新位置");
//    
//    
////    [self initAnnotationWithCoordinate:userLocation.coordinate withTitle:userLocation.title];
//    
//    [self.qMapView setCenterCoordinate:userLocation.coordinate];
//    
//    [self.qMapView removeAnnotations:self.qMapView.annotations];
//    
//    PoiAnnotation *annotation = [[PoiAnnotation alloc] init];
//    [annotation setCoordinate:userLocation.coordinate];
//    
//    [annotation setTitle:[NSString stringWithFormat:@"%@", userLocation.title]];
//    [annotation setSubtitle:[NSString stringWithFormat:@"lat:%f, lng:%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude]];
//    [self.qMapView addAnnotation:annotation];
//    
//}
//
//- (void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error
//{
//    NSLog(@"定位失败");
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，定位失败" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:cancelAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//
//- (void)initAnnotationWithCoordinate:(CLLocationCoordinate2D )coordinate withTitle:(NSString *)title
//{
//    [self.qMapView removeAnnotations:self.qMapView.annotations];
//    QPointAnnotation * blue = [[QPointAnnotation alloc]init];
//    [self.qMapView setCenterCoordinate:coordinate];
//    blue.coordinate = coordinate;
//    blue.title = title;
//    blue.subtitle = [NSString stringWithFormat:@"{%f, %f}", blue.coordinate.latitude, blue.coordinate.longitude];
//    [self.qMapView addAnnotation:blue];
//    
//}
//- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
//{
////    if ([annotation isKindOfClass:[QAnnotationView class]]) {
////    NSLog(@"[annotation class] = %@", [annotation class]);
//        static NSString * pointReuseIndetifier = @"pointReuseIndetifier";
//        QPinAnnotationView * annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
//            if (annotationView == nil) {
//                annotationView = [[QPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
//            }
//            
//            annotationView.animatesDrop = YES;
////            annotationView.draggable = YES;
//            annotationView.canShowCallout = YES;
//        
////            annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            return annotationView;
//       
//
//}
//
//#pragma mark - 腾讯地理编码
//- (void)searchWithGeoCodeSearchOption:(QMSGeoCodeSearchOption *)geoCodeSearchOption didReceiveResult:(QMSGeoCodeSearchResult *)geoCodeSearchResult
//{
////    NSLog(@"geo result:%@", geoCodeSearchResult);
//    self.geoResult = geoCodeSearchResult;
//    [self.qMapView setCenterCoordinate:self.geoResult.location];
//    [self setupAnnotation];
//}
//- (void)setupAnnotation
//{
//    [self.qMapView removeAnnotations:self.qMapView.annotations];
//    
//    [self.qMapView setCenterCoordinate:self.geoResult.location];
//    
//    PoiAnnotation *annotation = [[PoiAnnotation alloc] initWithPoiData:self.geoResult];
//    [annotation setCoordinate:self.geoResult.location];
//    
////    NSLog(@"%@", self.geoResult);
//    
//    [annotation setTitle:[NSString stringWithFormat:@"%@%@", self.geoResult.address_components.city, self.geoResult.address_components.district]];
//    [annotation setSubtitle:[NSString stringWithFormat:@"lat:%f, lng:%f", self.geoResult.location.latitude, self.geoResult.location.longitude]];
//    [self.qMapView addAnnotation:annotation];
//}
//- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
//{
//    self.qMapView.showsUserLocation = YES;
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，暂未搜索到指定位置，系统默认显示为当前位置" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:cancelAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//    NSLog(@"error = %@", error);
//}
//
//
//#pragma mark - 腾讯反地理编码
//- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult
//{
//    self.reGeoResult = reverseGeoCodeSearchResult;
//    [self setupAnnotation1];
//}
//- (void)setupAnnotation1
//{
//    
//    [self.qMapView removeAnnotations:self.qMapView.annotations];
//    
//    PoiAnnotation *annotation = [[PoiAnnotation alloc] initWithPoiData:self.reGeoResult];
//    [annotation setTitle:self.reGeoResult.address];
//    [annotation setCoordinate:self.longPressedCoordinate];
//    
//    [self.qMapView addAnnotation:annotation];
//}
//
//#pragma mark - 长按设置坐标
//- (void)longPressMapView:(UILongPressGestureRecognizer *)longPress
//{
//    self.qMapView.showsUserLocation = NO;
//    if (longPress.state == UIGestureRecognizerStateBegan)
//    {
//        CLLocationCoordinate2D coordinate = [self.qMapView convertPoint:[longPress locationInView:self.view]
//                                                  toCoordinateFromView:self.qMapView];
//        
//        self.longPressedCoordinate = coordinate;
//        NSLog(@"lat:%f, lng:%f", self.longPressedCoordinate.latitude, self.longPressedCoordinate.longitude);
//        [self searchReGeocode];
//        
//    }else if (longPress.state == UIGestureRecognizerStateEnded)
//    {
//        [self.qMapView setCenterCoordinate:self.longPressedCoordinate];
//    }
//    
//}
//- (void)searchReGeocode;
//{
//    //配置搜索参数
//    QMSReverseGeoCodeSearchOption *reGeoSearchOption = [[QMSReverseGeoCodeSearchOption alloc] init];
//    [reGeoSearchOption setLocationWithCenterCoordinate:self.longPressedCoordinate];
//    [reGeoSearchOption setGet_poi:YES];
//    [self.mapSearcher searchWithReverseGeoCodeSearchOption:reGeoSearchOption];
//}
//
//- (void)tapAction:(UIGestureRecognizer *)tap
//{
//    self.qMapView.showsUserLocation = NO;
//    
//        CLLocationCoordinate2D coordinate = [self.qMapView convertPoint:[tap locationInView:self.qMapView]
//                                                   toCoordinateFromView:self.qMapView];
//        
//        self.longPressedCoordinate = coordinate;
////    NSLog(@"%lu", self.qMapView.gestureRecognizers.count);
////    for (int i = 0; i < self.view.gestureRecognizers.count; i++) {
////        NSLog(@"****%@", self.view.gestureRecognizers[i]);
////    }
////        NSLog(@"lat:%f, lng:%f", self.longPressedCoordinate.latitude, self.longPressedCoordinate.longitude);
//        [self searchReGeocode];
//        [self.qMapView setCenterCoordinate:self.longPressedCoordinate];
//  
//
//}

#pragma mark - 移动大头针
//- (void)mapView:(QMapView *)mapView didSelectAnnotationView:(QAnnotationView *)view
//{
////    self.qMapView.showsUserLocation = NO;
//    [view setDragState:QAnnotationViewDragStateStarting animated:YES];
//    NSLog(@"触摸大头针");
//}
//- (void)mapView:(QMapView *)mapView didDeselectAnnotationView:(QAnnotationView *)view
//{
//    [view setDragState:QAnnotationViewDragStateEnding animated:YES];
//    NSLog(@"deselect!");
//}
*/
#pragma mark - 百度地图
/*
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
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
//{
//    NSString *AnnotationViewID = @"annotationViewID";
//    // 根据指定标识查找一个可被复用的标注view，一般在delegate中使用，用从函数来代替申请一个新的view
//    BMKPinAnnotationView * annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//    if (annotationView == nil) {
//        annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//        annotationView.pinColor = BMKPinAnnotationColorRed;
//    }
//    
//    annotationView.animatesDrop = YES;
//    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
//    annotationView.annotation = annotation;
//    annotationView.canShowCallout = TRUE;
//    return annotationView;
//}

*/
#pragma mark - 拨打电话
- (void)phoneAction:(UIButton *)button
{
    if (self.phone.length != 0) {
        AppDelegate * appdelegate = [UIApplication sharedApplication].delegate;
        NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.phone]);
        UIWebView *callWebView = [[UIWebView alloc]init];
        NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phone]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [appdelegate.window addSubview:callWebView];
    }
    
}

- (void)calculateWalkRout
{
    NSArray *startPoints = @[self.startPoint];
    NSArray *endPoints   = @[self.endPoint];
    
    
    if (self.travelType == TravelTypeCar)
    {
        [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyDefault];
    }
    else
    {
        [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
        NSLog(@"****%f, ****%f, ***%@, ******%@", _startPoint.latitude, _startPoint.longitude, [startPoints objectAtIndex:0], startPoints);
        
        NSLog(@"^^^^^^^lat%f^^^^^^lon%f", [UserLocation shareLocation].coordinate2D.latitude, [UserLocation shareLocation].coordinate2D.longitude);
    }
}

- (void)startNaviAction:(UIBarButtonItem *)sender
{
    if (_calRouteSuccess) {
        self.naviType = NavigationTypeGPS;
//        self.naviType = NavigationTypeSimulator;
        AMapNaviViewController * naviViewController = [[AMapNaviViewController alloc]initWithDelegate:self];
        
        [self.naviManager presentNaviViewController:naviViewController animated:YES];
        
    }else
    {
        [self.view makeToast:@"请先进行路径规划"
                    duration:2.0
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 240)]];
    }
}

@end
