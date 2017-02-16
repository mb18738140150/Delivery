//
//  DeliveryingCell.m
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "DeliveryingCell.h"




#define TOP_SPACE 10
#define SHOPVIEW_HEIGHT 120
#define CUSTOMERVIEW_HEIGHT 150
#define TOTLEPRICEVIEW_HEIGHT 50
#define MENUVIEW_HEIGHT 30
#define LINE_tag 8000

static int height = 0;
static int shopHeight = 0;
@interface DeliveryingCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel * storenameLabel;
@property (nonatomic, strong)UILabel * payStateLabel;
@property (nonatomic, strong)UILabel * sendtimeLabel;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UIView * linePrice;

@property (nonatomic, strong)UILabel * customLabel;
@property (nonatomic, strong)UIView * seperateline;
@property (nonatomic, strong)UILabel * customPhoneLabel;
@property (nonatomic, strong)UILabel * customAddtrssLabel;
@property (nonatomic, strong)UIImageView * cusimageview;
@property (nonatomic, strong)UILabel * cusaddressLB;
@property (nonatomic, strong)UIImageView * cusaddressimageview;
@property (nonatomic, strong)UILabel * customaddressLB;
@property (nonatomic, strong)UIButton * phoneBt;

@property (nonatomic, strong)UIImageView * remarkImageView;
@property (nonatomic, strong)UILabel * remarkLabel;


@end
@implementation DeliveryingCell

- (void)createSubView:(CGRect)frame mealCoutn:(NewOrderModel *)model
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [DeliveryingCell cellHeightWithMealCount:model] - TOP_SPACE )];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    
    self.storenameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150, 15)];
    self.storenameLabel.font = [UIFont systemFontOfSize:15];
    self.storenameLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    [self addSubview:self.storenameLabel];
    
    self.sendtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 75, 15, 60, 15)];
    self.sendtimeLabel.textColor = MAIN_COLORE;
    self.sendtimeLabel.font = [UIFont systemFontOfSize:15];
    self.sendtimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.sendtimeLabel];
    
    UIView * line2View = [[UIView alloc]initWithFrame:CGRectMake(self.sendtimeLabel.left - 6, 10, 1, 25)];
    line2View.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line2View];
    
    self.payStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(line2View.left - 75, 15, 70, 15)];
    self.payStateLabel.font = [UIFont systemFontOfSize:15];
    self.payStateLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    [self addSubview:self.payStateLabel];
    
    UIView * lineView3view = [[UIView alloc]initWithFrame:CGRectMake(self.payStateLabel.left - 6, 10, 1, 25)];
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
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, addressLB.bottom + 7, frame.size.width - 40, 12)];
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = [UIColor colorWithWhite:.6 alpha:1];
    self.addressLabel.numberOfLines = 0;
    [self addSubview:self.addressLabel];
    
   self.cusimageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.addressLabel.bottom + 9, 7, 7)];
    self.cusimageview.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cusimageview];
    self.cusimageview.image = [UIImage imageNamed:@"colect_s.png"];
    
    self.cusaddressLB = [[UILabel alloc]initWithFrame:CGRectMake(self.cusimageview.right + 10, self.addressLabel.bottom + 10, 85, 13)];
    self.cusaddressLB.text = @"客户联系方式:";
    self.cusaddressLB.font = [UIFont systemFontOfSize:13];
    self.cusaddressLB.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [self addSubview:self.cusaddressLB];
    
    self.customLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, self.cusaddressLB.bottom + 5, 30, 12)];
    self.customLabel.font = [UIFont systemFontOfSize:12];
    self.customLabel.textColor = [UIColor colorWithWhite:.6 alpha:1];
    self.customLabel.numberOfLines = 0;
    [self addSubview:self.customLabel];
    
    self.seperateline = [[UIView alloc]initWithFrame:CGRectMake(self.customLabel.right + 5, self.customLabel.top, 1, 12)];
    self.seperateline.backgroundColor = [UIColor colorWithWhite:.6 alpha:1];
    [self addSubview:self.seperateline];
    
    self.customPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.seperateline.right + 5, self.customLabel.top, 80, 12)];
    self.customPhoneLabel.font = [UIFont systemFontOfSize:12];
    self.customPhoneLabel.textColor = [UIColor colorWithWhite:.6 alpha:1];
    [self addSubview:self.customPhoneLabel];
    
    self.phoneBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneBt.frame = CGRectMake(frame.size.width - 38, self.linePrice.bottom + 70, 28, 28);
    [self.phoneBt setImage:[UIImage imageNamed:@"icon_hua.png"] forState:UIControlStateNormal];
    [self.phoneBt addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.phoneBt];
    
    self.cusaddressimageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.customLabel.bottom + 10, 7, 7)];
    self.cusaddressimageview.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cusaddressimageview];
    self.cusaddressimageview.image = [UIImage imageNamed:@"colect_s.png"];
    
    self.customaddressLB = [[UILabel alloc]initWithFrame:CGRectMake(self.cusaddressimageview.right + 10, self.customLabel.bottom + 9, 85, 13)];
    self.customaddressLB.text = @"送货地址:";
    self.customaddressLB.font = [UIFont systemFontOfSize:13];
    self.customaddressLB.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [self addSubview:self.customaddressLB];
    
    self.customAddtrssLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, self.customaddressLB.bottom + 7, frame.size.width - 40, 26)];
    self.customAddtrssLabel.font = [UIFont systemFontOfSize:12];
    self.customAddtrssLabel.textColor = [UIColor colorWithWhite:.6 alpha:1];
    self.customAddtrssLabel.numberOfLines = 0;
    [self addSubview:self.customAddtrssLabel];
    
    
    self.remarkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.customAddtrssLabel.bottom + 10, 7, 7)];
    _remarkImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_remarkImageView];
    _remarkImageView.image = [UIImage imageNamed:@"colect_s.png"];
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.remarkImageView.right + 10, self.customAddtrssLabel.bottom + 9, frame.size.width - 40, 13)];
    self.remarkLabel.text = @"订单备注: ";
    self.remarkLabel.font = [UIFont systemFontOfSize:13];
    self.remarkLabel.numberOfLines = 0;
    self.remarkLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [self addSubview:self.remarkLabel];
    
    self.totlePriceView = [[TotlePriceView alloc]initWithFrame:CGRectMake(0, self.remarkLabel.bottom + 6, self.width, TOTLEPRICEVIEW_HEIGHT)];
    self.totlePriceView.nullityButton.hidden = YES;
    [self addSubview:_totlePriceView];
    
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
    
    self.linePrice = [[UIView alloc]initWithFrame:CGRectMake(0, _customerView.bottom, self.width, 1)];
    _linePrice.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [self addSubview:_linePrice];
    
    
}


