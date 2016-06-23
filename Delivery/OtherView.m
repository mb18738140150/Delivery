//
//  OtherView.m
//  Delivery
//
//  Created by 仙林 on 15/10/23.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "OtherView.h"
#import "UICustomSwitch.h"
#define LEFT_SPACE 15
#define TOP_SPACE 10
#define TOP_SPACE_1 16
#define IMAGE_HEIGHT 25

@implementation OtherView

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
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, (self.height - IMAGE_HEIGHT) / 2, IMAGE_HEIGHT, IMAGE_HEIGHT)];
    self.iconImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.right + TOP_SPACE, TOP_SPACE_1, (self.frame.size.width - 2 * LEFT_SPACE) - IMAGE_HEIGHT  - 40, 14)];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    self.detalsLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right, TOP_SPACE_1, 40, 12)];
    _detalsLabel.textColor = [UIColor grayColor];
    _detalsLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_detalsLabel];
    
    self.detailButton = [[UISwitch alloc]initWithFrame:CGRectMake(self.width - 60, (self.height - 30) / 2, 40, 30)];
    _detailButton.onTintColor = [UIColor redColor];
//    _detailButton.tintColor = [UIColor grayColor];
//    _detailButton.thumbTintColor = [UIColor whiteColor];
    _detailButton.hidden = YES;
    [self addSubview:_detailButton];
    
    
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setDetailStr:(NSString *)detailStr
{
    self.titleLabel.frame = CGRectMake(_iconImageView.right + TOP_SPACE, TOP_SPACE_1 , (self.frame.size.width - 2 * LEFT_SPACE) - IMAGE_HEIGHT , 14);
    self.detalsLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 8, _titleLabel.width, 12);
    self.detalsLabel.text = detailStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
