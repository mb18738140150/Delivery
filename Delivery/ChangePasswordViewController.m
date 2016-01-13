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

@interface ChangePasswordViewController ()

@property (nonatomic, strong)PasswordVIewHelpView * oldPasswordTF;
@property (nonatomic, strong)PasswordVIewHelpView * nPasswordTF;
@property (nonatomic, strong)PasswordVIewHelpView * sPasswordTF;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.oldPasswordTF = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0,TOP_SPACE + 64, self.view.width, PASS_HEIGHT)];
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
    _sPasswordTF.nameLabel.text = @"确认新密码";
    _sPasswordTF.passwordTF.placeholder = @"6-16字符,区分大小写";
    _sPasswordTF.passwordTF.secureTextEntry = YES;
    [self.view addSubview:_sPasswordTF];
    
    self.navigationItem.title = @"修改登录密码";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complateAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)backAction:(UIBarButtonItem * )sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)complateAction:(UIBarButtonItem *)sender
{
    NSLog(@"完成");
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
