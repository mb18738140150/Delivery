//
//  LoginViewController.m
//  Delivery
//
//  Created by 仙林 on 16/1/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "LoginViewController.h"
#import "OrderViewController.h"

@interface LoginViewController ()<UITextFieldDelegate, UIAlertViewDelegate, HTTPPostDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfiled;
@property (strong, nonatomic) IBOutlet UIButton *passwordShowBT;
- (IBAction)loginAction:(id)sender;
- (IBAction)registeraction:(id)sender;

@property (nonatomic, strong)PositionDB * positionDb;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.positionDb = [[PositionDB alloc]init];
    
    self.nameTextFiled.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nameTextFiled.layer.borderWidth = 1;
    self.passwordTextfiled.layer.borderColor = [UIColor whiteColor].CGColor;
    self.passwordTextfiled.layer.borderWidth = 1;
    self.passwordTextfiled.layer.cornerRadius = 5;
    self.passwordTextfiled.layer.masksToBounds = YES;
    self.passwordTextfiled.secureTextEntry = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.nameTextFiled.delegate = self;
    self.passwordTextfiled.delegate = self;
    
    [self.passwordShowBT setBackgroundImage:[[UIImage imageNamed:@"password_hide.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.passwordShowBT setBackgroundImage:[[UIImage imageNamed:@"password_show.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.passwordShowBT setTintColor:[UIColor whiteColor]];
    [self.passwordShowBT addTarget:self action:@selector(passwordForpublic:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [self.view addGestureRecognizer:tapGesture];
//    [self automaticLogin];
//    UINavigationBar * bar = self.navigationController.navigationBar;
//    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self automaticLogin];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogin"] boolValue]) {
        self.passwordTextfiled.text = nil;
        self.nameTextFiled.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        NSLog(@"%@, user = %@", self.passwordTextfiled.text, self.nameTextFiled.text);
    }
}

- (void)automaticLogin
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogin"] boolValue]) {
        self.passwordTextfiled.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Pwd"];
        self.nameTextFiled.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        NSLog(@"%@, user = %@", self.passwordTextfiled.text, self.nameTextFiled.text);
        [self loginFramPost];
    }
}

- (void)tapGestureAction
{
    [self.nameTextFiled resignFirstResponder];
    [self.passwordTextfiled resignFirstResponder];
}

- (void)passwordForpublic:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.passwordTextfiled.secureTextEntry = NO;
        self.passwordTextfiled.text = self.passwordTextfiled.text;
    }else
    {
        self.passwordTextfiled.secureTextEntry = YES;
        self.passwordTextfiled.text = self.passwordTextfiled.text;
    }
    
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogin"] boolValue]) {
//        self.passwordTextfiled.text = nil;
//        self.nameTextFiled.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
//        NSLog(@"%@, user = %@", self.passwordTextfiled.text, self.nameTextFiled.text);
////        [self loginFramPost];
//    }
//}

- (void)viewWillDisappear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
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

- (IBAction)loginAction:(id)sender {
    
    if (self.nameTextFiled.text.length == 0) {
//        UIAlertView * NameAlerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [NameAlerView show];
//        [NameAlerView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入账号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        [self presentViewController:nameController animated:YES completion:nil];
        
    }else if (self.passwordTextfiled.text.length == 0) {
        UIAlertController * passwordController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [passwordController addAction:cancleAction];
        [self presentViewController:passwordController animated:YES completion:nil];
        
    }else
    {
        [self loginFramPost];
    }

}

