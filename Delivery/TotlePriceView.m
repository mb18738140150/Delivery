//
//  TotlePriceView.m
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "TotlePriceView.h"

#define TOP_SPACE 10
#define LEFT_SPACE 10
#define PRICELABEL_WIDTH 80
#define BUTTON_HEIGHT 40
#define DEALBUTTON_WIDTH 100
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
    UILabel * totleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 2 * LEFT_SPACE - 2 * DEALBUTTON_WIDTH - PRICELABEL_WIDTH - 30, TOP_SPACE, 30, 30)];
    totleLabel.text = @"总¥";
    totleLabel.textColor = [UIColor grayColor];
    totleLabel.textAlignment  = NSTextAlignmentRight;
    totleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:totleLabel];
    
    self.totlePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(totleLabel.right, TOP_SPACE, PRICELABEL_WIDTH, 30)];
    _totlePriceLabel.text = @"988.0";
    _totlePriceLabel.textColor = MAIN_COLORE;
    _totlePriceLabel.font = [UIFont systemFontOfSize:24];
    [self addSubview:_totlePriceLabel];
    
    self.detailsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _detailsButton.frame = CGRectMake(_totlePriceLabel.right, TOP_SPACE - 5, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
    [_detailsButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [_detailsButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:_detailsButton];
    
    self.startDeliveryBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _startDeliveryBT.frame = CGRectMake(_detailsButton.right + TOP_SPACE, TOP_SPACE - 5, DEALBUTTON_WIDTH, BUTTON_HEIGHT);
    _startDeliveryBT.backgroundColor = MAIN_COLORE;
    [_startDeliveryBT setTitle:@"开始配送" forState:UIControlStateNormal];
    [self addSubview:_startDeliveryBT];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
