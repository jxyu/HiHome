//
//  CustomTabBarViewController.m
//  Blinq
//
//  Created by Sugar on 13-8-12.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "CommenDef.h"
#import "Toolkit.h"
#import "MainPageViewController.h"
#import "TaskPageViewController.h"
#import "ChatPageViewController.h"
#import "AddressPageViewController.h"

#import "UIImage+WM.h"
#import "UIImage+NSBundle.h"

#import "CalendarViewController.h"
#import "ChatlistViewController.h"

#define tabBarButtonNum 4

@interface CustomTabBarViewController ()
{
    NSArray *_arrayImages;
    UIButton *_btnSelected;
    UIView *_tabBarBG;
    UIButton *btnTabBar;
}
@end

@implementation CustomTabBarViewController


@dynamic delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏系统tabbar
    self.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    NSArray *arrayImages_H = [[NSArray alloc] initWithObjects:@"main_tab_gods_icon@2x.png",@"chat_tab_gods_icon@2x.png" ,@"metion_tab_gods_icon@2x.png",@"friends_tab_gods_icon@2x.png",  nil];
    NSArray *arrayImages = [[NSArray alloc] initWithObjects:@"main_tab_gray_icon@2x.png",@"chat_tab_gray_icon@2x.png",@"metion_tab_gray_icon@2x.png",@"fridnes_tab_gray_icon@2x.png",  nil];
 
    _tabBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TabBar_HEIGHT, SCREEN_WIDTH, TabBar_HEIGHT)];
    
    _tabBarBG.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    [_tabBarBG addSubview:lineView];
    
    
    
    {
        UIImageView *original = [[UIImageView alloc] init];
        original.frame = CGRectMake(0, 0, 35, 35);
        original.image = [UIImage imageNamed:@"me"];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = CGRectMake(20, 20, 44, 44);
        [self.leftBtn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
        [self.leftBtn setImage:[[UIImage imageNamed:@"me"] getRoundImage] forState:UIControlStateNormal];
        UIBarButtonItem *barLeftBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
        [self.navigationItem setLeftBarButtonItem:barLeftBtn];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLeftBtn:) name:@"setleftbtn" object:nil];

//        self.leftBtn.contentMode = UIViewContentModeScaleAspectFill;
        
//        UIViewContentModeScaleToFill,
//        UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
//        UIViewContentModeScaleAspectFill,
        
        [self.view addSubview:self.leftBtn];
    }
//    UIView *tabbar_headview=[[UIView alloc] initWithFrame:CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
    //_tabBarBG.backgroundColor=[UIColor clearColor];
    //_tabBarBG.alpha=0.9;
    [self.view addSubview:_tabBarBG];
