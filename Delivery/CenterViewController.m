//
//  CenterViewController.m
//  Delivery
//
//  Created by 仙林 on 15/10/27.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "CenterViewController.h"

#import "PersonCenterViewController.h"

@interface CenterViewController ()<UIGestureRecognizerDelegate>

@end

BOOL showOrderView = YES; // 接单页面是否是当前页面
BOOL showUserView = NO; // 个人中心页面是否是当前界面

float timeInterval = .4; // 界面拖拽后视图的滑动时间间隔
float insertHeight = 50.0; // 接单页面划出后拒父试图上面的嵌入量(y坐标)
float leftWidth = 100.0; // 接单页面划出后在主屏幕剩余的宽度

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backImage.jpg"]];
    self.backImageView.frame = self.view.frame;
    [self.view addSubview:_backImageView];
    
    self.orderViewController = [[OrderViewController alloc]init];
    self.orderVC = [[UINavigationController alloc]initWithRootViewController:self.orderViewController];
    
    self.userVC = [[UserCenterViewController alloc]init];
    
    [self.view addSubview:self.userVC.view];
    [self addChildViewController:self.userVC];
    [self.userVC didMoveToParentViewController:self];
    
    self.userVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    
    [self setupView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
}

- (instancetype)initWithRightView:(UIViewController *)leftVC andMainView:(UINavigationController *)mainVC
{
    if (self = [super init]) {
        
        self.orderVC = mainVC;
    
        self.userVC = (UserCenterViewController *)leftVC;
        
        [self.view addSubview:self.userVC.view];
        [self addChildViewController:self.userVC];
        [self.userVC didMoveToParentViewController:self];
        
        self.userVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);

        
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    
    [self.view addSubview:self.orderVC.view];
    [self addChildViewController:self.orderVC];
    [self.orderVC didMoveToParentViewController:self];
    self.orderVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
}

- (void)setupGesture
{
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveView:)];
    [self.view addGestureRecognizer:_panGesture];
}

// 移动试图
- (void)moveView:(UIPanGestureRecognizer *)sender
{
    [sender.view.layer removeAllAnimations];
    
    // 获取拖拽过程中的坐标
    CGPoint translationPoint = [sender translationInView:self.view];
    // 获取拖拽的速度点
    CGPoint velocityPOint = [sender velocityInView:sender.view];
    
    UIView * childView = nil;
    
    // 拖拽开始
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (showOrderView) {
            // 已经是接单视图,向右滑动不做设置
            if (velocityPOint.x > 0) {
                
            }else if (velocityPOint.x < 0)
            {
                if (!showUserView) {
                    childView = [self getUserView];
                }
            }
            
            [self.view sendSubviewToBack:childView];
            [self.view bringSubviewToFront:self.orderVC.view];
            [self.view sendSubviewToBack:self.backImageView];
            
        }
    }
    
    // 拖拽结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (showOrderView) {
            if (self.orderVC.view.frame.origin.x + self.orderVC.view.width > leftWidth + (self.view.width - leftWidth) / 2) {
                [self moveOrderViewToOriginalPosition];
            }else
            {
                [self presentUserView];
            }
        }else if (showUserView)
        {
            if (self.orderVC.view.frame.origin.x + self.orderVC.view.width > leftWidth + (self.view.width - leftWidth) / 2) {
                [self moveOrderViewToOriginalPosition];
            }else
            {
                [self presentUserView];
            }
        }
        
        
    }
    
    // 拖拽过程中
    if (sender.state == UIGestureRecognizerStateChanged) {
        if (showOrderView) {
            if (!showUserView && translationPoint.x < 0 && translationPoint.x >= -self.view.width  + leftWidth / (1 - 2 * insertHeight / self.view.height) ) {
                
                float sizeScale = (- translationPoint.x) / (self.view.width - leftWidth / (1 - 2 * insertHeight / self.view.height));
                
//                NSLog(@"******sizeScale = %.2f$$$$$$$$$", sizeScale);
                
                if (- translationPoint.x * (1 - 2 * insertHeight / self.view.height) + leftWidth < self.orderVC.view.width) {
                    
//                    NSLog(@"******sizeScale = %.2f*****", sizeScale);
                
                    self.orderVC.view.frame = CGRectMake(translationPoint.x * (1 - 2 * insertHeight / self.view.height), insertHeight * sizeScale, self.view.width * ((self.view.height - 2 * insertHeight * sizeScale) / self.view.height), self.view.height - 2 * insertHeight * sizeScale);
                    
                    
                    self.userVC.headView.alpha = sizeScale;
                    self.userVC.totalOrderview.alpha = sizeScale;
//                    self.userVC.reciveOrderView.alpha = sizeScale;
                    self.userVC.massegeView.alpha = sizeScale;
                }
            
            }
            
            
        }else
        {
            if (showUserView && translationPoint.x > 0 && translationPoint.x < self.view.width  - leftWidth / (1 - 2 * insertHeight / self.view.height)) {
                float sizeScale = translationPoint.x / (self.view.width - leftWidth / (1 - 2 * insertHeight / self.view.height));
                
//                NSLog(@"******sizeScale = %.2f^^^^^^^^^", sizeScale);
                
                self.orderVC.view.frame = CGRectMake(- self.view.width * (1 - 2 * insertHeight / self.view.height) + leftWidth + translationPoint.x* (1 - 2 * insertHeight / self.view.height), insertHeight - insertHeight * sizeScale, self.view.width * ((self.view.height - 2 * insertHeight + 2 * insertHeight * sizeScale) / self.view.height), self.view.height - 2 * insertHeight + 2 * insertHeight * sizeScale);
                
                self.userVC.headView.alpha = 1 - sizeScale;
                self.userVC.totalOrderview.alpha = 1 - sizeScale;
//                self.userVC.reciveOrderView.alpha = 1 - sizeScale;
                self.userVC.massegeView.alpha = 1 - sizeScale;
                
            }
        }
    }
    
    if (sender.state == UIGestureRecognizerStateCancelled) {
        [self moveOrderViewToOriginalPosition];
    }
}



