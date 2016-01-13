//
//  LoginViewController.m
//  Delivery
//
//  Created by 仙林 on 16/1/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "LoginViewController.h"
#import "OrderViewController.h"

@interface LoginViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfiled;
@property (strong, nonatomic) IBOutlet UIButton *passwordShowBT;
- (IBAction)loginAction:(id)sender;
- (IBAction)registeraction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
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
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view.
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
    OrderViewController * orderVC = [[OrderViewController alloc]init];
    
    [self.navigationController pushViewController:orderVC animated:YES];
    NSLog(@"****");
    
}

- (IBAction)registeraction:(id)sender {
    NSLog(@"注册");
}
@end
