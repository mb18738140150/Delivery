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

#define IMAGE_WEIDTH 30
#define LABEL_HEIGHT 30
#define TOP_SPACE 10
#define LEFT_SPACE 10

#define TOTLEVIEW_tag 10000
#define MEALSView_tag 1000
#define SHOPDETAILSView_TAG 2000
#define TIPVIEW_TAG 3000

#define SHOP_PHONE_BT_TAG 4000
#define SHOP_ADDRESS_BT_TAG 5000
#define CUSTOM_PHONT_BT_TAG 6000
#define CUSTOM_ADDRESS_BT_TAG 7000

#define TEXT_COLOR [UIColor colorWithWhite:0.3 alpha:1]
@interface OrderDetailController ()<HTTPPostDelegate>

@property (nonatomic, strong)UIScrollView * scrollview;

// 用户信息
@property (nonatomic, strong)UIImageView * addressImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * phoneLabel;
@property (nonatomic, strong)UIButton *phoneBT;
@property (nonatomic, strong)UILabel * payStateLabel;
@property (nonatomic, strong)UILabel * addressLabel;
// 菜品
@property (nonatomic, strong)UILabel * remarkLabel;
// 赠品
@property (nonatomic, strong)UILabel * giftLabel;
// 商家
@property (nonatomic, strong)UIImageView * addressImageViewshop;
@property (nonatomic, strong)UILabel * nameLabelshop;
@property (nonatomic, strong)UILabel * phoneLabelshop;
@property (nonatomic, strong)UIButton * phoneBTshop;
@property (nonatomic, strong)UILabel * addressLabelshop;

// tip
@property (nonatomic, strong)UILabel * tiplabel;

@property (nonatomic, strong)TotlePriceView * totlePriceView;


@property (strong, nonatomic) IBOutlet UIScrollView *myScrollview;
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UIView *businessView;
@property (strong, nonatomic) IBOutlet UILabel *storeNameLB;
@property (strong, nonatomic) IBOutlet UILabel *sendState;
@property (strong, nonatomic) IBOutlet UILabel *payTypeLB;
@property (strong, nonatomic) IBOutlet UIView *storeLIne1;
@property (strong, nonatomic) IBOutlet UIView *storeLine2;
@property (strong, nonatomic) IBOutlet UILabel *storePhoneNumberLB;
@property (strong, nonatomic) IBOutlet UIImageView *storeAddressIcon;
@property (strong, nonatomic) IBOutlet UILabel *storeAddressLB;

@property (strong, nonatomic) IBOutlet UIView *customerView;
@property (strong, nonatomic) IBOutlet UILabel *customNameLB;
@property (strong, nonatomic) IBOutlet UILabel *customPhoneNumberLB;
@property (strong, nonatomic) IBOutlet UILabel *sendTimeLB;
@property (strong, nonatomic) IBOutlet UILabel *sendtimelabel;
@property (strong, nonatomic) IBOutlet UIView *customLine1;
@property (strong, nonatomic) IBOutlet UIView *customLine2;
@property (strong, nonatomic) IBOutlet UIImageView *customAddressIcon;
@property (strong, nonatomic) IBOutlet UILabel *customAddressLB;


@property (strong, nonatomic) IBOutlet UIView *mealDetailsView;
@property (strong, nonatomic) IBOutlet UILabel *payStateLB;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.scrollview= [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollview.height = self.view.height - 64 - 60;
    _scrollview.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [self.view addSubview:_scrollview];
    
    
    // 用户信息
    UIView * totleView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE, self.view.width, 100)];
    totleView.backgroundColor = [UIColor whiteColor];
    totleView.tag = TOTLEVIEW_tag;
    [_scrollview addSubview:totleView];
    
    self.addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 3, IMAGE_WEIDTH, IMAGE_WEIDTH)];
    _addressImageView.image = [UIImage imageNamed:@"location_order.png"];
    [totleView addSubview:_addressImageView];
    
    UIButton * addressBt = [UIButton buttonWithType:UIButtonTypeSystem];
    addressBt.frame = _addressImageView.frame;
    addressBt.backgroundColor = [UIColor clearColor];
