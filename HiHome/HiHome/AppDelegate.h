//
//  AppDelegate.h
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"
#import "FirstScrollController.h"
#import "LoginViewController.h"

#import "OptionTextViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "JKAlertDialog.h"
#import "UIImageView+WebCache.h"
#import "DataProvider.h"
#import "SVProgressHUD.h"
#import "TaskDetailPageViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMConnectionStatusDelegate,RCIMUserInfoDataSource,TaskDetailDelegate>
{
    CustomTabBarViewController *_tabBarViewCol;
    FirstScrollController *firstCol;
    UIViewController *_tempViewcontroller;
    LoginViewController *_loginViewCtl;
    BOOL    _loginFlag ;
    
    UIViewController *tempViewCtl2;
    OptionTextViewController *tempViewCtl;
    
    NSUserDefaults *mChatFriendList;
}

- (void)showTabBar;
- (void)hiddenTabBar;
- (void)selectTableBarIndex:(NSInteger)index;
-(CustomTabBarViewController *)getTabBar;

@property (strong, nonatomic) UIWindow *window;


@end

