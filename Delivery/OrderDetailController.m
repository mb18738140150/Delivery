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

#define IMAGE_WEIDTH 30
#define LABEL_HEIGHT 30
#define TOP_SPACE 10
#define LEFT_SPACE 10
#define MEALSView_tag 1000
#define SHOPDETAILSView_TAG 2000
#define TIPVIEW_TAG 3000
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
// 商家
@property (nonatomic, strong)UIImageView * addressImageViewshop;
@property (nonatomic, strong)UILabel * nameLabelshop;
@property (nonatomic, strong)UIButton * phoneBTshop;
@property (nonatomic, strong)UILabel * addressLabelshop;

// tip
@property (nonatomic, strong)UILabel * tiplabel;

@property (nonatomic, strong)TotlePriceView * totlePriceView;


@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"餐单详情";
    
    self.scrollview= [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollview.height = self.view.height - 50;
    _scrollview.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_scrollview];
    
    UIView * totleView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE, self.view.width, 100)];
    totleView.backgroundColor = [UIColor whiteColor];
    totleView.tag = 10000;
    [_scrollview addSubview:totleView];
    
    self.addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 3, IMAGE_WEIDTH, IMAGE_WEIDTH)];
    _addressImageView.image = [UIImage imageNamed:@"location_order.png"];
    [totleView addSubview:_addressImageView];
    
    UIButton * addressBt = [UIButton buttonWithType:UIButtonTypeSystem];
    addressBt.frame = _addressImageView.frame;
    addressBt.backgroundColor = [UIColor clearColor];
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
    totoleLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [totleView addSubview:totoleLine];
    
    UIImageView * remarkImageview = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 3 + totoleLine.bottom, IMAGE_WEIDTH, IMAGE_WEIDTH)];
    remarkImageview.image = [UIImage imageNamed:@"remark_order.png"];
    [totleView addSubview:remarkImageview];
    
    UILabel * remarkLB = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageview.right + LEFT_SPACE, TOP_SPACE + totoleLine.bottom, 100, LABEL_HEIGHT)];
    remarkLB.textAlignment = NSTextAlignmentCenter;
    remarkLB.adjustsFontSizeToFitWidth = YES;
    remarkLB.text = @"客户备注:";
    [totleView addSubview:remarkLB];
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(remarkLB.left + LEFT_SPACE, remarkLB.bottom + TOP_SPACE, self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT)];
    _remarkLabel.textColor = [UIColor grayColor];
    _remarkLabel.text = @"要超辣的，拉到死的可敬的奶粉进副科级";
    _remarkLabel.numberOfLines = 0;
    _remarkLabel.adjustsFontSizeToFitWidth = YES;
    [totleView addSubview:_remarkLabel];
    totleView.height = _remarkLabel.bottom + TOP_SPACE;
    
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
//    UIView * shopdetailsView = [[UIView alloc]initWithFrame:CGRectMake(0, mealsView.bottom + 10, self.view.width, 100)];
//    shopdetailsView.backgroundColor = [UIColor whiteColor];
//    shopdetailsView.tag = SHOPDETAILSView_TAG;
//    [_scrollview addSubview:shopdetailsView];
    
