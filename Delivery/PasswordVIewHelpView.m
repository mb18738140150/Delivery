//
//  PasswordVIewHelpView.m
//  Delivery
//
//  Created by 仙林 on 15/10/29.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "PasswordVIewHelpView.h"

#define LEFT_SPACE 10
#define TOP_SPACE 10

@implementation PasswordVIewHelpView

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
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 60, 30)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(_nameLabel.right + LEFT_SPACE, TOP_SPACE, 1, _nameLabel.height)];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
    
    self.passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(lineView.right + LEFT_SPACE, TOP_SPACE, self.width - 4 * LEFT_SPACE - 1 - _nameLabel.width, 30)];
    _passwordTF.textColor = [UIColor grayColor];
    _passwordTF.alpha = .8;
    [self addSubview:_passwordTF];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