//    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0.3, SCREEN_WIDTH, 0.3)];
//    imageline1.backgroundColor=[UIColor colorWithRed:0.88 green:0.89 blue:0.89 alpha:1];
//    [self.view addSubview:imageline1];
    //自定义tabbar的按钮和图片
	
    int tabBarWitdh = SCREEN_WIDTH * 1.0f / tabBarButtonNum;
	for(int i = 0; i < tabBarButtonNum; i++)
	{
//        if (i==2) {
//            CGRect frame=CGRectMake(i * tabBarWitdh, SCREEN_HEIGHT -tabBarWitdh, tabBarWitdh, tabBarWitdh);
//            btnTabBar = [[UIButton alloc] initWithFrame:frame];
//            [btnTabBar setImage: [UIImage imageWithBundleName:[arrayImages objectAtIndex:i]] forState:UIControlStateNormal];
//            [btnTabBar setImage:[UIImage imageWithBundleName:[arrayImages_H objectAtIndex:i]]forState:UIControlStateSelected] ;
//            btnTabBar.tag = i + 1000;
//            [btnTabBar addTarget:self action:@selector(onTabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:btnTabBar];
//        }
//        else
//        {
            CGRect frame=CGRectMake(i * tabBarWitdh, 0, tabBarWitdh, 49);
            UIButton * btnTabBar1 = [[UIButton alloc] initWithFrame:frame];
            [btnTabBar1 setImage: [UIImage imageWithBundleName:[arrayImages objectAtIndex:i]] forState:UIControlStateNormal];
            [btnTabBar1 setImage:[UIImage imageWithBundleName:[arrayImages_H objectAtIndex:i]]forState:UIControlStateSelected] ;
            btnTabBar1.tag = i + 1000;
            [btnTabBar1 addTarget:self action:@selector(onTabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_tabBarBG addSubview:btnTabBar1];
//        }
		
        
        
//        UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(btnTabBar.frame.origin.x, 37, btnTabBar.frame.size.width, 9)];
//        lbl_title.text =[arrayTitle objectAtIndex:i];
//        lbl_title.textAlignment=NSTextAlignmentCenter;
//        lbl_title.numberOfLines = 0;
//        lbl_title.font = [UIFont systemFontOfSize:10];
//        lbl_title.textColor = [UIColor darkGrayColor];
//        lbl_title.backgroundColor = [UIColor clearColor];
//        [_tabBarBG addSubview:lbl_title];
        
        
        
        
	}
//
//        if(0)
//        {
//            UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20,30, 30)];
//    
//            [titleBtn setImage:[UIImage imageNamed:@"me"] forState:UIControlStateNormal];
//            titleBtn.layer.masksToBounds = YES;
//            titleBtn.layer.cornerRadius = titleBtn.frame.size.width * 0.5;
//            titleBtn.layer.borderWidth = 1.0;
//            titleBtn.layer.borderColor = [[UIColor yellowColor] CGColor];
//            titleBtn.backgroundColor = [UIColor blueColor];
//    
//            UIImageView *threepiontImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 10, 30)];
//            threepiontImg.image = [UIImage imageNamed:@"threepoint"];
//            threepiontImg.contentMode = UIViewContentModeCenter;
//    
//            [titleBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//            [self.view addSubview:titleBtn];
//            [self.view addSubview:threepiontImg];
//            [self.view bringSubviewToFront:threepiontImg];
//            [self.view bringSubviewToFront:titleBtn];
//            
//        }
//    
   
    MainPageViewController *HomeView=[[MainPageViewController alloc]init];
    HomeView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [HomeView initViews];
    if ([Toolkit isSystemIOS7]||[Toolkit isSystemIOS8])
        HomeView.automaticallyAdjustsScrollViewInsets = NO;
    UINavigationController * homeviewnav=[[UINavigationController alloc]initWithRootViewController:HomeView];
    //    homePageNavigation.automaticallyAdjustsScrollViewInsets = YES;
    HomeView.hidesBottomBarWhenPushed = YES;
    homeviewnav.navigationBar.hidden=YES;
    
//    ChatPageViewController *typeView=[[ChatPageViewController alloc]init];
//    typeView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
////    [typeView initViews];
//    UINavigationController *typeViewnav = [[UINavigationController alloc] initWithRootViewController:typeView];
//    typeView.automaticallyAdjustsScrollViewInsets = NO;
////    typeView.view.h
//    typeView.hidesBottomBarWhenPushed=YES;
//    typeViewnav.navigationBar.hidden=YES;
    
    ChatlistViewController *chatListViewController = [[ChatlistViewController alloc]init];
    chatListViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UINavigationController *chatListVCNav = [[UINavigationController alloc] initWithRootViewController:chatListViewController];
    chatListViewController.automaticallyAdjustsScrollViewInsets = NO;
    chatListViewController.hidesBottomBarWhenPushed = YES;
    chatListVCNav.navigationBar.hidden = YES;
    //[self.navigationController pushViewController:chatListViewController animated:YES];

//
    TaskPageViewController *shoplistView=[[TaskPageViewController alloc]init];
    shoplistView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [shoplistView initViews];
   // shoplistView.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:85/255.0 blue:32/255.0 alpha:1.0];
    UINavigationController *shoplistViewnav = [[UINavigationController alloc] initWithRootViewController:shoplistView];
    shoplistView.hidesBottomBarWhenPushed = YES;
    shoplistViewnav.navigationBarHidden=YES;
    //消息
    
    AddressPageViewController *ShoppingCart=[[AddressPageViewController alloc]init];
    UINavigationController *ShoppingCartnav = [[UINavigationController alloc] initWithRootViewController:ShoppingCart];
    
    ShoppingCart .view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [ShoppingCart initViews];
    ShoppingCart.hidesBottomBarWhenPushed=YES;
    ShoppingCartnav.navigationBar.hidden=YES;
    
    
    //加入到真正的tabbar
    //fix me 商铺选项卡暂时隐藏
    self.viewControllers=[NSArray arrayWithObjects:homeviewnav,chatListVCNav,shoplistViewnav,ShoppingCartnav,nil];
    
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:0 + 1000];
    [self onTabButtonPressed:btnSender];
    
    
}