//    UILabel * shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, shopdetailsView.width - 10 , 30)];
//    shopLabel.text = @"菜单详情";
//    shopLabel.textColor = TEXT_COLOR;
//    [shopdetailsView addSubview:shopLabel];
//    
//    UIView * lineViewshop = [[UIView alloc] initWithFrame:CGRectMake(10, shopLabel.bottom, shopdetailsView.width - 20, 1)];
//    lineViewshop.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
//    [shopdetailsView addSubview:lineViewshop];
//    
//    
//    self.addressImageViewshop = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 3 + lineViewshop.bottom, IMAGE_WEIDTH, IMAGE_WEIDTH)];
//    _addressImageViewshop.image = [UIImage imageNamed:@"location_order.png"];
//    [shopdetailsView addSubview:_addressImageViewshop];
//    
//    self.nameLabelshop = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageViewshop.right + LEFT_SPACE, TOP_SPACE + lineViewshop.bottom, 80, LABEL_HEIGHT)];
//    _nameLabelshop.textAlignment = NSTextAlignmentCenter;
//    _nameLabelshop.adjustsFontSizeToFitWidth = YES;
//    _nameLabelshop.text = @"邻家小厨蓝湖湾";
//    [shopdetailsView addSubview:_nameLabelshop];
//    
//    UIView * line1shop = [[UIView alloc]initWithFrame:CGRectMake(_nameLabelshop.right, _nameLabelshop.top - 5, 1, 20)];
//    line1shop.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [shopdetailsView addSubview:line1shop];
//    
//    self.phoneBTshop = [UIButton buttonWithType:UIButtonTypeSystem];
//    _phoneBTshop.frame = CGRectMake(line1shop.right, TOP_SPACE + lineViewshop.bottom, 120, LABEL_HEIGHT);
//    [_phoneBTshop setTitle:@"18736087590" forState:UIControlStateNormal];
//    [_phoneBTshop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _phoneBTshop.backgroundColor = [UIColor whiteColor];
//    [shopdetailsView addSubview:_phoneBTshop];
//    
//    self.addressLabelshop = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageViewshop.right + LEFT_SPACE, _nameLabelshop.bottom , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT + 10)];
//    _addressLabelshop.textColor = [UIColor grayColor];
//    _addressLabelshop.numberOfLines = 0;
//    _addressLabelshop.adjustsFontSizeToFitWidth = YES;
//    _addressLabelshop.text = @"前进路中原路锦艺怡心苑区1号楼3单元2楼48号";
//    [shopdetailsView addSubview:_addressLabelshop];
//    
//    shopdetailsView.height = _addressLabelshop.bottom + 10;
    
    
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
    _tiplabel.text = @"此订单支付方式为现金支付，别忘记收款哦！";
    _tiplabel.adjustsFontSizeToFitWidth = YES;
    [tipView addSubview:_tiplabel];
    
    tipView.height = _tiplabel.bottom + TOP_SPACE;
    
    _scrollview.contentSize = CGSizeMake(self.view.width, tipView.bottom + 20);
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.totlePriceView = [[TotlePriceView alloc]initWithFrame:CGRectMake(0, rect.size.height - 120, self.view.width, 60)];
    self.totlePriceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totlePriceView];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
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
            UIView * tipView = [_scrollview viewWithTag:TIPVIEW_TAG];
            
            self.nameLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerName"]];
            self.phoneLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerPhone"]];
            
            NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
            CGRect nameRect = [self.nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.nameLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
            self.nameLabel.frame = CGRectMake(LEFT_SPACE + _addressImageView.right, TOP_SPACE, nameRect.size.width, LABEL_HEIGHT);
            UIView * totleView = [_scrollview viewWithTag:10000];
            UIView * line = [totleView viewWithTag:10001];
            line.frame = CGRectMake(_nameLabel.right + 2, 15, 1, 20);
            
            CGRect phoneRect = [self.phoneLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.phoneLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
            self.phoneLabel.frame = CGRectMake(line.right + 2, TOP_SPACE, phoneRect.size.width, LABEL_HEIGHT);
            
            
            if ([[dic objectForKey:@"PayType"] intValue] == 1) {
                self.payStateLabel.text = @"在线支付";
                tipView.hidden = YES;
            }else
            {
                self.payStateLabel.text = @"现金支付";
            }
            
            self.addressLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerAddress"]];
            NSString * remark = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Remark"]];
            if (remark.length == 0) {
                self.remarkLabel.text = @"暂无备注";
            }else
            {
                self.remarkLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Remark"]];
            }
            
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
            
            if (!tipView.hidden) {
                tipView.frame = CGRectMake(0, mealView.bottom + 10, self.view.width, 50);
            }
            
            self.totlePriceView.totlePriceLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"AllMoney"]];
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
    mapVC.name = self.nameLabel.text;
    mapVC.phone = self.phoneLabel.text;
    mapVC.address = self.addressLabel.text;
    NSLog(@"address = %@", mapVC.address);
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - 拨打电话
- (void)telToOrderTelNumber:(UIButton *)button
{
    NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.phoneLabel.text]);
    UIWebView *callWebView = [[UIWebView alloc]init];
    NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneLabel.text]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
    
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
