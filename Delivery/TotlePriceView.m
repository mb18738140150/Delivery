//
//  TotlePriceView.m
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "TotlePriceView.h"
#import "UserInfo.h"
#import "UserCenterViewController.h"

#define TOP_SPACE 10
#define LEFT_SPACE 10
#define PRICELABEL_WIDTH 80
#define BUTTON_HEIGHT 40
#define DEALBUTTON_WIDTH 80

@interface TotlePriceView ()<UIAlertViewDelegate>
@property (nonatomic, copy)NullityBlock  nullityBlock;
@end

@implementation TotlePriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line];
    
    UILabel * totleLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + 5, 15, 30)];
    totleLabel.text = @"¥";
    totleLabel.textColor = [UIColor grayColor];
    totleLabel.textAlignment  = NSTextAlignmentRight;
    totleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:totleLabel];
    
    self.totlePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(totleLabel.right, TOP_SPACE + 5, self.width - LEFT_SPACE - 3 * DEALBUTTON_WIDTH - totleLabel.width, 30)];
    _totlePriceLabel.text = @"988.0";
    _totlePriceLabel.textColor = MAIN_COLORE;
    _totlePriceLabel.font = [UIFont systemFontOfSize:24];
//    _totlePriceLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_totlePriceLabel];
    
    
    self.nullityButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nullityButton.frame = CGRectMake(self.width - 3 * DEALBUTTON_WIDTH , 0, DEALBUTTON_WIDTH, self.height);
    _nullityButton.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    [_nullityButton setTitle:@"拒绝接单" forState:UIControlStateNormal];
    [_nullityButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_nullityButton addTarget:self action:@selector(nullityOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    //    _startDeliveryBT.layer.cornerRadius = 5;
    //    _startDeliveryBT.layer.masksToBounds = YES;
    [self addSubview:_nullityButton];
    
    self.detailsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _detailsButton.frame = CGRectMake(self.width - 2 * DEALBUTTON_WIDTH , 0, DEALBUTTON_WIDTH, self.height);
    [_detailsButton setTitle:@"商品详情" forState:UIControlStateNormal];
    [_detailsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _detailsButton.backgroundColor = [UIColor colorWithRed:217 / 255.0 green:168 / 255.0 blue:38 / 255.0 alpha:1];
    
//    _detailsButton.layer.borderColor = [UIColor grayColor].CGColor;
//    _detailsButton.layer.borderWidth = 1;
//    _detailsButton.layer.cornerRadius = 5;
//    _detailsButton.layer.masksToBounds = YES;
    [self addSubview:_detailsButton];
    
    self.startDeliveryBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _startDeliveryBT.frame = CGRectMake(_detailsButton.right , 0, DEALBUTTON_WIDTH, self.height);
    _startDeliveryBT.backgroundColor = MAIN_COLORE;
    [_startDeliveryBT setTitle:@"开始配送" forState:UIControlStateNormal];
    [_startDeliveryBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _startDeliveryBT.layer.cornerRadius = 5;
//    _startDeliveryBT.layer.masksToBounds = YES;
    [self addSubview:_startDeliveryBT];
    
}

- (void)setTotalPrice:(NSString *)totalPrice
{
    NSString * moneystr = totalPrice;
    if ([moneystr containsString:@"."]) {
        
        NSArray * monerArr = [moneystr componentsSeparatedByString:@"."];
        NSString * monryStr1 = [monerArr objectAtIndex:0];
        NSString * moneyStr2 = [monerArr objectAtIndex:1];
        
        if (moneyStr2.length > 2) {
            NSString * moneyStr3 = [moneyStr2 substringToIndex:2];
            self.totlePriceLabel.text = [NSString stringWithFormat:@"%@.%@", monryStr1, moneyStr3];
        }else
        {
            self.totlePriceLabel.text = [NSString stringWithFormat:@"%@.%@", monryStr1, moneyStr2];
        }
    }else
    {
        self.totlePriceLabel.text = [NSString stringWithFormat:@"%@", moneystr];
    }
}

- (void)nulityOrderAction:(NullityBlock)block
{
    self.nullityBlock = [block copy];
}

- (void)nullityOrderAction:(UIButton *)button
{
    if ([UserInfo shareUserInfo].isOpenthebackgroundposition) {
        self.nullityBlock();
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在设置界面开启实时定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ;
    }else
    {
        UIViewController * vc = [self getCurrentViewController];
        
        UserCenterViewController * userVC = [[UserCenterViewController alloc]init];
        [vc.navigationController pushViewController:userVC animated:YES];
        
    }
}

-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
