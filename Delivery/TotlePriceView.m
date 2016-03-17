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
#define DEALBUTTON_WIDTH 90
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
    UILabel * totleLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + 5, 15, 30)];
    totleLabel.text = @"¥";
    totleLabel.textColor = [UIColor grayColor];
    totleLabel.textAlignment  = NSTextAlignmentRight;
    totleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:totleLabel];
    
    self.totlePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(totleLabel.right, TOP_SPACE + 5, self.width - 2 * LEFT_SPACE - 2 * DEALBUTTON_WIDTH - totleLabel.width, 30)];
    _totlePriceLabel.text = @"988.0";
    _totlePriceLabel.textColor = MAIN_COLORE;
    _totlePriceLabel.font = [UIFont systemFontOfSize:24];
//    _totlePriceLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_totlePriceLabel];
    
    self.detailsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _detailsButton.frame = CGRectMake(self.width - 2 * DEALBUTTON_WIDTH , 0, DEALBUTTON_WIDTH, self.height);
    [_detailsButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [_detailsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _detailsButton.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
