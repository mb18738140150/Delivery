//
//  OrderViewController.m
//  Delivery
//
//  Created by 仙林 on 15/10/23.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "OrderViewController.h"
#import "UserCenterViewController.h"
#import "PersonCenterViewController.h"
#import "OrderDetailController.h"
#import "AppDelegate.h"
#import "Mapcontroller.h"
#import "GiveupReasonView.h"
#import <AVFoundation/AVFoundation.h>
//#import <AudioToolbox/AudioToolbox.h>

#import "PersonalDataViewController.h"
#import "ViewController.h"

#import "NewOrderCell.h"
#import "DeliveryingCell.h"
#import "DeliveriedCell.h"
#import "NewOrderModel.h"

#define NORDERCELL_IDENTIFIER @"cell"
#define DELIVERYING_IDENTIFIER @"deliveryingcell"
#define DELIVERIED_IDENTIFIER @"deliveriedcell"

//#import <QMapKit/QMapKit.h>
//#import <QMapSearchKit/QMapSearchKit.h>


#define SEGMENT_HEIGHT 40
#define SEGMENT_WIDTH 260
#define SEGMENT_X [UIScreen mainScreen].bounds.size.width / 2 - SEGMENT_WIDTH / 2
#define TOP_SPACE 10
#define HEARDERVIEW_HEIGHT 4 + SEGMENT_HEIGHT

#define ADDRESS_SHOP_TAG 1000
#define ADDRESS_CUSTOM_TAG 2000

NSString *const QAnnotationViewDragStateCHange = @"QAnnotationViewDragState";

@interface OrderViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPPostDelegate, UIAlertViewDelegate, MAMapViewDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate>

{
    AVAudioPlayer * _player;
}

// 订单状态
@property (nonatomic, assign)int orderState;

// 导航条订单数量label
@property (nonatomic, strong)UILabel * waitAcceptLB;
@property (nonatomic, strong)UILabel * waiDeliveryLB;
@property (nonatomic, strong)UILabel * deliveringLB;
@property (nonatomic, strong)UILabel * deliveriedLB;


// 新订单
@property (nonatomic, strong)NSMutableArray * nOrderArray;
@property (nonatomic, assign)int nOrderCount;
@property (nonatomic, assign)int nOrderPag;
// 代配送
@property (nonatomic, strong)UITableView * waitOrderTableView;
@property (nonatomic, strong)NSMutableArray * waitOrderArray;
@property (nonatomic, assign)int waitOrderCount;
@property (nonatomic, assign)int waitOrderPag;

// 配送中
@property (nonatomic, strong)UITableView * deliveryingTableView;
@property (nonatomic, strong)NSMutableArray * deliveryingArray;
@property (nonatomic, assign)int deliveryingCount;
@property (nonatomic, assign)int deliveryingPag;

// 已配送
@property (nonatomic, strong)UITableView * deliveriedTableView;
@property (nonatomic, strong)NSMutableArray * deliveriedArray;
@property (nonatomic, assign)int deliveriedCount;
@property (nonatomic, assign)int deliveriedPag;

@property (nonatomic, assign)int toDetailsView;


@property (nonatomic, assign) CLLocationCoordinate2D Coordinate;

@property (nonatomic, strong)MAMapView * mapview;

@property (nonatomic, strong)PositionDB * positionDb;
@property (nonatomic, strong)GiveupReasonView * giupReasonView;// 放弃订单原因弹出框
@end

@implementation OrderViewController

- (NSMutableArray *)nOrderArray
{
    
    if (!_nOrderArray) {
        self.nOrderArray = [NSMutableArray array];
    }
    return _nOrderArray;
}

- (NSMutableArray *)waitOrderArray
{
    if (!_waitOrderArray) {
        self.waitOrderArray = [NSMutableArray array];
    }
    return _waitOrderArray;
}

- (NSMutableArray *)deliveryingArray
{
    if (!_deliveryingArray) {
        self.deliveryingArray = [NSMutableArray array];
    }
    return _deliveryingArray;
}

- (NSMutableArray *)deliveriedArray
{
    if (!_deliveriedArray) {
        self.deliveriedArray = [NSMutableArray array];
    }
    return _deliveriedArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHeaderView];
    
    self.view.backgroundColor = [UIColor redColor];
    self.toDetailsView = 0;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251 / 255.0 green:84 / 255.0 blue:8 / 255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.positionDb = [[PositionDB alloc]init];
    
    // 新订单
    self.nOrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    _nOrderTableView.dataSource = self;
    _nOrderTableView.delegate = self;
    self.nOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _nOrderTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_nOrderTableView];
    _nOrderPag = 1;
    _orderState = 1;
    self.nOrderTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.nOrderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_nOrderTableView registerClass:[NewOrderCell class] forCellReuseIdentifier:NORDERCELL_IDENTIFIER];
    
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    self.nOrderTableView.tableFooterView = [[UIView alloc]init];
    
    // 代配送订单
    self.waitOrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    _waitOrderTableView.delegate = self;
    _waitOrderTableView.dataSource = self;
    self.waitOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _waitOrderTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_waitOrderTableView];
    _waitOrderPag = 1;
    self.waitOrderTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.waitOrderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_waitOrderTableView registerClass:[DeliveryingCell class] forCellReuseIdentifier:DELIVERYING_IDENTIFIER];
    _waitOrderTableView.tableFooterView = [[UIView alloc]init];
    self.waitOrderTableView.hidden = YES;
    
    // 配送中订单
    self.deliveryingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    _deliveryingTableView.delegate = self;
    _deliveryingTableView.dataSource = self;
    self.deliveryingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _deliveryingTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_deliveryingTableView];
    _deliveryingPag = 1;
    self.deliveryingTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.deliveryingTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_deliveryingTableView registerClass:[DeliveryingCell class] forCellReuseIdentifier:DELIVERYING_IDENTIFIER];
    _deliveryingTableView.tableFooterView = [[UIView alloc]init];
    self.deliveryingTableView.hidden = YES;
    
    // 已配送订单
    self.deliveriedTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    _deliveriedTableView.delegate = self;
    _deliveriedTableView.dataSource = self;
    self.deliveriedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _deliveriedTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_deliveriedTableView];
    _deliveriedPag = 1;
    self.deliveriedTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.deliveriedTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    _deliveriedTableView.tableFooterView = [[UIView alloc]init];
    [_deliveriedTableView registerClass:[DeliveriedCell class] forCellReuseIdentifier:DELIVERIED_IDENTIFIER];
    self.deliveriedTableView.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"setting.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(setupAction:)];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"shezhi.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(setupAction:)];
    
    [MAMapServices sharedServices].apiKey = @"11ce5c3cc2c7353240532288a5f63425";
    [AMapSearchServices sharedServices].apiKey = @"11ce5c3cc2c7353240532288a5f63425";
    self.mapview = [[MAMapView alloc]init];
    self.mapview.delegate = self;
    self.mapview.showsUserLocation = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(qano:) name:QAnnotationViewDragStateCHange object:nil];;
    
}

