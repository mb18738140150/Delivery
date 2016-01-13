//
//  OtherView.m
//  Delivery
//
//  Created by 仙林 on 15/10/23.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "OtherView.h"

#define LEFT_SPACE 15
#define TOP_SPACE 10


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
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, (self.frame.size.width - 2 * LEFT_SPACE)  - 40, 30)];
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    
    self.detalsLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right, TOP_SPACE, 40, 30)];
    _detalsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_detalsLabel];
    
    self.detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _detailButton.frame = _detalsLabel.frame;
    [self addSubview:_detailButton];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _detalsLabel.bottom + 9, self.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line];
    
    
    self.backgroundColor = [UIColor whiteColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
