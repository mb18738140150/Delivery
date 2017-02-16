//
//  OrderDetailController.m
//  Delivery
//
//  Created by 仙林 on 16/1/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "OrderDetailController.h"
#import "Meal.h"
#import "MealPriceView.h"
#import "TotlePriceView.h"
#import "Mapcontroller.h"
#import "MealDetailsView.h"
#import "AMapSearchm.h"
#import "GiveupReasonView.h"

#import "AnimatedAnnotation.h"
#import "AnimatedAnnotationView.h"

#import "UserCenterViewController.h"

#import "ScrollLabelView.h"
#import "orderDetailspopView.h"
// 高德地图
#import "AppDelegate.h"
#import "Toast+UIView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

#define IMAGE_WEIDTH 30
#define LABEL_HEIGHT 30
#define TOP_SPACE 10
#define LEFT_SPACE 10

#define TOTLEVIEW_tag 10000
#define MEALSView_tag 1000
#define SHOPDETAILSView_TAG 2000
#define TIPVIEW_TAG 3000

#define SHOP_ADDRESS_BT_TAG 5000
#define SHOP_PHONE_BT_TAG 4000
#define CUSTOM_PHONT_BT_TAG 6000
#define CUSTOM_ADDRESS_BT_TAG 7000

#define TEXT_COLOR [UIColor colorWithWhite:0.3 alpha:1]
#define ViewWidth [UIScreen mainScreen].bounds.size.width
#define ViewHeight [UIScreen mainScreen].bounds.size.height

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

typedef NS_ENUM(NSInteger, NavigationTypes)
{
    NavigationTypeNone = 0,
    NavigationTypeSimulator, // 模拟导航
    NavigationTypeGPS,       // 实时导航
};

typedef NS_ENUM(NSInteger, TravelTypes)
{
    TravelTypeCar = 0,      // 驾车方式
    TravelTypeWalk,         // 步行方式
};


@interface OrderDetailController ()<HTTPPostDelegate, UIAlertViewDelegate, MAMapViewDelegate, AMapNaviViewControllerDelegate, AMapNaviManagerDelegate, IFlySpeechSynthesizerDelegate>

@property (nonatomic, copy)RefreshBlock myblock;

@property (nonatomic, strong)UIScrollView * scrollview;


// tip
@property (nonatomic, strong)UILabel * tiplabel;

@property (nonatomic, strong)TotlePriceView * totlePriceView;

// scrollLabelView
@property (nonatomic, strong)ScrollLabelView * shopLabelView;
@property (nonatomic, strong)ScrollLabelView * customLabelView;

@property (nonatomic, strong)orderDetailspopView * orderDetailsView;

@property (nonatomic, strong)UILabel * takeFoodLabel;
@property (nonatomic, strong)UIButton * naviBT;

// 高德地图
@property (nonatomic, strong)MAMapView * mapview;
@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic, strong) AMapNaviPoint* startPoint;
@property (nonatomic, strong) AMapNaviPoint* endPoint;

@property (nonatomic) BOOL calRouteSuccess; // 指示是否算路成功
@property (nonatomic)BOOL calRouteFailedCustom;
@property (nonatomic)BOOL calRouteFailedShop;

@property (nonatomic) NavigationTypes naviType;
@property (nonatomic) TravelTypes travelType;

@property (nonatomic, strong)AMapGeocodeSearchResponse * shopRes;
@property (nonatomic, strong)AMapGeocodeSearchResponse * customRes;
@property (nonatomic, strong) AnimatedAnnotation *animatedCustomAnnotation;
@property (nonatomic, strong) AnimatedAnnotation *animatedShopAnnotation;

// 商家版用户版经纬度
@property (nonatomic, assign)CGFloat BusinessLat;
@property (nonatomic, assign)CGFloat BusinessLon;
@property (nonatomic, assign)CGFloat CustomeLat;
@property (nonatomic, assign)CGFloat CustomeLon;


@property (nonatomic, strong)UIView * loadFileView;

@property (nonatomic, strong)UIButton * leftBT;
@property (nonatomic, strong)UIButton * rightBT;

@property (nonatomic, strong)GiveupReasonView * giupReasonView;// 放弃订单原因弹出框
@property (nonatomic, strong)NSNumber * currentOrderState;// 当前订单状态

@property (nonatomic, assign)BOOL orderDetailesLoadSuccess;

@property (nonatomic, assign)BOOL gotoCustom;
@property (nonatomic)BOOL isnavi;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationItem.title = @"地址详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_black.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.orderDetailesLoadSuccess = NO;
     self.travelType = TravelTypeWalk;
    [MAMapServices sharedServices].apiKey = @"11ce5c3cc2c7353240532288a5f63425";
    [AMapSearchServices sharedServices].apiKey = @"11ce5c3cc2c7353240532288a5f63425";
    [AMapNaviServices sharedServices].apiKey =@"11ce5c3cc2c7353240532288a5f63425";
    
    [self createSubViews];
    
    NSDictionary * jsonDic = @{
                               @"Command":@9,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"OrderId":self.orderID,
                               @"BusiId":[UserInfo shareUserInfo].BusiId,
                               @"IsAgent":@([UserInfo shareUserInfo].isAgent)
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    [self addLoadFailedView];
    
    // Do any additional setup after loading the view.
}

