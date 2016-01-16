//
//  ShopView.m
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "ShopView.h"

#define IMAGE_WEIDTH 30
#define LABEL_HEIGHT 30
#define TOP_SPACE 10
#define LEFT_SPACE 10

@implementation ShopView

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
    self.addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE , IMAGE_WEIDTH, IMAGE_WEIDTH)];
    _addressImageView.image = [UIImage imageNamed:@"location_order.png"];
    [self addSubview:_addressImageView];
//    
//    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageView.right + LEFT_SPACE, TOP_SPACE, 60, LABEL_HEIGHT)];
//    _nameLabel.textAlignment = NSTextAlignmentCenter;
//    _nameLabel.adjustsFontSizeToFitWidth = YES;
//    _nameLabel.text = @"集散地附近吧";
//    [self addSubview:_nameLabel];
//    
//    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_nameLabel.right, _nameLabel.top - 5, 1, 20)];
//    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [self addSubview:line1];
//    
//    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(line1.right, TOP_SPACE, 90, LABEL_HEIGHT)];
//    _phoneLabel.text = @"18734890150";
//    _phoneLabel.textAlignment = NSTextAlignmentCenter;
//    _phoneLabel.adjustsFontSizeToFitWidth = YES;
//    [self addSubview:_phoneLabel];
//    
//    self.phoneBT = [UIButton buttonWithType:UIButtonTypeSystem];
//    _phoneBT.frame = _phoneLabel.frame;
//    _phoneBT.backgroundColor = [UIColor clearColor];
//    [self addSubview:_phoneBT];
//    
//    
//    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_phoneLabel.right, TOP_SPACE + 5, 1, 20)];
//    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [self addSubview:line2];
//    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(line2.right, TOP_SPACE, 28, LABEL_HEIGHT)];
//    label.adjustsFontSizeToFitWidth = YES;
//    label.text = @"商家";
//    label.textColor = MAIN_COLORE;
//    [self addSubview:label];
    
    self.payStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - LEFT_SPACE - 80 , TOP_SPACE, 80, LABEL_HEIGHT)];
    _payStateLabel.layer.cornerRadius = 5;
    _payStateLabel.layer.masksToBounds = YES;
    _payStateLabel.layer.borderWidth = 1;
    _payStateLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _payStateLabel.textAlignment = NSTextAlignmentCenter;
    _payStateLabel.text = @"餐到付款";
    _payStateLabel.textColor = MAIN_COLORE;
    [self addSubview:_payStateLabel];
    
//    if (self.width >= 370) {
//        self.nameLabel.frame = CGRectMake(_addressImageView.right + LEFT_SPACE, TOP_SPACE, 80, LABEL_HEIGHT);
//        line1.frame = CGRectMake(_nameLabel.right, _nameLabel.top - 5, 1, 20);
//        self.phoneLabel.frame = CGRectMake(line1.right, TOP_SPACE, 100, LABEL_HEIGHT);
//        line2.frame = CGRectMake(_phoneLabel.right, TOP_SPACE + 5, 1, 20);
//        label.frame = CGRectMake(line2.right, TOP_SPACE, 40, LABEL_HEIGHT);
//        self.payStateLabel.frame = CGRectMake(self.width - LEFT_SPACE - 90 , TOP_SPACE, 90, LABEL_HEIGHT);
//    }
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageView.right + LEFT_SPACE, _nameLabel.bottom + TOP_SPACE, self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT)];
    _addressLabel.textColor = [UIColor grayColor];
    _addressLabel.text = @"未来路商城路科苑小区1号楼3单元2楼48号";
    _addressLabel.numberOfLines = 0;
    [self addSubview:_addressLabel];
    
    NSLog(@"dubf");
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