+ (CGFloat)cellHeightWithMealCount:(NewOrderModel * )model
{
//    int num = mealCount / 2 + mealCount % 2;
//    //
//    //    _mealsView.frame = CGRectMake(0, _addressLabel.bottom, self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, num * 30 + 10 * (num - 1) + 30);
//    
//    return SHOPVIEW_HEIGHT  + MENUVIEW_HEIGHT * ((mealCount - 1)/ 2 + 1 ) + (mealCount - 1) / 2 * 10  + 30  + CUSTOMERVIEW_HEIGHT + TOTLEPRICEVIEW_HEIGHT + TOP_SPACE + height + shopHeight;
    //    return SHOPVIEW_HEIGHT  + num * 30 + 10 * (num - 1) + 30  + CUSTOMERVIEW_HEIGHT + TOTLEPRICEVIEW_HEIGHT + TOP_SPACE ;
    
    CGFloat height1 ;
    
    if (model.remark.length > 0) {
        NSString * remark = model.remark;
        CGSize remarkSize = [remark boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (remarkSize.height > 22) {
            height1 = remarkSize.height;
        }else
        {
            height1 = 22;
        }
    }else
    {
        height1 = 0;
    }
    
    return 253 - 28 + height + shopHeight + 15 + height1;
}
- (void)setOrderModel:(NewOrderModel *)orderModel
{

    self.storenameLabel.text = orderModel.busiName;
    if (orderModel.payType == 1) {
        self.payStateLabel.text = @"在线支付";
    }else
    {
        self.payStateLabel.text = @"现金支付";
    }
    self.sendtimeLabel.text = orderModel.hopeTime;
//    orderModel.busiAddress = @"金水区经八路黄河路交叉口相对100米路西9号院1号楼3单元2楼601";
    self.addressLabel.text = orderModel.busiAddress;
    
    NSString * shopaddress =  orderModel.busiAddress;
        CGSize size = CGSizeMake(self.addressLabel.width, 1000);
        CGRect shopRect = [shopaddress boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    
        if (shopRect.size.height  <= 12) {
            ;
        }else
        {
            shopHeight = shopRect.size.height - 12;
            
            self.addressLabel.frame = CGRectMake(31, self.addressLabel.top, self.width - 40, shopRect.size.height);
            self.cusimageview.frame = CGRectMake(15, self.addressLabel.bottom + 13, 7, 7);
            
            self.cusaddressLB.frame = CGRectMake(self.cusimageview.right + 10, self.addressLabel.bottom + 10, 85, 13);
            
            self.customLabel.frame = CGRectMake(31, self.cusaddressLB.bottom + 5, 30, 12);
            
            self.seperateline.frame = CGRectMake(self.customLabel.right + 5, self.customLabel.top, 1, 12);
            
            self.customPhoneLabel.frame = CGRectMake(self.seperateline.right + 5, self.customLabel.top, 80, 12);
            
            self.phoneBt.frame = CGRectMake(self.phoneBt.left, self.addressLabel.bottom + 9, 28, 28);
            self.cusaddressimageview.frame = CGRectMake(15, self.customLabel.bottom + 13, 7, 7);
            self.customaddressLB.frame = CGRectMake(self.cusaddressimageview.right + 10, self.customLabel.bottom + 9, 85, 13);
            self.customAddtrssLabel.frame = CGRectMake(31, self.customaddressLB.bottom + 7, self.customAddtrssLabel.size.width - 40, 26);
            
            self.remarkImageView.frame = CGRectMake(15, self.customAddtrssLabel.bottom + 10, 7, 7);
            self.remarkLabel.frame = CGRectMake(self.remarkImageView.right + 10, self.customAddtrssLabel.bottom + 9, self.remarkLabel.width, 13);
            
        }
    
    self.customLabel.text = orderModel.customerName;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGRect nameRect = [orderModel.customerName boundingRectWithSize:CGSizeMake(MAXFLOAT, self.customLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    self.customLabel.frame = CGRectMake(self.customLabel.left, self.customLabel.top, nameRect.size.width, 12);
    self.seperateline.left = self.customLabel.right + 5;
    self.customPhoneLabel.text = orderModel.customerPhone;
    CGRect phoneRect = [orderModel.customerPhone boundingRectWithSize:CGSizeMake(MAXFLOAT, self.customPhoneLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    self.customPhoneLabel.frame = CGRectMake(self.seperateline.right + 5, self.customPhoneLabel.top, phoneRect.size.width, 12);
//    orderModel.customerAddress = @"金水区经八路黄河路交叉口相对100米路西9号院1号楼3单元2楼601";
    self.customAddtrssLabel.text = orderModel.customerAddress;
    NSString * contentText = orderModel.customerAddress;
        CGSize maxSize = CGSizeMake(self.customAddtrssLabel.width, 1000);
        CGRect textRect = [contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    
        if (textRect.size.height  <= 12) {
            self.customAddtrssLabel.frame = CGRectMake(31, self.customaddressLB.bottom + 7, self.customAddtrssLabel.width , 12);
            self.remarkImageView.frame = CGRectMake(15, self.customAddtrssLabel.bottom + 10 + textRect.size.height - 12, 7, 7);
            self.remarkLabel.frame = CGRectMake(self.remarkImageView.right + 10, self.customAddtrssLabel.bottom + 7 + textRect.size.height - 12, self.remarkLabel.width, 13);
        }else
        {
            
            height = textRect.size.height - 12;
            self.customAddtrssLabel.frame = CGRectMake(31, self.customaddressLB.bottom + 7, self.customAddtrssLabel.width , textRect.size.height);
            self.remarkImageView.frame = CGRectMake(15, self.customAddtrssLabel.bottom + 10 + textRect.size.height - 12, 7, 7);
            self.remarkLabel.frame = CGRectMake(self.remarkImageView.right + 10, self.customAddtrssLabel.bottom + 7 + textRect.size.height - 12, self.remarkLabel.width, 13);
        }
    
    if (orderModel.remark.length == 0) {
        self.remarkImageView.hidden = YES;
        self.remarkLabel.hidden = YES;
        self.totlePriceView.top = self.customAddtrssLabel.bottom + 6;
    }else
    {
        NSString * remark = orderModel.remark;
        CGSize remarkSize = [remark boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        self.remarkImageView.hidden = NO;
        self.remarkLabel.hidden = NO;
        self.remarkLabel.height = remarkSize.height;
        self.remarkLabel.text = [NSString stringWithFormat:@"订单备注: %@", remark];
        
        if (remarkSize.height > 22) {
            self.totlePriceView.top = self.customAddtrssLabel.bottom + 6 + remarkSize.height;
        }else
        {
            self.totlePriceView.top = self.customAddtrssLabel.bottom + 6 + 22;
        }
    }
    
    self.totlePriceView.totalPrice = [NSString stringWithFormat:@"%@", orderModel.allMoney];
//    self.totlePriceView.totlePriceLabel.text = [NSString stringWithFormat:@"%@", orderModel.allMoney];
    if (orderModel.orderState.intValue == 2) {
        if (orderModel.isTakeFood.intValue == 1) {
            self.totlePriceView.nullityButton.hidden = YES;
        }else
        {
            self.totlePriceView.nullityButton.hidden = NO;
        }
        [self.totlePriceView.nullityButton setTitle:@"放弃订单" forState:UIControlStateNormal];
        if (orderModel.isTakeFood.intValue == 1) {
            [self.totlePriceView.startDeliveryBT setTitle:@"开始配送" forState:UIControlStateNormal];
        }else
        {
             [self.totlePriceView.startDeliveryBT setTitle:@"到达商家处" forState:UIControlStateNormal];
        }
        
    }else
    {
        [self.totlePriceView.startDeliveryBT setTitle:@"确认送达" forState:UIControlStateNormal];
    }
    
    self.backView.frame = CGRectMake(0, 0, self.frame.size.width, [DeliveryingCell cellHeightWithMealCount:orderModel] - TOP_SPACE );
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
