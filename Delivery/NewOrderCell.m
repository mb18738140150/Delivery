//
//  NewOrderCell.m
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "NewOrderCell.h"




#define TOP_SPACE 10
#define SHOPVIEW_HEIGHT 120
#define CUSTOMERVIEW_HEIGHT 150
#define TOTLEPRICEVIEW_HEIGHT 50
#define MENUVIEW_HEIGHT 30
#define LINE_tag 8000

static int height = 0;
static int shopHeight = 0;

@interface NewOrderCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel * storenameLabel;
@property (nonatomic, strong)UILabel * payTypeLabel;
@property (nonatomic, strong)UILabel * ordertimeLabel;
@property (nonatomic, strong)UIView * linePrice;

@property (nonatomic, strong)UILabel * distanceToStoreLabel;
@property (nonatomic, strong)UILabel * distanceOfcustomTostore;
@property (nonatomic, strong)UILabel * sendTimeLabel;


@end

@implementation NewOrderCell


- (void)createSubView:(CGRect)frame mealCoutn:(int)mealCount
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [NewOrderCell cellHeightWithMealCount:mealCount] - TOP_SPACE )];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    
    self.storenameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150, 15)];
    self.storenameLabel.font = [UIFont systemFontOfSize:15];
    self.storenameLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    [self addSubview:self.storenameLabel];
    
    self.ordertimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 75, 15, 60, 15)];
    self.ordertimeLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    self.ordertimeLabel.font = [UIFont systemFontOfSize:15];
    self.ordertimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.ordertimeLabel];
    
    UIView * line2View = [[UIView alloc]initWithFrame:CGRectMake(self.ordertimeLabel.left - 11, 10, 1, 25)];
    line2View.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line2View];
    
    self.payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(line2View.left - 70, 15, 60, 15)];
    self.payTypeLabel.font = [UIFont systemFontOfSize:15];
    self.payTypeLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    [self addSubview:self.payTypeLabel];
    
    UIView * lineView3view = [[UIView alloc]initWithFrame:CGRectMake(self.payTypeLabel.left - 11, 10, 1, 25)];
    lineView3view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:lineView3view];
    
    self.linePrice = [[UIView alloc]initWithFrame:CGRectMake(0, self.storenameLabel.bottom + 15, self.width, 1)];
    _linePrice.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:_linePrice];
    
    
    UIImageView * addressimageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20 + self.linePrice.bottom, 7, 7)];
    addressimageview.backgroundColor = [UIColor whiteColor];
    [self addSubview:addressimageview];
    addressimageview.image = [UIImage imageNamed:@"colect_s.png"];
    
    self.distanceToStoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressimageview.right + 10, self.linePrice.bottom + 16, 97, 13)];
    self.distanceToStoreLabel.text = @"距离商家 0.5km";
    self.distanceToStoreLabel.font = [UIFont systemFontOfSize:13];
    self.distanceToStoreLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [self addSubview:self.distanceToStoreLabel];
    
    UIImageView * customTostoreimageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 43 + self.linePrice.bottom, 7, 7)];
    customTostoreimageview.backgroundColor = [UIColor whiteColor];
    [self addSubview:customTostoreimageview];
    customTostoreimageview.image = [UIImage imageNamed:@"colect_s.png"];
    
    self.distanceOfcustomTostore = [[UILabel alloc]initWithFrame:CGRectMake(customTostoreimageview.right + 10, self.linePrice.bottom + 40, 123, 13)];
    self.distanceOfcustomTostore.text = @"商家距离客户 0.5km";
    self.distanceOfcustomTostore.font = [UIFont systemFontOfSize:13];
    self.distanceOfcustomTostore.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [self addSubview:self.distanceOfcustomTostore];
    
    UIImageView * sendTimeimageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 65 + self.linePrice.bottom, 7, 7)];
    sendTimeimageview.backgroundColor = [UIColor whiteColor];
    [self addSubview:sendTimeimageview];
    sendTimeimageview.image = [UIImage imageNamed:@"colect_s.png"];
    
    self.sendTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(sendTimeimageview.right + 10, self.linePrice.bottom + 62, 95, 13)];
    self.sendTimeLabel.text = @"送达时间 0.5km";
    self.sendTimeLabel.font = [UIFont systemFontOfSize:13];
    self.sendTimeLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [self addSubview:self.sendTimeLabel];
    
    
    self.shopView = [[ShopView alloc]initWithFrame:CGRectMake(0, 0, self.width, SHOPVIEW_HEIGHT)];
    [_shopView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_shopView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _shopView.bottom, self.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    line.tag = LINE_tag;
//    [self addSubview:line];
    
    self.customerView = [[CustomerView alloc]initWithFrame:CGRectMake(0, line.bottom, self.width, 120)];
    [_customerView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_customerView];
    
//    self.linePrice = [[UIView alloc]initWithFrame:CGRectMake(0, _customerView.bottom, self.width, 1)];
//    _linePrice.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [self addSubview:_linePrice];
    
    self.totlePriceView = [[TotlePriceView alloc]initWithFrame:CGRectMake(0, _linePrice.bottom, self.width, TOTLEPRICEVIEW_HEIGHT)];
    [self addSubview:_totlePriceView];
    
}


