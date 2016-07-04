//
//  reasonTableViewCell.m
//  Delivery
//
//  Created by 仙林 on 16/6/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "reasonTableViewCell.h"

@implementation reasonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"选中了");
    // Configure the view for the selected state
}

@end