-(void) viewDidAppear:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(setViewState)]) {
        [self.delegate setViewState];
    }
    NSLog(@"navigationController count = %ld ",self.navigationController.viewControllers.count);
    
    
    if(_btnSelected.tag==1000)
    {
        self.leftBtn.hidden = YES;
    }
    else
        self.leftBtn.hidden = NO;
    
    [self showTabBar];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    self.leftBtn.hidden = YES;
   
    
    [self hideCustomTabBar];
}


- (void)clicked {
    if ([self.delegate respondsToSelector:@selector(leftBtnClicked)]) {
        [self.delegate leftBtnClicked];
    }
}
/*set left btn hide or not*/
-(void)hideLeftBtn:(id)sender
{
  //  self.leftBtn.hidden = YES;

    
    NSString *str = [[sender userInfo]objectForKey:@"hide"];
    if([str isEqualToString:@"YES"])
    {
        self.leftBtn.hidden = YES;
    }
    else if([str isEqualToString:@"NO"])
    {
        self.leftBtn.hidden = NO;
    }
}
//
// -(void)headBtnClick
//{
//    NSLog(@"Click left btn");
//    
//    [self.delegate ZYleftBtnClicked];
//    
//   // leftBtnClicked
//}


//点击tab页时的响应
-(void)onTabButtonPressed:(UIButton *)sender
{
    
    
    if(sender!=nil)
    {
        if(sender.tag==1000)
        {
            self.leftBtn.hidden = YES;
        }
        else
            self.leftBtn.hidden = NO;
    }
    if (_btnSelected == sender)
        return ;
    
    if (_btnSelected)
        _btnSelected.selected = !_btnSelected.selected;
    
    NSLog(@"select this tab %ld ",(long)sender.tag);
    sender.selected = !sender.selected;
    _btnSelected = sender;
    [self setSelectedIndex:sender.tag - 1000];
    
}

- (void)selectTableBarIndex:(NSInteger)index
{
    if (index < 0 || index > 5)
        return ;
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:index + 1000];
    [self onTabButtonPressed:btnSender];
}

//隐藏tabbar
- (void)hideCustomTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    btnTabBar.frame=CGRectMake(btnTabBar.frame.origin.x, SCREEN_HEIGHT, btnTabBar.frame.size.width, btnTabBar.frame.size.height);
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT, 320, _tabBarBG.frame.size.height);
	[UIView commitAnimations];
	
}
//显示tabbar
-(void)showTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    btnTabBar.frame=CGRectMake(btnTabBar.frame.origin.x, SCREEN_HEIGHT-btnTabBar.frame.size.height, btnTabBar.frame.size.width, btnTabBar.frame.size.height);
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT - TabBar_HEIGHT, SCREEN_WIDTH, _tabBarBG.frame.size.height);
	[UIView commitAnimations];
}

- (void)goToHomePage
{
    [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