- (void)loginFramPost
{
    //    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
    //        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请打开远程推送,本应用需要远程推送协助" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alertView show];
    //        return;
    //    }
    NSDictionary * jsonDic = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"]) {
        jsonDic = @{
                    @"Pwd":self.passwordTextfiled.text,
                    @"UserName":self.nameTextFiled.text,
                    @"Command":@1,
                    @"RegistrationID":[[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"],
                    @"DeviceType":@1
                    };
    }else
    {
        jsonDic = @{
                    @"Pwd":self.passwordTextfiled.text,
                    @"UserName":self.nameTextFiled.text,
                    @"Command":@1,
                    @"RegistrationID":[NSNull null],
                    @"DeviceType":@1
                    };
    }
    NSString * jsonStr = [jsonDic JSONString];
    
    NSString * str = [NSString stringWithFormat:@"%@131139", jsonStr];
//    NSLog(@"jsonStr = %@*****postStr = %@", str, jsonStr);
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    httpPost.commend = [jsonDic objectForKey:@"Command"];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
    [self.nameTextFiled resignFirstResponder];
    [self.passwordTextfiled resignFirstResponder];
    
//    AFHTTPSessionManager * sessionmanager = [AFHTTPSessionManager manager];
//    NSMutableSet * contentTypes = [[NSMutableSet alloc]initWithSet:sessionmanager.responseSerializer.acceptableContentTypes];
//    [contentTypes addObject:@"text/html"];
//    [contentTypes addObject:@"text/plain"];
//    sessionmanager.responseSerializer.acceptableContentTypes = contentTypes;
//    
//    [sessionmanager POST:urlString parameters:jsonDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        [SVProgressHUD dismiss];
//        NSLog( @"请求成功………………%@", responseObject);
//        NSLog(@"%@", [responseObject objectForKey:@"ErrorMsg"]);
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
//    }];
    
}

- (void)refresh:(id)data
{
    NSDictionary * dataDic = (NSDictionary *)data;
//    NSLog(@"data = %@", [dataDic description]);
    if ([[dataDic objectForKey:@"Result"] isEqual:@1]) {
        [self registerRemoteNotification];
        NSString * registrationID = [JPUSHService registrationID];
        
        NSLog(@"********registrationID = %@", registrationID);
        [UserInfo shareUserInfo].userId = [dataDic objectForKey:@"UserId"];
//        [[NSNotificationCenter defaultCenter]postNotificationName:LoginAndStartUDP object:nil userInfo:nil];
        
        // 登录成功以后判断该userid是否已经在数据库中，没有的话创建positionModel讲userID信息存储进去
        PositionModel * positionModel = [[PositionModel alloc]init];
        positionModel.userId = [UserInfo shareUserInfo].userId.intValue;
        positionModel.positionType = 2;
        [UserInfo shareUserInfo].isOpenthebackgroundposition = NO;
        if ([self.positionDb retrieveList:positionModel]) {
        }else
        {
            [self.positionDb insert:positionModel];
        }
        
        [UserInfo shareUserInfo].userName = self.nameTextFiled.text;
        [UserInfo shareUserInfo].BusiId =[dataDic objectForKey:@"BusiId"];
        [UserInfo shareUserInfo].isAgent = [[dataDic objectForKey:@"IsAgent"] intValue];
        [UserInfo shareUserInfo].orderCount = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"OrderCount"]];
        [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextfiled.text forKey:@"Pwd"];//记录登录密码
        [[NSUserDefaults standardUserDefaults] setValue:self.nameTextFiled.text forKey:@"UserName"];
        
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogin"] boolValue]) {
            [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"haveLogin"];//记录已经登录过
        }
        OrderViewController * orderVC = [[OrderViewController alloc]init];
        orderVC.isfromLoginVC = 1;
        orderVC.orderCount = [UserInfo shareUserInfo].orderCount;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else
    {
//        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:[dataDic objectForKey:@"ErrorMsg"] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [nameController addAction:cancleAction];
//        [self presentViewController:nameController animated:YES completion:nil];
//        self.passwordTextfiled.text = nil;
        
        if ([[dataDic objectForKey:@"ErrorMsg"] length]) {
            UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dataDic objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alerView show];
            [alerView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            self.passwordTextfiled.text = nil;
        }else
        {
            UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alerView show];
            [alerView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }

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

- (void)registerRemoteNotification
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [JPUSHService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [JPUSHService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [JPUSHService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
}



- (IBAction)registeraction:(id)sender {
//    NSLog(@"注册");
}
@end
