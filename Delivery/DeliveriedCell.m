//
//  DeliveriedCell.m
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "DeliveriedCell.h"





#define TOP_SPACE 10
#define SHOPVIEW_HEIGHT 120
#define CUSTOMERVIEW_HEIGHT 150
#define TOTLEPRICEVIEW_HEIGHT 50
#define MENUVIEW_HEIGHT 30
#define LINE_tag 8000

static int height = 0;
static int shopHeight = 0;
@interface DeliveriedCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel * storenameLabel;
@property (nonatomic, strong)UILabel * payStateLabel;
@property (nonatomic, strong)UILabel * sendStateLabel;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UIView * linePrice;
@property (nonnull, copy)DetailsBlock detailsBlock;


@end

@implementation DeliveriedCell



- (void)createSubView:(CGRect)frame mealCoutn:(NewOrderModel *)model
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [DeliveriedCell cellHeightWithMealCount:model] - TOP_SPACE )];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    self.storenameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150, 15)];
    self.storenameLabel.font = [UIFont systemFontOfSize:15];
    self.storenameLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    [self addSubview:self.storenameLabel];
    
    self.sendStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 75, 15, 60, 15)];
    self.sendStateLabel.textColor = MAIN_COLORE;
    self.sendStateLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.sendStateLabel];
    
    UIView * line2View = [[UIView alloc]initWithFrame:CGRectMake(self.sendStateLabel.left - 11, 10, 1, 25)];
    line2View.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line2View];
    
    self.payStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(line2View.left - 70, 15, 60, 15)];
    self.payStateLabel.font = [UIFont systemFontOfSize:15];
    self.payStateLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    [self addSubview:self.payStateLabel];
    
    UIView * lineView3view = [[UIView alloc]initWithFrame:CGRectMake(self.payStateLabel.left - 11, 10, 1, 25)];
    lineView3view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:lineView3view];
    
    self.linePrice = [[UIView alloc]initWithFrame:CGRectMake(0, self.storenameLabel.bottom + 15, self.width, 1)];
    _linePrice.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:_linePrice];
    
    UIImageView * addressimageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 18 + self.linePrice.bottom, 7, 7)];
    addressimageview.backgroundColor = [UIColor whiteColor];
    [self addSubview:addressimageview];
    addressimageview.image = [UIImage imageNamed:@"colect_s.png"];
    
    UILabel * addressLB = [[UILabel alloc]initWithFrame:CGRectMake(addressimageview.right + 10, 15 + self.linePrice.bottom, 85, 13)];
    addressLB.text = @"商家店铺地址:";
    addressLB.font = [UIFont systemFontOfSize:13];
    addressLB.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [self addSubview:addressLB];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, addressLB.bottom + 7, 246, 26)];
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = [UIColor colorWithWhite:.6 alpha:1];
    self.addressLabel.numberOfLines = 0;
    [self addSubview:self.addressLabel];
    
    UIButton * detailsBT = [UIButton buttonWithType:UIButtonTypeCustom];
    detailsBT.frame = CGRectMake(frame.size.width - 55, self.linePrice.bottom + 18, 40, 40);
    [detailsBT setImage:[UIImage imageNamed:@"arrowright.png"] forState:UIControlStateNormal];
    detailsBT.imageEdgeInsets = UIEdgeInsetsMake(10, 28, 10, 4);
    [detailsBT addTarget:self action:@selector(detailsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailsBT];
    
    
    
    
    self.shopView = [[ShopView alloc]initWithFrame:CGRectMake(0, 0, self.width, SHOPVIEW_HEIGHT)];
    [_shopView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_shopView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _shopView.bottom, self.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    line.tag = LINE_tag;
    [self addSubview:line];
    
    self.customerView = [[CustomerView alloc]initWithFrame:CGRectMake(0, line.bottom, self.width, 120)];
    [_customerView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_customerView];
    
//    self.linePrice = [[UIView alloc]initWithFrame:CGRectMake(0, _customerView.bottom, self.width, 1)];
//    _linePrice.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [self addSubview:_linePrice];
    
    self.totlePriceView = [[TotlePriceView alloc]initWithFrame:CGRectMake(0, _linePrice.bottom, self.width, TOTLEPRICEVIEW_HEIGHT)];
    self.totlePriceView.detailsButton.frame = CGRectMake(self.totlePriceView.width - self.totlePriceView.detailsButton.width , 0, self.totlePriceView.detailsButton.width, self.totlePriceView.detailsButton.height);
//    [self addSubview:_totlePriceView];
    
}


+ (CGFloat)cellHeightWithMealCount:(NewOrderModel *)model
{
//    int num = mealCount / 2 + mealCount % 2;
    //
    //    _mealsView.frame = CGRectMake(0, _addressLabel.bottom, self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, num * 30 + 10 * (num - 1) + 30);
    
//    return SHOPVIEW_HEIGHT  + MENUVIEW_HEIGHT * ((mealCount - 1)/ 2 + 1 ) + (mealCount - 1) / 2 * 10  + 30  + CUSTOMERVIEW_HEIGHT + TOTLEPRICEVIEW_HEIGHT + TOP_SPACE + height + shopHeight;
    //    return SHOPVIEW_HEIGHT  + num * 30 + 10 * (num - 1) + 30  + CUSTOMERVIEW_HEIGHT + TOTLEPRICEVIEW_HEIGHT + TOP_SPACE ;
    return 121;
}

- (void)detailsAction:(UIButton *)button
{
    _detailsBlock();
}

- (void)orderDetailsBlock:(DetailsBlock)block
{
    _detailsBlock = [block copy];
}

- (void)setOrderModel:(NewOrderModel *)orderModel
{
    
//    self.shopView.name = orderModel.busiName;
//    self.shopView.phone = orderModel.busiPhone;
//    self.shopView.addressLabel.text = orderModel.busiAddress;
//    NSString * shopaddress =  self.shopView.addressLabel.text;
//    CGSize size = CGSizeMake(self.shopView.addressLabel.width, 1000);
//    CGRect shopRect = [shopaddress boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
//    
//    if (shopRect.size.height + 5 < 30) {
//        ;
//    }else
//    {
//        shopHeight = shopRect.size.height + 5 - 30;
//        self.shopView.addressLabel.height = shopRect.size.height + 5;
//        self.shopView.orderTimeLB.top = self.shopView.addressLabel.bottom;
//        self.shopView.payStateLabel.top = self.shopView.orderTimeLB.top;
//        self.shopView.height = SHOPVIEW_HEIGHT + shopHeight;
//        UIView * line = [self viewWithTag:LINE_tag];
//        line.top = self.shopView.bottom;
//        self.customerView.top = line.bottom;
//    }
//    
//    
//    self.shopView.orderTimeLB.text = orderModel.orderTime;
//    
//    if (orderModel.payType == 1) {
//        self.shopView.payStateLabel.text = @"在线支付";
//    }else
//    {
//        self.shopView.payStateLabel.text = @"现金支付";
//    }
//    
//    self.customerView.name = orderModel.customerName;
//    self.customerView.phone = orderModel.customerPhone;
//    self.customerView.addressLabel.text = orderModel.customerAddress;
//    self.customerView.arriveTimeLabel.text = orderModel.hopeTime;
//    if (orderModel.remark.length == 0) {
//        self.customerView.remarkLabel.text = @"暂无备注!";
//    }else
//    {
//        self.customerView.remarkLabel.text = orderModel.remark;
//    }
//    if (orderModel.gift.length == 0) {
//        self.customerView.giftLabel.text = @"赠品:无";
//    }else
//    {
//        self.customerView.giftLabel.text = [NSString stringWithFormat:@"赠品:%@", orderModel.remark];
//    }
//    // 计算字符串高度
//    NSString * contentText = orderModel.customerAddress;
//    CGSize maxSize = CGSizeMake(self.customerView.addressLabel.width, 1000);
//    CGRect textRect = [contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
//    
//    if (textRect.size.height + 10 < 30) {
//        ;
//    }else
//    {
//        height = textRect.size.height + 10 - 30;
//        self.customerView.addressLabel.height = textRect.size.height + 10;
//        self.customerView.mealsView.top = self.customerView.addressLabel.bottom;
//    }
//    
//    [self.customerView creatMealViewWithArray:orderModel.mealArray];
//    
//    self.customerView.height = CUSTOMERVIEW_HEIGHT + height + MENUVIEW_HEIGHT * ((orderModel.mealArray.count - 1)/ 2 + 1 ) + (orderModel.mealArray.count - 1) / 2 * 10 + 30;
//    self.linePrice.top = self.customerView.bottom ;
//    self.totlePriceView.top = self.linePrice.bottom;
//    self.totlePriceView.totalPrice = [NSString stringWithFormat:@"%@", orderModel.allMoney];
////    self.totlePriceView.totlePriceLabel.text = [NSString stringWithFormat:@"%@", orderModel.allMoney];
////    [self.totlePriceView.startDeliveryBT setTitle:@"立即抢单" forState:UIControlStateNormal];
//    //    self.totlePriceView.totlePriceLabel.frame = self.totlePriceView.detailsButton.frame;
//    self.backView.frame = CGRectMake(0, 0, self.frame.size.width, [DeliveriedCell cellHeightWithMealCount:orderModel] - TOP_SPACE );
//        self.totlePriceView.startDeliveryBT.hidden = YES;
    
    self.storenameLabel.text = orderModel.busiName;
    
    if (orderModel.payType == 1) {
        self.payStateLabel.text = @"在线支付";
    }else
    {
        self.payStateLabel.text = @"现金支付";
    }
    if ([orderModel.orderState intValue] == 4) {
        self.sendStateLabel.text = @"送达成功";
    }
    
    self.addressLabel.text = orderModel.busiAddress;
    
}

- (void)telToOrderTelNumber:(UIButton *)button
{
    if ([button isEqual:_shopView.phoneBT]) {
        NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.shopView.phoneLabel.text]);
        UIWebView *callWebView = [[UIWebView alloc]init];
        NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.shopView.phoneLabel.text]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.window addSubview:callWebView];
    }else
    {
        
        NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.customerView.phoneLabel.text]);
        UIWebView *callWebView = [[UIWebView alloc]init];
        NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.customerView.phoneLabel.text]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.window addSubview:callWebView];
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