//    addressBt.tag = CUSTOM_ADDRESS_BT_TAG;
    [addressBt addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    [totleView addSubview:addressBt];
    
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageView.right + LEFT_SPACE, TOP_SPACE, 60, LABEL_HEIGHT)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.text = @"集散地附近吧";
    [totleView addSubview:_nameLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_nameLabel.right, 15, 1, 20)];
    line1.backgroundColor = [UIColor grayColor];
    line1.tag = 10001;
    [totleView addSubview:line1];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right + 1, TOP_SPACE, 90, LABEL_HEIGHT)];
    _phoneLabel.text = @"18734890150";
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.adjustsFontSizeToFitWidth = YES;
    [totleView addSubview:_phoneLabel];
    
    self.phoneBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _phoneBT.frame = _phoneLabel.frame;
    _phoneBT.backgroundColor = [UIColor clearColor];
    _phoneBT.tag = CUSTOM_PHONT_BT_TAG;
    [_phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [totleView addSubview:_phoneBT];
    
    
    self.payStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - LEFT_SPACE - 80 , TOP_SPACE, 80, LABEL_HEIGHT)];
    _payStateLabel.layer.cornerRadius = 5;
    _payStateLabel.layer.masksToBounds = YES;
    _payStateLabel.layer.borderWidth = 1;
    _payStateLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _payStateLabel.textAlignment = NSTextAlignmentCenter;
    _payStateLabel.text = @"现金支付";
    _payStateLabel.textColor = MAIN_COLORE;
    [totleView addSubview:_payStateLabel];
    
    if (self.view.width >= 370) {
        self.nameLabel.frame = CGRectMake(_addressImageView.right + LEFT_SPACE, TOP_SPACE, 80, LABEL_HEIGHT);
        line1.frame = CGRectMake(_nameLabel.right, _nameLabel.top - 5, 1, 20);
        self.phoneLabel.frame = CGRectMake(line1.right, TOP_SPACE, 100, LABEL_HEIGHT);
        self.payStateLabel.frame = CGRectMake(self.view.width - LEFT_SPACE - 90 , TOP_SPACE, 90, LABEL_HEIGHT);
    }
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageView.right + LEFT_SPACE, _nameLabel.bottom , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT + 10)];
    _addressLabel.textColor = [UIColor grayColor];
    _addressLabel.text = @"未来路商城路科苑小区1号楼3单元2楼48号";
    _addressLabel.numberOfLines = 0;
    _addressLabel.adjustsFontSizeToFitWidth = YES;
    [totleView addSubview:_addressLabel];

    UIView * totoleLine = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _addressLabel.bottom + 10, self.view.width - 2 * LEFT_SPACE, 1)];
    totoleLine.tag = 3003;
    totoleLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [totleView addSubview:totoleLine];
    
    UIImageView * remarkImageview = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + totoleLine.bottom, IMAGE_WEIDTH, IMAGE_WEIDTH)];
    remarkImageview.image = [UIImage imageNamed:@"remark_order.png"];
    remarkImageview.tag = 4004;
    [totleView addSubview:remarkImageview];
    
//    UILabel * remarkLB = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageview.right + LEFT_SPACE, TOP_SPACE + totoleLine.bottom, 100, LABEL_HEIGHT)];
//    remarkLB.textAlignment = NSTextAlignmentCenter;
//    remarkLB.adjustsFontSizeToFitWidth = YES;
//    remarkLB.text = @"客户备注:";
//    [totleView addSubview:remarkLB];
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageview.right + LEFT_SPACE, TOP_SPACE + totoleLine.bottom , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT)];
    _remarkLabel.textColor = [UIColor grayColor];
    _remarkLabel.text = @"要超辣的，拉到死的可敬的奶粉进副科级未付费的爽肤水";
    _remarkLabel.numberOfLines = 0;
//    _remarkLabel.adjustsFontSizeToFitWidth = YES;
    [totleView addSubview:_remarkLabel];
    
//    UILabel * giftLB = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageview.right + LEFT_SPACE, _remarkLabel.bottom, 50, LABEL_HEIGHT)];
//    giftLB.textAlignment = NSTextAlignmentCenter;
//    giftLB.adjustsFontSizeToFitWidth = YES;
//    giftLB.text = @"赠品:";
//    [totleView addSubview:giftLB];
    
    self.giftLabel = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageview.right + LEFT_SPACE, _remarkLabel.bottom, self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH , LABEL_HEIGHT)];
    _giftLabel.textColor = [UIColor grayColor];
    _giftLabel.text = @"手机一部jhdsbf跨世纪的办法看电视剧电脑是豆腐脑";
    _giftLabel.numberOfLines = 0;
