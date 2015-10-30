//
//  ViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "ViewController.h"
#import "WMHomeViewController.h"
#import "WMMenuViewController.h"
#import "WMOtherViewController.h"
#import "WMNavigationController.h"
#import "WMCommon.h"
#import "CustomTabBarViewController.h"
#import "BackPageViewController.h"

#import "MainSettings.h"
#import "OptionTextViewController.h"

typedef enum state {
    kStateHome,
    kStateMenu,
    kStateOption//add by wangjc  添加设置页面状态
}state;

static const CGFloat viewSlideHorizonRatio = 0.75;
static const CGFloat viewHeightNarrowRatio = 0.80;
static const CGFloat menuStartNarrowRatio  = 0.70;

@interface ViewController () <WMHomeViewControllerDelegate, WMMenuViewControllerDelegate>
@property (assign, nonatomic) state   sta;              // 状态(Home or Menu)
@property (assign, nonatomic) CGFloat distance;         // 距离左边的边距
@property (assign, nonatomic) CGFloat leftDistance;
@property (assign, nonatomic) CGFloat menuCenterXStart; // menu起始中点的X
@property (assign, nonatomic) CGFloat menuCenterXEnd;   // menu缩放结束中点的X
@property (assign, nonatomic) CGFloat panStartX;        // 拖动开始的x值

@property (strong, nonatomic) WMCommon               *common;
@property (strong, nonatomic) CustomTabBarViewController   *homeVC;
//@property (strong, nonatomic) WMHomeViewController   *homeVC;
@property (strong, nonatomic) WMMenuViewController   *menuVC;
@property (strong, nonatomic) WMNavigationController *messageNav;
@property (strong, nonatomic) UIView                 *cover;
@property (strong, nonatomic) UITabBarController     *tabBarController;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHeaderImgClick) name:@"headerImgClickName" object:nil];
    
    swipFlag = false;
    NSLog(@"run Here ");
    
    self.common = [WMCommon getInstance];
    self.sta = kStateHome;
    self.distance = 0;
    self.menuCenterXStart = self.common.screenW * menuStartNarrowRatio / 2.0;
    self.menuCenterXEnd = self.view.center.x;
    self.leftDistance = self.common.screenW * viewSlideHorizonRatio;
    
    [self initCustomView];
    
    // 设置背景
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    bg.frame        = [[UIScreen mainScreen] bounds];
    [self.view addSubview:bg];
    
    // 设置menu的view
    self.menuVC = [[WMMenuViewController alloc] init];
    self.menuVC.delegate = self;
    self.menuVC.view.frame = [[UIScreen mainScreen] bounds];
    self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuStartNarrowRatio, menuStartNarrowRatio);
    self.menuVC.view.center = CGPointMake(self.menuCenterXStart, self.menuVC.view.center.y);
    [self.view addSubview:self.menuVC.view];
    
    // 设置遮盖
    self.cover = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.cover.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.cover];
    
    // 添加tabBarController
    self.tabBarController = [[UITabBarController alloc] init];
    self.homeVC = [[CustomTabBarViewController alloc] init];
    //self.homeVC = [[WMHomeViewController alloc] init];
    self.homeVC.view.frame = [[UIScreen mainScreen] bounds];
    self.homeVC.delegate = self;
    
    // 设置控制器的状态，添加手势操作
    self.messageNav = [[WMNavigationController alloc] initWithRootViewController:self.homeVC];
    self.messageNav.navigationBar.barTintColor = [UIColor colorWithRed:0 green:122.0 / 255 blue:1.0 alpha:1.0];
    self.messageNav.navigationBar.tintColor = [UIColor whiteColor];
    [self.messageNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.messageNav.tabBarItem.title = @"消息";
    self.messageNav.tabBarItem.image = [UIImage imageNamed:@"tab_recent_nor"];
    
    
//    {
//        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20,30, 30)];
//        
//        [titleBtn setImage:[UIImage imageNamed:@"me"] forState:UIControlStateNormal];
//        titleBtn.layer.masksToBounds = YES;
//        titleBtn.layer.cornerRadius = titleBtn.frame.size.width * 0.5;
//        titleBtn.layer.borderWidth = 1.0;
//        titleBtn.layer.borderColor = [[UIColor yellowColor] CGColor];
//        titleBtn.backgroundColor = [UIColor blueColor];
//        
//        UIImageView *threepiontImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 10, 30)];
//        threepiontImg.image = [UIImage imageNamed:@"threepoint"];
//        threepiontImg.contentMode = UIViewContentModeCenter;
//        
//        [titleBtn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.view addSubview:titleBtn];
//        [self.view addSubview:threepiontImg];
//        [self.view bringSubviewToFront:threepiontImg];
//        [self.view bringSubviewToFront:titleBtn];
//        
//    }
    
    [self.tabBarController addChildViewController:self.messageNav];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    /*在判定pan之前先确认下面手势是否完成(上 下 左 右滑动)*/
    UISwipeGestureRecognizer *tempSwipRight = [[UISwipeGestureRecognizer alloc] init];
    tempSwipRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [tempSwipRight addTarget:self action:@selector(slideMenu:)];
    [self.tabBarController.view addGestureRecognizer:tempSwipRight];
    [pan requireGestureRecognizerToFail:tempSwipRight];
    tempSwipRight.delegate = self;
    
    
    
    
    UISwipeGestureRecognizer *tempSwipLeft = [[UISwipeGestureRecognizer alloc] init];
    tempSwipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [tempSwipLeft addTarget:self action:@selector(swipLeft:)];
    [self.tabBarController.view addGestureRecognizer:tempSwipLeft];
    [pan requireGestureRecognizerToFail:tempSwipLeft];
    tempSwipLeft.delegate = self;
    
    
    UISwipeGestureRecognizer *tempSwipUp = [[UISwipeGestureRecognizer alloc] init];
    tempSwipUp.direction = UISwipeGestureRecognizerDirectionUp;
    [tempSwipUp addTarget:self action:@selector(tempSwip)];
    [self.tabBarController.view addGestureRecognizer:tempSwipUp];
    [pan requireGestureRecognizerToFail:tempSwipUp];
    tempSwipUp.delegate = self;

    UISwipeGestureRecognizer *tempSwipDown = [[UISwipeGestureRecognizer alloc] init];
    tempSwipDown.direction = UISwipeGestureRecognizerDirectionDown;
    [tempSwipDown addTarget:self action:@selector(tempSwip)];
    [self.tabBarController.view addGestureRecognizer:tempSwipDown];
    [pan requireGestureRecognizerToFail:tempSwipDown];
    tempSwipDown.delegate = self;

    
// [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView:) name:@"changeRootView" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setHideTabBar:) name:@"tabbar" object:nil];
    pan.delegate = self;
    [self.tabBarController.view addGestureRecognizer:pan];
    
    [self.view addSubview:self.tabBarController.view];
}


