//
//  AppDelegate.m
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainPageViewController.h"
#import "AddressPageViewController.h"
#import "ChatPageViewController.h"
#import "TaskPageViewController.h"

#import "WMCommon.h"
#import "UIDefine.h"
#import "ViewController.h"
#import "CommenDef.h"
#import <RongIMKit/RongIMKit.h>

#import "OptionTextViewController.h"


#define RONGCLOUD_IM_APPKEY @"lmxuhwagxp4yd"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    
    
    
    
    
    
    
    
    //初始化融云SDK。
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY ];
    
    
    //登录
    NSString *token =[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSString *userId=[DEFAULTS objectForKey:@"userId"];
    NSString *userName = [DEFAULTS objectForKey:@"userName"];
    NSString *password = [DEFAULTS objectForKey:@"userPwd"];
    if (token.length && userId.length && password.length) {
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:userId
                                      name:userName
                                  portrait:nil];
        [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
        [[RCIM sharedRCIM] connectWithToken:token
                                    success:^(NSString *userId) {
//                                        [AFHttpTool loginWithEmail:userName
//                                                          password:password
//                                                               env:1
//                                                           success:^(id response) {
//                                                               if ([response[@"code"] intValue] == 200) {
//                                                                   [RCDHTTPTOOL getUserInfoByUserID:userId
//                                                                                         completion:^(RCUserInfo *user) {
//                                                                                             [[RCIM sharedRCIM]
//                                                                                              refreshUserInfoCache:user
//                                                                                              withUserId:userId];
//                                                                                         }];
//                                                                   //登陆demoserver成功之后才能调demo 的接口
//                                                                   [RCDDataSource syncGroups];
//                                                                   [RCDDataSource syncFriendList:^(NSMutableArray * result) {}];
//                                                               }
//                                                           }
//                                                           failure:^(NSError *err){
//                                                           }];
                                        //设置当前的用户信息
                                        
                                        //同步群组
                                        //调用connectWithToken时数据库会同步打开，不用再等到block返回之后再访问数据库，因此不需要这里刷新
                                        //这里仅保证之前已经成功登陆过，如果第一次登陆必须等block 返回之后才操作数据
                                        //          dispatch_async(dispatch_get_main_queue(), ^{
                                        //            UIStoryboard *storyboard =
                                        //                [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        //            UINavigationController *rootNavi = [storyboard
                                        //                instantiateViewControllerWithIdentifier:@"rootNavi"];
                                        //            self.window.rootViewController = rootNavi;
                                        //          });
                                    }
                                      error:^(RCConnectErrorCode status) {
//                                          RCUserInfo *_currentUserInfo =[[RCUserInfo alloc] initWithUserId:userId
//                                                                                                      name:userName
//                                                                                                  portrait:nil];
//                                          [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
//                                          [RCDDataSource syncGroups];
//                                          NSLog(@"connect error %ld", (long)status);
//                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                              UIStoryboard *storyboard =
//                                              [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                              UINavigationController *rootNavi = [storyboard
//                                                                                  instantiateViewControllerWithIdentifier:@"rootNavi"];
//                                              self.window.rootViewController = rootNavi;
//                                          });
                                      }
                             tokenIncorrect:^{
//                                 dispatch_async(dispatch_get_main_queue(), ^{
//                                     RCDLoginViewController *loginVC =
//                                     [[RCDLoginViewController alloc] init];
//                                     UINavigationController *_navi = [[UINavigationController alloc]
//                                                                      initWithRootViewController:loginVC];
//                                     self.window.rootViewController = _navi;
//                                     UIAlertView *alertView =
//                                     [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"Token已过期，请重新登录"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil, nil];
//                                     ;
//                                     [alertView show];
//                                 });
                             }];
    }
    
    
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    
    
    
    
    
    
    
    
#if 1
//    ViewController *mainPageCtl = [[ViewController alloc] init];
    
    _loginViewCtl = [[LoginViewController alloc] init];
//    loginViewCtl.view.frame = [[UIScreen mainScreen] bounds];
    
//    loginViewCtl.view.backgroundColor = ZY_UIBASECOLOR;
    
    _tempViewcontroller = self.window.rootViewController;
    
    WMCommon *common = [WMCommon getInstance];
    common.screenW = [[UIScreen mainScreen] bounds].size.width;
    common.screenH = [[UIScreen mainScreen] bounds].size.height;
    
    /**
     设置根VC
     */
    firstCol=[[FirstScrollController alloc]init];
    _tabBarViewCol = [[CustomTabBarViewController alloc] init];
    if(self.window == nil)
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
    _loginFlag = false;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        
        if(!_loginFlag)
        {
            self.window.rootViewController = _loginViewCtl;
            _loginFlag = true;
        }
    //    self.window.rootViewController =mainPageCtl;
    }
    else
    {
        self.window.rootViewController =firstCol;
    }
    [self.window makeKeyAndVisible];
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView:) name:@"changeRootView" object:nil];
#else
    if(self.window == nil)
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
    tempViewCtl = [[OptionTextViewController alloc] init];
    
    tempViewCtl2 = [[UIViewController alloc] init];
    UINavigationController *tempNav = [[UINavigationController alloc] initWithRootViewController:tempViewCtl];
    
    tempViewCtl2.view.backgroundColor = [UIColor greenColor];
    
    UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 100, 44)];
    tempBtn.backgroundColor = [UIColor purpleColor];
    [tempViewCtl2.view addSubview:tempNav.view];
    [tempBtn addTarget:self action:@selector(ClickBtn) forControlEvents:UIControlEventTouchUpInside];
 //   [tempViewCtl2.view addSubview:tempNav.view];
    
    self.window.rootViewController = tempViewCtl2;
    
    
    
#endif
    return YES;
}

-(void) ClickBtn
{
    [tempViewCtl2.navigationController pushViewController:tempViewCtl animated:YES];
}

-(void)changeRootView:(id)sender
{
    NSString *viewName = [[sender userInfo]objectForKey:@"rootView"];
    
    NSLog(@"ViewName = %@",viewName);
    
    if([viewName isEqualToString:@"mainpage"])
    {
        self.window.rootViewController=_tempViewcontroller;
        return;
    }
    
    if([viewName isEqualToString:@"loginpage"])
    {
        self.window.rootViewController = _loginViewCtl;
        return;
    }
    
    if([viewName isEqualToString:@"optionspage"])
    {
      //  self.window.rootViewController = _loginViewCtl;
        return;
    }
    
}
- (void)showTabBar
{
    [_tabBarViewCol showTabBar];
}
- (void)hiddenTabBar
{
    [_tabBarViewCol hideCustomTabBar];
}
- (void)selectTableBarIndex:(NSInteger)index
{
    [_tabBarViewCol selectTableBarIndex:index];
}
-(CustomTabBarViewController *)getTabBar
{
    return _tabBarViewCol;
}



/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