//    _giftLabel.adjustsFontSizeToFitWidth = YES;
    [totleView addSubview:_giftLabel];
    
    totleView.height = _giftLabel.bottom + TOP_SPACE;
    
    
    // 菜单信息
    UIView * mealsView = [[UIView alloc]initWithFrame:CGRectMake(0, totleView.bottom + TOP_SPACE, self.view.width, 100)];
    mealsView.backgroundColor = [UIColor whiteColor];
    mealsView.tag = MEALSView_tag;
    [_scrollview addSubview:mealsView];
    
    UILabel * mealsLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, mealsView.width - 10 , 30)];
    mealsLabel.text = @"菜单详情";
    mealsLabel.textColor = TEXT_COLOR;
    [mealsView addSubview:mealsLabel];
    
    UIView * lineView5 = [[UIView alloc] initWithFrame:CGRectMake(10, mealsLabel.bottom, mealsView.width - 20, 1)];
    lineView5.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    lineView5.tag = 5005;
    [mealsView addSubview:lineView5];
    
    // 商家信息
    UIView * shopdetailsView = [[UIView alloc]initWithFrame:CGRectMake(0, mealsView.bottom + 10, self.view.width, 100)];
    shopdetailsView.backgroundColor = [UIColor whiteColor];
    shopdetailsView.tag = SHOPDETAILSView_TAG;
    [_scrollview addSubview:shopdetailsView];
    
    UILabel * shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, shopdetailsView.width - 10 , 30)];
    shopLabel.text = @"商家详情";
    shopLabel.textColor = TEXT_COLOR;
    [shopdetailsView addSubview:shopLabel];
    
    UIView * lineViewshop = [[UIView alloc] initWithFrame:CGRectMake(10, shopLabel.bottom, shopdetailsView.width - 20, 1)];
    lineViewshop.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [shopdetailsView addSubview:lineViewshop];
    
    
    self.addressImageViewshop = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 3 + lineViewshop.bottom, IMAGE_WEIDTH, IMAGE_WEIDTH)];
    _addressImageViewshop.image = [UIImage imageNamed:@"location_order.png"];
    [shopdetailsView addSubview:_addressImageViewshop];
    
    UIButton * shopaddressBt = [UIButton buttonWithType:UIButtonTypeSystem];
    shopaddressBt.frame = _addressImageViewshop.frame;
    shopaddressBt.backgroundColor = [UIColor clearColor];
//    shopaddressBt.tag = SHOP_ADDRESS_BT_TAG;
    [shopaddressBt addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    [shopdetailsView addSubview:shopaddressBt];
    
    self.nameLabelshop = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageViewshop.right + LEFT_SPACE, TOP_SPACE + lineViewshop.bottom, 80, LABEL_HEIGHT)];
    _nameLabelshop.textAlignment = NSTextAlignmentCenter;
    _nameLabelshop.adjustsFontSizeToFitWidth = YES;
    _nameLabelshop.text = @"邻家小厨蓝湖湾";
    [shopdetailsView addSubview:_nameLabelshop];
    
    UIView * line1shop = [[UIView alloc]initWithFrame:CGRectMake(_nameLabelshop.right, _nameLabelshop.top - 5, 1, 20)];
    line1shop.backgroundColor = [UIColor grayColor];
    line1shop.tag = 20002;
    [shopdetailsView addSubview:line1shop];
    
    self.phoneLabelshop = [[UILabel alloc]initWithFrame:CGRectMake(line1shop.right, TOP_SPACE + lineViewshop.bottom, 120, LABEL_HEIGHT)];
    _phoneLabelshop.text = @"18734890150";
    _phoneLabelshop.textAlignment = NSTextAlignmentCenter;
//    _phoneLabelshop.adjustsFontSizeToFitWidth = YES;
    [shopdetailsView addSubview:_phoneLabelshop];
    
    self.phoneBTshop = [UIButton buttonWithType:UIButtonTypeSystem];
    _phoneBTshop.frame = CGRectMake(line1shop.right, TOP_SPACE + lineViewshop.bottom, 120, LABEL_HEIGHT);
