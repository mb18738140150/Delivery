//
//  OrderDetailController.m
//  Delivery
//
//  Created by 仙林 on 16/1/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "OrderDetailController.h"

#define IMAGE_WEIDTH 30
#define LABEL_HEIGHT 30
#define TOP_SPACE 10
#define LEFT_SPACE 10
#define MEALSView_tag 1000
#define SHOPDETAILSView_TAG 2000
#define TIPVIEW_TAG 3000
#define TEXT_COLOR [UIColor colorWithWhite:0.3 alpha:1]
@interface OrderDetailController ()<HTTPPostDelegate>

@property (nonatomic, strong)UIScrollView * scrollview;

// 用户信息
@property (nonatomic, strong)UIImageView * addressImageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * phoneLabel;
@property (nonatomic, strong)UIButton *phoneBT;
@property (nonatomic, strong)UILabel * payStateLabel;
@property (nonatomic, strong)UILabel * addressLabel;
// 菜品
@property (nonatomic, strong)UILabel * remarkLabel;
// 商家
@property (nonatomic, strong)UIImageView * addressImageViewshop;
@property (nonatomic, strong)UILabel * nameLabelshop;
@property (nonatomic, strong)UIButton * phoneBTshop;
@property (nonatomic, strong)UILabel * addressLabelshop;

