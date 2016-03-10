//
//  CustomerView.m
//  Delivery
//
//  Created by 仙林 on 15/11/3.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "CustomerView.h"
#import "Meal.h"
#import "MealPriceView.h"
#define IMAGE_WEIDTH 30
#define LABEL_HEIGHT 30
#define TOP_SPACE 10
#define LEFT_SPACE 10
#define NUMLABEL_WIDTH 40

@interface CustomerView ()
@property (nonatomic, strong)UILabel * customLabel;
@property (nonatomic, strong)UIImageView * imageView;
@end

@implementation CustomerView



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
    self.addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 5, IMAGE_WEIDTH, IMAGE_WEIDTH)];
    _addressImageView.image = [UIImage imageNamed:@"location_order.png"];
    [self addSubview:_addressImageView];
    
    self.addressBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _addressBT.backgroundColor = [UIColor clearColor];
    _addressBT.frame = _addressImageView.frame;
    [self addSubview:_addressBT];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageView.right + LEFT_SPACE, TOP_SPACE, 60, LABEL_HEIGHT)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.text = @"集散地附近吧";
    [self addSubview:_nameLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_nameLabel.right, TOP_SPACE + 5, 1, 20)];
    line1.backgroundColor = [UIColor grayColor];
    line1.tag = 1001;
    [self addSubview:line1];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(line1.right, TOP_SPACE, 90, LABEL_HEIGHT)];
    _phoneLabel.text = @"18734890150";
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
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
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_phoneLabel.right, TOP_SPACE + 5, 1, 20)];
    line2.backgroundColor = [UIColor grayColor];
    line2.tag = 1002;
    [self addSubview:line2];
    
    self.customLabel = [[UILabel alloc]initWithFrame:CGRectMake(line2.right, TOP_SPACE, 28, LABEL_HEIGHT)];
//    _customLabel.adjustsFontSizeToFitWidth = YES;
    _customLabel.font = [UIFont systemFontOfSize:13];
    _customLabel.text = @"客户";
    _customLabel.textColor = MAIN_COLORE;
    [self addSubview:_customLabel];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(self.width - (self.width / 2 - LEFT_SPACE - NUMLABEL_WIDTH) - LEFT_SPACE, TOP_SPACE, self.width / 2 - LEFT_SPACE - NUMLABEL_WIDTH, _phoneLabel.height)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.enabled = NO;
    textField.layer.cornerRadius = 5;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self addSubview:textField];
    
    UILabel * arriveLB = [[UILabel alloc]initWithFrame:CGRectMake(textField.left + 1, TOP_SPACE + 1, textField.width / 2 - 1, textField.height - 2)];
    arriveLB.text = @"送达时间";
    arriveLB.adjustsFontSizeToFitWidth = YES;
    arriveLB.layer.cornerRadius = 5;
    arriveLB.layer.masksToBounds = YES;
    arriveLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:arriveLB];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(arriveLB.right + 1, arriveLB.top + 4, 1, 20)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    
    self.arriveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(line.right, arriveLB.top, textField.width / 2 - 1, arriveLB.height)];
    _arriveTimeLabel.text = @"00:00";
    _arriveTimeLabel.textAlignment = NSTextAlignmentCenter;
//        _arriveTimeLabel.font = [UIFont systemFontOfSize:13];
    _arriveTimeLabel.adjustsFontSizeToFitWidth = YES;
    _arriveTimeLabel.layer.cornerRadius = 5;
    _arriveTimeLabel.layer.masksToBounds = YES;
    self.arriveTimeLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [self addSubview:_arriveTimeLabel];

    
