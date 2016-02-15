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

@interface ShopView ()
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * shoplabel;
@end

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
    self.addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 5 , IMAGE_WEIDTH, IMAGE_WEIDTH)];
    _addressImageView.image = [UIImage imageNamed:@"location_order.png"];
    [self addSubview:_addressImageView];
    
    self.addressBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _addressBT.backgroundColor = [UIColor clearColor];
    _addressBT.frame = _addressImageView.frame;
    [self addSubview:_addressBT];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 90, LABEL_HEIGHT)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.text = @"集散地附近吧";
    [self addSubview:_nameLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_nameLabel.right, _nameLabel.top + 5, 1, 20)];
    line1.backgroundColor = [UIColor grayColor];
    line1.tag = 1001;
    [self addSubview:line1];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(line1.right, TOP_SPACE, 90, LABEL_HEIGHT)];
    _phoneLabel.text = @"18734890150";
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.font = [UIFont systemFontOfSize:13];
    _phoneLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_phoneLabel];
    
    self.phoneBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _phoneBT.frame = _phoneLabel.frame;
    _phoneBT.backgroundColor = [UIColor clearColor];
    [self addSubview:_phoneBT];

    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_phoneLabel.right, _phoneLabel.top + 5, 30, 20)];
    _imageView.image = [UIImage imageNamed:@"phone.png"];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.tag = 2000;
    [self addSubview:_imageView];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_imageView.right, TOP_SPACE + 5, 1, 20)];
    line2.backgroundColor = [UIColor grayColor];
    line2.tag = 1002;
    [self addSubview:line2];
    
    self.shoplabel = [[UILabel alloc]initWithFrame:CGRectMake(line2.right, TOP_SPACE, 28, LABEL_HEIGHT)];
//    _shoplabel.adjustsFontSizeToFitWidth = YES;
    _shoplabel.font = [UIFont systemFontOfSize:13];
    _shoplabel.text = @"商家";
    _shoplabel.textColor = MAIN_COLORE;
    [self addSubview:_shoplabel];
    
   
    
    if (self.width >= 370) {
        self.nameLabel.frame = CGRectMake(_addressImageView.right + LEFT_SPACE, TOP_SPACE, 80, LABEL_HEIGHT);
        line1.frame = CGRectMake(_nameLabel.right, _nameLabel.top - 5, 1, 20);
        self.phoneLabel.frame = CGRectMake(line1.right, TOP_SPACE, 100, LABEL_HEIGHT);
        line2.frame = CGRectMake(_phoneLabel.right, TOP_SPACE + 5, 1, 20);
        _shoplabel.frame = CGRectMake(line2.right, TOP_SPACE, 40, LABEL_HEIGHT);
//        self.payStateLabel.frame = CGRectMake(self.width - LEFT_SPACE - 90 , TOP_SPACE, 90, LABEL_HEIGHT);
    }
    
    
//    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageView.right + LEFT_SPACE, _nameLabel.bottom + TOP_SPACE, self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT)];
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake( _addressImageView.right + LEFT_SPACE, _nameLabel.bottom + TOP_SPACE, self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT)];
    _addressLabel.textColor = [UIColor grayColor];
    _addressLabel.text = @"未来路商城路科苑小区1号楼3单元2楼48号未来路商城路科苑小区1号楼3单元2楼48号";
//    _addressLabel.text = @"科苑小区1号楼3单元2楼48号";
    _addressLabel.numberOfLines = 0;
    [self addSubview:_addressLabel];
    
    self.orderTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _addressLabel.bottom + TOP_SPACE, self.width - 3 * LEFT_SPACE , LABEL_HEIGHT)];
    _orderTimeLB.textColor = [UIColor grayColor];
    _orderTimeLB.text = @"未来路商城路科苑小区1号楼3单元2楼48号";
    _orderTimeLB.numberOfLines = 0;
    [self addSubview:_orderTimeLB];
    
    self.payStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - LEFT_SPACE - 80 , _orderTimeLB.top, 80, LABEL_HEIGHT)];
    _payStateLabel.layer.cornerRadius = 5;
    _payStateLabel.layer.masksToBounds = YES;
    _payStateLabel.layer.borderWidth = 1;
    _payStateLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _payStateLabel.textAlignment = NSTextAlignmentCenter;
    _payStateLabel.text = @"现金支付";
    _payStateLabel.textColor = MAIN_COLORE;
    [self addSubview:_payStateLabel];
    
}

- (void)setName:(NSString *)name
{
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect nameRect = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, self.nameLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    self.nameLabel.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, nameRect.size.width, LABEL_HEIGHT);
    self.nameLabel.text = name;
    UIView * line1 = [self viewWithTag:1001];
    line1.frame = CGRectMake(_nameLabel.right, _nameLabel.top + 8, 1, 14);
    self.phoneLabel.frame = CGRectMake(line1.right, TOP_SPACE, 90, LABEL_HEIGHT);
    self.phoneBT.frame = self.phoneLabel.frame;
    self.imageView.frame = CGRectMake(_phoneLabel.right, _phoneLabel.top + 5, 20, 20);
    UIView * line2 = [self viewWithTag:1002];
    line2.frame = CGRectMake(_imageView.right + 2, TOP_SPACE + 8, 1, 14);
    self.shoplabel.frame = CGRectMake(line2.right, TOP_SPACE, 28, LABEL_HEIGHT);
}

- (void)setPhone:(NSString *)phone
{
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect phoneRect = [phone boundingRectWithSize:CGSizeMake(MAXFLOAT, self.phoneLabel.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    self.phoneLabel.text = phone;
    self.phoneLabel.frame = CGRectMake(self.phoneLabel.left, TOP_SPACE, phoneRect.size.width, LABEL_HEIGHT);
    self.phoneBT.frame = self.phoneLabel.frame;
    self.imageView.frame = CGRectMake(_phoneLabel.right, _phoneLabel.top + 5, 20, 20);
    UIView * line2 = [self viewWithTag:1002];
    line2.frame = CGRectMake(_imageView.right + 2, TOP_SPACE + 8, 1, 14);
    self.shoplabel.frame = CGRectMake(line2.right, TOP_SPACE, 28, LABEL_HEIGHT);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
