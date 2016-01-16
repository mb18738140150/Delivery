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

#import "PersonalDataViewController.h"

#import "NewOrderCell.h"
#import "DeliveryingCell.h"
#import "DeliveriedCell.h"
#import "NewOrderModel.h"

#define NORDERCELL_IDENTIFIER @"cell"
#define DELIVERYING_IDENTIFIER @"deliveryingcell"
#define DELIVERIED_IDENTIFIER @"deliveriedcell"

#define SEGMENT_HEIGHT 40
#define SEGMENT_WIDTH 240
#define SEGMENT_X self.view.width / 2 - SEGMENT_WIDTH / 2
#define TOP_SPACE 10
#define HEARDERVIEW_HEIGHT 4 + SEGMENT_HEIGHT

@interface OrderViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPPostDelegate>

// 订单状态
@property (nonatomic, assign)int orderState;

// 新订单
@property (nonatomic, strong)UITableView * nOrderTableView;
@property (nonatomic, strong)NSMutableArray * nOrderArray;
@property (nonatomic, assign)int nOrderCount;
@property (nonatomic, assign)int nOrderPag;

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

@end

@implementation OrderViewController

- (NSMutableArray *)nOrderArray
{
    if (!_nOrderArray) {
        self.nOrderArray = [NSMutableArray array];
    }
    return _nOrderArray;
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251 / 255.0 green:84 / 255.0 blue:8 / 255.0 alpha:1];
    
    
    // 新订单
    self.nOrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    _nOrderTableView.dataSource = self;
    _nOrderTableView.delegate = self;
    self.nOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _nOrderTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_nOrderTableView];
    _nOrderPag = 1;
    _orderState = 1;
//    [self.nOrderTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.nOrderTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [_nOrderTableView registerClass:[NewOrderCell class] forCellReuseIdentifier:NORDERCELL_IDENTIFIER];
    [self downloadDataWithCommand:@3 page:_nOrderPag count:10 orderState:1];
//    [self.nOrderTableView headerBeginRefreshing];
    
    // 代配送订单
    self.deliveryingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    _deliveryingTableView.delegate = self;
    _deliveryingTableView.dataSource = self;
    self.deliveryingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _deliveryingTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_deliveryingTableView];
    _deliveryingPag = 1;
    [_deliveryingTableView registerClass:[DeliveryingCell class] forCellReuseIdentifier:DELIVERYING_IDENTIFIER];
    self.deliveryingTableView.hidden = YES;
    
    // 已配送订单
    self.deliveriedTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    _deliveriedTableView.delegate = self;
    _deliveriedTableView.dataSource = self;
    self.deliveriedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _deliveriedTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_deliveriedTableView];
    _deliveriedPag = 1;
    [_deliveriedTableView registerClass:[DeliveriedCell class] forCellReuseIdentifier:DELIVERIED_IDENTIFIER];
    self.deliveriedTableView.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"setting_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(setupAction:)];
    
}

- (void)addHeaderView
{
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"新订单", @"待配送", @"已配送"]];
    self.segment.tintColor = [UIColor whiteColor];
    self.segment.frame = CGRectMake(SEGMENT_X, 2, SEGMENT_WIDTH, SEGMENT_HEIGHT);
    self.segment.selectedSegmentIndex = 0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [_segment addTarget:self action:@selector(deliveryState:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segment;
    
}


- (void)deliveryState:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        self.nOrderTableView.hidden = NO;
        self.deliveryingTableView.hidden = YES;
        self.deliveriedTableView.hidden = YES;
        _orderState = 1;
        [self downloadDataWithCommand:@3 page:_nOrderPag count:10 orderState:1];
    }else if (segment.selectedSegmentIndex == 1)
    {
        self.nOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = NO;
        self.deliveriedTableView.hidden = YES;
        _orderState = 2;
        [self downloadDataWithCommand:@3 page:_nOrderPag count:10 orderState:2];
    }else
    {
        self.nOrderTableView.hidden = YES;
        self.deliveryingTableView.hidden = YES;
        self.deliveriedTableView.hidden = NO;
        _orderState = 3;
        [self downloadDataWithCommand:@3 page:_nOrderPag count:10 orderState:3];
    }
}
#pragma mark - 下拉刷新，上拉加载
- (void)headerRereshing
{
    [self tableViewEndRereshing];
    if (self.segment.selectedSegmentIndex == 0) {
        _orderState = 1;
        _nOrderPag = 1;
        [self downloadDataWithCommand:@3 page:_nOrderPag count:10 orderState:1];
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        _deliveryingPag = 1;
        _orderState = 2;
        [self downloadDataWithCommand:@3 page:_deliveryingPag count:10 orderState:2];
    }else
    {
        _deliveriedPag = 1;
        _orderState = 3;
        [self downloadDataWithCommand:@3 page:_deliveriedPag count:10 orderState:3];
    }
}

