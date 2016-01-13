//
//  PersonCenterViewController.m
//  Delivery
//
//  Created by 仙林 on 15/10/28.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "ChangePasswordViewController.h"


#define ICONIMAGE_WIDTH 80
#define LABEL_HEIGHT 30
#define TOP_SPACE 10
#define LEFT_SPACE 10

@interface PersonCenterViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * phoneLabel;

@property (nonatomic, strong)UIButton * changePasswordBT;
@property (nonatomic, strong)UIButton * exitButton;

@property (nonatomic, strong)UIImagePickerController * imagePic;

@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    //    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    //    button.frame = CGRectMake(100, 100, 100, 100);
    //    button.backgroundColor = [UIColor redColor];
    //    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:button];
    
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
    
    UIView * infomationView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE + 64, self.view.width, 202)];
    infomationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infomationView];
    
    UITapGestureRecognizer * tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [infomationView addGestureRecognizer:tapgesture];
    
    UILabel * iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.view.width / 2, ICONIMAGE_WIDTH)];
    iconLabel.text = @"头像";
    iconLabel.font = [UIFont systemFontOfSize:24];
    [infomationView addSubview:iconLabel];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - LEFT_SPACE - ICONIMAGE_WIDTH, TOP_SPACE, ICONIMAGE_WIDTH, ICONIMAGE_WIDTH)];
    _iconImageView.image = [UIImage imageNamed:@"PHOTO.png"];
    _iconImageView.userInteractionEnabled = YES;
    [infomationView addSubview:_iconImageView];
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageAction:)];
    [_iconImageView addGestureRecognizer:imageTap];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _iconImageView.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [infomationView addSubview:line1];
    
    UILabel * nameLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, line1.bottom + TOP_SPACE, 100, LABEL_HEIGHT)];
    nameLB.text = @"昵称";
    nameLB.font = [UIFont systemFontOfSize:24];
    [infomationView addSubview:nameLB];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLB.right, nameLB.top, self.view.width - 2 *LEFT_SPACE - nameLB.width, nameLB.height)];
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.text = @"嘎嘎嘎";
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [infomationView addSubview:_nameLabel];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, nameLB.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [infomationView addSubview:line2];
    
    UILabel * phoneLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, line2.bottom + TOP_SPACE, 100, LABEL_HEIGHT)];
    phoneLB.text = @"电话";
    phoneLB.font = [UIFont systemFontOfSize:24];
    [infomationView addSubview:phoneLB];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(phoneLB.right, phoneLB.top, self.view.width - 2 *LEFT_SPACE - phoneLB.width, phoneLB.height)];
    _phoneLabel.textColor = [UIColor grayColor];
    _phoneLabel.text = @"8237567834tr8";
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    [infomationView addSubview:_phoneLabel];
    
    UITapGestureRecognizer * changeNameOrphone = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNameOrPhonrAction:)];
    UITapGestureRecognizer * changeNameOrphone1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNameOrPhonrAction:)];
    _nameLabel.userInteractionEnabled = YES;
    _phoneLabel.userInteractionEnabled = YES;
    [_nameLabel addGestureRecognizer:changeNameOrphone];
    [_phoneLabel addGestureRecognizer:changeNameOrphone1];
    
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, infomationView.bottom + 2 * TOP_SPACE, self.view.width, 101)];
    
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    self.changePasswordBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _changePasswordBT.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 30);
    [_changePasswordBT setTitle:@"修改密码" forState:UIControlStateNormal];
    _changePasswordBT.titleLabel.font = [UIFont systemFontOfSize:24];
    [_changePasswordBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _changePasswordBT.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    _changePasswordBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 四个参数为距离上左下右边界的距离
    _changePasswordBT.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [_changePasswordBT addTarget:self action:@selector(changePasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:_changePasswordBT];
    
    UIView * line11 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _changePasswordBT.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 1)];
    line11.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [view1 addSubview:line11];
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _exitButton.frame = CGRectMake(LEFT_SPACE, line11.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 30);
    [_exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    _exitButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [_exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _exitButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _exitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _exitButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_exitButton addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:_exitButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)backAction:(UIBarButtonItem * )sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)sender
{
    
}

- (void)changeNameOrPhonrAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"jdhbfhj");
}

- (void)changeImageAction:(UITapGestureRecognizer *)sender
{
    //    UIActionSheet * actionsheet = [[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册获取", nil];
    //    actionsheet.actionSheetStyle = UIActionSheetStyleDefault;
    //    [actionsheet showInView:self.view];
    
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePic animated:YES completion:nil];
        }else
        {
            UIAlertController * tipControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相机,请选择图库" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }];
            [tipControl addAction:sureAction];
            [self presentViewController:tipControl animated:YES completion:nil];
            
        }
    }];
    UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePic animated:YES completion:nil];
    }];
    
    [alertcontroller addAction:cancleAction];
    [alertcontroller addAction:cameraAction];
    [alertcontroller addAction:libraryAction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.iconImageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 修改密码
- (void)changePasswordAction:(UIButton *)button
{
    ChangePasswordViewController * changePasswordVC = [[ChangePasswordViewController alloc]init];
    
    [self.navigationController pushViewController:changePasswordVC animated:YES];
    
}

- (void)exitAction:(UIButton *)button
{
    NSLog(@"退出登录");
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
