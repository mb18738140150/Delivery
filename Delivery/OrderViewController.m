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

#define SEGMENT_HEIGHT 40
#define SEGMENT_WIDTH 240
#define SEGMENT_X self.view.width / 2 - SEGMENT_WIDTH / 2
#define TOP_SPACE 10
#define HEARDERVIEW_HEIGHT 4 + SEGMENT_HEIGHT

@interface OrderViewController ()<UITableViewDataSource, UITableViewDelegate>


@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHeaderView];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251 / 255.0 green:84 / 255.0 blue:8 / 255.0 alpha:1];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height )];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
//    self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width  / 2, self.view.height / 2, self.view.width / 3, self.view.height / 3)];
//    _label.textColor = [UIColor blackColor];
//    _label.font = [UIFont systemFontOfSize:30];
//    _label.text = @"你好啊才";
//    _label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_label];setupAction
    
//    self.navigationItem.leftBarButtonItem = nil;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"setting_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(setupAction:)];
    
}

- (void)addHeaderView
{
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"新订单", @"配送中", @"已配送"]];
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
        self.tableView.backgroundColor = [UIColor whiteColor];
    }else if (segment.selectedSegmentIndex == 1)
    {
        self.tableView.backgroundColor = [UIColor grayColor];
    }else
    {
        self.tableView.backgroundColor = [UIColor cyanColor];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ceiiID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.detailTextLabel.text = @"测试";
    cell.textLabel.text = @"hhh";
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    OrderDetailController * pVC = [[OrderDetailController alloc]init];
    [self.navigationController pushViewController:pVC animated:YES];
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