- (void)createSubViews
{
    self.gotoCustom = NO;
    self.isnavi = NO;
    self.currentOrderState = @0;
    
    self.shopLabelView = [[ScrollLabelView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 70, 45)];
    self.shopLabelView.iconImageView.image = [UIImage imageNamed:@"shopicon.png"];
    [self.view addSubview:self.shopLabelView];
    
    self.customLabelView = [[ScrollLabelView alloc]initWithFrame:CGRectMake(0, self.shopLabelView.bottom, self.shopLabelView.width, self.shopLabelView.height)];
    self.customLabelView.iconImageView.image = [UIImage imageNamed:@"customicon.png"];
    [self.view addSubview:self.customLabelView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(self.shopLabelView.left + 15, _shopLabelView.bottom, _shopLabelView.width - 15, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:lineView];
    
    UIButton * orderDetailesBT = [UIButton buttonWithType:UIButtonTypeCustom];
    orderDetailesBT.frame = CGRectMake(self.view.width - 70, 0, 70, 90);
    orderDetailesBT.backgroundColor = [UIColor whiteColor];
    [orderDetailesBT setImage:[UIImage imageNamed:@"orderDertailsicon.png"] forState:UIControlStateNormal];
    [orderDetailesBT addTarget:self action:@selector(orderDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderDetailesBT];
    
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"orderDetailspopView" owner:nil options:nil];
    self.orderDetailsView = [objs objectAtIndex:0];
    self.orderDetailsView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 22);
    
    UIView * naviBackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.customLabelView.bottom + 10, self.view.width, 40)];
    naviBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBackView];
    
    self.takeFoodLabel = [[UILabel alloc]initWithFrame:CGRectMake(21, 13, 98, 15)];
    self.takeFoodLabel.font = [UIFont systemFontOfSize:15];
    self.takeFoodLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [naviBackView addSubview:_takeFoodLabel];
    
    self.naviBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _naviBT.frame = CGRectMake(naviBackView.width - 60, 0, 60, 40);
    _naviBT.backgroundColor = MAIN_COLORE;
    [_naviBT setTitle:@"导航" forState:UIControlStateNormal];
    [_naviBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_naviBT addTarget:self action:@selector(naviAction:) forControlEvents:UIControlEventTouchUpInside];
    [naviBackView addSubview:_naviBT];
    
    
    self.mapview = [[MAMapView alloc]initWithFrame:CGRectMake(0, naviBackView.bottom, self.view.width, self.view.height - naviBackView.bottom - 45)];
    self.mapview.delegate = self;
    self.mapview.zoomLevel = 15;
    [self.view addSubview:self.mapview];
    
    self.naviManager = [[AMapNaviManager alloc]init];
    self.naviManager.delegate = self;
    
    if (self.iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
        self.leftBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBT.frame = CGRectMake(0, self.view.height - 64 - 45, self.view.width / 2, 45);
        [self.view addSubview:_leftBT];
        _leftBT.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    [_leftBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_leftBT setTitle:@"拒绝接单" forState:UIControlStateNormal];
    [_leftBT addTarget:self action:@selector(refuseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBT.frame = CGRectMake(_leftBT.right, self.view.height - 64 - 45, self.view.width / 2, 45);
    [self.view addSubview:_rightBT];
    _rightBT.backgroundColor = MAIN_COLORE;
    [_rightBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBT setTitle:@"接受订单" forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    httpPost.commend = [dic objectForKey:@"Command"];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}
- (void)refresh:(id)data
{
    NSLog(@"**%@", [data description]);
    [SVProgressHUD dismiss];
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10009]) {
            [self.loadFileView removeFromSuperview];
            NSDictionary * dic = [data objectForKey:@"OrderDetail"];
            
            self.orderDetailesLoadSuccess = YES;
            [self updateViewWithDic:dic];
            
        }else if ([command isEqualToNumber:@10013])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"接受订单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            if (self.myblock) {
                self.myblock();
            }
            [self updateWithOrderState:[data objectForKey:@"OrderState"] IsTakeFood:[data objectForKey:@"IsTakeFood"]];
        }else if ([command isEqualToNumber:@10007])
        {
            if ([self.rightBT.titleLabel.text isEqualToString:@"确认送达"] ) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认送达成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始配送成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            }
            if (self.myblock) {
                self.myblock();
            }
            [self updateWithOrderState:[data objectForKey:@"OrderState"] IsTakeFood:@0];
        }else if ([command isEqualToNumber:@10011])
        {
            
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"放弃订单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            
            if (self.myblock) {
                self.myblock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([command isEqualToNumber:@10012])
        {
            if (self.myblock) {
                self.myblock();
            }
            NSLog(@"取货成功");
            [self updateWithOrderState:[data objectForKey:@"OrderState"] IsTakeFood:[data objectForKey:@"IsTakeFood"]];
        }else if ([command isEqualToNumber:@10014])
        {
            
            NSLog(@"拒绝接单成功");
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拒绝接单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            
            if (self.myblock) {
                self.myblock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else
    {
        
        UIAlertController * nameController = [UIAlertController alertControllerWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [nameController addAction:cancleAction];
        [self presentViewController:nameController animated:YES completion:nil];
        
        
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber: @10009]) {
//            [self showLoadFailImage];
            self.orderDetailesLoadSuccess = NO;
        }
        
    }
}
- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        if ([[error.userInfo objectForKey:@"Command"] intValue] == 9) {
//            [self showLoadFailImage];
            self.orderDetailesLoadSuccess = NO;
        }
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }

    NSLog(@"%@", error);
}

