//
//  PersonCenterViewController.m
//  Delivery
//
//  Created by 仙林 on 15/10/28.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "ChangePasswordViewController.h"
#import "AppDelegate.h"

#define ICONIMAGE_WIDTH 80
#define LABEL_HEIGHT 30
#define TOP_SPACE 10
#define LEFT_SPACE 10

@interface PersonCenterViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, HTTPPostDelegate>

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * phoneLabel;

@property (nonatomic, strong)UIButton * changePasswordBT;
@property (nonatomic, strong)UIButton * exitButton;

@property (nonatomic, strong)UIImagePickerController * imagePic;

// 弹出框
@property (nonatomic, strong)UIView * tanchuView;
@property (nonatomic, strong)UITextField * changeNameTF;

@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    //    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    //    button.frame = CGRectMake(100, 100, 100, 100);
    //    button.backgroundColor = [UIColor redColor];
    //    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:button];
    
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
    
    UIView * infomationView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE , self.view.width, 202)];
    infomationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infomationView];
    
    UITapGestureRecognizer * tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [infomationView addGestureRecognizer:tapgesture];
    
    UILabel * iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.view.width / 2, ICONIMAGE_WIDTH)];
    iconLabel.text = @"头像";
//    iconLabel.font = [UIFont systemFontOfSize:24];
    [infomationView addSubview:iconLabel];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - LEFT_SPACE - ICONIMAGE_WIDTH, TOP_SPACE, ICONIMAGE_WIDTH, ICONIMAGE_WIDTH)];
    if (self.iconImage) {
        self.iconImageView.image = self.iconImage;
    }else
    {
        _iconImageView.image = [UIImage imageNamed:@"PHOTO.png"];
    }
    _iconImageView.userInteractionEnabled = YES;
    [infomationView addSubview:_iconImageView];
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageAction:)];
    [_iconImageView addGestureRecognizer:imageTap];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _iconImageView.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [infomationView addSubview:line1];
    
    UILabel * nameLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, line1.bottom + TOP_SPACE, 100, LABEL_HEIGHT)];
    nameLB.text = @"昵称";
//    nameLB.font = [UIFont systemFontOfSize:24];
    [infomationView addSubview:nameLB];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLB.right, nameLB.top, self.view.width - 2 *LEFT_SPACE - nameLB.width, nameLB.height)];
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.text = self.name;
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [infomationView addSubview:_nameLabel];
    
    
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, nameLB.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [infomationView addSubview:line2];
    
    UILabel * phoneLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, line2.bottom + TOP_SPACE, 100, LABEL_HEIGHT)];
    phoneLB.text = @"电话";
//    phoneLB.font = [UIFont systemFontOfSize:24];
    [infomationView addSubview:phoneLB];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(phoneLB.right, phoneLB.top, self.view.width - 2 *LEFT_SPACE - phoneLB.width, phoneLB.height)];
    _phoneLabel.textColor = [UIColor grayColor];
    _phoneLabel.text = self.phone;
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
    _changePasswordBT.titleLabel.font = [UIFont systemFontOfSize:17];
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
    _exitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _exitButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _exitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _exitButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_exitButton addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:_exitButton];
    
    self.tanchuView = [[UIView alloc]initWithFrame:self.view.bounds];
    _tanchuView.backgroundColor = [UIColor clearColor];
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
#pragma mark - 修改昵称
- (void)changeNameOrPhonrAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"jdhbfhj");
    UILabel * nameLabel = (UILabel *)sender.view;
    NSLog(@"%d", [nameLabel isEqual:_nameLabel]);
    if ([nameLabel isEqual:_nameLabel]) {
        [self changeNameAction];
    }
}