//    if (self.width >= 370) {
////        self.nameLabel.frame = CGRectMake(_addressImageView.right + LEFT_SPACE, TOP_SPACE, 80, LABEL_HEIGHT);
////        line1.frame = CGRectMake(_nameLabel.right, _nameLabel.top - 5, 1, 20);
////        self.phoneLabel.frame = CGRectMake(line1.right, TOP_SPACE, 100, LABEL_HEIGHT);
////        line2.frame = CGRectMake(_phoneLabel.right, TOP_SPACE + 5, 1, 20);
////        label.frame = CGRectMake(line2.right, TOP_SPACE, 40, LABEL_HEIGHT);
//        textField.frame = CGRectMake(self.width - LEFT_SPACE - 100 , TOP_SPACE, 100, LABEL_HEIGHT);
//    }
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageView.right + LEFT_SPACE, _nameLabel.bottom + TOP_SPACE, self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT)];
    _addressLabel.textColor = [UIColor grayColor];
    _addressLabel.numberOfLines = 0;
    _addressLabel.text = @"未来路商城路科苑小区1号楼3单元2楼48号";
    [self addSubview:_addressLabel];
    
    
    self.mealsView = [[UIView alloc]initWithFrame:CGRectMake(0, _addressLabel.bottom , self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, 0)];
    [self addSubview:_mealsView];
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _mealsView.bottom, _mealsView.width, LABEL_HEIGHT)];
    _remarkLabel.text = @"注:请十二点半之前送到";
    _remarkLabel.textColor = [UIColor grayColor];
    [self addSubview:_remarkLabel];
    
    self.giftLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, _remarkLabel.bottom, _remarkLabel.width, LABEL_HEIGHT)];
    _giftLabel.text = @"赠品：抽纸一盒";
    _giftLabel.textColor = [UIColor grayColor];
    [self addSubview:_giftLabel];
    
    
}
- (void)creatMealViewWithArray:(NSMutableArray *)array
{
    int k = 0;
    for (int i = 0; i < array.count; i++) {
        Meal * meal = [array objectAtIndex:i];
        MealPriceView * mealPriceView = [[MealPriceView alloc]initWithFrame:CGRectMake(LEFT_SPACE + (self.width - 3 * LEFT_SPACE) / 2 * k + LEFT_SPACE * k, 15 + (i) / 2 * 40, (self.width - 3 * LEFT_SPACE) / 2, 30)];
        k++;
        if ((i + 1) % 2 == 0) {
            k = 0;
        }
        [_mealsView addSubview:mealPriceView];
        mealPriceView.menuLabel.text = meal.name;
        mealPriceView.menuPriceLB.text = [NSString stringWithFormat:@"¥%g", meal.money];
        mealPriceView.numberLabel.text = [NSString stringWithFormat:@"X%d", meal.count];
    }
    int num = 0;
    int mealCount = array.count;
    num = mealCount / 2 + mealCount % 2;

    _mealsView.frame = CGRectMake(0, _addressLabel.bottom, self.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, num * 30 + 10 * (num - 1) + 30);
    self.remarkLabel.frame = CGRectMake(LEFT_SPACE, _mealsView.bottom, _mealsView.width, LABEL_HEIGHT);
    self.giftLabel.frame = CGRectMake(LEFT_SPACE, _remarkLabel.bottom, _remarkLabel.width, LABEL_HEIGHT);
    
}

- (void)setName:(NSString *)name
{
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect nameRect = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, self.nameLabel.width) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    self.nameLabel.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, nameRect.size.width, LABEL_HEIGHT);
    self.nameLabel.text = name;
    UIView * line1 = [self viewWithTag:1001];
    line1.frame = CGRectMake(_nameLabel.right, _nameLabel.top + 9, 1, 14);
    self.phoneLabel.frame = CGRectMake(line1.right, TOP_SPACE, 90, LABEL_HEIGHT);
    self.phoneBT.frame = self.phoneLabel.frame;
    self.imageView.frame = CGRectMake(_phoneLabel.right, _phoneLabel.top + 5, 20, 20);
    UIView * line2 = [self viewWithTag:1002];
    line2.frame = CGRectMake(_imageView.right + 2, TOP_SPACE + 8, 1, 14);
    self.customLabel.frame = CGRectMake(line2.right, TOP_SPACE, 28, LABEL_HEIGHT);
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
    self.customLabel.frame = CGRectMake(line2.right, TOP_SPACE, 28, LABEL_HEIGHT);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