#pragma mark - 高德地图
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    [UserLocation shareLocation].coordinate2D = userLocation.coordinate;;
    self.mapview.showsUserLocation = NO;
//    NSLog(@"userLocation = %@, %@, %f, %f", userLocation.title, userLocation.subtitle, userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
    [[AMapSearchm shareSearch] getaddressWithCoordinate:[UserLocation shareLocation].coordinate2D complate:^(NSString *address) {
//        [UserLocation shareLocation].city = address;
    } failed:^{
        ;
    }];
    
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"高德地图定位失败");
}

- (void)qano:(NSNotification *)notification
{
//    [self downloadDataWithCommand:@3 page:_nOrderPag count:10 orderState:1];
}

- (void)addHeaderView
{
    NSArray * strArr = [self.orderCount componentsSeparatedByString:@","];
    NSString * waitAcceptStr = nil;
    NSString * waitdeliceryStr = nil;
    NSString * deliveringStr = nil;
    NSString * deliveriedStr = nil;
    
    if (strArr.count > 3) {
        waitAcceptStr = [strArr objectAtIndex:0];
        waitdeliceryStr = [strArr objectAtIndex:1];
        deliveringStr = [strArr objectAtIndex:2];
        deliveriedStr = [strArr objectAtIndex:3];
        if (deliveriedStr.length>= 3) {
            deliveriedStr = @"99+";
        }
    }
    
    
    CGSize sized = [deliveriedStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"待接受",@"待配送",@"配送中", @"已配送"]];
    self.segment.tintColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.segment.frame = CGRectMake(-30, 2, SEGMENT_WIDTH, SEGMENT_HEIGHT);
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: MAIN_COLORE};
    [self.segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName: [UIColor grayColor]};
    [self.segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    self.segment.selectedSegmentIndex = 0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [_segment addTarget:self action:@selector(deliveryState:) forControlEvents:UIControlEventValueChanged];
    
    self.waitAcceptLB = [[UILabel alloc]initWithFrame:CGRectMake(24, 6, 14, 14)];
    self.waitAcceptLB.backgroundColor = MAIN_COLORE;
    self.waitAcceptLB.layer.cornerRadius = 7;
    self.waitAcceptLB.layer.masksToBounds = YES;
    self.waitAcceptLB.font = [UIFont systemFontOfSize:10];
    self.waitAcceptLB.textColor = [UIColor whiteColor];
    self.waitAcceptLB.text = waitAcceptStr;
    if ([waitAcceptStr isEqualToString:@"0"]) {
        self.waitAcceptLB.hidden = YES;
    }
    self.waitAcceptLB.textAlignment = NSTextAlignmentCenter;
    
    self.waiDeliveryLB = [[UILabel alloc]initWithFrame:CGRectMake(89, 6, 14, 14)];
    self.waiDeliveryLB.backgroundColor = MAIN_COLORE;
    self.waiDeliveryLB.layer.cornerRadius = 7;
    self.waiDeliveryLB.layer.masksToBounds = YES;
    self.waiDeliveryLB.font = [UIFont systemFontOfSize:10];
    self.waiDeliveryLB.textColor = [UIColor whiteColor];
    self.waiDeliveryLB.text = waitdeliceryStr;
    if ([waitdeliceryStr isEqualToString:@"0"]) {
        self.waiDeliveryLB.hidden = YES;
    }
    self.waiDeliveryLB.textAlignment = NSTextAlignmentCenter;
    
    self.deliveringLB = [[UILabel alloc]initWithFrame:CGRectMake(154, 6, 14, 14)];
    self.deliveringLB.backgroundColor = MAIN_COLORE;
    self.deliveringLB.layer.cornerRadius = 7;
    self.deliveringLB.layer.masksToBounds = YES;
    self.deliveringLB.font = [UIFont systemFontOfSize:10];
    self.deliveringLB.textColor = [UIColor whiteColor];
    self.deliveringLB.text = deliveringStr;
    if ([deliveringStr isEqualToString:@"0"]) {
        self.deliveringLB.hidden = YES;
    }
    self.deliveringLB.textAlignment = NSTextAlignmentCenter;
    
    self.deliveriedLB = [[UILabel alloc]initWithFrame:CGRectMake(219, 6, 14, 14)];
    self.deliveriedLB.backgroundColor = MAIN_COLORE;
    self.deliveriedLB.layer.cornerRadius = 7;
    self.deliveriedLB.layer.masksToBounds = YES;
    self.deliveriedLB.font = [UIFont systemFontOfSize:10];
    self.deliveriedLB.textColor = [UIColor whiteColor];
    self.deliveriedLB.text = deliveriedStr;
    if ([deliveriedStr isEqualToString:@"0"]) {
        self.deliveriedLB.hidden = YES;
    }
    self.deliveriedLB.textAlignment = NSTextAlignmentCenter;
    if (sized.width > 14) {
        self.deliveriedLB.width = sized.width;
    }
    
    if ([UIScreen mainScreen].bounds.size.width > 320) {
        self.segment.frame = CGRectMake(0, 2, SEGMENT_WIDTH, SEGMENT_HEIGHT);
        self.waitAcceptLB.frame = CGRectMake(54, 6, 14, 14);
        self.waiDeliveryLB.frame = CGRectMake(119, 6, 14, 14);
        self.deliveringLB.frame = CGRectMake(184, 6, 14, 14);
        self.deliveriedLB.frame = CGRectMake(249, 6, 14, 14);
    }
    
    UIView * hearderView = [[UIView alloc] initWithFrame:CGRectMake(SEGMENT_X, 0, SEGMENT_WIDTH, HEARDERVIEW_HEIGHT)];
    hearderView.backgroundColor = [UIColor clearColor];
    [hearderView addSubview:_segment];
    [hearderView addSubview:_waitAcceptLB];
    [hearderView addSubview:_waiDeliveryLB];
    [hearderView addSubview:_deliveringLB];
    [hearderView addSubview:_deliveriedLB];
    
    self.navigationItem.titleView = hearderView;
    
}

