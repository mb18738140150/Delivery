//
//  MealDetailsView.m
//  TinyOrder
//
//  Created by 仙林 on 16/3/1.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MealDetailsView.h"
#define LETF_SPACE 10
#define TOP_SPACE 10
@implementation MealDetailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
    }
    return self;
}


- (void)createSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(LETF_SPACE, TOP_SPACE + 1, 7, 7)];
    imageView.image = [UIImage imageNamed:@"colect_s.png"];
    [self addSubview:imageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + LETF_SPACE, 0, self.width - 2 * LETF_SPACE - imageView.width - 130, self.height)];
    self.nameLabel.textColor = [UIColor grayColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.numberOfLines = 0;
    [self addSubview:_nameLabel];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right, _nameLabel.top, 50, _nameLabel.height)];
    _countLabel.font = [UIFont systemFontOfSize:14];
    _countLabel.textColor = [UIColor grayColor];
    [self addSubview:_countLabel];
    
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_countLabel.right, _nameLabel.top, 70, _nameLabel.height)];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.textColor = [UIColor grayColor];
    [self addSubview:_priceLabel];
    
}

- (void)setNametext:(NSString *)nametext
{
    CGSize size = [nametext boundingRectWithSize:CGSizeMake(self.nameLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if (size.height > self.height) {
        self.nameLabel.height = size.height;
        self.height = size.height;
        NSLog(@"***************************************************************");
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
