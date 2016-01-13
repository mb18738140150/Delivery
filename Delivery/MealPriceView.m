//
//  MealPriceView.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/27.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MealPriceView.h"

#define RIGHTLABEL_WIDTH 40
#define LABEL_HEITH 30
#define LEFT_SPACE 10
#define NUMLB_WIDTH 40


@implementation MealPriceView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}


- (void)createSubview
{
    UIImageView *backgroundImage = [[UIImageView alloc]init];
    backgroundImage.frame = CGRectMake(0, 0, self.width, self.height);
    backgroundImage.image = [UIImage imageNamed:@"action_food_left.png"];
    [self addSubview:backgroundImage];
    
    self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width - RIGHTLABEL_WIDTH - NUMLB_WIDTH, self.height)];
    _menuLabel.backgroundColor = [UIColor clearColor];
    _menuLabel.adjustsFontSizeToFitWidth = YES;
    _menuLabel.numberOfLines = 0;
    _menuLabel.textColor = [UIColor orangeColor];
    _menuLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_menuLabel];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_menuLabel.right, 0, NUMLB_WIDTH - 10, _menuLabel.height)];
    _numberLabel.textColor = [UIColor orangeColor];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_numberLabel];
    
    self.menuPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_numberLabel.right, 0, RIGHTLABEL_WIDTH + 10, _numberLabel.height)];
    _menuLabel.backgroundColor = [UIColor clearColor];
    _menuPriceLB.textColor = [UIColor orangeColor];
    _menuPriceLB.font = [UIFont systemFontOfSize:15];
    [self addSubview:_menuPriceLB];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
