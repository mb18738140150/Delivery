//
//  PersonalDataViewController.m
//  MorningMarket
//
//  Created by LiangQiang on 15/12/11.
//  Copyright © 2015年 河南联强电子商务. All rights reserved.
//

#import "PersonalDataViewController.h"

#import "UIImageView+WebCache.h"
@interface PersonalDataViewController ()<UINavigationControllerDelegate , UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePicker;
    UIImage *theImage;
    
    
}
@property (nonatomic , strong)UIImageView *headImage;
@property (nonatomic , strong)UIButton *touxiangButton;
@property (nonatomic , strong)UIButton *userNameButton;
@property (nonatomic , strong)UIButton *nichengButton;
@property (nonatomic , strong)UIButton *genderButton;
@property (nonatomic , strong)UIButton *addressButton;
@property (nonatomic , strong)UIView *blackView;
@property (nonatomic , strong)UILabel *nichengLabeltext;
@property (nonatomic , strong)UILabel *xingbieLabeltext;
@property (nonatomic , strong)UILabel *usernameLabel;
@end
#define kTouxiangkuandu 50
#define kLeft 10
#define kJianTouLeft CGRectGetMaxX(self.headImage.frame)+10
@implementation PersonalDataViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self getPersonData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"个人资料";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
#pragma mark - ******改变返回按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]  ;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:nil];
    

    [self setView];
}
- (void)setView{
    UILabel *touxiangLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeft, 94, 50, 30)];
    touxiangLabel.text = @"头像";
    
    [self.view addSubview:touxiangLabel];
#pragma mark - 头像
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - kTouxiangkuandu - 30, 64 + (90 - kTouxiangkuandu) / 2, kTouxiangkuandu, kTouxiangkuandu)];
    self.headImage.image = [UIImage imageNamed:@"头像"];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = kTouxiangkuandu / 2;
    
    [self.view addSubview:self.headImage];
    
    UILabel *jiantou1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImage.frame)+10, 100, 15, 15)];
    jiantou1.font = [UIFont systemFontOfSize:20];
//    jiantou1.backgroundColor = [UIColor yellowColor];
    jiantou1.text = @">";
    [self.view addSubview:jiantou1];
    
    
    UIView *touxiangxiamianLine = [[UIView alloc]initWithFrame:CGRectMake(0, 154, self.view.frame.size.width, 1)];
    touxiangxiamianLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:touxiangxiamianLine];
    //头像button
    self.touxiangButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.touxiangButton.frame = CGRectMake(0, 64, self.view.frame.size.width, 90);
//    self.touxiangButton.backgroundColor = [UIColor redColor];
    [self.touxiangButton addTarget:self action:@selector(touxiangButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.touxiangButton];
#pragma mark - 用户名
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeft, CGRectGetMaxY(touxiangxiamianLine.frame) + 20, 100, 30)];
    userNameLabel.text = @"用户名";
   
    [self.view addSubview:userNameLabel];
   self.usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake( 110, userNameLabel.frame.origin.y + 7, self.view.frame.size.width - 120, 20)];
    
    self.usernameLabel.font = [UIFont systemFontOfSize:14];
    self.usernameLabel.textColor = [UIColor grayColor];
    self.usernameLabel.textAlignment = NSTextAlignmentRight;
//    self.usernameLabel.text = [LoginYesOrNo shareLoinYesOrNo].userName;
    
    [self.view addSubview:self.usernameLabel];
    
    UIView *yonghumingxiamianLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(userNameLabel.frame) + 20, self.view.frame.size.width, 1)];
    yonghumingxiamianLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:yonghumingxiamianLine];
    //用户名按钮
    self.userNameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.userNameButton.frame = CGRectMake(0, CGRectGetMaxY(touxiangxiamianLine.frame), self.view.frame.size.width, 70);
//    self.userNameButton.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.userNameButton];
    
