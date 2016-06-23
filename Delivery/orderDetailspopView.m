//
//  orderDetailspopView.m
//  Delivery
//
//  Created by 仙林 on 16/6/23.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "orderDetailspopView.h"
#import "TotlePriceView.h"
#import "MealDetailsView.h"
#import "Meal.h"

#define SHOP_PHONE_BT_TAG 4000
#define CUSTOM_PHONT_BT_TAG 6000

@interface orderDetailspopView()

@property (strong, nonatomic) IBOutlet UIScrollView *myscroll;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *backBT;

// 商家
@property (strong, nonatomic) IBOutlet UILabel *shopNameLB;
@property (strong, nonatomic) IBOutlet UILabel *shopPhoneLB;
@property (strong, nonatomic) IBOutlet UILabel *shopAddressLB;
@property (strong, nonatomic) IBOutlet UIButton *shopPhoneBT;

// 用户
@property (strong, nonatomic) IBOutlet UILabel *customNameLB;
@property (strong, nonatomic) IBOutlet UILabel *customPhoneLB;
@property (strong, nonatomic) IBOutlet UILabel *customAddressLB;
@property (strong, nonatomic) IBOutlet UIButton *customPhoneBT;

@property (strong, nonatomic) IBOutlet UILabel *payStateLB;
@property (strong, nonatomic) IBOutlet UIView *meallistView;

@property (nonatomic, strong)TotlePriceView * totalPriceView;

@property (nonatomic, strong)NSDictionary * dic;

@end

@implementation orderDetailspopView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addOtherView];
        NSLog(@"加载");
    }
    return self;
}

- (void)addOtherView
{
    self.backView.height = self.meallistView.bottom + 50;
    self.myscroll.contentSize = CGSizeMake(self.myscroll.width, self.backView.bottom);
    
//    [self.backBT addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.shopPhoneBT = [self viewWithTag:SHOP_PHONE_BT_TAG];
    self.customPhoneBT = [self viewWithTag:CUSTOM_PHONT_BT_TAG];
    
    [self.shopPhoneBT addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customPhoneBT addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)createWithDic:(NSDictionary *)dic
{
    self.dic = dic;
    
    self.shopNameLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"BusiName"]];
    NSDictionary * attributesshop = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGRect nameRectshop = [self.shopNameLB.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.shopNameLB.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributesshop context:nil];
    self.customNameLB.frame = CGRectMake(self.shopNameLB.left, self.shopNameLB.top , nameRectshop.size.width, self.shopNameLB.height);
    self.shopPhoneLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"BusiPhone"]];
    self.shopAddressLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"BusiAddress"]];
    CGRect addressRectshop = [self.shopAddressLB.text boundingRectWithSize:CGSizeMake(self.shopAddressLB.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesshop context:nil];
    _customAddressLB.frame = CGRectMake(self.shopAddressLB.left, self.shopAddressLB.top , self.shopAddressLB.width, addressRectshop.size.height);
    
    self.customNameLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerName"]];
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGRect nameRect = [self.customNameLB.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.customNameLB.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    self.customNameLB.frame = CGRectMake(self.customNameLB.left, self.customNameLB.top , nameRect.size.width, self.customNameLB.height);
    
    self.customPhoneLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerPhone"]];
    self.customAddressLB.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"CustomerAddress"]];
    CGRect addressRect = [self.customAddressLB.text boundingRectWithSize:CGSizeMake(self.customAddressLB.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    _customAddressLB.frame = CGRectMake(self.customAddressLB.left, self.customAddressLB.top , self.customAddressLB.width, addressRect.size.height);
    
    NSArray * mealsarray = [dic objectForKey:@"MealList"];
    
    NSMutableArray *mealarray = [NSMutableArray array];
    for (NSDictionary * dic in mealsarray) {
        Meal * meal = [[Meal alloc]initWithDictionary:dic];
        [mealarray addObject:meal];
    }
    
    
    for (int i = 0; i < mealarray.count; i++) {
        MealDetailsView * mealDetailView = [[MealDetailsView alloc]initWithFrame:CGRectMake(0, 47 + 30 * i, self.width - 30, 30)];
        Meal * meal = [mealarray objectAtIndex:i];
        
        mealDetailView.nametext = meal.name;
        mealDetailView.nameLabel.text = meal.name;
        mealDetailView.countLabel.text = [NSString stringWithFormat:@"x %d", meal.count];
        mealDetailView.priceLabel.text = [NSString stringWithFormat:@"%.2f元", meal.money];
        [self.meallistView addSubview:mealDetailView];
        self.meallistView.height = mealDetailView.bottom + 10;
    }
    self.meallistView.height = 47 + mealarray.count * 30;
    self.backView.frame = CGRectMake(self.backView.left, self.backView.top, self.backView.width, self.meallistView.bottom);
    self.myscroll.backgroundColor = self.backView.backgroundColor;
//    self.myscroll.contentSize = CGSizeMake(self.myscroll.width, self.meallistView.bottom + 10);
    NSLog(@"^^^^^^^^%f********%f", self.backView.height, self.meallistView.bottom);
    
}

- (void)calculate
{
    [self addTotleView];
    
    NSArray * mealsarray = [self.dic objectForKey:@"MealList"];
    self.meallistView.height = 47 + mealsarray.count * 30;
    
    self.myscroll.contentSize = CGSizeMake(self.myscroll.width, self.meallistView.bottom + 15);
    NSLog(@"^^^^^^^^^%f, ^^^^^^^%f", self.myscroll.height, self.myscroll.contentSize.height);
}
- (void)addTotleView
{
    self.totalPriceView = [[TotlePriceView alloc]initWithFrame:CGRectMake(0, self.height - 45, self.width, 45)];
    [self addSubview:_totalPriceView];
}
- (void)phoneAction:(UIButton *)button
{
    if (button.tag == CUSTOM_PHONT_BT_TAG) {
        NSLog(@"打电话%@", [NSString stringWithFormat:@"%@", self.customPhoneLB.text]);
        UIWebView *callWebView = [[UIWebView alloc]init];
        NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.customPhoneLB.text]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self addSubview:callWebView];
    }else
    {
        NSLog(@"打电话***%@", [NSString stringWithFormat:@"%@", self.shopPhoneLB.text]);
        UIWebView *callWebView = [[UIWebView alloc]init];
        NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.shopPhoneLB.text]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self addSubview:callWebView];
    }
}

- (IBAction)dismiss:(id)sender {
    NSLog(@"移除弹出框");
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