//    [_phoneBTshop setTitle:@"18736087590" forState:UIControlStateNormal];
    _phoneBTshop.tag = SHOP_PHONE_BT_TAG;
    [_phoneBTshop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _phoneBTshop.backgroundColor = [UIColor clearColor];
    [_phoneBTshop addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [shopdetailsView addSubview:_phoneBTshop];
    
    self.addressLabelshop = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageViewshop.right + LEFT_SPACE, _nameLabelshop.bottom , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT + 10)];
    _addressLabelshop.textColor = [UIColor grayColor];
    _addressLabelshop.numberOfLines = 0;
    _addressLabelshop.adjustsFontSizeToFitWidth = YES;
    _addressLabelshop.text = @"前进路中原路锦艺怡心苑区1号楼3单元2楼48号";
    [shopdetailsView addSubview:_addressLabelshop];
    
    shopdetailsView.height = _addressLabelshop.bottom + 10;
    
    
    UIView * tipView = [[UIView alloc]initWithFrame:CGRectMake(0, mealsView.bottom + 10, self.view.width, 50)];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.tag = TIPVIEW_TAG;
    [_scrollview addSubview:tipView];
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 80, 30)];
    tipLabel.text = @"温馨提示:";
    tipLabel.textColor = [UIColor orangeColor];
    [tipView addSubview:tipLabel];
    
    self.tiplabel = [[UILabel alloc]initWithFrame:CGRectMake(tipLabel.right, TOP_SPACE, self.view.width - 2 * LEFT_SPACE - tipLabel.width, 30)];
    _tiplabel.textColor = [UIColor grayColor];
    
    NSString * contentstr = @"此订单支付方式为现金支付，别忘记收款哦！";
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:contentstr];
    [str addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(8, 4)];
    
    _tiplabel.attributedText = str;
    _tiplabel.adjustsFontSizeToFitWidth = YES;
    [tipView addSubview:_tiplabel];
    
    tipView.height = _tiplabel.bottom + TOP_SPACE;
    
    _scrollview.contentSize = CGSizeMake(self.view.width, tipView.bottom + 20);
    
    
    
    UIButton * addressBt1 = [UIButton buttonWithType:UIButtonTypeSystem];
    addressBt1.frame = self.customAddressIcon.frame;
    addressBt1.backgroundColor = [UIColor clearColor];
    addressBt1.tag = CUSTOM_ADDRESS_BT_TAG;
    [addressBt1 addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customerView addSubview:addressBt1];
    
    UIButton * shopaddressBt1 = [UIButton buttonWithType:UIButtonTypeSystem];
    shopaddressBt1.frame = self.storeAddressIcon.frame;
    shopaddressBt1.backgroundColor = [UIColor clearColor];
    shopaddressBt1.tag = SHOP_ADDRESS_BT_TAG;
    [shopaddressBt1 addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.businessView addSubview:shopaddressBt1];
    self.backView.height = self.mealDetailsView.bottom ;
    self.myScrollview.contentSize = CGSizeMake(self.myScrollview.width, self.backView.bottom + 10);
    
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.totlePriceView = [[TotlePriceView alloc]initWithFrame:CGRectMake(0, _scrollview.bottom, self.view.width, 60)];
    self.totlePriceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totlePriceView];
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationItem.title = @"餐单详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_black.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    NSDictionary * jsonDic = @{
                               @"Command":@9,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"OrderId":self.orderID,
                               @"BusiId":[UserInfo shareUserInfo].BusiId,
                               @"IsAgent":@([UserInfo shareUserInfo].isAgent)
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    
    // Do any additional setup after loading the view.
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
            
            NSDictionary * dic = [data objectForKey:@"OrderDetail"];
            
            UIView * mealView = [_scrollview viewWithTag:MEALSView_tag];
            UIView * shopDetailsView = [_scrollview viewWithTag:SHOPDETAILSView_TAG];
            UIView * tipView = [_scrollview viewWithTag:TIPVIEW_TAG];
            
            self.nameLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerName"]];
            self.phoneLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerPhone"]];
            
            NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
            CGRect nameRect = [self.nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.nameLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
            self.nameLabel.frame = CGRectMake(LEFT_SPACE + _addressImageView.right, TOP_SPACE, nameRect.size.width, LABEL_HEIGHT);
            UIView * totleView = [_scrollview viewWithTag:TOTLEVIEW_tag];
            UIView * line = [totleView viewWithTag:10001];
            line.frame = CGRectMake(_nameLabel.right + 2, 15, 1, 20);
            
            CGRect phoneRect = [self.phoneLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.phoneLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
            self.phoneLabel.frame = CGRectMake(line.right + 2, TOP_SPACE, phoneRect.size.width, LABEL_HEIGHT);
            self.phoneBT.frame = _phoneLabel.frame;
            
            if ([[dic objectForKey:@"PayType"] intValue] == 1) {
                self.payStateLabel.text = @"在线支付";
                tipView.hidden = YES;
            }else
            {
                self.payStateLabel.text = @"现金支付";
            }
            
            self.addressLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerAddress"]];
            CGRect addressRect = [self.addressLabel.text boundingRectWithSize:CGSizeMake(_addressLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            
            _addressLabel.frame = CGRectMake(_addressImageView.right + LEFT_SPACE, _nameLabel.bottom , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, addressRect.size.height);
            
            UIView * totleLine = [totleView viewWithTag:3003];
            UIImageView * remarkImageView = (UIImageView *)[totleView viewWithTag:4004];
            totleLine.frame = CGRectMake(LEFT_SPACE, _addressLabel.bottom + 10, self.view.width - 2 * LEFT_SPACE, 1);
            remarkImageView.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + totleLine.bottom, IMAGE_WEIDTH, IMAGE_WEIDTH);
            
            _remarkLabel.frame = CGRectMake(remarkImageView.right + LEFT_SPACE, TOP_SPACE + totleLine.bottom , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT);
            
            NSString * remark = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Remark"]];
            
            
            if (remark.length == 0) {
                self.remarkLabel.text = @"客户备注:暂无备注";
            }else
            {
                self.remarkLabel.text = [NSString stringWithFormat:@"客户备注:%@", [dic objectForKey:@"Remark"]];
            }
            
            NSDictionary * attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
            CGRect remaskRect = [self.remarkLabel.text boundingRectWithSize:CGSizeMake(_remarkLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil];
            _remarkLabel.frame = CGRectMake(_remarkLabel.left, _remarkLabel.top , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, remaskRect.size.height);
            
            NSString * giftStr =[NSString stringWithFormat:@"%@", [dic objectForKey:@"Gift"]];
            if (giftStr.length == 0) {
                self.giftLabel.text = @"赠品:暂无赠品";
            }else
            {
                self.giftLabel.text = [NSString stringWithFormat:@"赠品:%@", [dic objectForKey:@"Remark"]];
            }
            
            CGSize giftSize = [self.giftLabel sizeThatFits:CGSizeMake(self.remarkLabel.width, CGFLOAT_MAX)];
            _giftLabel.frame = CGRectMake(_giftLabel.left, _remarkLabel.bottom, self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH , giftSize.height);
            
            NSMutableAttributedString * remarkStr = [[NSMutableAttributedString alloc]initWithString:self.remarkLabel.text];
            [remarkStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 4)];
            self.remarkLabel.attributedText = remarkStr;
            
            NSMutableAttributedString * giftMUtableStr = [[NSMutableAttributedString alloc]initWithString:self.giftLabel.text];
            [giftMUtableStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 2)];
            self.giftLabel.attributedText = giftMUtableStr;
            
            totleView.height = _giftLabel.bottom + TOP_SPACE;
            mealView.frame = CGRectMake(0, totleView.bottom + TOP_SPACE, self.view.width, 100);
            
            int k = 0;
            NSArray * array = [dic objectForKey:@"MealList"];
            for (int i = 0; i < array.count; i++) {
                Meal * meal = [[Meal alloc]initWithDictionary:[array objectAtIndex:i]];
                MealPriceView * mealPriceView = [[MealPriceView alloc]initWithFrame:CGRectMake(LEFT_SPACE + (self.view.width - 3 * LEFT_SPACE) / 2 * k + LEFT_SPACE * k, 41 + 15 + (i) / 2 * 40, (self.view.width - 3 * LEFT_SPACE) / 2, 30)];
                k++;
                if ((i + 1) % 2 == 0) {
                    k = 0;
                }
                [mealView addSubview:mealPriceView];
                mealPriceView.menuLabel.text = meal.name;
                mealPriceView.menuPriceLB.text = [NSString stringWithFormat:@"¥%g", meal.money];
                mealPriceView.numberLabel.text = [NSString stringWithFormat:@"X%d", meal.count];
            }
            
            int num = 0;
            int mealCount = array.count;
            num = mealCount / 2 + mealCount % 2;
            mealView.frame = CGRectMake(0, mealView.top, mealView.width, num * 30 + 10 * (num - 1) + 41 + 30);
            
            shopDetailsView.frame = CGRectMake(0, mealView.bottom + 10, self.view.width, 100);
            // BusiName BusiPhone  BusiAddress
            self.nameLabelshop.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"BusiName"]];
            self.phoneLabelshop.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"BusiPhone"]];
            
            CGRect nameRectshop = [self.nameLabelshop.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.nameLabelshop.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
            self.nameLabelshop.frame = CGRectMake(_addressImageViewshop.right + LEFT_SPACE, _nameLabelshop.top, nameRectshop.size.width, LABEL_HEIGHT);
            
            UIView * line1shop = [shopDetailsView viewWithTag:20002];
            line1shop.frame = CGRectMake(_nameLabelshop.right + 2, _nameLabelshop.top + 5, 1, 20);
            
            CGRect phoneRectshop = [self.phoneLabelshop.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.phoneLabelshop.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
//            self.phoneBTshop.frame = CGRectMake(line1shop.right + 2, _nameLabelshop.top, phoneRectshop.size.width, LABEL_HEIGHT);
            _phoneLabelshop.frame = CGRectMake(line1shop.right + 2, _nameLabelshop.top, phoneRectshop.size.width, LABEL_HEIGHT);
            self.phoneBTshop.frame = _phoneLabelshop.frame;
            
            self.addressLabelshop.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"BusiAddress"]];
            CGRect addressRectshop = [self.addressLabelshop.text boundingRectWithSize:CGSizeMake(_addressLabelshop.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            _addressLabelshop.frame = CGRectMake(_addressImageViewshop.right + LEFT_SPACE, _nameLabelshop.bottom , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, addressRectshop.size.height);
            shopDetailsView.height = _addressLabelshop.bottom + TOP_SPACE;
            
            if (!tipView.hidden) {
                tipView.frame = CGRectMake(0, shopDetailsView.bottom + 10, self.view.width, 50);
                _scrollview.contentSize = CGSizeMake(self.view.width, tipView.bottom + 20);
            }else
            {
                _scrollview.contentSize = CGSizeMake(self.view.width, shopDetailsView.bottom + 20);
            }
            
            
            
            // 死了复活就被冻结副本及
            self.storeNameLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"BusiName"]];
            self.storePhoneNumberLB.text = [NSString stringWithFormat:@"联系电话：%@", [dic objectForKey:@"BusiPhone"]];
            if ([[dic objectForKey:@"PayType"] intValue] == 1) {
                self.payTypeLB.text = @"在线支付";
                self.payStateLB.text = @"已支付";
            }else
            {
                self.payTypeLB.text = @"现金支付";
                self.payStateLB.text = @"未支付";
            }
            
            switch ([[dic objectForKey:@"OrderState"] intValue]) {
                case 1:
                    self.sendState.text = @"新订单";
                    break;
                case 2:
                    self.sendState.text = @"待配送";
                    break;
                case 3:
                    self.sendState.text = @"配送中";
                    break;
                case 4:
                    self.sendState.text = @"已配送";
                    break;
                    
                default:
                    break;
            }
            
            NSDictionary * attribute2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            self.storeAddressLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"BusiAddress"]];