#pragma mark - 昵称
    UILabel *nichengLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeft, CGRectGetMaxY(yonghumingxiamianLine.frame) + 20, 50, 30)];
    nichengLabel.text = @"昵称";
    [self.view addSubview:nichengLabel];
    self.nichengLabeltext = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nichengLabel.frame), nichengLabel.frame.origin.y + 7, self.view.frame.size.width - 90, 20 )];
    self.nichengLabeltext.textAlignment = NSTextAlignmentRight;
    self.nichengLabeltext.textColor = [UIColor grayColor];
    self.nichengLabeltext.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.nichengLabeltext];
    
    
    UILabel *jiantou3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImage.frame)+10, nichengLabel.frame.origin.y, 15, 30)];
    jiantou3.font = [UIFont systemFontOfSize:20];
    
    jiantou3.text = @">";
    [self.view addSubview:jiantou3];
    UIView *nichengxiamianLine = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nichengLabel.frame) + 20, self.view.frame.size.width, 1)];
    nichengxiamianLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:nichengxiamianLine];
    //昵称按钮
    self.nichengButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.nichengButton.backgroundColor = [UIColor grayColor];
    self.nichengButton.frame = CGRectMake(0, CGRectGetMaxY(yonghumingxiamianLine.frame), self.view.frame.size.width, 70);
    [self.nichengButton addTarget:self action:@selector(nichengButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nichengButton];
#pragma mark - 性别
    UILabel *genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeft, CGRectGetMaxY(nichengxiamianLine.frame) + 20, 50, 30)];
    genderLabel.text = @"性别";
    [self.view addSubview:genderLabel];
    self.xingbieLabeltext = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(genderLabel.frame), genderLabel.frame.origin.y + 7, self.view.frame.size.width - 90, 20 )];
    self.xingbieLabeltext.textAlignment = NSTextAlignmentRight;
    self.xingbieLabeltext.textColor = [UIColor grayColor];
    self.xingbieLabeltext.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.xingbieLabeltext];

    
    UILabel *jiantou4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImage.frame)+10, genderLabel.frame.origin.y, 15, 30)];
    jiantou4.font = [UIFont systemFontOfSize:20];
    
    jiantou4.text = @">";
    [self.view addSubview:jiantou4];
    UIView *genderLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(genderLabel.frame) + 20, self.view.frame.size.width, 1)];
    genderLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:genderLine];
    //性别按钮
    self.genderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.genderButton.frame = CGRectMake(0, CGRectGetMaxY(nichengxiamianLine.frame), self.view.frame.size.width, 70);
