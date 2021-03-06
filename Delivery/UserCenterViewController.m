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
#import "Delivery-Swift.h"

#define TOP_SPACE 10
#define LEFT_SPACE 12
#define ICONIMAGE_WIDTH 65
#define label_height 15
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@interface UserCenterViewController ()<HTTPPostDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)PositionDB * positionDb;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName: UIColorFromRGBA(0x999999, 1),
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:16]
                                                                    };
    
    self.navigationItem.title = @"设置";
    
    self.positionDb = [[PositionDB alloc]init];

    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0,  TOP_SPACE , self.view.frame.size.width, 81)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headView];
    
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE - 2, ICONIMAGE_WIDTH, ICONIMAGE_WIDTH)];
    _iconImage.image = [UIImage imageNamed:@"PHOTO.png"];
    [_headView addSubview:_iconImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImage.right + LEFT_SPACE + 5, 2*TOP_SPACE + 2, self.view.width - 3 * LEFT_SPACE - ICONIMAGE_WIDTH - 60, label_height)];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.text = @"配送员姓名";
    [_headView addSubview:_nameLabel];
    
    self.phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left , _nameLabel.bottom + TOP_SPACE, _nameLabel.width, _nameLabel.height)];
    self.phoneNumberLabel.textColor = [UIColor grayColor];
    _phoneNumberLabel.font = [UIFont systemFontOfSize:11];
    _phoneNumberLabel.text = @"w47872y49r8349t";
    [_headView addSubview:_phoneNumberLabel];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 32, _headView.height / 2  - 8, 8, 15)];
    imageView.image = [UIImage imageNamed:@"arrowright.png"];
    [_headView addSubview:imageView];
    
    UIButton *personCenterBT = [UIButton buttonWithType:UIButtonTypeSystem];
    personCenterBT.frame = CGRectMake(self.view.width - 50, _headView.height / 2  - 20, 40, 40);