//            self.storeAddressLB.text = @"金水区经八路黄河路交叉口向东100米路西九号院1号楼3单元2楼50号";
            CGRect storeaddressRectshop = [self.storeAddressLB.text boundingRectWithSize:CGSizeMake(_addressLabelshop.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute2 context:nil];
            self.storeAddressLB.height = storeaddressRectshop.size.height;
            self.businessView.frame = CGRectMake(self.businessView.left, self.businessView.top, self.businessView.width, self.storeAddressLB.bottom );
            
            
            
            NSLog(@"***%f***%f****%f",self.businessView.height, self.storeAddressLB.bottom, self.storeAddressLB.height);
            
            self.customNameLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerName"]];
            self.customPhoneNumberLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerPhone"]];
            self.sendTimeLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"HopeTime"]];
            self.customAddressLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerAddress"]];
            CGRect customAddressrect = [self.customAddressLB.text boundingRectWithSize:CGSizeMake(_customAddressLB.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute2 context:nil];
            _customAddressLB.height = customAddressrect.size.height;
            self.customerView.top = self.businessView.bottom + TOP_SPACE;
            self.customerView.height = _customAddressLB.bottom + TOP_SPACE;
            
             NSArray * mealsarray = [dic objectForKey:@"MealList"];
            
            NSMutableArray *mealarray = [NSMutableArray array];
            for (NSDictionary * dic in mealsarray) {
                Meal * meal = [[Meal alloc]initWithDictionary:dic];
                [mealarray addObject:meal];
            }
            
            
            for (int i = 0; i < mealarray.count; i++) {
                MealDetailsView * mealDetailView = [[MealDetailsView alloc]initWithFrame:CGRectMake(0, 47 + 30 * i, self.mealDetailsView.width, 30)];
                Meal * meal = [mealarray objectAtIndex:i];
                
                mealDetailView.nametext = meal.name;
                mealDetailView.nameLabel.text = meal.name;
                mealDetailView.countLabel.text = [NSString stringWithFormat:@"x %d", meal.count];
                mealDetailView.priceLabel.text = [NSString stringWithFormat:@"%.2f元", meal.money];
                [self.mealDetailsView addSubview:mealDetailView];
                self.mealDetailsView.height = mealDetailView.bottom + 10;
            }
            self.mealDetailsView.height = 47 + mealarray.count * 30;
            
            self.backView.height = self.mealDetailsView.bottom ;
            NSLog(@"^^^^^^^^%f", self.backView.height);
            self.myScrollview.backgroundColor = self.backView.backgroundColor;
            self.myScrollview.contentSize = CGSizeMake(self.myScrollview.width, self.backView.bottom + TOP_SPACE);
            
            self.totlePriceView.totalPrice = [NSString stringWithFormat:@"%@", [dic objectForKey:@"AllMoney"]];
//            self.totlePriceView.totlePriceLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"AllMoney"]];
            self.totlePriceView.detailsButton.hidden = YES;
            if ([[dic objectForKey:@"OrderState"] intValue] == 2) {
                [self.totlePriceView.startDeliveryBT setTitle:@"开始配送" forState:UIControlStateNormal];
                [self.totlePriceView.startDeliveryBT addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([[dic objectForKey:@"OrderState"] intValue] == 1)
            {
                [self.totlePriceView.startDeliveryBT setTitle:@"立即抢单" forState:UIControlStateNormal];
                [self.totlePriceView.startDeliveryBT addTarget:self action:@selector(robAction:) forControlEvents:UIControlEventTouchUpInside];
            }else
            {
                self.totlePriceView.startDeliveryBT.hidden = YES;
            }
            
        }else if ([command isEqualToNumber:@10006])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抢单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([command isEqualToNumber:@10007])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始配送成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.0];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
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
- (void)robAction:(UIButton *)button
{
            NSDictionary * jsonDic = @{
                                   @"Command":@6,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"OrderId":self.orderID
                                   };
        [self playPostWithDictionary:jsonDic];
        
    
    
}
- (void)deliveryAction:(UIButton *)button
{
    
        NSDictionary * jsonDic = @{
                                   @"Command":@7,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"OrderId":self.orderID
                                   };
        [self playPostWithDictionary:jsonDic];
    
}

#pragma mark - 查看地图
- (void)mapAction:(UIButton *)button
{
    Mapcontroller * mapVC = [[Mapcontroller alloc]init];
    if (button.tag == CUSTOM_ADDRESS_BT_TAG) {
        mapVC.name = self.nameLabel.text;
        mapVC.phone = self.phoneLabel.text;
        mapVC.address = self.addressLabel.text;
    }else
    {
        mapVC.name = self.nameLabelshop.text;
        mapVC.phone = self.phoneLabelshop.text;
        mapVC.address = self.addressLabelshop.text;
    }
    NSLog(@"address = %@", mapVC.address);
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - 拨打电话
- (void)telToOrderTelNumber:(UIButton *)button
{
    if (button.tag == CUSTOM_PHONT_BT_TAG) {
        NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.phoneLabel.text]);
        UIWebView *callWebView = [[UIWebView alloc]init];
        NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneLabel.text]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebView];
    }else
    {
        NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.phoneLabelshop.text]);
        UIWebView *callWebView = [[UIWebView alloc]init];
        NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneLabelshop.text]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebView];
    }
    
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
