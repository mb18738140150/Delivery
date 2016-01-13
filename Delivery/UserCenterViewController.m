//
//  UserCenterViewController.m
//  Delivery
//
//  Created by 仙林 on 15/10/23.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "UserCenterViewController.h"
#import "PersonCenterViewController.h"

#import "AppDelegate.h"

#define TOP_SPACE 10
#define LEFT_SPACE 10
#define ICONIMAGE_WIDTH 80
#define label_height 30

@interface UserCenterViewController ()



@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.navigationItem.title = @"设置";
    
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height + 20 + TOP_SPACE, self.view.frame.size.width, 100)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headView];
    
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, ICONIMAGE_WIDTH, ICONIMAGE_WIDTH)];
    _iconImage.image = [UIImage imageNamed:@"PHOTO.png"];
    [_headView addSubview:_iconImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImage.right + LEFT_SPACE , TOP_SPACE + 5, self.view.width - 3 * LEFT_SPACE - ICONIMAGE_WIDTH - 60, label_height)];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.text = @"配送员姓名"
    ;    [_headView addSubview:_nameLabel];
    
    self.phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImage.right + LEFT_SPACE , _nameLabel.bottom + TOP_SPACE, _nameLabel.width, _nameLabel.height)];
    _phoneNumberLabel.adjustsFontSizeToFitWidth = YES;
    self.phoneNumberLabel.textColor = [UIColor grayColor];
    _phoneNumberLabel.text = @"w47872y49r8349t";
    [_headView addSubview:_phoneNumberLabel];
    
    UIButton *personCenterBT = [UIButton buttonWithType:UIButtonTypeSystem];
    personCenterBT.frame = CGRectMake(self.view.width - 60, _nameLabel.top + 5, 40, 60);
    [personCenterBT setImage:[[UIImage imageNamed:@"arrowright.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [personCenterBT addTarget:self action:@selector(personCenterAction:) forControlEvents:UIControlEventTouchUpInside];
    personCenterBT.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:personCenterBT];
    
    _iconImage.userInteractionEnabled = YES;
    _nameLabel.userInteractionEnabled = YES;
    _phoneNumberLabel.userInteractionEnabled = YES;
    _headView.userInteractionEnabled = YES;
    
    
    self.totalOrderview = [[OtherView alloc]initWithFrame:CGRectMake(0, _headView.bottom + TOP_SPACE, self.view.width, 50)];
    _totalOrderview.titleLabel.text = @"总订单数";
    _totalOrderview.detalsLabel.text = @"20";
    [self.view addSubview:_totalOrderview];
    
    
    self.reciveOrderView = [[OtherView alloc]initWithFrame:CGRectMake(0, _totalOrderview.bottom, self.view.width, _totalOrderview.height)];
    _reciveOrderView.titleLabel.text = @"接收订单";
    [_reciveOrderView.detailButton setTitle:@"允许" forState:UIControlStateNormal];
    [_reciveOrderView.detailButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_reciveOrderView.detailButton addTarget:self action:@selector(allowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reciveOrderView];
    
    self.massegeView = [[OtherView alloc]initWithFrame:CGRectMake(0, _reciveOrderView.bottom, self.view.width , _totalOrderview.height)];
    _massegeView.titleLabel.text = @"消息免打扰";
    [_massegeView.detailButton setTitle:@"关闭" forState:UIControlStateNormal];
    [_massegeView.detailButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_massegeView.detailButton addTarget:self action:@selector(openOrCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_massegeView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
}

- (void)backLastVC:(UIBarButtonItem * )sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)personCenterAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"此处应该跳转到个人中心界面了");
    /*
     // 抽屉效果
     PersonCenterViewController * personVC = [[PersonCenterViewController alloc]init];
     
     AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
     
     [appDelegate.centerVC moveOrderViewToOriginalPosition];
     
     [appDelegate.centerVC.orderVC pushViewController:personVC animated:YES];
    */
    PersonCenterViewController * personVC = [[PersonCenterViewController alloc]init];
    
    [self.navigationController pushViewController:personVC animated:YES];
}


- (void)allowAction:(UIButton *)button
{
    NSLog(@"允许接收订单");
}

- (void)openOrCloseAction:(UIButton *)button
{
    NSLog(@"纤细免打扰");
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