- (void)updateWithOrderState:(NSNumber *)orderState IsTakeFood:(NSNumber *)isTakeFood
{
    self.currentOrderState = orderState;
    
    switch ([orderState intValue]) {
        case 1:
            [_rightBT addTarget:self action:@selector(robAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            
            if ([isTakeFood intValue] == 1) {
                self.leftBT.hidden = YES;
                self.rightBT.frame = CGRectMake(0, _rightBT.top, self.view.width, _rightBT.height);
                [self.rightBT setTitle:@"开始配送" forState:UIControlStateNormal];
            }else if ([isTakeFood intValue] == 2)
            {
                [_rightBT removeTarget:self action:@selector(robAction:) forControlEvents:UIControlEventTouchUpInside];
                self.leftBT.hidden = NO;
                [self.leftBT setTitle:@"放弃订单" forState:UIControlStateNormal];
                [self.rightBT setTitle:@"到达商家处" forState:UIControlStateNormal];
            }
            [self.rightBT addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        case 3:
            if (self.deliveried == 1) {
                self.leftBT.hidden = YES;
                [self.rightBT setTitle:@"已完成" forState:UIControlStateNormal];
                self.rightBT.frame = CGRectMake(0, _rightBT.top, self.view.width, _rightBT.height);
                [self.rightBT addTarget:self action:@selector(complateAction:) forControlEvents:UIControlEventTouchUpInside];
            }else
            {
                
                self.gotoCustom = YES;
                self.leftBT.hidden = YES;
                [_rightBT removeTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
                self.rightBT.frame = CGRectMake(0, _rightBT.top, self.view.width, _rightBT.height);
                [self.rightBT setTitle:@"确认送达" forState:UIControlStateNormal];
                [self.rightBT addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
                
                NSString * str = [NSString stringWithFormat:@"去%@送货", self.customLabelView.addressLabel.text];
                NSMutableAttributedString * strATT = [[NSMutableAttributedString alloc]initWithString:str];
                [strATT setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:MAIN_COLORE} range:NSMakeRange(1, str.length - 3)];
                self.takeFoodLabel.attributedText = strATT;
                CGSize takefoodlabelSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.takeFoodLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                self.takeFoodLabel.width = takefoodlabelSize.width;
                
                if (self.takeFoodLabel.width >= self.view.width - 100) {
                    self.takeFoodLabel.width = self.view.width - 100;
                    self.takeFoodLabel.adjustsFontSizeToFitWidth = YES;
                }
                
            }
            
            break;
        case 4:
        {
            NSString * str = [NSString stringWithFormat:@"去%@送货(已完成)", self.customLabelView.addressLabel.text];
            NSMutableAttributedString * strATT = [[NSMutableAttributedString alloc]initWithString:str];
            [strATT setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:MAIN_COLORE} range:NSMakeRange(1, str.length - 8)];
            self.takeFoodLabel.attributedText = strATT;
            CGSize takefoodlabelSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.takeFoodLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            self.takeFoodLabel.width = takefoodlabelSize.width;
            
            if (self.takeFoodLabel.width >= self.view.width - 100) {
                self.takeFoodLabel.width = self.view.width - 100;
                self.takeFoodLabel.adjustsFontSizeToFitWidth = YES;
            }
            self.leftBT.hidden = YES;
            [self.rightBT setTitle:@"已完成" forState:UIControlStateNormal];
            self.rightBT.frame = CGRectMake(0, _rightBT.top, self.view.width, _rightBT.height);
            [self.rightBT addTarget:self action:@selector(complateAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            
            
            break;
        default:
            break;
    }
}

- (void)updateViewWithDic:(NSDictionary *)dic
{
    
    UIView * mealView = [_scrollview viewWithTag:MEALSView_tag];
    UIView * shopDetailsView = [_scrollview viewWithTag:SHOPDETAILSView_TAG];
    UIView * tipView = [_scrollview viewWithTag:TIPVIEW_TAG];
    
    self.customLabelView.addressStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerAddress"]];
    self.shopLabelView.addressStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"BusiAddress"]];
    
    NSString * str = [NSString stringWithFormat:@"去%@取货", [dic objectForKey:@"BusiName"]];
    NSMutableAttributedString * strATT = [[NSMutableAttributedString alloc]initWithString:str];
    [strATT setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:MAIN_COLORE} range:NSMakeRange(1, str.length - 3)];
    self.takeFoodLabel.attributedText = strATT;
    CGSize takefoodlabelSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.takeFoodLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.takeFoodLabel.width = takefoodlabelSize.width;
    
    [self.orderDetailsView createWithDic:dic];
    
    self.currentOrderState = [dic objectForKey:@"OrderState"];
        switch ([[dic objectForKey:@"OrderState"] intValue]) {
            case 1:
                [_rightBT addTarget:self action:@selector(robAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                if ([[dic objectForKey:@"IsTakeFood"] intValue] == 1) {
                    self.leftBT.hidden = YES;
                    self.rightBT.frame = CGRectMake(0, _rightBT.top, self.view.width, _rightBT.height);
                    [self.rightBT setTitle:@"开始配送" forState:UIControlStateNormal];
                }else
                {
                    self.leftBT.hidden = NO;
                    [self.leftBT setTitle:@"放弃订单" forState:UIControlStateNormal];
                    [self.rightBT setTitle:@"到达商家处" forState:UIControlStateNormal];
                }
                
                [self.rightBT addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            case 3:
                if (self.deliveried == 1) {
//                    self.sendState.text = @"已配送";
                    
                    NSString * str = [NSString stringWithFormat:@"去%@送货(已完成)", [dic objectForKey:@"CustomerAddress"]];
                    NSMutableAttributedString * strATT = [[NSMutableAttributedString alloc]initWithString:str];
                    [strATT setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:MAIN_COLORE} range:NSMakeRange(1, str.length - 8)];
                    self.takeFoodLabel.attributedText = strATT;
                    CGSize takefoodlabelSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.takeFoodLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                    self.takeFoodLabel.width = takefoodlabelSize.width;
                    
                    if (self.takeFoodLabel.width >= self.view.width - 100) {
                        self.takeFoodLabel.width = self.view.width - 100;
                        self.takeFoodLabel.adjustsFontSizeToFitWidth = YES;
                    }
                    
                    self.leftBT.hidden = YES;
                    [self.rightBT setTitle:@"已完成" forState:UIControlStateNormal];
                    self.rightBT.frame = CGRectMake(0, _rightBT.top, self.view.width, _rightBT.height);
                    [self.rightBT addTarget:self action:@selector(complateAction:) forControlEvents:UIControlEventTouchUpInside];
                }else
                {
                    self.gotoCustom = YES;
//                    self.sendState.text = @"配送中";
                    self.leftBT.hidden = YES;
                    self.rightBT.frame = CGRectMake(0, _rightBT.top, self.view.width, _rightBT.height);
                    [self.rightBT setTitle:@"确认送达" forState:UIControlStateNormal];
                    [self.rightBT addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    NSString * str = [NSString stringWithFormat:@"去%@送货", [dic objectForKey:@"CustomerAddress"]];
                    NSMutableAttributedString * strATT = [[NSMutableAttributedString alloc]initWithString:str];
                    [strATT setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:MAIN_COLORE} range:NSMakeRange(1, str.length - 3)];
                    self.takeFoodLabel.attributedText = strATT;
                    CGSize takefoodlabelSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.takeFoodLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                    self.takeFoodLabel.width = takefoodlabelSize.width;
                    
                    if (self.takeFoodLabel.width >= self.view.width - 100) {
                        self.takeFoodLabel.width = self.view.width - 100;
                        self.takeFoodLabel.adjustsFontSizeToFitWidth = YES;
                    }
                    
                }
    
                break;
                case 4:
            {
                NSString * str = [NSString stringWithFormat:@"去%@送货(已完成)", [dic objectForKey:@"CustomerAddress"]];
                NSMutableAttributedString * strATT = [[NSMutableAttributedString alloc]initWithString:str];
                [strATT setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:MAIN_COLORE} range:NSMakeRange(1, str.length - 8)];
                self.takeFoodLabel.attributedText = strATT;
                CGSize takefoodlabelSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.takeFoodLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                self.takeFoodLabel.width = takefoodlabelSize.width;
                
                if (self.takeFoodLabel.width >= self.view.width - 100) {
                    self.takeFoodLabel.width = self.view.width - 100;
                    self.takeFoodLabel.adjustsFontSizeToFitWidth = YES;
                }
                
                self.leftBT.hidden = YES;
                [self.rightBT setTitle:@"已完成" forState:UIControlStateNormal];
                self.rightBT.frame = CGRectMake(0, _rightBT.top, self.view.width, _rightBT.height);
                [self.rightBT addTarget:self action:@selector(complateAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            default:
                break;
        }
    
    self.BusinessLat = [[dic objectForKey:@"BusinessLat"] floatValue];
    self.BusinessLon = [[dic objectForKey:@"BusinessLon"] floatValue];
    self.CustomeLat = [[dic objectForKey:@"CustomeLat"] floatValue];
    self.CustomeLon = [[dic objectForKey:@"CustomeLon"] floatValue];
    
    // 更新地图
    [self getCoorDinate];
    
}

#pragma mark - 加载失败显示图
- (void)addLoadFailedView
{
    self.loadFileView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    UIImageView * loadFiledImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.loadFileView.width, self.loadFileView.height)];
    loadFiledImageView.image = [UIImage imageNamed:@"loadFailed.png"];
    loadFiledImageView.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    [self.loadFileView addSubview:loadFiledImageView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.loadFileView.centerX - 50, self.loadFileView.centerY + 50, 100, 50);
    [button setTitle:@"点击从新加载" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadDataAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loadFileView addSubview:button];

}
- (void)showLoadFailImage
{
    [self.view addSubview:self.loadFileView];
}

- (void)loadDataAction:(UIButton * )button
{
    NSDictionary * jsonDic = @{
                               @"Command":@9,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"OrderId":self.orderID,
                               @"BusiId":[UserInfo shareUserInfo].BusiId,
                               @"IsAgent":@([UserInfo shareUserInfo].isAgent)
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - 订单详情弹出框
- (void)orderDetailsAction:(UIButton * )button
{
    if (self.orderDetailesLoadSuccess) {
        NSLog(@"弹出订单详情");
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        
        self.orderDetailsView.frame = CGRectMake(0, self.customLabelView.bottom + 10, ViewWidth, ViewHeight - 22);
        self.orderDetailsView.alpha = 0;
        [delegate.window addSubview:self.orderDetailsView];
        [UIView animateWithDuration:.5 animations:^{
            self.orderDetailsView.frame = CGRectMake(0, 22, ViewWidth, ViewHeight - 22);
            self.orderDetailsView.alpha = 1;
        } completion:^(BOOL finished) {
            [self.orderDetailsView calculate];
        }];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单信息加载失败， 暂无法查看订单详情" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark - 订单处理

- (void)refuseAction:(UIButton *)button
{
    
    if ([UserInfo shareUserInfo].isOpenthebackgroundposition) {
        if ([button.titleLabel.text isEqualToString:@"拒绝接单"])
        {
            NSLog(@"拒绝接单");
            NSDictionary * jsonDic = @{
                                       @"Command":@14,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"OrderId":self.orderID
                                       };
            [self playPostWithDictionary:jsonDic];
            
        }else
        {
            NSLog(@"放弃订单");
            
            if (self.giupReasonView) {
                __weak OrderDetailController * orderVC = self;
                [self.giupReasonView giveuporder:^(NSString *reasonStr) {
                    ;
                    
                    NSLog(@"***%@", reasonStr);
                    NSDictionary * jsonDic = @{
                                               @"Command":@11,
                                               @"UserId":[UserInfo shareUserInfo].userId,
                                               @"Reason":reasonStr,
                                               @"OrderId":self.orderID
                                               };
                    [orderVC playPostWithDictionary:jsonDic];
                }];
                [self.giupReasonView show];
            }else
            {
                
                NSBundle *bundle=[NSBundle mainBundle];
                NSArray *objs=[bundle loadNibNamed:@"GiveupReasonView" owner:nil options:nil];
                self.giupReasonView = [objs objectAtIndex:0];
                self.giupReasonView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                __weak OrderDetailController * orderVC = self;
                [self.giupReasonView giveuporder:^(NSString *reasonStr) {
                    ;
                    NSLog(@"***%@", reasonStr);
                    NSDictionary * jsonDic = @{
                                               @"Command":@11,
                                               @"UserId":[UserInfo shareUserInfo].userId,
                                               @"Reason":reasonStr,
                                               @"OrderId":self.orderID
                                               };
                    [orderVC playPostWithDictionary:jsonDic];
                }];
                [self.giupReasonView show];
            }
            
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在设置界面开启实时定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }
    
}

- (void)robAction:(UIButton *)button
{
    NSLog(@"接受订单");
    if ([UserInfo shareUserInfo].isOpenthebackgroundposition) {
        NSDictionary * jsonDic = @{
                                   @"Command":@13,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"OrderId":self.orderID
                                   };
        [self playPostWithDictionary:jsonDic];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在设置界面开启实时定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }
}
- (void)deliveryAction:(UIButton *)button
{
    NSLog(@"待配送");
    if ([UserInfo shareUserInfo].isOpenthebackgroundposition) {
        
        if ([button.titleLabel.text isEqualToString:@"到达商家处"]) {
            NSLog(@"到达商家处");
//            [button setTitle:@"开始配送" forState:UIControlStateNormal];
            
            NSDictionary * jsonDic = @{
                                       @"Command":@12,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"OrderId":self.orderID,
                                       };
            [self playPostWithDictionary:jsonDic];
            
        }else{
            NSLog(@"开始配送");
            NSDictionary * jsonDic = @{
                                       @"Command":@7,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"OrderId":self.orderID,
                                       @"SendStateType":@1
                                       };
            [self playPostWithDictionary:jsonDic];
        }
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在设置界面开启实时定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }
}

- (void)sureAction:(UIButton *)button
{
   
    NSLog(@"确认送达");
    if ([UserInfo shareUserInfo].isOpenthebackgroundposition) {
        NSDictionary * jsonDic = @{
                                   @"Command":@7,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"OrderId":self.orderID,
                                   @"SendStateType":@2
                                   };
        [self playPostWithDictionary:jsonDic];
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在设置界面开启实时定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ;
    }else
    {
        UserCenterViewController * userVC = [[UserCenterViewController alloc]init];
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

#pragma mark - 拨打电话
//- (void)telToOrderTelNumber:(UIButton *)button
//{
//    if (button.tag == CUSTOM_PHONT_BT_TAG) {
//        NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.phoneLabel.text]);
//        UIWebView *callWebView = [[UIWebView alloc]init];
//        NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneLabel.text]];
//        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
//        [self.view addSubview:callWebView];
//    }else
//    {
//        NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.phoneLabelshop.text]);
//        UIWebView *callWebView = [[UIWebView alloc]init];
//        NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneLabelshop.text]];
//        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
//        [self.view addSubview:callWebView];
//    }
//    
//}

#pragma mark - 获取地图数据信息
- (void)getCoorDinate
{
    if (self.CustomeLon != 0.0 && self.CustomeLat != 0.0) {
        [UserLocation shareLocation].searchCoordinate = CLLocationCoordinate2DMake(self.CustomeLat, self.CustomeLon);
        [self getShopCoordinate];
    }else
    {
        __weak OrderDetailController * orderVC = self;
        [[AMapSearchm shareSearch]getCoordinateWithAddress:orderVC.customLabelView.addressLabel.text complate:^(AMapGeocodeSearchResponse *response) {
            AMapGeocode * geoCode = [response.geocodes objectAtIndex:0];
            [UserLocation shareLocation].searchCoordinate = CLLocationCoordinate2DMake(geoCode.location.latitude, geoCode.location.longitude);
            
            NSLog(@"用户获取成功");
            orderVC.customRes = response;
            [orderVC getShopCoordinate];
        } failed:^{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取用户位置信息失败，请从新点击获取" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:2];
            [orderVC getShopCoordinate];
        }];
    }
    
}
- (void)getShopCoordinate
{
    if (self.BusinessLon != 0.0 && self.BusinessLat != 0.0) {
        [UserLocation shareLocation].shopSearchCoordinate = CLLocationCoordinate2DMake(self.BusinessLat, self.BusinessLon);
        
        [self initNaviPoints];
        [self initAnnotations];
        [self calculateWalkRout];
        
        [self addAnimateAnnotation];
        
    }else
    {
        __weak OrderDetailController * orderVC = self;
        [[AMapSearchm shareSearch] getCoordinateWithAddress:self.shopLabelView.addressLabel.text complate:^(AMapGeocodeSearchResponse *response) {
            AMapGeocode * geoCode = [response.geocodes objectAtIndex:0];
            [UserLocation shareLocation].shopSearchCoordinate = CLLocationCoordinate2DMake(geoCode.location.latitude, geoCode.location.longitude);
            NSLog(@"商家获取成功");
            orderVC.shopRes = response;
            [orderVC initNaviPoints];
            [orderVC initAnnotations];
            [orderVC calculateWalkRout];
            
            [orderVC addAnimateAnnotation];
            
        } failed:^{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取商家位置信息失败，请从新点击获取" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:2];
        }];
    }
}

#pragma mark - 添加位置图片

- (void)addAnimateAnnotation
{
    [self addshopAnnotation];
    [self addCustomAnnotation];
}
- (void)addshopAnnotation
{
    NSMutableArray * shopArr = [[NSMutableArray alloc]init];
    [shopArr addObject:[UIImage imageNamed:@"商家.png"]];
    
    self.animatedShopAnnotation = [[AnimatedAnnotation alloc]initWithCoordinate:[UserLocation shareLocation].shopSearchCoordinate];
    self.animatedShopAnnotation.animatedImages = shopArr;
    self.animatedShopAnnotation.title = @"商家";
    
    [self.mapview addAnnotation:self.animatedShopAnnotation];
    
}
- (void)addCustomAnnotation
{
    NSMutableArray * shopArr = [[NSMutableArray alloc]init];
    [shopArr addObject:[UIImage imageNamed:@"客户.png"]];
    self.animatedCustomAnnotation = [[AnimatedAnnotation alloc]initWithCoordinate:[UserLocation shareLocation].searchCoordinate];
    self.animatedCustomAnnotation.animatedImages = shopArr;
    self.animatedCustomAnnotation.title = @"用户";
    
    [self.mapview addAnnotation:self.animatedCustomAnnotation];
}
#pragma mark - 地图
// 计算路径
- (void)calculateWalkRout
{
    NSArray *startPoints = @[self.startPoint];
    NSArray *endPoints   = @[self.endPoint];
    
    
    if (self.travelType == TravelTypeCar)
    {
        [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyDefault];
    }
    else
    {
        [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
    }
}

// 客户路径规划
- (void)initNaviPoints
{
    self.startPoint = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].coordinate2D.latitude longitude:[UserLocation shareLocation].coordinate2D.longitude];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].searchCoordinate.latitude longitude:[UserLocation shareLocation].searchCoordinate.longitude];
    
}
- (void)initAnnotations
{
    NavPointAnnotation *beginAnnotation = [[NavPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    beginAnnotation.title        = @"起始点";
    beginAnnotation.navPointType = NavPointAnnotationStart;
    
    [self.mapview addAnnotation:beginAnnotation];
    
    NavPointAnnotation *endAnnotation = [[NavPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
    endAnnotation.title        = @"用户";
    endAnnotation.navPointType = NavPointAnnotationEnd;
    
//    [self.mapview addAnnotation:endAnnotation];
//    [self.mapview selectAnnotation:endAnnotation animated:YES];
    [self.mapview setCenterCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    
}
// 商家路径规划
- (void)initNaviPointsShop
{
    self.startPoint = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].coordinate2D.latitude longitude:[UserLocation shareLocation].coordinate2D.longitude];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].shopSearchCoordinate.latitude longitude:[UserLocation shareLocation].shopSearchCoordinate.longitude];
    NSLog(@"%f***%f",self.endPoint.latitude,  [UserLocation shareLocation].shopSearchCoordinate.latitude);
    NSLog(@"商家 *** JJJJJ");
}
- (void)initAnnotationsShop
{
    NavPointAnnotation *beginAnnotation = [[NavPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    beginAnnotation.title        = @"起始点";
    beginAnnotation.navPointType = NavPointAnnotationStart;
    
    [self.mapview addAnnotation:beginAnnotation];
    
    NavPointAnnotation *endAnnotation = [[NavPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
    endAnnotation.title        = @"商家";
    endAnnotation.navPointType = NavPointAnnotationEnd;
    
//    [self.mapview addAnnotation:endAnnotation];
//    [self.mapview selectAnnotation:endAnnotation animated:YES];
    [self.mapview setCenterCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    
}

#pragma mark - 高德地图
- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil)
    {
        return;
    }
    
    // 清除旧的overlays
    //    [self.mapview removeOverlays:self.mapview.overlays];
    
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.mapview addOverlay:polyline];
}
#pragma mark - AMapNaviManager Delegate
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
    _calRouteSuccess = YES;
    
//    NSLog(@"%f***%f",self.endPoint.latitude,  [UserLocation shareLocation].shopSearchCoordinate.latitude);
    
    if (self.endPoint.latitude != [UserLocation shareLocation].shopSearchCoordinate.latitude) {
        if (self.gotoCustom && self.isnavi) {
            ;
        }else
        {
            [self initNaviPointsShop];
            [self initAnnotationsShop];
            [self calculateWalkRout];
        }
    }
}
- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error;
{
    NSLog(@"路径规划失败");
    _calRouteSuccess = NO;
    if (self.endPoint.latitude != [UserLocation shareLocation].shopSearchCoordinate.latitude) {
        self.calRouteFailedCustom = YES;
        [self.view makeToast:@"客户路径规划失败"
                    duration:2.0
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 240)]];
        [self initNaviPointsShop];
        [self initAnnotationsShop];
        [self calculateWalkRout];
    }else
    {
        self.calRouteFailedShop = YES;
        [self.view makeToast:@"商家路径规划失败"
                    duration:2.0
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 240)]];
    }
}
- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error
{
    NSLog(@"error:{%@}",error.localizedDescription);
}
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    //    [super naviManager:naviManager didPresentNaviViewController:naviViewController];
    
    if (self.naviType == NavigationTypeGPS)
    {
        [self.naviManager startGPSNavi];
    }
    else if (self.naviType == NavigationTypeSimulator)
    {
        [self.naviManager startEmulatorNavi];
    }
}

- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController
{
    //    [super naviManager:naviManager didDismissNaviViewController:naviViewController];
}

- (void)naviManagerNeedRecalculateRouteForYaw:(AMapNaviManager *)naviManager
{
    NSLog(@"NeedReCalculateRouteForYaw");
}
- (void)naviManager:(AMapNaviManager *)naviManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager
{
    NSLog(@"DidEndEmulatorNavi");
}

- (void)naviManagerOnArrivedDestination:(AMapNaviManager *)naviManager
{
    NSLog(@"OnArrivedDestination");
}

- (void)naviManager:(AMapNaviManager *)naviManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint");
}
- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation
{
    //    NSLog(@"didUpdateNaviLocation");
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviInfo:(AMapNaviInfo *)naviInfo
{
    //    NSLog(@"didUpdateNaviInfo");
}

- (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager
{
    //    NSLog(@"GetSoundPlayState");
    
    return 0;
}
- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    if (soundStringType == AMapNaviSoundTypePassedReminder)
    {
        //用系统自带的声音做简单例子，播放其他提示音需要另外配置
        AudioServicesPlaySystemSound(1009);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [_iFlySpeechSynthesizer startSpeaking:soundString];
        });
    }
}

- (void)naviManagerDidUpdateTrafficStatuses:(AMapNaviManager *)naviManager
{
    NSLog(@"DidUpdateTrafficStatuses");
}

#pragma mark - AManNaviViewController Delegate

- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviType != NavigationTypeNone)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self.iFlySpeechSynthesizer stopSpeaking];
        });
        
        [self.naviManager stopNavi];
    }
    
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}

- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
}

- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    [self.naviManager readNaviInfoManual];
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NavPointAnnotation class]]) {
        static NSString * annotationIdentifier = @"annotationIdentifier";
        
        MAPinAnnotationView * pointAnnotationView = (MAPinAnnotationView*)[self.mapview dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil) {
            pointAnnotationView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        
        pointAnnotationView.animatesDrop = NO;
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.draggable = NO;
        
        NavPointAnnotation * navAnnotation = (NavPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NavPointAnnotationStart) {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
        }else if (navAnnotation.navPointType == NavPointAnnotationEnd)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
        }
        return pointAnnotationView;
    }else if ([annotation isKindOfClass:[AnimatedAnnotation class]])
    {
        static NSString *animatedAnnotationIdentifier = @"AnimatedAnnotationIdentifier";
        
        AnimatedAnnotationView * annotationView = (AnimatedAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:animatedAnnotationIdentifier];
        if (annotationView == nil) {
            annotationView = [[AnimatedAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:animatedAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            annotationView.draggable = NO;
        }
        
        return annotationView;
    }
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineView * polylineView = [[MAPolylineView alloc]initWithPolyline:overlay];
        polylineView.lineWidth = 5.0f;
        polylineView.strokeColor = [UIColor redColor];
        if (self.endPoint.latitude != [UserLocation shareLocation].shopSearchCoordinate.latitude) {
            polylineView.strokeColor = [UIColor blueColor];
        }
        return polylineView;
    }
    return nil;
}

