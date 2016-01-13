//
//  OrderMenuVIew.m
//  vlifree
//
//  Created by 仙林 on 15/5/26.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "OrderMenuVIew.h"


#define LEFT_SPACE 10
#define PRICE_LABEL_WIDTH 70
#define COUNT_LABEL_WIDTH 40
#define LABEL_HEIGHT 25
//#define VIEW_COLOR [UIColor orangeColor]
#define VIEW_COLOR [UIColor clearColor]

#define TEXT_COLOR [UIColor colorWithWhite:0.3 alpha:1]
@implementation OrderMenuVIew



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuNameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, self.width - COUNT_LABEL_WIDTH - PRICE_LABEL_WIDTH - 4 * LEFT_SPACE, LABEL_HEIGHT)];
        _menuNameLB.backgroundColor = VIEW_COLOR;
        _menuNameLB.text = @"1号套餐猪排饭";
        _menuNameLB.textColor = TEXT_COLOR;
        _menuNameLB.adjustsFontSizeToFitWidth = YES;
        _menuNameLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:_menuNameLB];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_menuNameLB.right, 0, COUNT_LABEL_WIDTH, LABEL_HEIGHT)];
        _countLabel.text = @"1";
        _countLabel.textColor = TEXT_COLOR;
        _countLabel.backgroundColor = VIEW_COLOR;
        _countLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_countLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - PRICE_LABEL_WIDTH, 0, PRICE_LABEL_WIDTH, LABEL_HEIGHT)];
        _priceLabel.text = @"23";
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.backgroundColor = VIEW_COLOR;
        _priceLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_priceLabel];
        
    }
    return self;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