- (void)deliveryState:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        self.nOrderTableView.hidden = NO;
        self.waitOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = YES;
        self.deliveriedTableView.hidden = YES;
        [self.nOrderTableView.header endRefreshing];
        [self.nOrderTableView.header beginRefreshing];
    }
    else if (segment.selectedSegmentIndex == 1)
    {
        self.waitOrderTableView.hidden = NO;
        self.nOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = YES;
        self.deliveriedTableView.hidden = YES;
        [self.waitOrderTableView.header endRefreshing];
        [self.waitOrderTableView.header beginRefreshing];
    }else if (segment.selectedSegmentIndex == 2)
    {
        self.nOrderTableView.hidden = YES;
        self.waitOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = NO;
        self.deliveriedTableView.hidden = YES;
        [self.deliveryingTableView.header endRefreshing];
        [self.deliveryingTableView.header beginRefreshing];
    }else
    {
        self.nOrderTableView.hidden = YES;
        self.waitOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = YES;
        self.deliveriedTableView.hidden = NO;
        [self.deliveriedTableView.header endRefreshing];
        [self.deliveriedTableView.header beginRefreshing];
    }
}
#pragma mark - 下拉刷新，上拉加载
- (void)headerRereshing
{
    
    if (self.segment.selectedSegmentIndex == 0) {
        [self.nOrderTableView.header endRefreshing];
        _nOrderPag = 1;
        _orderState = 1;
        [self downloadDataWithCommand:@3 page:_nOrderPag count:10 orderState:1];
    }
    else if (self.segment.selectedSegmentIndex == 1)
    {
        [self.waitOrderTableView.header endRefreshing];
        _waitOrderPag = 1;
        _orderState = 2;
        [self downloadDataWithCommand:@3 page:_waitOrderPag count:10 orderState:2];
    }else if (self.segment.selectedSegmentIndex == 2)
    {
        [self.deliveryingTableView.header endRefreshing];
        _deliveryingPag = 1;
        _orderState = 3;
        [self downloadDataWithCommand:@3 page:_deliveryingPag count:10 orderState:3];
    }else
    {
        [self.deliveriedTableView.header endRefreshing];
        _deliveriedPag = 1;
        _orderState = 4;
        [self downloadDataWithCommand:@3 page:_deliveriedPag count:10 orderState:4];
    }
}

- (void)footerRereshing
{
    if (self.segment.selectedSegmentIndex == 0) {
        if (self.nOrderArray.count < _nOrderCount) {
            [self downloadDataWithCommand:@3 page:++_nOrderPag count:10 orderState:1];
        }else
        {
            [self.nOrderTableView.footer endRefreshingWithNoMoreData];

        }
    }
    else if (self.segment.selectedSegmentIndex == 1)
    {
        if (_waitOrderArray.count < _waitOrderCount ) {
            [self downloadDataWithCommand:@3 page:++_waitOrderPag count:10 orderState:2];
        }else
        {
            [self.waitOrderTableView.footer endRefreshingWithNoMoreData];
        }
    }else if (self.segment.selectedSegmentIndex == 2)
    {
        if (_deliveryingArray.count < _deliveryingCount ) {
            [self downloadDataWithCommand:@3 page:++_deliveryingPag count:10 orderState:3];
        }else
        {
            [self.deliveryingTableView.footer endRefreshingWithNoMoreData];
        }
    }else
    {
        if (_deliveriedArray.count < _deliveriedCount) {
            [self downloadDataWithCommand:@3 page:++_deliveriedPag count:10 orderState:4];
        }else
        {
            [self.deliveriedTableView.footer endRefreshingWithNoMoreData];

        }
    }
}

- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count orderState:(int)state
{
    NSDictionary * jsonDic = @{
                               @"Command":command,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"CurPage":[NSNumber numberWithInt:page],
                               @"CurCount":[NSNumber numberWithInt:count],
                               @"BusiId":[UserInfo shareUserInfo].BusiId,
                               @"Lat":[NSNumber numberWithDouble:[UserLocation shareLocation].coordinate2D.latitude],
                               @"Lon":[NSNumber numberWithDouble:[UserLocation shareLocation].coordinate2D.longitude],
                               @"OrderState":[NSNumber numberWithInt:state],
                               @"IsAgent":@([UserInfo shareUserInfo].isAgent)
                               };
    [self playPostWithDictionary:jsonDic];
}
#pragma mark - 数据请求
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@131139", jsonStr];
    NSLog(@"jsonStr = %@", str);
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    httpPost.commend = [dic objectForKey:@"Command"];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [SVProgressHUD dismiss];
    NSLog(@"data = %@", [data description]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10003]) {
            
            if (_orderState == 1) {
                if (_nOrderPag == 1) {
                    [self.nOrderArray removeAllObjects];
                }
                [self.nOrderTableView.header endRefreshing];
                [self.nOrderTableView.footer endRefreshing];
                self.nOrderCount = [[data objectForKey:@"AllCount"] intValue];
                NSArray * array = [data objectForKey:@"OrderList"];
                for (NSDictionary * dic in array) {
                    NewOrderModel * model = [[NewOrderModel alloc]initWithDictionary:dic];
                    model.orderState = @1;
                    [self.nOrderArray addObject:model];
                }
//                [self.segment setTitle:[NSString stringWithFormat:@"待接受%@", [data objectForKey:@"AllCount"]] forSegmentAtIndex:0];
                if ([[data objectForKey:@"AllCount"] intValue] == 0) {
                    self.waitAcceptLB.hidden = YES;
                }else
                {
                    self.waitAcceptLB.hidden = NO;
                }
                
                self.waitAcceptLB.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"AllCount"]];
                [self.nOrderTableView reloadData];
            }else if (_orderState == 2)
            {
              
                if (_waitOrderPag == 1) {
                    [self.waitOrderArray removeAllObjects];
                    [self.waitOrderTableView.header endRefreshing];
                }else
                {
                    [self.waitOrderTableView.footer endRefreshing];
                }
                self.waitOrderCount = [[data objectForKey:@"AllCount"] intValue];
                NSArray * array1 = [data objectForKey:@"OrderList"];
                for (NSDictionary * dic in array1) {
                    NewOrderModel * model = [[NewOrderModel alloc]initWithDictionary:dic];
                    model.orderState = @2;
                    [self.waitOrderArray addObject:model];
                }
//                [self.segment setTitle:[NSString stringWithFormat:@"待配送%@", [data objectForKey:@"AllCount"]] forSegmentAtIndex:1];
                if ([[data objectForKey:@"AllCount"] intValue] == 0) {
                    self.waiDeliveryLB.hidden = YES;
                }else
                {
                    self.waiDeliveryLB.hidden = NO;
                }
                self.waiDeliveryLB.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"AllCount"]];
                [self.waitOrderTableView reloadData];
                
            }
            else if (_orderState == 3)
            {
                if (_deliveryingPag == 1) {
                    [self.deliveryingArray removeAllObjects];
                    [self.deliveryingTableView.header endRefreshing];
                }else
                {
                    [self.deliveryingTableView.footer endRefreshing];
                }
                self.deliveryingCount = [[data objectForKey:@"AllCount"] intValue];
                NSArray * array = [data objectForKey:@"OrderList"];
                for (NSDictionary * dic in array) {
                    NewOrderModel * model = [[NewOrderModel alloc]initWithDictionary:dic];
                    model.orderState = @3;
                    [self.deliveryingArray addObject:model];
                }
//                [self.segment setTitle:[NSString stringWithFormat:@"配送中%@", [data objectForKey:@"AllCount"]] forSegmentAtIndex:2];
                if ([[data objectForKey:@"AllCount"] intValue] == 0) {
                    self.deliveringLB.hidden = YES;
                }else
                {
                    self.deliveringLB.hidden = NO;
                }
                self.deliveringLB.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"AllCount"]];
                [self.deliveryingTableView reloadData];
                
                
            }else
            {
                if (_deliveriedPag == 1) {
                    [self.deliveriedArray removeAllObjects];
                }
                [self.deliveriedTableView.header endRefreshing];
                [self.deliveriedTableView.footer endRefreshing];
                self.deliveriedCount = [[data objectForKey:@"AllCount"] intValue];
                NSArray * array = [data objectForKey:@"OrderList"];
                for (NSDictionary * dic in array) {
                    NewOrderModel * model = [[NewOrderModel alloc]initWithDictionary:dic];
                    model.orderState = @4;
                    [self.deliveriedArray addObject:model];
                }
//                [self.segment setTitle:[NSString stringWithFormat:@"已配送%@", [data objectForKey:@"AllCount"]] forSegmentAtIndex:3];
                if ([[data objectForKey:@"AllCount"] intValue] == 0) {
                    self.deliveriedLB.hidden = YES;
                }else
                {
                    self.deliveriedLB.hidden = NO;
                }
                self.deliveriedLB.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"AllCount"]];
                [self.deliveriedTableView reloadData];
            }
            
        }else if ([command isEqualToNumber:@10013])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"接受订单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
                _orderState = 1;
                [self downloadDataWithCommand:@3 page:1 count:10 orderState:1];
            
        }else if ([command isEqualToNumber:@10007])
        {
            if (self.segment.selectedSegmentIndex == 1) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始配送成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
                
                [self downloadDataWithCommand:@3 page:1 count:10 orderState:2];
            }else if (self.segment.selectedSegmentIndex == 2){
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认送达成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
                
                [self downloadDataWithCommand:@3 page:1 count:10 orderState:3];
            }
            
        }else if ([command isEqualToNumber:@10011])
        {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"放弃订单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
                
                [self downloadDataWithCommand:@3 page:1 count:10 orderState:2];
            
        }else if ([command isEqualToNumber:@10014])
        {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拒绝接单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
                
                [self downloadDataWithCommand:@3 page:1 count:10 orderState:1];
            
        }else if ([command isEqualToNumber:@10012])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取餐成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            
            [self downloadDataWithCommand:@3 page:1 count:10 orderState:2];
            
        }
    }else
    {
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        [self presentViewController:nameController animated:YES completion:nil];
    }
}
- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    //    AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
    //    [self.tableView headerEndRefreshing];
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
    NSLog(@"%@", error);
}

