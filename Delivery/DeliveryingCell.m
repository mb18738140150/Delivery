//
//  DeliveryingCell.m
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "DeliveryingCell.h"
#import "ShopView.h"
#import "CustomerView.h"


#define TOP_SPACE 10
#define SHOPVIEW_HEIGHT 50
#define CUSTOMERVIEW_HEIGHT 120
#define TOTLEPRICEVIEW_HEIGHT 60
#define MENUVIEW_HEIGHT 30

static int height = 0;
@interface DeliveryingCell ()

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)ShopView * shopView;
@property (nonatomic, strong)CustomerView * customerView;

@property (nonatomic, strong)UIView * linePrice;

@end
@implementation DeliveryingCell

- (void)createSubView:(CGRect)frame mealCoutn:(int)mealCount
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [DeliveryingCell cellHeightWithMealCount:mealCount] - TOP_SPACE )];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    self.shopView = [[ShopView alloc]initWithFrame:CGRectMake(0, 0, self.width, SHOPVIEW_HEIGHT)];
    [_shopView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shopView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _shopView.bottom, self.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line];
    
    self.customerView = [[CustomerView alloc]initWithFrame:CGRectMake(0, line.bottom, self.width, 120)];
    [_customerView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_customerView];
    
    self.linePrice = [[UIView alloc]initWithFrame:CGRectMake(0, _customerView.bottom, self.width, 1)];
    _linePrice.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:_linePrice];
    
    self.totlePriceView = [[TotlePriceView alloc]initWithFrame:CGRectMake(0, _linePrice.bottom, self.width, 60)];
    [self addSubview:_totlePriceView];
    
}


+ (CGFloat)cellHeightWithMealCount:(int)mealCount
{
    int num = mealCount / 2 + mealCount % 2;
    //
    //    _mealsView.frame = CGRectMake(0, _addressLabel.bottom, self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, num * 30 + 10 * (num - 1) + 30);
    
    return SHOPVIEW_HEIGHT  + MENUVIEW_HEIGHT * ((mealCount - 1)/ 2 + 1 ) + (mealCount - 1) / 2 * 10  + 30  + CUSTOMERVIEW_HEIGHT + TOTLEPRICEVIEW_HEIGHT + TOP_SPACE + height;
    //    return SHOPVIEW_HEIGHT  + num * 30 + 10 * (num - 1) + 30  + CUSTOMERVIEW_HEIGHT + TOTLEPRICEVIEW_HEIGHT + TOP_SPACE ;
}
- (void)setOrderModel:(NewOrderModel *)orderModel
{
    self.shopView.addressLabel.text = orderModel.orderTime;
    if (orderModel.payType == 1) {
        self.shopView.payStateLabel.text = @"在线支付";
    }else
    {
        self.shopView.payStateLabel.text = @"餐到付款";
    }
    
    self.customerView.nameLabel.text = orderModel.customerName;
    self.customerView.phoneLabel.text = orderModel.customerPhone;
    self.customerView.addressLabel.text = orderModel.customerAddress;
    self.customerView.arriveTimeLabel.text = orderModel.hopeTime;
    if (orderModel.remark.length == 0) {
        self.customerView.remarkLabel.text = @"暂无备注";
    }else
    {
        self.customerView.remarkLabel.text = orderModel.remark;
    }
    // 计算字符串高度
    NSString * contentText = orderModel.customerAddress;
    CGSize maxSize = CGSizeMake(self.customerView.addressLabel.width, 1000);
    CGRect textRect = [contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    if (textRect.size.height + 10 < 30) {
        ;
    }else
    {
        height = textRect.size.height + 10 - 30;
        self.customerView.addressLabel.height = textRect.size.height + 10;
        self.customerView.mealsView.top = self.customerView.addressLabel.bottom;
    }
    
    [self.customerView creatMealViewWithArray:orderModel.mealArray];
    
    self.customerView.height = CUSTOMERVIEW_HEIGHT + height + MENUVIEW_HEIGHT * ((orderModel.mealArray.count - 1)/ 2 + 1 ) + (orderModel.mealArray.count - 1) / 2 * 10 + 30;
    self.linePrice.top = self.customerView.bottom ;
    self.totlePriceView.top = self.linePrice.bottom;
    self.totlePriceView.totlePriceLabel.text = [NSString stringWithFormat:@"%@", orderModel.allMoney];
    [self.totlePriceView.startDeliveryBT setTitle:@"开始配送" forState:UIControlStateNormal];
    self.backView.frame = CGRectMake(0, 0, self.frame.size.width, [DeliveryingCell cellHeightWithMealCount:orderModel.mealArray.count] - TOP_SPACE );
    //    self.totlePriceView.totlePriceLabel.frame = self.totlePriceView.detailsButton.frame;
    //    self.totlePriceView.detailsButton.hidden = YES;
}

- (void)telToOrderTelNumber:(UIButton *)button
{
    NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.customerView.phoneLabel.text]);
    UIWebView *callWebView = [[UIWebView alloc]init];
    NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.customerView.phoneLabel.text]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.window addSubview:callWebView];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