//    [personCenterBT setImage:[[UIImage imageNamed:@"arrowright.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [personCenterBT addTarget:self action:@selector(personCenterAction:) forControlEvents:UIControlEventTouchUpInside];
    personCenterBT.backgroundColor = [UIColor clearColor];
    [_headView addSubview:personCenterBT];
    
    _iconImage.userInteractionEnabled = YES;
    _nameLabel.userInteractionEnabled = YES;
    _phoneNumberLabel.userInteractionEnabled = YES;
    _headView.userInteractionEnabled = YES;
    
    self.totalOrderview = [[OtherView alloc]initWithFrame:CGRectMake(0, _headView.bottom + TOP_SPACE, self.view.width / 2, 66)];
    _totalOrderview.iconImageView.image = [UIImage imageNamed:@"icon_2.png"];
    _totalOrderview.titleLabel.text = @"总订单数";
    _totalOrderview.detalsLabel.text = @"20";
    [self.view addSubview:_totalOrderview];
    
    self.todayOrderview = [[OtherView alloc]initWithFrame:CGRectMake(_totalOrderview.right + 1, _totalOrderview.top , self.view.width / 2, 66)];
    _todayOrderview.iconImageView.image = [UIImage imageNamed:@"icon_3.png"];
    _todayOrderview.titleLabel.text = @"今日订单数";
    _todayOrderview.detalsLabel.text = @"20";
    [self.view addSubview:_todayOrderview];
    
    self.totlaMoney = [[OtherView alloc]initWithFrame:CGRectMake(0, _totalOrderview.bottom + 1, self.view.width / 2, 66)];
    _totlaMoney.iconImageView.image = [UIImage imageNamed:@"totoaMonry.png"];
    _totlaMoney.titleLabel.text = @"总金额";
    _totlaMoney.detalsLabel.text = @"20";
    _totlaMoney.detalsLabel.textColor = RGBCOLOR(221, 15, 96);
    [self.view addSubview:_totlaMoney];
    UITapGestureRecognizer * totalTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailAction:)];
    [_totlaMoney addGestureRecognizer:totalTap];
    
    self.todayMoney = [[OtherView alloc]initWithFrame:CGRectMake(_totlaMoney.right + 1, _totlaMoney.top , self.view.width / 2, 66)];
    _todayMoney.iconImageView.image = [UIImage imageNamed:@"todayMoney.png"];
    _todayMoney.titleLabel.text = @"今日到账";
    _todayMoney.detalsLabel.text = @"20";
    _todayMoney.detalsLabel.textColor = RGBCOLOR(31, 195, 164);
    [self.view addSubview:_todayMoney];
    UITapGestureRecognizer * todayTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailAction:)];
    [_todayMoney addGestureRecognizer:todayTap];
    
    self.massegeView = [[OtherView alloc]initWithFrame:CGRectMake(0, _totlaMoney.bottom + TOP_SPACE, self.view.width , 45)];
    _massegeView.iconImageView.image = [UIImage imageNamed:@"icon_1.png"];
    _massegeView.titleLabel.text = @"是否上班";
    _massegeView.detailButton.hidden = NO;
    [_massegeView.detailButton addTarget:self action:@selector(openOrCloseAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_massegeView];
    
    self.positionView = [[OtherView alloc]initWithFrame:CGRectMake(0, _massegeView.bottom + TOP_SPACE, self.view.width , 45)];
    _positionView.iconImageView.image = [UIImage imageNamed:@"positionIcon.png"];
    _positionView.titleLabel.text = @"实时定位";
    _positionView.detailButton.hidden = NO;
    [_positionView.detailButton addTarget:self action:@selector(positionAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_positionView];
    
    NSArray * array = [self.positionDb getPositionModels];
    for (PositionModel * model in array) {
        
        NSLog(@"%d, %d***", model.userId, model.positionType);
        if (model.userId == [UserInfo shareUserInfo].userId.intValue) {
            if (model.positionType == 2) {
                _positionView.detailButton.on = NO;
            }else
            {
                _positionView.detailButton.on = YES;
            }
        }
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_black.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary * jsonDic = nil;
    jsonDic = @{
                @"Command":@2,
                @"UserId":[UserInfo shareUserInfo].userId
                };
    
    [self playPostWithDictionary:jsonDic];
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
#pragma mark - 收入明细
- (void)detailAction:(UITapGestureRecognizer *)sender
{
    IncomDetailsViewController * incomVC = [[IncomDetailsViewController alloc]init];
    
    [self.navigationController pushViewController:incomVC animated:YES];
}
#pragma mark - 实时定位
- (void)positionAction:(UISwitch *)aswitch
{
    if (aswitch.isOn) {
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
//            NSLog(@"需要开启定位服务，青岛设置 - >隐私，打开定位服务");
            aswitch.on = NO;
            [UserInfo shareUserInfo].isOpenthebackgroundposition = NO;
        }else
        {
            NSArray * array = [self.positionDb getPositionModels];
            for (PositionModel * model in array) {
                if (model.userId == [UserInfo shareUserInfo].userId.intValue) {
                    model.positionType = 1;
                    [self.positionDb updateModel:model];
                }
            }
            [UserInfo shareUserInfo].isOpenthebackgroundposition = YES;
        }
        
    }else
    {
        NSArray * array = [self.positionDb getPositionModels];
        for (PositionModel * model in array) {
            if (model.userId == [UserInfo shareUserInfo].userId.intValue) {
                model.positionType = 2;
                [self.positionDb updateModel:model];
            }
        }
        
        [UserInfo shareUserInfo].isOpenthebackgroundposition = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:LoginAndStartUDP object:nil userInfo:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)allowAction:(UIButton *)button
{
    NSLog(@"允许接受订单");
}

- (void)openOrCloseAction:(UISwitch *)aswitch
{
    NSLog(@"上班");
    if (aswitch.isOn) {
        UIAlertController * Controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否上班" preferredStyle:UIAlertControllerStyleAlert];
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
        UIAlertController * Controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否下班" preferredStyle:UIAlertControllerStyleAlert];
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
//    NSLog(@"jsonStr = %@", str);
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    httpPost.commend = [dic objectForKey:@"Command"];
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
            
            NSLog(@" --- TotalMoney = %@", [dic objectForKey:@"TotalMoney"]);
            
            __weak UserCenterViewController * userVC = self;
            [self.iconImage sd_setImageWithURL:[dic objectForKey:@"Icon"] placeholderImage:[UIImage imageNamed:@"PHOTO.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    userVC.iconImage.image = image;
                }
            }];
            
            if ([[dic objectForKey:@"UserType"] intValue] == 1) {
                // 全职
                NSString * nameS = [dic objectForKey:@"UserName"];
                NSString * str = [NSString stringWithFormat:@"%@[%@]" ,[dic objectForKey:@"UserName"], @"全职"];
                NSMutableAttributedString * quanzhiStr = [[NSMutableAttributedString alloc]initWithString:str];
                [quanzhiStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithRed:0/ 255.0 green:196/ 255.0 blue:164/ 255.0 alpha:1]} range:NSMakeRange(nameS.length, str.length - nameS.length)];
                self.nameLabel.attributedText = quanzhiStr;
                
            }else if ([[dic objectForKey:@"UserType"] intValue] == 2  )
            {
                // 兼职
                NSString * nameS = [dic objectForKey:@"UserName"];
                NSString * str = [NSString stringWithFormat:@"%@[%@]" ,[dic objectForKey:@"UserName"], @"兼职"];
                NSMutableAttributedString * jianzhiStr = [[NSMutableAttributedString alloc]initWithString:str];
                [jianzhiStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithRed:252/ 255.0 green:80/ 255.0 blue:53/ 255.0 alpha:1]} range:NSMakeRange(nameS.length, str.length - nameS.length)];
                self.nameLabel.attributedText = jianzhiStr;
            }else
            {
                
                self.nameLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"UserName"]];
            }
            
            
            self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Phone"]];
            _totalOrderview.detailStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"TotalOrderCount"]];
            _todayOrderview.detailStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"TodayOrderCount"]];
            _totlaMoney.detailStr = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:@"TotalMoney"] doubleValue]];
            _todayMoney.detailStr = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:@"TodayMoney"] doubleValue]];
            
            if ([[dic objectForKey:@"Remind"] intValue] == 1) {
                _massegeView.detailButton.on = YES;
                _massegeView.titleLabel.text = @"上班";
            }else
            {
                _massegeView.detailButton.on = NO;
                _massegeView.titleLabel.text = @"下班";
            }
            
        }else if ([command isEqualToNumber:@10008])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            
            UISwitch * isopen = _massegeView.detailButton;
            if (isopen.isOn) {
                _massegeView.titleLabel.text = @"上班";
            }else
            {
                _massegeView.titleLabel.text = @"下班";
            }
            
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