- (void)setupAction:(UIBarButtonItem *)sender
{
    /*
     抽屉效果
     AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
     
     [appDelegate.centerVC presentUserView];
     */
    UserCenterViewController * userVC = [[UserCenterViewController alloc]init];
    [self.navigationController pushViewController:userVC animated:YES];
    
    
//    [self playSound];
    
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_nOrderTableView]) {
        return self.nOrderArray.count ;
    }
    else if ([tableView isEqual:_waitOrderTableView])
    {
        return self.waitOrderArray.count;
    }else if ([tableView isEqual:_deliveryingTableView])
    {
        return self.deliveryingArray.count;
    }else
    {
        return self.deliveriedArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_nOrderTableView]) {
        
        NewOrderModel * model = [self.nOrderArray objectAtIndex:indexPath.row];
        NewOrderCell * newOrderCell = [tableView dequeueReusableCellWithIdentifier:NORDERCELL_IDENTIFIER forIndexPath:indexPath];
        [newOrderCell createSubView:tableView.bounds mealCoutn:(int)model.mealArray.count];
        newOrderCell.orderModel = model;
        
        [newOrderCell.shopView.addressBT addTarget:self action:@selector(mapAction:event:) forControlEvents:UIControlEventTouchUpInside];
        newOrderCell.shopView.addressBT.tag = ADDRESS_SHOP_TAG;
        
        [newOrderCell.customerView.addressBT addTarget:self action:@selector(mapAction:event:) forControlEvents:UIControlEventTouchUpInside];
        newOrderCell.customerView.addressBT.tag = ADDRESS_CUSTOM_TAG;
        
        [newOrderCell.totlePriceView.detailsButton addTarget:self action:@selector(orderDetais:event:) forControlEvents:UIControlEventTouchUpInside];
        [newOrderCell.totlePriceView.startDeliveryBT addTarget:self action:@selector(robAction:event:) forControlEvents:UIControlEventTouchUpInside];
        
        __weak OrderViewController * orderVC = self;
        [newOrderCell.totlePriceView nulityOrderAction:^{
            NSLog(@"拒绝接单");
            NSLog(@"%@", model.orderId);
            NSDictionary * jsonDic = @{
                                       @"Command":@14,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"OrderId":model.orderId
                                       };
            [orderVC playPostWithDictionary:jsonDic];
        }];
        return newOrderCell;
    }
    else if ([tableView isEqual:_waitOrderTableView])
    {
        NewOrderModel * model = [self.waitOrderArray objectAtIndex:indexPath.row];
        DeliveryingCell * deliveryingCell = [tableView dequeueReusableCellWithIdentifier:DELIVERYING_IDENTIFIER forIndexPath:indexPath];
        [deliveryingCell createSubView:tableView.bounds mealCoutn:model];
        deliveryingCell.orderModel = model;
        
        [deliveryingCell.shopView.addressBT addTarget:self action:@selector(mapAction:event:) forControlEvents:UIControlEventTouchUpInside];
        deliveryingCell.shopView.addressBT.tag = ADDRESS_SHOP_TAG;
        
        [deliveryingCell.customerView.addressBT addTarget:self action:@selector(mapAction:event:) forControlEvents:UIControlEventTouchUpInside];
        deliveryingCell.customerView.addressBT.tag = ADDRESS_CUSTOM_TAG;
        
        [deliveryingCell.totlePriceView.detailsButton addTarget:self action:@selector(orderDetais:event:) forControlEvents:UIControlEventTouchUpInside];
        [deliveryingCell.totlePriceView.startDeliveryBT addTarget:self action:@selector(deliveryAction:event:) forControlEvents:UIControlEventTouchUpInside];
        __weak OrderViewController * orderVC = self;
        [deliveryingCell.totlePriceView nulityOrderAction:^{
            NSLog(@"放弃订单");
            
            [self tanchuGiveupViewWithOrderId:model.orderId];
            
        }];
        
        return deliveryingCell;
    }else if ([tableView isEqual:_deliveryingTableView])
    {
        NewOrderModel * model = [self.deliveryingArray objectAtIndex:indexPath.row];
        DeliveryingCell * deliveryingCell = [tableView dequeueReusableCellWithIdentifier:DELIVERYING_IDENTIFIER forIndexPath:indexPath];
        [deliveryingCell createSubView:tableView.bounds mealCoutn:model];
        deliveryingCell.orderModel = model;
        
        [deliveryingCell.shopView.addressBT addTarget:self action:@selector(mapAction:event:) forControlEvents:UIControlEventTouchUpInside];
        deliveryingCell.shopView.addressBT.tag = ADDRESS_SHOP_TAG;
        
        [deliveryingCell.customerView.addressBT addTarget:self action:@selector(mapAction:event:) forControlEvents:UIControlEventTouchUpInside];
        deliveryingCell.customerView.addressBT.tag = ADDRESS_CUSTOM_TAG;
        
        [deliveryingCell.totlePriceView.detailsButton addTarget:self action:@selector(orderDetais:event:) forControlEvents:UIControlEventTouchUpInside];
        [deliveryingCell.totlePriceView.startDeliveryBT addTarget:self action:@selector(deliveryAction:event:) forControlEvents:UIControlEventTouchUpInside];
        deliveryingCell.totlePriceView.nullityButton.hidden = YES;
        return deliveryingCell;
    }else
    {
        NewOrderModel * model = [self.deliveriedArray objectAtIndex:indexPath.row];
        DeliveriedCell * deliveriedCell = [tableView dequeueReusableCellWithIdentifier:DELIVERIED_IDENTIFIER forIndexPath:indexPath];
        [deliveriedCell createSubView:tableView.bounds mealCoutn:model];
        deliveriedCell.orderModel = model;
//        [deliveriedCell.shopView.addressBT addTarget:self action:@selector(mapAction:event:) forControlEvents:UIControlEventTouchUpInside];
//        deliveriedCell.shopView.addressBT.tag = ADDRESS_SHOP_TAG;
//        
//        [deliveriedCell.customerView.addressBT addTarget:self action:@selector(mapAction:event:) forControlEvents:UIControlEventTouchUpInside];
//        deliveriedCell.customerView.addressBT.tag = ADDRESS_CUSTOM_TAG;
//        
//        [deliveriedCell.totlePriceView.detailsButton addTarget:self action:@selector(orderDetais:event:) forControlEvents:UIControlEventTouchUpInside];
        __weak OrderViewController * orderVC = self;
        [deliveriedCell orderDetailsBlock:^{
            
            OrderDetailController * pVC = [[OrderDetailController alloc]init];
            
//            OrderDetailController * pVC = [[UIStoryboard storyboardWithName:@"OrderDetailController" bundle:nil] instantiateInitialViewController];
            pVC.orderID = model.orderId;
            pVC.deliveried = 1;
            orderVC.toDetailsView = 1;
            pVC.title = @"餐单详情";
            [UserLocation shareLocation].searchCoordinate = (CLLocationCoordinate2D){0.0, 0.0};
            [UserLocation shareLocation].shopSearchCoordinate = (CLLocationCoordinate2D){0.0, 0.0};
            [orderVC.navigationController pushViewController:pVC animated:YES];
        }];
        
        return deliveriedCell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_nOrderTableView]) {
        NewOrderModel * model = [self.nOrderArray objectAtIndex:indexPath.row];
        return [NewOrderCell cellHeightWithMealCount:(int)model.mealArray.count];
    }
    else if ([tableView isEqual:_waitOrderTableView])
    {
        NewOrderModel * model = [self.waitOrderArray objectAtIndex:indexPath.row];
        return [DeliveryingCell cellHeightWithMealCount:(NewOrderModel *)model];
    }else if ([tableView isEqual:_deliveryingTableView])
    {
        NewOrderModel * model = [self.deliveryingArray objectAtIndex:indexPath.row];
        return [DeliveryingCell cellHeightWithMealCount:(NewOrderModel *)model];
    }else
    {
        NewOrderModel * model = [self.deliveriedArray objectAtIndex:indexPath.row];
        return [DeliveriedCell cellHeightWithMealCount:(NewOrderModel *)model];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     // 抽屉效果
     AppDelegate * delegate = [UIApplication sharedApplication].delegate;
     [delegate.centerVC moveOrderViewToOriginalPosition];
     
     OrderDetailController * pVC = [[OrderDetailController alloc]init];
     [self.navigationController pushViewController:pVC animated:YES];
     */
}

