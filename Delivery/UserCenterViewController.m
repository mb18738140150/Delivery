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

@interface UserCenterViewController ()<HTTPPostDelegate>



@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.navigationItem.title = @"设置";
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0,  TOP_SPACE, self.view.frame.size.width, 100)];
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
    
    
    self.todayOrderview = [[OtherView alloc]initWithFrame:CGRectMake(0, _totalOrderview.bottom , self.view.width, 50)];
    _todayOrderview.titleLabel.text = @"今日订单数";
    _todayOrderview.detalsLabel.text = @"20";
    [self.view addSubview:_todayOrderview];
    
    self.massegeView = [[OtherView alloc]initWithFrame:CGRectMake(0, _todayOrderview.bottom, self.view.width , _totalOrderview.height)];
    _massegeView.titleLabel.text = @"消息免打扰";
    _massegeView.detailButton.hidden = NO;
    [_massegeView.detailButton addTarget:self action:@selector(openOrCloseAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_massegeView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    NSDictionary * jsonDic = nil;
        jsonDic = @{
                    @"Command":@2,
                    @"UserId":[UserInfo shareUserInfo].userId
                    };
    
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)backLastVC:(UIBarButtonItem * )sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)personCenterAction:(UITapGestureRecognizer *)sender
{
//    NSLog(@"此处应该跳转到个人中心界面了");
    /*
     // 抽屉效果
     PersonCenterViewController * personVC = [[PersonCenterViewController alloc]init];
     
     AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
     
     [appDelegate.centerVC moveOrderViewToOriginalPosition];
     
     [appDelegate.centerVC.orderVC pushViewController:personVC animated:YES];
    */
    PersonCenterViewController * personVC = [[PersonCenterViewController alloc]init];
    
    personVC.iconImage = self.iconImage.image;
    personVC.name = self.nameLabel.text;
    personVC.phone = self.phoneNumberLabel.text;
    
    [self.navigationController pushViewController:personVC animated:YES];
}


- (void)allowAction:(UIButton *)button
{
    NSLog(@"允许接收订单");
}

- (void)openOrCloseAction:(UISwitch *)aswitch
{
    NSLog(@"消息免打扰");
    if (aswitch.isOn) {
        UIAlertController * Controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否开启消息免打扰" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UISwitch * isopen = aswitch;
            [isopen setOn:!isopen.isOn animated:YES];
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary * jsonDic = nil;
            jsonDic = @{
                        @"Command":@8,
                        @"UserId":[UserInfo shareUserInfo].userId,
                        @"Remind":@1
                        };
            
            [self playPostWithDictionary:jsonDic];
        }];
        [Controller addAction:cancleAction];
        [Controller addAction:sureAction];
        [self presentViewController:Controller animated:YES completion:nil];
    }else
    {
        UIAlertController * Controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否关闭消息免打扰" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UISwitch * isopen = aswitch;
            [isopen setOn:!isopen.isOn animated:YES];
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary * jsonDic = nil;
            jsonDic = @{
                        @"Command":@8,
                        @"UserId":[UserInfo shareUserInfo].userId,
                        @"Remind":@2
                        };
            
            [self playPostWithDictionary:jsonDic];
        }];
        [Controller addAction:cancleAction];
        [Controller addAction:sureAction];
        [self presentViewController:Controller animated:YES completion:nil];

    }
    
}

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
    [SVProgressHUD dismiss];
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10002]) {
            NSDictionary * dic = [data objectForKey:@"UserInfo"];
            
            __weak UserCenterViewController * userVC = self;
            [self.iconImage sd_setImageWithURL:[dic objectForKey:@"Icon"] placeholderImage:[UIImage imageNamed:@"PHOTO.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    userVC.iconImage.image = image;
                }
            }];
            
            self.nameLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"UserName"]];
            self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Phone"]];
            _totalOrderview.detalsLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"TotalOrderCount"]];
            _todayOrderview.detalsLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"TodayOrderCount"]];
            
        }else if ([command isEqualToNumber:@10008])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];

        }
    }else
    {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10008]) {
            UISwitch * isopen = _massegeView.detailButton;
            [isopen setOn:!isopen.isOn animated:YES];
        }
        
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