#pragma mark - 导航
- (void)naviAction:(UIButton *)button
{
    if (self.currentOrderState.intValue == 4) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单已完成" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else
    {
        
        // 去用户
        if (self.gotoCustom) {
            if (self.calRouteFailedCustom) {
                [self.view makeToast:@"用户路径规划失败，暂不能导航"
                            duration:2.0
                            position:[NSValue valueWithCGPoint:CGPointMake(160, 240)]];
            }else
            {
                self.isnavi = YES;
                self.startPoint = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].coordinate2D.latitude longitude:[UserLocation shareLocation].coordinate2D.longitude];
                self.endPoint   = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].searchCoordinate.latitude longitude:[UserLocation shareLocation].searchCoordinate.longitude];
                
                NSArray *startPoints = @[self.startPoint];
                NSArray *endPoints   = @[self.endPoint];
                [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
                
                self.naviType = NavigationTypeGPS;
                AMapNaviViewController * naviViewController = [[AMapNaviViewController alloc]initWithDelegate:self];
                
                [self.naviManager presentNaviViewController:naviViewController animated:YES];
                
            }
        }else
        {
            if (self.calRouteFailedShop) {
                [self.view makeToast:@"商家路径规划失败，暂不能导航"
                            duration:2.0
                            position:[NSValue valueWithCGPoint:CGPointMake(160, 240)]];
            }else
            {
                self.startPoint = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].coordinate2D.latitude longitude:[UserLocation shareLocation].coordinate2D.longitude];
                self.endPoint   = [AMapNaviPoint locationWithLatitude:[UserLocation shareLocation].shopSearchCoordinate.latitude longitude:[UserLocation shareLocation].shopSearchCoordinate.longitude];
                
                NSArray *startPoints = @[self.startPoint];
                NSArray *endPoints   = @[self.endPoint];
                [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
                self.naviType = NavigationTypeGPS;
                AMapNaviViewController * naviViewController = [[AMapNaviViewController alloc]initWithDelegate:self];
                
                [self.naviManager presentNaviViewController:naviViewController animated:YES];
            }
        }
        
    }
    
}


#pragma mark - iFlySpeechSynthesizer Delegate

- (void)onCompleted:(IFlySpeechError *)error
{
    NSLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData:(RefreshBlock)block
{
    self.myblock = [block copy];
}

- (void)complateAction:(UIButton *)button
{
    NSLog(@"清空地图路线");
//    [self.mapview removeOverlays:self.mapview.overlays];
}

- (void)dealloc
{
    self.giupReasonView = nil;
    NSLog(@"****giupReasonView 消失" );
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