#pragma mark - 查看地址
- (void)mapAction:(UIButton *)button event:(UIEvent *)event
{
    Mapcontroller * mapVC = [[Mapcontroller alloc]init];
    
    NSSet * touches = [event allTouches];
    UITouch * touch = [touches anyObject];
    if (self.segment.selectedSegmentIndex == 0) {
        CGPoint currentPoint = [touch locationInView:self.nOrderTableView];
        NSIndexPath * indexpath = [self.nOrderTableView indexPathForRowAtPoint:currentPoint];
        if (indexpath) {
            NewOrderModel * model = [self.nOrderArray objectAtIndex:indexpath.row];
            if (button.tag == ADDRESS_CUSTOM_TAG) {
                mapVC.address = model.customerAddress;
                mapVC.name = model.customerName;
                mapVC.phone = model.customerPhone;
            }else
            {
                mapVC.address = model.busiAddress;
                mapVC.name = model.busiName;
                mapVC.phone = model.busiPhone;
            }
//            NSLog(@"segment = %d, address = %@", self.segment.selectedSegmentIndex, mapVC.address);
        }
        
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        CGPoint currentPoint = [touch locationInView:self.deliveryingTableView];
        NSIndexPath * indexpath = [self.deliveryingTableView indexPathForRowAtPoint:currentPoint];
        if (indexpath) {
            NewOrderModel * model = [self.deliveryingArray objectAtIndex:indexpath.row];
            if (button.tag == ADDRESS_CUSTOM_TAG) {
                mapVC.address = model.customerAddress;
                mapVC.name = model.customerName;
                mapVC.phone = model.customerPhone;
            }else
            {
                mapVC.address = model.busiAddress;
                mapVC.name = model.busiName;
                mapVC.phone = model.busiPhone;
            }

//             NSLog(@"segment = %d, address = %@", self.segment.selectedSegmentIndex, mapVC.address);
        }
    }else
    {
        CGPoint currentPoint = [touch locationInView:self.deliveriedTableView];
        NSIndexPath * indexpath = [self.deliveriedTableView indexPathForRowAtPoint:currentPoint];
        if (indexpath) {
            NewOrderModel * model = [self.deliveriedArray objectAtIndex:indexpath.row];
            if (button.tag == ADDRESS_CUSTOM_TAG) {
                mapVC.address = model.customerAddress;
                mapVC.name = model.customerName;
                mapVC.phone = model.customerPhone;
            }else
            {
                mapVC.address = model.busiAddress;
                mapVC.name = model.busiName;
                mapVC.phone = model.busiPhone;
            }

//             NSLog(@"segment = %d, address = %@", self.segment.selectedSegmentIndex, mapVC.address);
        }
    }
    
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - 查看详情
- (void)orderDetais:(UIButton *)button event:(UIEvent *)event
{
     OrderDetailController * pVC = [[OrderDetailController alloc]init];
//    ViewController * VC = [[ViewController alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
    __weak OrderViewController * orderVC = self;
    
    if (self.segment.selectedSegmentIndex == 0) {
        NSSet * touches = [event allTouches];
        UITouch * touch = [touches anyObject];
        CGPoint currentTouchPoint = [touch locationInView:self.nOrderTableView];
        NSIndexPath * indepath = [self.nOrderTableView indexPathForRowAtPoint:currentTouchPoint];
        if (indepath != nil) {
            NewOrderModel * model = [self.nOrderArray objectAtIndex:indepath.row];
            pVC.orderID = model.orderId;
        }
        [pVC refreshData:^{
            [orderVC.nOrderTableView.header beginRefreshing];
        }];
    }else if(self.segment.selectedSegmentIndex == 1)
    {
        NSSet * touches = [event allTouches];
        UITouch * touch = [touches anyObject];
        CGPoint currrenPoint = [touch locationInView:self.waitOrderTableView];
        NSIndexPath * indexpath = [self.waitOrderTableView indexPathForRowAtPoint:currrenPoint];
        if (indexpath != nil) {
            NewOrderModel * model = [self.waitOrderArray objectAtIndex:indexpath.row];
            pVC.orderID = model.orderId;
        }
        [pVC refreshData:^{
            [orderVC.waitOrderTableView.header beginRefreshing];
        }];
    }
    else if(self.segment.selectedSegmentIndex == 2)
    {
        NSSet * touches = [event allTouches];
        UITouch * touch = [touches anyObject];
        CGPoint currrenPoint = [touch locationInView:self.deliveryingTableView];
        NSIndexPath * indexpath = [self.deliveryingTableView indexPathForRowAtPoint:currrenPoint];
        if (indexpath != nil) {
            NewOrderModel * model = [self.deliveryingArray objectAtIndex:indexpath.row];
            pVC.orderID = model.orderId;
        }
        [pVC refreshData:^{
            [orderVC.deliveryingTableView.header beginRefreshing];
        }];
    }else
    {
        NSSet * touches = [event allTouches];
        UITouch * touch = [touches anyObject];
        CGPoint currrenPoint = [touch locationInView:self.deliveriedTableView];
        NSIndexPath * indexpath = [self.deliveriedTableView indexPathForRowAtPoint:currrenPoint];
        if (indexpath != nil) {
            NewOrderModel * model = [self.deliveriedArray objectAtIndex:indexpath.row];
            pVC.orderID = model.orderId;
        }
        
    }
    self.toDetailsView = 1;
    pVC.title = @"餐单详情";
    
//    ViewController * vc = [[ViewController alloc]init];
    
    [UserLocation shareLocation].searchCoordinate = (CLLocationCoordinate2D){0.0, 0.0};
    [UserLocation shareLocation].shopSearchCoordinate = (CLLocationCoordinate2D){0.0, 0.0};
    
    [self.navigationController pushViewController:pVC animated:YES];
    
}
#pragma mark - 抢单
- (void)robAction:(UIButton *)button event:(UIEvent *)event
{
    
    if ([UserInfo shareUserInfo].isOpenthebackgroundposition) {
        NSSet * touches = [event allTouches];
        UITouch * touch = [touches anyObject];
        CGPoint currentTouchPoint = [touch locationInView:self.nOrderTableView];
        NSIndexPath * indepath = [self.nOrderTableView indexPathForRowAtPoint:currentTouchPoint];
        if (indepath != nil) {
            NewOrderModel * model = [self.nOrderArray objectAtIndex:indepath.row];
            
            NSDictionary * jsonDic = @{
                                       @"Command":@13,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"OrderId":model.orderId
                                       };
            [self playPostWithDictionary:jsonDic];
            
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在设置界面开启实时定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }

}
#pragma mark - 配送
- (void)deliveryAction:(UIButton *)button event:(UIEvent *)event
{
    
    if ([UserInfo shareUserInfo].isOpenthebackgroundposition) {
        if (self.segment.selectedSegmentIndex == 1) {
            
            
            
            NSSet * touches = [event allTouches];
            UITouch * touch = [touches anyObject];
            CGPoint currentTouchPoint = [touch locationInView:self.waitOrderTableView];
            NSIndexPath * indepath = [self.waitOrderTableView indexPathForRowAtPoint:currentTouchPoint];
            if (indepath != nil) {
                NewOrderModel * model = [self.waitOrderArray objectAtIndex:indepath.row];
                
                if ([button.titleLabel.text isEqualToString:@"到达商家处"]) {
                    NSDictionary * jsonDic = @{
                                               @"Command":@12,
                                               @"UserId":[UserInfo shareUserInfo].userId,
                                               @"OrderId":model.orderId,
                                               };
                    [self playPostWithDictionary:jsonDic];
                }else
                {
                    
                    NSDictionary * jsonDic = @{
                                               @"Command":@7,
                                               @"UserId":[UserInfo shareUserInfo].userId,
                                               @"OrderId":model.orderId,
                                               @"SendStateType":@1
                                               };
                    [self playPostWithDictionary:jsonDic];
                }
                
                
            }
        }else if (self.segment.selectedSegmentIndex == 2)
        {
            NSSet * touches = [event allTouches];
            UITouch * touch = [touches anyObject];
            CGPoint currentTouchPoint = [touch locationInView:self.deliveryingTableView];
            NSIndexPath * indepath = [self.deliveryingTableView indexPathForRowAtPoint:currentTouchPoint];
            if (indepath != nil) {
                NewOrderModel * model = [self.deliveryingArray objectAtIndex:indepath.row];
                NSDictionary * jsonDic = @{
                                           @"Command":@7,
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"OrderId":model.orderId,
                                           @"SendStateType":@2
                                           };
                [self playPostWithDictionary:jsonDic];
                
            }
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在设置界面开启实时定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 2000;
        [alert show];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    /*
     // 抽屉效果
     AppDelegate * delegate = [UIApplication sharedApplication].delegate;
     
     
     if (delegate.centerVC.panGesture == nil) {
     [delegate.centerVC setupGesture];
     }
     */
    NSLog(@"***");
    //    [UIView animateWithDuration:2 animations:^{
    //
    //    } completion:^(BOOL finished) {
    //
    //
    //        if (self.segment.selectedSegmentIndex == 0) {
    //            [self.nOrderTableView.header beginRefreshing];
    //        }else if (self.segment.selectedSegmentIndex == 1)
    //        {
    //            [self.deliveryingTableView.header beginRefreshing];
    //
    //        }else
    //        {
    //            [self.deliveriedTableView.header beginRefreshing];
    //
    //        }
    //
    //    }];
    if (self.toDetailsView == 1) {
        self.toDetailsView = 0;
    }else
    {
        [self performSelector:@selector(pullrefresh) withObject:nil afterDelay:.35];
    }
    if (self.isfromLoginVC == 1) {
        NSArray * array = [self.positionDb getPositionModels];
        for (PositionModel * model in array) {
            
            if (model.userId == [UserInfo shareUserInfo].userId.intValue) {
                if (model.positionType == 2) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未开启实时定位功能，是否开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                    self.mapview.showsUserLocation = YES;
                }else
                {
                    [UserInfo shareUserInfo].isOpenthebackgroundposition = YES;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:LoginAndStartUDP object:nil userInfo:nil];
                }
            }
        }
    }
//    if (![UserInfo shareUserInfo].isOpenthebackgroundposition) {
//        if (self.isfromLoginVC == 1) {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未开启实时定位功能，是否开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
//            self.mapview.showsUserLocation = YES;
//        }
//        
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000 || alertView.tag == 2000) {
        if (buttonIndex == 0) {
            ;
        }else
        {
            UserCenterViewController * userVC = [[UserCenterViewController alloc]init];
            [self.navigationController pushViewController:userVC animated:YES];
        }
    }else
    {
        if (buttonIndex == 0) {
            ;
        }else
        {
//            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
//            if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                alert.tag = 4000;
//                [alert show];
//                [UserInfo shareUserInfo].isOpenthebackgroundposition = NO;
//            }else
//            {
//                [UserInfo shareUserInfo].isOpenthebackgroundposition = YES;
//            }
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:LoginAndStartUDP object:nil userInfo:nil];
            
            
            UserCenterViewController * userVC = [[UserCenterViewController alloc]init];
            [self.navigationController pushViewController:userVC animated:YES];
        }
    }
    
}