//    self.genderButton.backgroundColor = [UIColor brownColor];
    [self.genderButton addTarget:self action:@selector(genderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.genderButton];
#pragma mark - 地址管理
    UILabel *addresslabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeft, CGRectGetMaxY(genderLine.frame) + 20, 100, 30)];
    addresslabel.text = @"地址管理";
    [self.view addSubview:addresslabel];
    
    
    UILabel *jiantou5 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImage.frame)+10, addresslabel.frame.origin.y, 15, 30)];
    jiantou5.font = [UIFont systemFontOfSize:20];
    
    jiantou5.text = @">";
    [self.view addSubview:jiantou5];
    UIView *addressxiamianLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(addresslabel.frame) + 20, self.view.frame.size.width, 1)];
    addressxiamianLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:addressxiamianLine];
    //地址按钮
    self.addressButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.addressButton.frame = CGRectMake(0, CGRectGetMaxY(genderLine.frame), self.view.frame.size.width, 70);
    [self.addressButton addTarget:self action:@selector(addressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.addressButton.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.addressButton];
    
    
    
}
#pragma mark - 性别按钮点击事件
- (void)genderButtonAction
{
//    GenderViewController *genderVC = [[GenderViewController alloc]init];
//    [self.navigationController pushViewController:genderVC animated:YES];
}
#pragma mark - 昵称按钮点击事件
- (void)nichengButtonAction
{
//    NickNameViewController *nickNameVC = [[NickNameViewController alloc]init];
//    [self.navigationController pushViewController:nickNameVC animated:YES];
}
#pragma mark - 管理地址按钮点击事件
- (void)addressButtonAction:(UIButton *)sender
{
//    ShipAddressViewController *shipAddressVC = [[ShipAddressViewController alloc]init];
//    [self.navigationController pushViewController:shipAddressVC animated:YES];
}
- (void)touxiangButtonAction:(UIButton *)sender
{
    self.blackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.blackView .backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    
    [self.view addSubview:self.blackView ];
    UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 150, self.view.frame.size.width - 20, 150)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.alpha = 1;
    backGroundView.layer.masksToBounds = YES;
    backGroundView.layer.cornerRadius = 8;
    [self.blackView  addSubview:backGroundView];
    UIButton *xiangceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    xiangceButton.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 50);
    [xiangceButton  setTitle:@"从相册选择" forState:UIControlStateNormal];
    [xiangceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    xiangceButton.layer.masksToBounds = YES;
    
    xiangceButton.layer.cornerRadius = 5;
    xiangceButton.layer.borderWidth = 0.5;
    xiangceButton.layer.borderColor = [UIColor blackColor].CGColor;
    [backGroundView addSubview:xiangceButton];
#pragma mark - 给相册按钮添加事件
    [xiangceButton addTarget:self action:@selector(xiangceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *paizhaoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    paizhaoButton.frame = CGRectMake(0, 49, self.view.frame.size.width - 20, 50);
    [paizhaoButton  setTitle:@"拍照" forState:UIControlStateNormal];
    [paizhaoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    paizhaoButton.layer.masksToBounds = YES;
    paizhaoButton.backgroundColor = [UIColor whiteColor];
    paizhaoButton.layer.cornerRadius = 5;
    paizhaoButton.layer.borderWidth = 0.5;
    paizhaoButton.layer.borderColor = [UIColor blackColor].CGColor;
    [backGroundView addSubview:paizhaoButton];
#pragma mark - 给拍照按钮添加点击事件
    [paizhaoButton addTarget:self action:@selector(paizhaoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *quxiaoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    quxiaoButton.frame = CGRectMake(0, 98, self.view.frame.size.width - 20, 50);
    [quxiaoButton  setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quxiaoButton.layer.masksToBounds = YES;
    
    quxiaoButton.layer.cornerRadius = 5;
    quxiaoButton.layer.borderWidth = 0.5;
    quxiaoButton.layer.borderColor = [UIColor blackColor].CGColor;
    [backGroundView addSubview:quxiaoButton];
#pragma mark - 给取消按钮添加事件
    [quxiaoButton addTarget:self action:@selector(quxiaoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -  相册按钮事件
- (void)xiangceButtonAction:(UIButton *)sender
{
    [self pickImageFromAlbum];
}
#pragma mark -  取消按钮事件
- (void)quxiaoButtonAction:(UIButton *)sender
{
    [self.blackView setHidden:YES];
    
}
#pragma mark - 拍照按钮事件
- (void)paizhaoButtonAction:(UIButton *)sender
{
    [self pickImageFromCamera];
}
#pragma mark 从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate =self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing =YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma  mark - 从摄像头获取活动图片
- (void)pickImageFromCamera
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - 选择图片结束所调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageNew= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //设置image的尺寸
    CGSize imagesize = imageNew.size;
    imagesize.height =400;
    imagesize.width =600;
    //对图片大小进行压缩--
    imageNew = [self imageWithImageSimple:imageNew scaledToSize:imagesize];
    NSData *imageData = UIImageJPEGRepresentation(imageNew,0.00001);
    if(imageNew !=nil)
    {
        UIImage *imageNew = [UIImage imageWithData:imageData];
        
        self.headImage.image = imageNew;
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
        return ;
    }
}
#pragma mark -  压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
// Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new sizkle
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  // End the context
  UIGraphicsEndImageContext();
  // Return the new image.
return newImage;
}
- (void)upLoadSalesBigImage:(NSString *)bigImage MidImage:(NSString *)midImage SmallImage:(NSString *)smallImage
{
 
 
}
//- (void)getPersonData
//{
////    NSDictionary *userDic = @{@"action":@"perdata",@"buid"  : [LoginYesOrNo shareLoinYesOrNo].uid};
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    [manager POST:@"http://www.959mall.com/appcan_api/perset.php" parameters:userDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSData *data = responseObject;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@" , dic);
//        if (![dic[@"name"] isKindOfClass:[NSNull class]]) {
//            self.nichengLabeltext.text = dic[@"name"];
//        }
//        if (![dic[@"sex"] isKindOfClass:[NSNull class]]) {
//            if ([dic[@"sex"] isEqual:@"1"]) {
//                self.xingbieLabeltext.text =  @"男";
//            }else if ([dic[@"sex"] isEqual:@"2"]){
//                self.xingbieLabeltext.text =  @"女";
//            }else{
//                self.xingbieLabeltext.text =  @"保密";
//            }
//
//        }
//        [self.headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]]];
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"获取个人信息失败");
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
