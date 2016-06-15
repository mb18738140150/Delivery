//
//  AMapSearchm.m
//  Delivery
//
//  Created by 仙林 on 16/6/6.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "AMapSearchm.h"

@interface AMapSearchm()<AMapSearchDelegate, MAMapViewDelegate>

@property (nonatomic, copy)LocationBlock1 locationBlock;
@property (nonatomic, copy)AddressBlock addressBlock;
@property (nonatomic, copy)CoorDinateBlock coordinateBlock;
@property (nonatomic, copy)SearchFaileBlock searchFailedBlock;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, copy)NSString * address;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end

@implementation AMapSearchm

+(AMapSearchm *)shareSearch
{
    static AMapSearchm * amapSearch = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        amapSearch = [[AMapSearchm alloc]init];
    });
    return amapSearch;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapView = [[MAMapView alloc]init];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = NO;
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        
    }
    return self;
}


- (void)getLocationCoordinate:(LocationBlock1)locationBlock
{
    self.locationBlock = [locationBlock copy];
    self.mapView.showsUserLocation = YES;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    self.locationBlock(userLocation.coordinate);
    _locationBlock = nil;
    self.mapView.showsUserLocation = NO;
}

#pragma mark - 地理编码
- (void)getCoordinateWithAddress:(NSString *)address complate:(CoorDinateBlock)coordinateBlock failed:(SearchFaileBlock)faile
{
    self.coordinateBlock = [coordinateBlock copy];
    self.searchFailedBlock = [faile copy];
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc]init];
    geo.address = address;
    [self.search AMapGeocodeSearch:geo];
    
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (self.coordinateBlock) {
        
        NSLog(@"%@", response.geocodes);
        
        if (response.geocodes.count == 0) {
            if (self.searchFailedBlock) {
                _searchFailedBlock();
                _searchFailedBlock = nil;
            }
            return;
        }
        
        AMapGeocode * mapgeocode = [response.geocodes objectAtIndex:0];
        
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(mapgeocode.location.latitude, mapgeocode.location.longitude);
        _coordinateBlock(coor);
        _coordinateBlock = nil;
    }
}

#pragma mark - 逆地理编码

- (void)getaddressWithCoordinate:(CLLocationCoordinate2D)coordinate complate:(AddressBlock)addressBlock failed:(SearchFaileBlock)faile
{
    self.coordinateBlock = [addressBlock copy];
    self.searchFailedBlock = [faile copy];
    
    AMapReGeocodeSearchRequest * regeo = [[AMapReGeocodeSearchRequest alloc]init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (self.addressBlock) {
        if (response.regeocode != nil) {
            _addressBlock(response.regeocode.formattedAddress);
            _addressBlock = nil;
        }else
        {
            if (self.searchFailedBlock) {
                _searchFailedBlock();
                _searchFailedBlock = nil;
            }
        }
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    if (self.searchFailedBlock) {
        _searchFailedBlock();
        _searchFailedBlock = nil;
    }
}

@end
