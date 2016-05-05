//
//  ChangePasswordViewController.m
//  Delivery
//
//  Created by 仙林 on 15/10/29.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "PasswordVIewHelpView.h"

#define TOP_SPACE 10
#define PASS_HEIGHT 50

@interface ChangePasswordViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)PasswordVIewHelpView * oldPasswordTF;
@property (nonatomic, strong)PasswordVIewHelpView * nPasswordTF;
@property (nonatomic, strong)PasswordVIewHelpView * sPasswordTF;


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.oldPasswordTF = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0,TOP_SPACE , self.view.width, PASS_HEIGHT)];
    self.oldPasswordTF.nameLabel.text = @"原密码";
    self.oldPasswordTF.passwordTF.placeholder = @"请输入您的原始密码";
    _oldPasswordTF.passwordTF.secureTextEntry = YES;
    [self.view addSubview:_oldPasswordTF];
    
    self.nPasswordTF = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0, _oldPasswordTF.bottom + TOP_SPACE, self.view.width, PASS_HEIGHT)];
    _nPasswordTF.nameLabel.text = @"新密码";
    _nPasswordTF.passwordTF.placeholder = @"6-16字符,区分大小写";
    _nPasswordTF.passwordTF.secureTextEntry = YES;
    [self.view addSubview:_nPasswordTF];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _nPasswordTF.bottom, self.view.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:line];
    
    self.sPasswordTF = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0, line.bottom, self.view.width, PASS_HEIGHT)];
    _sPasswordTF.nameLabel.text = @"确认密码";
    _sPasswordTF.passwordTF.placeholder = @"6-16字符,区分大小写";
    _sPasswordTF.passwordTF.secureTextEntry = YES;
    [self.view addSubview:_sPasswordTF];
    
    self.navigationItem.title = @"修改登录密码";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"启用" style:UIBarButtonItemStylePlain target:self action:@selector(startOrTtop:)];
//    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                             NSForegroundColorAttributeName: [UIColor blackColor]};
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complateAction:)];
    NSDictionary * titleAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]
                                       };
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_black.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismisKeybord)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)backAction:(UIBarButtonItem * )sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismisKeybord
{
    [self.oldPasswordTF.passwordTF resignFirstResponder];
    [self.nPasswordTF.passwordTF resignFirstResponder];
    [self.sPasswordTF.passwordTF resignFirstResponder];
}

- (void)complateAction:(UIBarButtonItem *)sender
{
    NSLog(@"完成");
    if (self.oldPasswordTF.passwordTF.text.length == 0 || self.nPasswordTF.passwordTF.text.length == 0 || self.sPasswordTF.passwordTF.text.length == 0) {
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:@"原密码，新密码均不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        [self presentViewController:nameController animated:YES completion:nil];

    }else if (![self.nPasswordTF.passwordTF.text isEqualToString:self.sPasswordTF.passwordTF.text])
    {
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入的新密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        [self presentViewController:nameController animated:YES completion:nil];

    }else if (self.nPasswordTF.passwordTF.text.length < 6 || self.sPasswordTF.passwordTF.text.length < 6)
    {
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不能小于六位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        [self presentViewController:nameController animated:YES completion:nil];

    }
    else
    {
        NSDictionary * jsonDic = nil;
        jsonDic = @{
                    @"Command":@4,
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"OldPassword":self.oldPasswordTF.passwordTF.text,
                    @"NewPassword":self.nPasswordTF.passwordTF.text
                    };
        
        [self playPostWithDictionary:jsonDic];
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
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
      
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            
        [self.navigationController popViewControllerAnimated:YES];
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
