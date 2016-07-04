//
//  GiveupReasonView.m
//  Delivery
//
//  Created by 仙林 on 16/6/27.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "GiveupReasonView.h"
#import "reasonTableViewCell.h"
#import "AppDelegate.h"
@interface GiveupReasonView()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, copy)GiveUpBlock myBlock;
@property (nonatomic, copy)NSString * reasonStr;

@property (strong, nonatomic) IBOutlet UIButton *dismissBT;
@property (strong, nonatomic) IBOutlet UIButton *sureGiveupBT;
@property (strong, nonatomic) IBOutlet UITableView *reasonTableView;
@property (strong, nonatomic) IBOutlet UITextView *reasonTextView;

@property (nonatomic, strong) IBOutlet UITableViewCell *customCell;

@property (nonatomic, strong)NSArray * reasonArr;

@end

@implementation GiveupReasonView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addOtherView];
    }
    return self;
}

- (void)addOtherView
{
    self.reasonArr = @[@"交通拥堵", @"订单繁忙，无法接单", @"交通事故", @"其他"];
    
    self.reasonTextView.editable = NO;
    
//    [self.reasonTableView registerNib:[UINib nibWithNibName:@"reasonTableViewCell" bundle:nil] forCellReuseIdentifier:@"reasonCell"];
//    self.reasonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.dismissBT addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.sureGiveupBT addTarget:self action:@selector(sureGiveUpAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.reasonArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reasonCellIdentify = @"reasonCellIdentify";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reasonCellIdentify];
    NSArray * nibarr = [[NSBundle mainBundle] loadNibNamed:@"reasonTableViewCell" owner:self options:nil];
    if ([nibarr count] > 0) {
        self.customCell = [nibarr objectAtIndex:0];
        cell = self.customCell;
    }
    UILabel * reasonLabel = (UILabel *)[cell viewWithTag:2000];
    reasonLabel.text = [self.reasonArr objectAtIndex:indexPath.row];
//    cell.selected = NO;
//    if (indexPath.row == 0) {
//        UIImageView * imageView = (UIImageView *)[cell viewWithTag:1000];
//        imageView.image = [UIImage imageNamed:@"check1.png"];
//        cell.selected = YES;
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 3) {
        reasonTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView * imageView = (UIImageView *)[cell viewWithTag:1000];
        imageView.image = [UIImage imageNamed:@"check1.png"];
        self.reasonTextView.editable = YES;
//        self.reasonStr = self.reasonTextView.text;
    }else
    {
        reasonTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView * imageView = (UIImageView *)[cell viewWithTag:1000];
        imageView.image = [UIImage imageNamed:@"check1.png"];
        UILabel * reasonLabel = (UILabel *)[cell viewWithTag:2000];
        self.reasonTextView.editable = NO;
        self.reasonStr = reasonLabel.text;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    reasonTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:1000];
    imageView.image = [UIImage imageNamed:@"check.png"];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.reasonStr = textView.text;
}

- (void)giveuporder:(GiveUpBlock)Block
{
    self.myBlock = [Block copy];
}

- (IBAction)dismissAction1:(id)sender {
    NSLog(@"移除");
    self.myBlock = nil;
    [self removeFromSuperview];
}
- (IBAction)sureGiveup:(id)sender {
    if (self.myBlock) {
        if (self.reasonStr.length == 0) {
            if (self.reasonTextView.text.length == 0) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写放弃原因" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择放弃原因" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
            }
        }else
        {
            self.myBlock(self.reasonStr);
            self.myBlock = nil;
            [self removeFromSuperview];
        }
    }
}
- (void)show
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
}

- (void)dealloc
{
    self.myBlock = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
