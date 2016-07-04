//
//  ScrollLabelView.m
//  Delivery
//
//  Created by 仙林 on 16/6/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ScrollLabelView.h"

@interface ScrollLabelView()<UIScrollViewDelegate>
{
    UIScrollView * _myScroll;
    CGRect _labelrect;
}
@end


@implementation ScrollLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubviews];
    }
    return self;
}
- (void)creatSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 14, 21, 18)];
    [self addSubview:self.iconImageView];
    
    _myScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(_iconImageView.right + 15, 15, self.width - 51, 15)];
    _myScroll.delegate = self;
    _myScroll.alwaysBounceVertical = NO;
    _myScroll.showsHorizontalScrollIndicator = NO;
    _myScroll.bounces = NO;
    [self addSubview:_myScroll];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _myScroll.width, 15)];
    _addressLabel.font = [UIFont systemFontOfSize:15];
    _addressLabel.text = @"地址加载失败";
    CGSize labelSize = [_addressLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    [_myScroll addSubview:_addressLabel];
    _myScroll.contentSize = CGSizeMake(labelSize.width, 15);
    
}

- (void)setAddressStr:(NSString *)addressStr
{
    _addressLabel.text = addressStr;
    CGSize labelSize = [addressStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _myScroll.contentSize = CGSizeMake(labelSize.width, 15);
}

#pragma mark - scrollviewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖拽");
    CGSize labelSize = [_addressLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _addressLabel.width = labelSize.width;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"结束拖拽");
    CGPoint offset = scrollView.contentOffset;
    offset.x = -scrollView.contentInset.left;
    [scrollView setContentOffset:offset animated:YES];
    _addressLabel.width = scrollView.width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
