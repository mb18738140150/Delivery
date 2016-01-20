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

@interface Mapcontroller ()<BMKMapViewDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong)BMKMapView * mapView;
@property (nonatomic, strong)BMKGeoCodeSearch * geoCodeSearch;


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
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geoCodeSearch.delegate = nil;
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
    if (error == 0) {
        // 检索成功添加标注
        BMKPointAnnotation * item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
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
