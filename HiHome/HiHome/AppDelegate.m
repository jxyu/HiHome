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
#import "DataProvider.h"

#import "CommenDef.h"
#import <SMS_SDK/SMSSDK.h>
#import <RongIMKit/RongIMKit.h>

#import "APService.h"

#import "OptionTextViewController.h"


#define RONGCLOUD_IM_APPKEY @"lmxuhwagxp4yd"

#import "OptionTextViewController.h"
#import "UMessage.h"

#define SMSappKey @"b5174972a9ac"
#define SMSappSecret @"8536890596fff208c04a3e52c88a2060"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    
    
    
    /**
     *  短信验证添加
     */
    [SMSSDK registerApp:SMSappKey withSecret:SMSappSecret];
    
    
    
    
    
    
    
    
    
    
    
    
    //初始化融云SDK。
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY ];
    
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

    
    
    
    
    

    
    
    
    
    
    
    
    
    //集成短信
    [UMessage startWithAppkey:@"55ee2fcc67e58e2d20005b57" launchOptions:launchOptions];

    
    
    
    
    
    
    
    
    
    
    // Required
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //categories
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        } else {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#else
             //categories nil
             categories:nil];
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#endif
             // Required
             categories:nil];
        
    
    
    
    
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
    if (_tabBarViewCol==nil) {
        _tabBarViewCol = [[CustomTabBarViewController alloc] init];
        
    }
    if(self.window == nil)
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
    _loginFlag = false;
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary * userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        
//        if(!_loginFlag)
            if (!userinfoWithFile[@"id"])
        {
            self.window.rootViewController = _loginViewCtl;
            _loginFlag = true;
        }
        else
        {
            self.window.rootViewController =_tempViewcontroller;
        }
//        self.window.rootViewController =_tempViewcontroller;
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
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        NSDictionary * userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.window.rootViewController=_tempViewcontroller;
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetTokenBackCall:"];
        [dataprovider GetToken:userinfoWithFile[@"id"]];
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

-(void)GetTokenBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        // 快速集成第二步，连接融云服务器
        [[RCIM sharedRCIM] connectWithToken:dict[@"token"] success:^(NSString *userId) {
            // Connect 成功
            NSLog(@"Connect 成功");
        }
                                      error:^(RCConnectErrorCode status) {
                                          // Connect 失败
                                          NSLog(@"Connect 失败");
                                      }
                             tokenIncorrect:^() {
                                 // Token 失效的状态处理
                             }];
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
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
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