- (void)pullrefresh
{
    NSLog(@"0.35以后*****");
    if (self.segment.selectedSegmentIndex == 0) {
        [self.nOrderTableView.header beginRefreshing];
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        [self.deliveryingTableView.header beginRefreshing];
        
    }else
    {
        [self.deliveriedTableView.header beginRefreshing];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    /*
     // 抽屉效果
     AppDelegate * delegate = [UIApplication sharedApplication].delegate;
     
     if (delegate.centerVC.panGesture) {
     [delegate.centerVC.view removeGestureRecognizer:delegate.centerVC.panGesture];
     
     delegate.centerVC.panGesture = nil;
     
     }
    */
    
    self.isfromLoginVC = 0;
}

// 放弃订单原因弹出框
- (void)tanchuGiveupViewWithOrderId:(NSString *)string
{
    if (self.giupReasonView) {
        [self.giupReasonView show];
    }else
    {
        NSBundle *bundle=[NSBundle mainBundle];
        NSArray *objs=[bundle loadNibNamed:@"GiveupReasonView" owner:nil options:nil];
        self.giupReasonView = [objs objectAtIndex:0];
        self.giupReasonView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        __block OrderViewController * orderVC = self;
        [self.giupReasonView giveuporder:^(NSString *reasonStr) {
            ;
            NSDictionary * jsonDic = @{
                                       @"Command":@11,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Reason":reasonStr,
                                       @"OrderId":string
                                       };
            [orderVC playPostWithDictionary:jsonDic];
            NSLog(@"***%@", reasonStr);
        }];
        [self.giupReasonView show];
    }
    
}

- (void)refreshOrderCountWith:(NSString *)string
{
    NSArray * strArr = [string componentsSeparatedByString:@","];
    
    NSString * waitAcceptStr = [strArr objectAtIndex:0];
    NSString * waitdeliceryStr = [strArr objectAtIndex:1];
    NSString * deliveringStr = [strArr objectAtIndex:2];
    NSString * deliveriedStr = [strArr objectAtIndex:3];
    
    if (deliveriedStr.length>= 3) {
        deliveriedStr = @"99+";
    }
    CGSize sized = [deliveriedStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    self.waitAcceptLB.text = waitAcceptStr;
    self.waiDeliveryLB.text = waitdeliceryStr;
    self.deliveringLB.text = deliveringStr;
    self.deliveriedLB.text = deliveriedStr;
    if (sized.width > 18) {
        self.deliveriedLB.width = sized.width;
    }
    
    if ([waitAcceptStr isEqualToString:@"0"]) {
        self.waitAcceptLB.hidden = YES;
    }else
    {
        self.waitAcceptLB.hidden = NO;
    }
    
    if ([waitdeliceryStr isEqualToString:@"0"]) {
        self.waiDeliveryLB.hidden = YES;
    }else
    {
        self.waiDeliveryLB.hidden = NO;
    }
    
    if ([deliveringStr isEqualToString:@"0"]) {
        self.deliveringLB.hidden = YES;
    }else
    {
        self.deliveringLB.hidden = NO;
    }
    
    if ([deliveriedStr isEqualToString:@"0"]) {
        self.deliveriedLB.hidden = YES;
    }else
    {
        self.deliveriedLB.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