- (void)footerRereshing
{
    [self tableViewEndRereshing];
    if (self.segment.selectedSegmentIndex == 0) {
        if (self.nOrderArray.count < _nOrderCount) {
            self.nOrderTableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@3 page:++_nOrderPag count:10 orderState:1];
        }else
        {
            self.nOrderTableView.footerRefreshingText = @"数据已经加载完";
            [self.nOrderTableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];

        }
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        if (_deliveryingArray.count < _deliveryingCount ) {
            self.deliveryingTableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@3 page:++_deliveryingPag count:10 orderState:2];
        }else
        {
            self.deliveryingTableView.footerRefreshingText = @"数据已经加载完";
            [self.deliveryingTableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }else
    {
        if (_deliveriedArray.count < _deliveriedCount) {
            self.deliveriedTableView.footerRefreshingText = @"正在加载数据";
            [self downloadDataWithCommand:@3 page:++_deliveriedPag count:10 orderState:3];
        }else
        {
            self.deliveriedTableView.footerRefreshingText = @"数据已经加载完";
            [self.deliveriedTableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1];
        }
    }
}

- (void)tableViewEndRereshing
{
    if (self.segment.selectedSegmentIndex == 0) {
        
        if (self.nOrderTableView.isHeaderRefreshing) {
            [self.nOrderTableView headerEndRefreshing];
        }
        if (self.nOrderTableView.isFooterRefreshing) {
            [self.nOrderTableView footerEndRefreshing];
        }
    }else if (self.segment.selectedSegmentIndex == 1)
    {
        if (self.deliveryingTableView.isHeaderRefreshing) {
            [self.deliveryingTableView headerEndRefreshing];
        }
        if (self.deliveryingTableView.isFooterRefreshing) {
            [self.deliveryingTableView footerEndRefreshing];
        }
    }else
    {
        if (self.deliveriedTableView.isHeaderRefreshing) {
            [self.deliveriedTableView headerEndRefreshing];
        }
        if (self.deliveriedTableView.isFooterRefreshing) {
            [self.deliveriedTableView footerEndRefreshing];
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
                               @"OrderState":[NSNumber numberWithInt:state]
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
    NSLog(@"data = %@", [data description]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10003]) {
            
            if (_orderState == 1) {
                if (_nOrderPag == 1) {
                    [self.nOrderArray removeAllObjects];
                }
                self.nOrderCount = [[data objectForKey:@"AllCount"] intValue];
                NSArray * array = [data objectForKey:@"OrderList"];
                for (NSDictionary * dic in array) {
                    NewOrderModel * model = [[NewOrderModel alloc]initWithDictionary:dic];
                    [self.nOrderArray addObject:model];
                }
                [self.nOrderTableView reloadData];
            }else if (_orderState == 2)
            {
                if (_deliveryingPag == 1) {
                    [self.deliveryingArray removeAllObjects];
                }
                self.deliveryingCount = [[data objectForKey:@"AllCount"] intValue];
                NSArray * array = [data objectForKey:@"OrderList"];
                for (NSDictionary * dic in array) {
                    NewOrderModel * model = [[NewOrderModel alloc]initWithDictionary:dic];
                    [self.deliveryingArray addObject:model];
                }
                [self.deliveryingTableView reloadData];
            }else
            {
                if (_deliveriedPag == 1) {
                    [self.deliveriedArray removeAllObjects];
                }
                self.deliveriedCount = [[data objectForKey:@"AllCount"] intValue];
                NSArray * array = [data objectForKey:@"OrderList"];
                for (NSDictionary * dic in array) {
                    NewOrderModel * model = [[NewOrderModel alloc]initWithDictionary:dic];
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
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始配送成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
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


- (void)setupAction:(UIBarButtonItem *)sender
{
    /*
     抽屉效果
     AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
     
     [appDelegate.centerVC presentUserView];
     */
    UserCenterViewController * userVC = [[UserCenterViewController alloc]init];
    [self.navigationController pushViewController:userVC animated:YES];
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
        
        [newOrderCell.totlePriceView.detailsButton addTarget:self action:@selector(orderDetais:event:) forControlEvents:UIControlEventTouchUpInside];
        [newOrderCell.totlePriceView.startDeliveryBT addTarget:self action:@selector(robAction:event:) forControlEvents:UIControlEventTouchUpInside];
        
        return newOrderCell;
    }else if ([tableView isEqual:_deliveryingTableView])
    {
        NewOrderModel * model = [self.deliveryingArray objectAtIndex:indexPath.row];
        DeliveryingCell * deliveryingCell = [tableView dequeueReusableCellWithIdentifier:DELIVERYING_IDENTIFIER forIndexPath:indexPath];
        [deliveryingCell createSubView:tableView.bounds mealCoutn:model.mealArray.count];
        deliveryingCell.orderModel = model;
        [deliveryingCell.totlePriceView.detailsButton addTarget:self action:@selector(orderDetais:event:) forControlEvents:UIControlEventTouchUpInside];
        [deliveryingCell.totlePriceView.startDeliveryBT addTarget:self action:@selector(deliveryAction:event:) forControlEvents:UIControlEventTouchUpInside];
        return deliveryingCell;
    }else
    {
        NewOrderModel * model = [self.deliveriedArray objectAtIndex:indexPath.row];
        DeliveriedCell * deliveriedCell = [tableView dequeueReusableCellWithIdentifier:DELIVERIED_IDENTIFIER forIndexPath:indexPath];
        [deliveriedCell createSubView:tableView.bounds mealCoutn:model.mealArray.count];
        deliveriedCell.orderModel = model;
        [deliveriedCell.totlePriceView.detailsButton addTarget:self action:@selector(orderDetais:event:) forControlEvents:UIControlEventTouchUpInside];
        return deliveriedCell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_nOrderTableView]) {
        NewOrderModel * model = [self.nOrderArray objectAtIndex:indexPath.row];
        return [NewOrderCell cellHeightWithMealCount:(int)model.mealArray.count];
    }else if ([tableView isEqual:_deliveryingTableView])
    {
        NewOrderModel * model = [self.deliveryingArray objectAtIndex:indexPath.row];
        return [DeliveryingCell cellHeightWithMealCount:(int)model.mealArray.count];
    }else
    {
        NewOrderModel * model = [self.deliveriedArray objectAtIndex:indexPath.row];
        return [DeliveriedCell cellHeightWithMealCount:(int)model.mealArray.count];
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
    if ([tableView isEqual:_nOrderTableView]) {
        OrderDetailController * pVC = [[OrderDetailController alloc]init];
        [self.navigationController pushViewController:pVC animated:YES];
    }
}

#pragma mark - 查看详情
- (void)orderDetais:(UIButton *)button event:(UIEvent *)event
{
     OrderDetailController * pVC = [[OrderDetailController alloc]init];
    PersonalDataViewController * vc = [[PersonalDataViewController alloc]init];
    
    if (self.segment.selectedSegmentIndex == 0) {
        NSSet * touches = [event allTouches];
        UITouch * touch = [touches anyObject];
        CGPoint currentTouchPoint = [touch locationInView:self.nOrderTableView];
        NSIndexPath * indepath = [self.nOrderTableView indexPathForRowAtPoint:currentTouchPoint];
        if (indepath != nil) {
            NewOrderModel * model = [self.nOrderArray objectAtIndex:indepath.row];
            pVC.orderID = model.orderId;
        }
    }else if(self.segment.selectedSegmentIndex == 1)
    {
        NSSet * touches = [event allTouches];
        UITouch * touch = [touches anyObject];
        CGPoint currrenPoint = [touch locationInView:self.deliveryingTableView];
        NSIndexPath * indexpath = [self.deliveryingTableView indexPathForRowAtPoint:currrenPoint];
        if (indexpath != nil) {
            NewOrderModel * model = [self.deliveryingArray objectAtIndex:indexpath.row];
            pVC.orderID = model.orderId;
        }
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
    NSLog(@"pVC.orderID = %@", pVC.orderID);
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 抢单
- (void)robAction:(UIButton *)button event:(UIEvent *)event
{
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

}
#pragma mark - 配送
- (void)deliveryAction:(UIButton *)button event:(UIEvent *)event
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
                                   @"OrderId":model.orderId
                                   };
        [self playPostWithDictionary:jsonDic];
        
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