// tip
@property (nonatomic, strong)UILabel * tiplabel;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"餐单详情";
    
    self.scrollview= [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollview.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:_scrollview];
    
    UIView * totleView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE, self.view.width, 100)];
    totleView.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:totleView];
    
    self.addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 3, IMAGE_WEIDTH, IMAGE_WEIDTH)];
    _addressImageView.image = [UIImage imageNamed:@"location_order.png"];
    [totleView addSubview:_addressImageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageView.right + LEFT_SPACE, TOP_SPACE, 60, LABEL_HEIGHT)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.text = @"集散地附近吧";
    [totleView addSubview:_nameLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_nameLabel.right, _nameLabel.top - 5, 1, 20)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [totleView addSubview:line1];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(line1.right, TOP_SPACE, 90, LABEL_HEIGHT)];
    _phoneLabel.text = @"18734890150";
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.adjustsFontSizeToFitWidth = YES;
    [totleView addSubview:_phoneLabel];
    
    self.phoneBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _phoneBT.frame = _phoneLabel.frame;
    _phoneBT.backgroundColor = [UIColor clearColor];
    [totleView addSubview:_phoneBT];
    
    
    self.payStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - LEFT_SPACE - 80 , TOP_SPACE, 80, LABEL_HEIGHT)];
    _payStateLabel.layer.cornerRadius = 5;
    _payStateLabel.layer.masksToBounds = YES;
    _payStateLabel.layer.borderWidth = 1;
    _payStateLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _payStateLabel.textAlignment = NSTextAlignmentCenter;
    _payStateLabel.text = @"餐到付款";
    _payStateLabel.textColor = MAIN_COLORE;
    [totleView addSubview:_payStateLabel];
    
    if (self.view.width >= 370) {
        self.nameLabel.frame = CGRectMake(_addressImageView.right + LEFT_SPACE, TOP_SPACE, 80, LABEL_HEIGHT);
        line1.frame = CGRectMake(_nameLabel.right, _nameLabel.top - 5, 1, 20);
        self.phoneLabel.frame = CGRectMake(line1.right, TOP_SPACE, 100, LABEL_HEIGHT);
        self.payStateLabel.frame = CGRectMake(self.view.width - LEFT_SPACE - 90 , TOP_SPACE, 90, LABEL_HEIGHT);
    }
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageView.right + LEFT_SPACE, _nameLabel.bottom , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT + 10)];
    _addressLabel.textColor = [UIColor grayColor];
    _addressLabel.text = @"未来路商城路科苑小区1号楼3单元2楼48号";
    _addressLabel.numberOfLines = 0;
    _addressLabel.adjustsFontSizeToFitWidth = YES;
    [totleView addSubview:_addressLabel];

    UIView * totoleLine = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _addressLabel.bottom + 10, self.view.width - 2 * LEFT_SPACE, 1)];
    totoleLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [totleView addSubview:totoleLine];
    
    UIImageView * remarkImageview = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 3 + totoleLine.bottom, IMAGE_WEIDTH, IMAGE_WEIDTH)];
    remarkImageview.image = [UIImage imageNamed:@"location_order.png"];
    [totleView addSubview:remarkImageview];
    
    UILabel * remarkLB = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageview.right + LEFT_SPACE, TOP_SPACE + totoleLine.bottom, 100, LABEL_HEIGHT)];
    remarkLB.textAlignment = NSTextAlignmentCenter;
    remarkLB.adjustsFontSizeToFitWidth = YES;
    remarkLB.text = @"客户备注:";
    [totleView addSubview:remarkLB];
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageview.right + LEFT_SPACE, remarkLB.bottom + TOP_SPACE, self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT)];
    _remarkLabel.textColor = [UIColor grayColor];
    _remarkLabel.text = @"要超辣的，拉到死的可敬的奶粉进副科级";
    [totleView addSubview:_remarkLabel];
    totleView.height = _remarkLabel.bottom + TOP_SPACE;
    
    UIView * mealsView = [[UIView alloc]initWithFrame:CGRectMake(0, totleView.bottom + TOP_SPACE, self.view.width, 100)];
    mealsView.backgroundColor = [UIColor whiteColor];
    mealsView.tag = MEALSView_tag;
    [_scrollview addSubview:mealsView];
    
    UILabel * mealsLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, mealsView.width - 10 , 30)];
    mealsLabel.text = @"菜单详情";
    mealsLabel.textColor = TEXT_COLOR;
    [mealsView addSubview:mealsLabel];
    
    UIView * lineView5 = [[UIView alloc] initWithFrame:CGRectMake(10, mealsLabel.bottom, mealsView.width - 20, 1)];
    lineView5.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    lineView5.tag = 5005;
    [mealsView addSubview:lineView5];
    
    // 商家信息
    UIView * shopdetailsView = [[UIView alloc]initWithFrame:CGRectMake(0, mealsView.bottom + 10, self.view.width, 100)];
    shopdetailsView.backgroundColor = [UIColor whiteColor];
    shopdetailsView.tag = SHOPDETAILSView_TAG;
    [_scrollview addSubview:shopdetailsView];
    
    UILabel * shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, shopdetailsView.width - 10 , 30)];
    shopLabel.text = @"菜单详情";
    shopLabel.textColor = TEXT_COLOR;
    [shopdetailsView addSubview:shopLabel];
    
    UIView * lineViewshop = [[UIView alloc] initWithFrame:CGRectMake(10, shopLabel.bottom, shopdetailsView.width - 20, 1)];
    lineViewshop.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [shopdetailsView addSubview:lineViewshop];
    
    
    self.addressImageViewshop = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE * 3 + lineViewshop.bottom, IMAGE_WEIDTH, IMAGE_WEIDTH)];
    _addressImageViewshop.image = [UIImage imageNamed:@"location_order.png"];
    [shopdetailsView addSubview:_addressImageViewshop];
    
    self.nameLabelshop = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageViewshop.right + LEFT_SPACE, TOP_SPACE + lineViewshop.bottom, 80, LABEL_HEIGHT)];
    _nameLabelshop.textAlignment = NSTextAlignmentCenter;
    _nameLabelshop.adjustsFontSizeToFitWidth = YES;
    _nameLabelshop.text = @"邻家小厨蓝湖湾";
    [shopdetailsView addSubview:_nameLabelshop];
    
    UIView * line1shop = [[UIView alloc]initWithFrame:CGRectMake(_nameLabelshop.right, _nameLabelshop.top - 5, 1, 20)];
    line1shop.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [shopdetailsView addSubview:line1shop];
    
    self.phoneBTshop = [UIButton buttonWithType:UIButtonTypeSystem];
    _phoneBTshop.frame = CGRectMake(line1shop.right, TOP_SPACE + lineViewshop.bottom, 120, LABEL_HEIGHT);
    [_phoneBTshop setTitle:@"18736087590" forState:UIControlStateNormal];
    [_phoneBTshop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _phoneBTshop.backgroundColor = [UIColor whiteColor];
    [shopdetailsView addSubview:_phoneBTshop];
    
    self.addressLabelshop = [[UILabel alloc]initWithFrame:CGRectMake(_addressImageViewshop.right + LEFT_SPACE, _nameLabelshop.bottom , self.view.width - 3 * LEFT_SPACE - IMAGE_WEIDTH, LABEL_HEIGHT + 10)];
    _addressLabelshop.textColor = [UIColor grayColor];
    _addressLabelshop.numberOfLines = 0;
    _addressLabelshop.adjustsFontSizeToFitWidth = YES;
    _addressLabelshop.text = @"前进路中原路锦艺怡心苑区1号楼3单元2楼48号";
    [shopdetailsView addSubview:_addressLabelshop];
    
    shopdetailsView.height = _addressLabelshop.bottom + 10;
    
    
    UIView * tipView = [[UIView alloc]initWithFrame:CGRectMake(0, shopdetailsView.bottom + 10, self.view.width, 50)];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.tag = TIPVIEW_TAG;
    [_scrollview addSubview:tipView];
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 80, 30)];
    tipLabel.text = @"温馨提示:";
    tipLabel.textColor = [UIColor orangeColor];
    [tipView addSubview:tipLabel];
    
    self.tiplabel = [[UILabel alloc]initWithFrame:CGRectMake(tipLabel.right, TOP_SPACE, self.view.width - 2 * LEFT_SPACE - tipLabel.width, 30)];
    _tiplabel.textColor = [UIColor grayColor];
    _tiplabel.text = @"此订单支付方式为餐到付款，别忘记收款哦！";
    [tipView addSubview:_tiplabel];
    
    tipView.height = _tiplabel.bottom + TOP_SPACE;
    
    _scrollview.contentSize = CGSizeMake(self.view.width, tipView.bottom + 20);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    // Do any additional setup after loading the view.
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
