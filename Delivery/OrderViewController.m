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
#define SEGMENT_WIDTH 240
#define SEGMENT_X self.view.width / 2 - SEGMENT_WIDTH / 2
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

// 新订单
@property (nonatomic, strong)UITableView * nOrderTableView;
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
    
//    NSLog(@"userLocation = %@, %@, %f, %f", userLocation.title, userLocation.subtitle, userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"高德地图定位失败");
}

#pragma mark - 腾讯地图定位


//- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
//{
//    //    NSLog(@"刷新位置");
//    
//    
//    self.Coordinate = userLocation.coordinate;
//    [[NSNotificationCenter defaultCenter]postNotificationName:QAnnotationViewDragStateCHange object:nil];
////    NSLog(@"lat = %f  ****  lon = %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//}
//- (void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error
//{
//    NSLog(@"定位失败");
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，定位失败" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:cancelAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//    self.Coordinate = (CLLocationCoordinate2D){0.0, 0.0};
//    
//    [[NSNotificationCenter defaultCenter]postNotificationName:QAnnotationViewDragStateCHange object:nil];
//}

- (void)qano:(NSNotification *)notification
{
//    [self downloadDataWithCommand:@3 page:_nOrderPag count:10 orderState:1];
}

- (void)addHeaderView
{
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"新订单",@"待配送",@"配送中", @"已配送"]];
    self.segment.tintColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.segment.frame = CGRectMake(SEGMENT_X, 2, SEGMENT_WIDTH, SEGMENT_HEIGHT);
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: MAIN_COLORE};
    [self.segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName: [UIColor grayColor]};
    [self.segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    self.segment.selectedSegmentIndex = 0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [_segment addTarget:self action:@selector(deliveryState:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segment;
    
}

- (void)deliveryState:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        self.nOrderTableView.hidden = NO;
        self.waitOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = YES;
        self.deliveriedTableView.hidden = YES;
        [self.nOrderTableView.header beginRefreshing];
    }
    else if (segment.selectedSegmentIndex == 1)
    {
        self.waitOrderTableView.hidden = NO;
        self.nOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = YES;
        self.deliveriedTableView.hidden = YES;
        [self.waitOrderTableView.header beginRefreshing];
    }else if (segment.selectedSegmentIndex == 2)
    {
        self.nOrderTableView.hidden = YES;
        self.waitOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = NO;
        self.deliveriedTableView.hidden = YES;
        [self.deliveryingTableView.header beginRefreshing];
    }else
    {
        self.nOrderTableView.hidden = YES;
        self.waitOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = YES;
        self.deliveriedTableView.hidden = NO;
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
                [self.deliveriedTableView reloadData];
            }
            
        }else if ([command isEqualToNumber:@10006])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抢单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
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
            if (self.segment.selectedSegmentIndex == 1) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拒绝接单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
                
                [self downloadDataWithCommand:@3 page:1 count:10 orderState:2];
            }else if (self.segment.selectedSegmentIndex == 0){
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拒绝接单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
                
                [self downloadDataWithCommand:@3 page:1 count:10 orderState:1];
            }
            
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
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
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

static SystemSoundID shake_sound_male_id = 0;

-(void) playSound

{
    NSString *path = nil;
    
    path = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"mp3"];
    
    if (path ) {
        NSLog(@"path = %@", path);
        NSURL * cafUrl = [[NSURL alloc]initFileURLWithPath:path];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:cafUrl error:nil];
        _player.delegate = self;
        _player.numberOfLoops = 1;
        _player.volume = 5.0;
        
        
        [_player prepareToPlay];
        [_player play];
    }
    
    
//    if (path) {
//        //注册声音到系统
//        NSURL *url = [NSURL fileURLWithPath:path];
//        CFURLRef inFileURL = (__bridge CFURLRef)url;
//        OSStatus err =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&shake_sound_male_id);
//        if (err != kAudioServicesNoError) {
//            NSLog(@"Cound not load %@, error code %@", url, err);
//        }
//        
//        NSLog(@"id = %u", shake_sound_male_id);
//        
//        AudioServicesPlaySystemSound(shake_sound_male_id);
//        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
//        NSLog(@"走了******");
//    }
//    
//    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
//    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_player) {
        _player.delegate = nil;
        _player = nil;
    }
    NSLog(@"播放完了");
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if (_player) {
        _player.delegate = nil;
        _player = nil;
    }
    NSLog(@"播放失败error = %@", error);
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
            NSLog(@"取消订单");
            NSDictionary * jsonDic = @{
                                       @"Command":@11,
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
            NSLog(@"取消订单");
            NSDictionary * jsonDic = @{
                                       @"Command":@11,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"OrderId":model.orderId
                                       };
            [orderVC playPostWithDictionary:jsonDic];
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
            OrderDetailController * pVC = [[UIStoryboard storyboardWithName:@"OrderDetailController" bundle:nil] instantiateInitialViewController];
            pVC.orderID = model.orderId;
            pVC.deliveried = 1;
            orderVC.toDetailsView = 1;
            pVC.title = @"餐单详情";
            
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
     OrderDetailController * pVC = [[UIStoryboard storyboardWithName:@"OrderDetailController" bundle:nil] instantiateInitialViewController];
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
                                       @"Command":@6,
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
                NSDictionary * jsonDic = @{
                                           @"Command":@7,
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"OrderId":model.orderId,
                                           @"SendStateType":@1
                                           };
                [self playPostWithDictionary:jsonDic];
                
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
    
    
    if (![UserInfo shareUserInfo].isOpenthebackgroundposition) {
        if (self.isfromLoginVC == 1) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未开启实时定位功能，是否开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }
    
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