-(void)slideMenu:(id)sender//右划显示menu
{
    if (self.sta == kStateHome) {
        [self showMenu];
    }
//    else if(self.sta == kStateMenu)
}

-(void)swipLeft:(id)sender//menu状态左划home 返回home
{
    if(self.sta == kStateMenu)
       [self showHome:kStateHome];
    else
        NSLog(@"swip  left");
}

-(void)setHideTabBar:(id)sender
{
    NSString *str = [[sender userInfo]objectForKey:@"hide"];
    if([str isEqualToString:@"YES"])
    {
        [self.homeVC hideCustomTabBar];
    }
    else if([str isEqualToString:@"NO"])
    {
        [self.homeVC showTabBar];
    }

}

-(void)initCustomView
{
    _personFirstVC = [[PersonFirstViewController alloc] init];
    _anniversaryPage= [[AnniversaryViewController alloc] init];
    _optionPage = [[OptionsViewController alloc] init];
    _CoupleSetPage = [[CoupleViewController alloc]init];
    _planMonthPage = [[PlanMonthViewController alloc] init];
    _AlbumPage = [[AlbumMainViewController alloc] init];
}

-(void) tempSwip
{
    NSLog(@"swip------");
}

-(void)btnclick
{
    NSLog(@"Click btn");
    
    [self showMenu];
    
}
//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    
    //||[NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] [NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]||
    
   // if(gestureRecognizer.d)
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"JTCalendarMonthWeekDaysView"]
        ||[NSStringFromClass([touch.view class]) isEqualToString:@"JTCalendarMonthWeekDaysView"]
        ||[NSStringFromClass([touch.view class]) isEqualToString:@"UITextView"]
        || [NSStringFromClass([touch.view class]) isEqualToString:@"MAMapScrollView"]
        ) {
        
        //     NSLog(@"return no");
        return NO;
    }
    //  NSLog(@"return YES");
    return  YES;
}
//设置多个view同时响应事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
       NSLog(@"--%@", NSStringFromClass([otherGestureRecognizer.view class]));
    if (
        [NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"UITableViewWrapperView"]//解决滑动和tablecell的滑动删除冲突
         ||[NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"UIView"]
         ||[NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"JTCalendarContentView"]
        ||[NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"UITableViewCellScrollView"]//解决滑动和tablecell的滑动删除冲突 （IOS7 ONLY?? 模拟器ios9.0不需要该项）
        )
//    if ([otherGestureRecognizer.view isKindOfClass:[UITableViewWrapperView class]])
    {
        NSLog(@"return Yes");
        return YES;
    }
    return NO;
}

