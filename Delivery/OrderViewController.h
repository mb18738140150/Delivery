//
//  OrderViewController.h
//  Delivery
//
//  Created by 仙林 on 15/10/23.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderViewController : UIViewController


@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UISegmentedControl * segment;
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, assign)int isfromLoginVC;

@end