// 获得个人中心视图
- (UIView *)getUserView
{
    if (self.userVC == nil) {
        self.userVC = [[UserCenterViewController alloc]init];
        [self.view addSubview:self.userVC.view];
        [self addChildViewController:self.userVC];
        [self.userVC didMoveToParentViewController:self];
        
        self.userVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    }
    
    return self.userVC.view;
}

- (void)personCenterAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"此处应该跳转到个人中心界面了");
    
    PersonCenterViewController * personVC = [[PersonCenterViewController alloc]init];
    
    
    [self.navigationController pushViewController:personVC animated:YES];
    
    
}

// 展示个人中心视图
- (void)presentUserView
{
    UIView * userView = [self getUserView];
    
    [self.view sendSubviewToBack:userView];
    [self.view sendSubviewToBack:self.backImageView];
    
    [UIView animateWithDuration:timeInterval animations:^{
        self.orderVC.view.frame = CGRectMake(- self.view.width * (1 - 2 * insertHeight / self.view.height) + leftWidth, insertHeight, self.view.width * ((self.view.height - 2 * insertHeight) / self.view.height), self.view.height - 2 * insertHeight);
        
        self.userVC.headView.alpha = 1;
        self.userVC.totalOrderview.alpha = 1;
//        self.userVC.reciveOrderView.alpha = 1;
        self.userVC.massegeView.alpha = 1;
        
    }];
    
    showOrderView = NO;
    showUserView = YES;
    
}

// 将接单视图恢复初始位置
- (void)moveOrderViewToOriginalPosition
{
    [UIView animateWithDuration:timeInterval animations:^{
        self.orderVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        self.userVC.headView.alpha = 0;
        self.userVC.totalOrderview.alpha = 0;
//        self.userVC.reciveOrderView.alpha = 0;
        self.userVC.massegeView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            showOrderView = YES;
            [self resetAllview];
        }
    }];
}


// 重新布局所有试图(释放个人中心视图所占内存)
- (void)resetAllview
{
    if (self.userVC != nil) {
        [self.userVC.view removeFromSuperview];
        [self.userVC removeFromParentViewController];
        self.userVC = nil;
        showUserView = NO;
    }
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (!self.isnable) {
//        return NO;
//    }
//    return YES;
//}

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