- (void)changeNameAction
{
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_tanchuView];
    
    [_tanchuView removeAllSubviews];
    
    
    UIView * backView = [[UIView alloc]init];
    backView.frame = _tanchuView.frame;
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = .5;
    [_tanchuView addSubview:backView];
    
    UIView *changeNamelView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, self.view.width - 40, 150)];
    changeNamelView.center = _tanchuView.center;
    changeNamelView.backgroundColor = [UIColor whiteColor];
    [_tanchuView addSubview:changeNamelView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, changeNamelView.width, 30)];
    titleLabel.text = @"修改昵称";
    titleLabel.textColor = [UIColor blackColor];
    [changeNamelView addSubview:titleLabel];
    
    self.changeNameTF = [[UITextField alloc]initWithFrame:CGRectMake(40, titleLabel.bottom + 10, changeNamelView.width - 80, 30)];
    _changeNameTF.placeholder = @"";
    _changeNameTF.borderStyle = UITextBorderStyleNone;
    //        _tasteNameTF.keyboardType = UIKeyboardTypeNumberPad;
    [changeNamelView addSubview:_changeNameTF];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(40, _changeNameTF.bottom, changeNamelView.width - 80, 1)];
    lineView2.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [changeNamelView addSubview:lineView2];
    
    
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(40, lineView2.bottom + 9, 80, 40);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleChangeAction) forControlEvents:UIControlEventTouchUpInside];
    [changeNamelView addSubview:cancleButton];
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(changeNamelView.width - 40 - 80, cancleButton.top, cancleButton.width, cancleButton.height);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureChange:) forControlEvents:UIControlEventTouchUpInside];
    [changeNamelView addSubview:sureButton];
    
    [self animateIn];
    
}
- (void)animateIn
{
    self.tanchuView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.tanchuView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.tanchuView.alpha = 1;
        self.tanchuView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)cancleChangeAction
{
    [self.tanchuView removeFromSuperview];
}
- (void)sureChange:(UIButton *)button
{
     [self.tanchuView removeFromSuperview];
    if (self.changeNameTF.text.length == 0) {
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:@"昵称不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        [self presentViewController:nameController animated:YES completion:nil];

    }else
    {
        NSDictionary * jsonDic = nil;
        jsonDic = @{
                    @"Command":@5,
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"DeliveryName":self.changeNameTF.text
                    };
        
        [self playPostWithDictionary:jsonDic];
    }
}
#pragma mark - 修改图片
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
    
    [self uploadImageWithUrlString];
}

- (void)uploadImageWithUrlString
{
    NSString * urlstr = @"http://ceshi.p.vlifee.com/uploadimg.aspx?savetype=100";
    NSString * url = [urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData * imageData = UIImageJPEGRepresentation(self.iconImageView.image, 0.5);
    NSString * imageName = [self imageName];
    NSString * imagePath = [[self getLibarayCachePath] stringByAppendingPathComponent:imageName ];
    [imageData writeToFile:imagePath atomically:YES];
    
    __weak PersonCenterViewController * personVC = self;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:imageName fileName:imagePath mimeType:@"image/jpg/file"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * jsonDic = nil;
        jsonDic = @{
                    @"Command":@10,
                    @"UserId":[UserInfo shareUserInfo].userId,
                    @"UserIcon":[responseObject objectForKey:@"ImgPath"]
                    };
        
        [self playPostWithDictionary:jsonDic];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片添加失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        [self presentViewController:nameController animated:YES completion:nil];
    }];
    
}

- (NSString *)imageName
{
    NSDateFormatter * myFormatter = [[NSDateFormatter alloc]init];
    [myFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString * strTime = [myFormatter stringFromDate:[NSDate date]];
    NSString * name = [NSString stringWithFormat:@"t%@%@%lld%@.png", [UserInfo shareUserInfo].userId, strTime, arc4random() % 9000000000 + 1000000000, [UserInfo shareUserInfo].userName];
    return name;
}

- (NSString *)getLibarayCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", [paths firstObject]);
    return [paths firstObject];
}

#pragma mark - 数据请求
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
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10010]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
        }else if ([command isEqualToNumber:@10005])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            self.nameLabel.text = self.changeNameTF.text;
            
        }
    }else
    {
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        [self presentViewController:nameController animated:YES completion:nil];
    }
    
}
#pragma mark - 修改密码
- (void)changePasswordAction:(UIButton *)button
{
    ChangePasswordViewController * changePasswordVC = [[ChangePasswordViewController alloc]init];
    
    [self.navigationController pushViewController:changePasswordVC animated:YES];
    
}

- (void)exitAction:(UIButton *)button
{
    NSLog(@"退出登录");
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogin"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Pwd"];
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
