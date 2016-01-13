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
#define ICONIMAGE_WIDTH 60

@interface UserCenterViewController ()



@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(150, 50, self.view.frame.size.width, 100)];
    _headView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_headView];
    
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, ICONIMAGE_WIDTH, ICONIMAGE_WIDTH)];
    _iconImage.image = [UIImage imageNamed:@"PHOTO.png"];
    [_headView addSubview:_iconImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImage.right , TOP_SPACE, self.view.width - 2 * LEFT_SPACE - ICONIMAGE_WIDTH - 150, 30)];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.text = @"配送员姓名"
    ;    [_headView addSubview:_nameLabel];
    
    self.phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImage.right , _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
    _phoneNumberLabel.adjustsFontSizeToFitWidth = YES;
    self.phoneNumberLabel.textColor = [UIColor grayColor];
    _phoneNumberLabel.text = @"w47872y49r8349t";
    [_headView addSubview:_phoneNumberLabel];
    
    _iconImage.userInteractionEnabled = YES;
    _nameLabel.userInteractionEnabled = YES;
    _phoneNumberLabel.userInteractionEnabled = YES;
    _headView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personCenterAction:)];
    
    [_headView addGestureRecognizer:tap];
    [_iconImage addGestureRecognizer:tap];
    [_nameLabel addGestureRecognizer:tap];
    [_phoneNumberLabel addGestureRecognizer:tap];
    
    
    
    self.totalOrderview = [[OtherView alloc]initWithFrame:CGRectMake(150, _headView.bottom + TOP_SPACE, self.view.width - 150, 50)];
    _totalOrderview.titleLabel.text = @"总订单数";
    _totalOrderview.detalsLabel.text = @"20";
    [self.view addSubview:_totalOrderview];
    
    
    self.reciveOrderView = [[OtherView alloc]initWithFrame:CGRectMake(150, _totalOrderview.bottom, self.view.width - 150, _totalOrderview.height)];
    _reciveOrderView.titleLabel.text = @"接收订单";
    [_reciveOrderView.detailButton setTitle:@"允许" forState:UIControlStateNormal];
    [_reciveOrderView.detailButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_reciveOrderView.detailButton addTarget:self action:@selector(allowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reciveOrderView];
    
    self.massegeView = [[OtherView alloc]initWithFrame:CGRectMake(150, _reciveOrderView.bottom, self.view.width - 150, _totalOrderview.height)];
    _massegeView.titleLabel.text = @"消息免打扰";
    [_massegeView.detailButton setTitle:@"关闭" forState:UIControlStateNormal];
    [_massegeView.detailButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_massegeView.detailButton addTarget:self action:@selector(openOrCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_massegeView];
    
    
}

- (void)backAction:(UIBarButtonItem * )sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)personCenterAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"此处应该跳转到个人中心界面了");
    
    PersonCenterViewController * personVC = [[PersonCenterViewController alloc]init];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate.centerVC moveOrderViewToOriginalPosition];
    
    [appDelegate.centerVC.orderVC pushViewController:personVC animated:YES];
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