+ (CGFloat)cellHeightWithMealCount:(int)mealCount
{
     int num = mealCount / 2 + mealCount % 2;
//
//    _mealsView.frame = CGRectMake(0, _addressLabel.bottom, self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, num * 30 + 10 * (num - 1) + 30);
    
//    return SHOPVIEW_HEIGHT  + MENUVIEW_HEIGHT * ((mealCount - 1)/ 2 + 1 ) + (mealCount - 1) / 2 * 10  + 30  + CUSTOMERVIEW_HEIGHT + TOTLEPRICEVIEW_HEIGHT + TOP_SPACE + height + shopHeight;
//    return SHOPVIEW_HEIGHT  + num * 30 + 10 * (num - 1) + 30  + CUSTOMERVIEW_HEIGHT + TOTLEPRICEVIEW_HEIGHT + TOP_SPACE ;
    return 175 + 20;
}

- (void)setOrderModel:(NewOrderModel *)orderModel
{
    self.shopView.name = orderModel.busiName;
    self.shopView.phone = orderModel.busiPhone;
    self.shopView.addressLabel.text = orderModel.busiAddress;
    
    NSString * shopaddress =  self.shopView.addressLabel.text;
    CGSize size = CGSizeMake(self.shopView.addressLabel.width, 1000);
    CGRect shopRect = [shopaddress boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    if (shopRect.size.height + 5 < 30) {
        ;
    }else
    {
        shopHeight = shopRect.size.height + 5 - 30;
        self.shopView.addressLabel.height = shopRect.size.height + 5;
        self.shopView.orderTimeLB.top = self.shopView.addressLabel.bottom;
        self.shopView.payStateLabel.top = self.shopView.orderTimeLB.top;
        self.shopView.height = SHOPVIEW_HEIGHT + shopHeight;
        UIView * line = [self viewWithTag:LINE_tag];
        line.top = self.shopView.bottom;
        self.customerView.top = line.bottom;
    }

    
    self.shopView.orderTimeLB.text = orderModel.orderTime;
    
    if (orderModel.payType == 1) {
        self.shopView.payStateLabel.text = @"在线支付";
    }else
    {
        self.shopView.payStateLabel.text = @"现金支付";
    }
    
    self.customerView.name = orderModel.customerName;
    self.customerView.phone = orderModel.customerPhone;
    self.customerView.addressLabel.text = orderModel.customerAddress;
    self.customerView.arriveTimeLabel.text = orderModel.hopeTime;
    if (orderModel.remark.length == 0) {
        self.customerView.remarkLabel.text = @"暂无备注!";
    }else
    {
        self.customerView.remarkLabel.text = orderModel.remark;
    }
    if (orderModel.gift.length == 0) {
        self.customerView.giftLabel.text = @"赠品:无";
    }else
    {
        self.customerView.giftLabel.text = [NSString stringWithFormat:@"赠品:%@", orderModel.remark];
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
    
//    NSLog(@"textRect.size.height = %f", textRect.size.height);
    
    
    [self.customerView creatMealViewWithArray:orderModel.mealArray];
    self.customerView.height = CUSTOMERVIEW_HEIGHT + height + MENUVIEW_HEIGHT * ((orderModel.mealArray.count - 1)/ 2 + 1 ) + (orderModel.mealArray.count - 1) / 2 * 10 + 30;
//    self.linePrice.top = self.customerView.bottom ;
    
    
    
    self.storenameLabel.text = orderModel.busiName;
    if (orderModel.payType == 1) {
        self.payTypeLabel.text = @"在线支付";
    }else
    {
        self.payTypeLabel.text = @"现金支付";
    }
    
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy-MM-DD HH:mm";
    NSDate * time = [fomatter dateFromString:orderModel.orderTime];
    NSDateFormatter * fomatter1 = [[NSDateFormatter alloc]init];
    fomatter1.dateFormat = @"HH:mm";
    NSString * timeStr = [fomatter1 stringFromDate:time];
    self.ordertimeLabel.text = timeStr;
    
    
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:MAIN_COLORE};
    
    
    NSString * distanceS = [NSString stringWithFormat:@"距离商家 %@km", orderModel.distanceToStore];
    NSMutableAttributedString * distanceStr = [[NSMutableAttributedString alloc]initWithString:distanceS];
    [distanceStr addAttributes:attribute range:NSMakeRange(5, distanceS.length - 7)];
    self.distanceToStoreLabel.attributedText = distanceStr;
    CGRect distanceRect = [distanceS boundingRectWithSize:CGSizeMake(MAXFLOAT, self.distanceToStoreLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    self.distanceToStoreLabel.width = distanceRect.size.width;
    
    NSString * distanceOfCustomTostoreS = [NSString stringWithFormat:@"商家距离客户 %@km", orderModel.distanceToCustom];
    NSMutableAttributedString * distanceOfCustomTostoreStr = [[NSMutableAttributedString alloc]initWithString:distanceOfCustomTostoreS];
    [distanceOfCustomTostoreStr addAttributes:attribute range:NSMakeRange(7, distanceOfCustomTostoreS.length - 9)];
    self.distanceOfcustomTostore.attributedText = distanceOfCustomTostoreStr;
    CGRect distanceofRect = [distanceOfCustomTostoreS boundingRectWithSize:CGSizeMake(MAXFLOAT, self.distanceOfcustomTostore.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    self.distanceOfcustomTostore.width = distanceofRect.size.width;
    
    NSString * sendS = [NSString stringWithFormat:@"送达时间 %@", orderModel.hopeTime];
    NSMutableAttributedString * sendtimeStr = [[NSMutableAttributedString alloc]initWithString:sendS];
    [sendtimeStr addAttributes:attribute range:NSMakeRange(5, sendS.length - 5)];
    self.sendTimeLabel.attributedText = sendtimeStr;
    CGRect sendRect = [sendS boundingRectWithSize:CGSizeMake(MAXFLOAT, self.sendTimeLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    self.sendTimeLabel.width = sendRect.size.width;
    
    
    self.totlePriceView.top = self.sendTimeLabel.bottom + 16;
//    self.totlePriceView.detailsButton.frame = CGRectMake(self.totlePriceView.detailsButton.left, 0, self.totlePriceView.detailsButton.width, s elf.totlePriceView.detailsButton.height);
    self.totlePriceView.totalPrice = [NSString stringWithFormat:@"%@", orderModel.allMoney];
//    self.totlePriceView.totlePriceLabel.text = [NSString stringWithFormat:@"%@", orderModel.allMoney];
    [self.totlePriceView.startDeliveryBT setTitle:@"立即抢单" forState:UIControlStateNormal];
    self.backView.frame = CGRectMake(0, 0, self.frame.size.width, [NewOrderCell cellHeightWithMealCount:orderModel.mealArray.count] - TOP_SPACE );
//    self.totlePriceView.totlePriceLabel.frame = self.totlePriceView.detailsButton.frame;
//    self.totlePriceView.detailsButton.hidden = YES;
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