/**
 *  设置statusbar的状态
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/**
 *  处理拖动事件
 *
 *  @param recognizer
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    NSLog(@"get pan self.sta = %d",self.sta);
    if(self.sta == kStateOption)//add by wangjc  设置页面禁止左划
    {
        return;
    }
    
    // 当滑动水平X大于75时禁止滑动
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartX = [recognizer locationInView:self.view].x;
    }
    NSLog(@"get pan self.panStartX  = %lf",self.panStartX );
    if (self.sta == kStateHome && self.panStartX >= 150/*pan 手势有效范围*/) {
        return;
    }
    
    CGFloat x = [recognizer translationInView:self.view].x;
    NSLog(@"get pan x  = %lf",x );
    // 禁止在主界面的时候向左滑动
    if (self.sta == kStateHome && x < 0) {
        [self showHome:kStateHome];//add by wangjc 防止左划出现负值,出现时恢复到home page
        return;
    }
    
    CGFloat dis = self.distance + x;
    // 当手势停止时执行操作
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (dis >= self.common.screenW * viewSlideHorizonRatio / 2.0) {
            [self showMenu];
        } else {
            [self showHome:kStateHome];
        }
        return;
    }
    
    CGFloat proportion = (viewHeightNarrowRatio - 1) * dis / self.leftDistance + 1;
    if (proportion < viewHeightNarrowRatio || proportion > 1) {
        return;
    }
    self.tabBarController.view.center = CGPointMake(self.view.center.x + dis, self.view.center.y);
    self.tabBarController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    
    self.homeVC.leftBtn.alpha = self.cover.alpha = 1 - dis / self.leftDistance;
    
    CGFloat menuProportion = dis * (1 - menuStartNarrowRatio) / self.leftDistance + menuStartNarrowRatio;
    CGFloat menuCenterMove = dis * (self.menuCenterXEnd - self.menuCenterXStart) / self.leftDistance;
    self.menuVC.view.center = CGPointMake(self.menuCenterXStart + menuCenterMove, self.view.center.y);
    self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
}

/**
 *  展示侧边栏
 */
- (void)showMenu {
    self.distance = self.leftDistance;
    self.sta = kStateMenu;
    [self doSlide:viewHeightNarrowRatio];
}

/**
 *  展示主界面
 */
- (void)showHome:(state)pageState {
    self.distance = 0;
    self.sta = pageState;
    [self doSlide:1];
}

/**
 *  实施自动滑动
 *
 *  @param proportion 滑动比例
 */
- (void)doSlide:(CGFloat)proportion {
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.view.center = CGPointMake(self.view.center.x + self.distance, self.view.center.y);
        self.tabBarController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
        
        self.homeVC.leftBtn.alpha = self.cover.alpha = proportion == 1 ? 1 : 0;
        
        CGFloat menuCenterX;
        CGFloat menuProportion;
        if (proportion == 1) {
            menuCenterX = self.menuCenterXStart;
            menuProportion = menuStartNarrowRatio;
        } else {
            menuCenterX = self.menuCenterXEnd;
            menuProportion = 1;
        }
        self.menuVC.view.center = CGPointMake(menuCenterX, self.view.center.y);
        self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
    } completion:^(BOOL finished) {

    }];
}

-(void)setViewState
{
    NSLog(@"----＋＋＋-------");
    self.sta = kStateHome;
}

#pragma mark - WMHomeViewController代理方法
- (void)leftBtnClicked {
    [self showMenu];
}

-(void)swipLeftAction//menu状态划动menu 返回home
{
    NSLog(@"back to home page");
    if(self.sta == kStateMenu)
        [self showHome:kStateHome];
}


#pragma mark - WMMenuViewController代理方法
- (void)didSelectItem:(NSString *)title {
    
    BackPageViewController *other;
    NSLog(@"title = [%@]",title);
    if ([title isEqualToString:@"我的资料"]) {
        other = (BackPageViewController *)_personFirstVC;
    }
    else if([title isEqualToString:@"纪念日总览"])
    {
        other = (BackPageViewController *)_anniversaryPage;
    }
    else if([title isEqualToString:@"设置"])
    {
        other = (BackPageViewController *)_optionPage;
    }
    else if([title isEqualToString:@"绑定配偶"])
    {
        other = (BackPageViewController *)_CoupleSetPage;
    }
    else if([title isEqualToString:@"月任务总览"])
    {
        other = (BackPageViewController *)_planMonthPage;
    }
    else if([title isEqualToString:@"相册"])
    {
        other = (BackPageViewController *)_AlbumPage;
    }
    else
    {
        other = [[BackPageViewController alloc] init];
    }
    
    
    other.navTitle = title;
    other.hidesBottomBarWhenPushed = YES;
    
   // [self.messageNav pushViewController:other animated:NO];
    other.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentViewController:other animated:YES completion:^{}];
    
    [self showHome:kStateOption];
}

-(void)didHeaderImgClick{
    [self didSelectItem:@"我的资料"];
}

@end
