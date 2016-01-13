//
//  NewOrderCell.m
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "NewOrderCell.h"
#import "ShopView.h"
#import "CustomerView.h"


#define TOP_SPACE 10
#define SHOPVIEW_HEIGHT 90
#define CUSTOMERVIEW_HEIGHT 120
#define TOTLEPRICEVIEW_HEIGHT 60
#define MENUVIEW_HEIGHT 30

@interface NewOrderCell ()

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)ShopView * shopView;
@property (nonatomic, strong)CustomerView * customerView;


@end

@implementation NewOrderCell


- (void)createSubView:(CGRect)frame mealCoutn:(int)mealCount;
{
    [self removeAllSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [NewOrderCell cellHeightWithMealCount:mealCount] - TOP_SPACE )];
    _backView.backgroundColor = [UIColor whiteColor];
    
    self.shopView = [[ShopView alloc]initWithFrame:CGRectMake(0, 0, self.width, 90)];
    [_shopView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shopView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _shopView.bottom, self.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line];
    
    self.customerView = [[CustomerView alloc]initWithFrame:CGRectMake(0, line.bottom, self.width, 120)];
    [_customerView.phoneBT addTarget:self action:@selector(telToOrderTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_customerView];
    
    UIView * linePrice = [[UIView alloc]initWithFrame:CGRectMake(0, _customerView.bottom, self.width, 1)];
    linePrice.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:linePrice];
    
    self.totlePriceView = [[TotlePriceView alloc]initWithFrame:CGRectMake(0, linePrice.bottom, self.width, 60)];
    [self addSubview:_totlePriceView];
    
}


+ (CGFloat)cellHeightWithMealCount:(int)mealCount
{
    return SHOPVIEW_HEIGHT  + MENUVIEW_HEIGHT * ((mealCount - 1)/ 2 + 1 ) + (mealCount - 1) / 2 * 10  + 30  + CUSTOMERVIEW_HEIGHT + TOTLEPRICEVIEW_HEIGHT + TOP_SPACE ;
}

- (void)setOrderModel:(NewOrderModel *)orderModel
{
    
}

- (void)telToOrderTelNumber:(UIButton *)button
{
    UIWebView *callWebView = [[UIWebView alloc]init];
    NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.orderModel.tel]];
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
