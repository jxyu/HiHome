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

#import "NoticePageView.h"
#import "APService.h"

#import "OptionTextViewController.h"


#define RONGCLOUD_IM_APPKEY @"lmxuhwagxp4yd"

#import "OptionTextViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"

#define SMSappKey @"b5174972a9ac"
#define SMSappSecret @"8536890596fff208c04a3e52c88a2060"


@interface AppDelegate (){
    NSArray *mFriendArray;
    NSUserDefaults *mUserDefault;
    NSString *sId;
    TaskDetailMode _taskDetailMode;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    
    /**
     *  短信验证添加
     */
    [SMSSDK registerApp:SMSappKey withSecret:SMSappSecret];
    
    
    
    
    /***************************************分享开始**********************************************/
    
    [UMSocialData setAppKey:@"563b17b1e0f55a046d003028"];//设置友盟appkey
    //设置微信AppId，设置分享url，默认使用友盟的网址
    
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx367d784d1cf53eb3" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.pgyer.com/ItEJ"];
    
    //    //设置支持没有客户端情况下使用SSO授权
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1104931910" appKey:@"Lle8IoqegSm0Rnvd" url:@"http://www.pgyer.com/ItEJ"];
    
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    
    
    /***************************************分享结束**********************************************/
    
    
    
    
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTokenEvent) name:@"getTokenInfo" object:nil];
    
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
            [self getTokenEvent];
            
            [APService setAlias:[NSString stringWithFormat:@"%@",userinfoWithFile[@"id"]] callbackSelector:nil object:nil];
            
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





-(void)getTokenEvent{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetTokenBackCall:"];
    [dataprovider GetToken:[self getUserID]];
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
        self.window.rootViewController = [[LoginViewController alloc] init];
        return;
    }
    
    if([viewName isEqualToString:@"optionspage"])
    {
      //  self.window.rootViewController = _loginViewCtl;
        return;
    }
    
}
-(void)setSelectTableBarIndex:(id)sender
{
    NSInteger index = [[[sender userInfo]objectForKey:@"index"] integerValue];
    NSLog(@"index = %ld",index);
    [self selectTableBarIndex:index];
}

-(void)GetTokenBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        // 快速集成第二步，连接融云服务器
        [[RCIM sharedRCIM] connectWithToken:dict[@"token"] success:^(NSString *userId) {
            // Connect 成功
            NSLog(@"Connect 成功");
            //获取好友列表
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendInfoByUserID:"];
            [dataProvider getFriendInfo:[self getUserID]];
            
            NSLog(@"Login successfully with userId: %@.", userId);
            dispatch_async(dispatch_get_main_queue(), ^{
                //ChatlistViewController *chatListViewController = [[ChatlistViewController alloc]init];
                //[self.navigationController pushViewController:chatListViewController animated:YES];
            });
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

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    NSLog(@"%@",mFriendArray);
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = userId;
    user.name = @"匿名";
    mUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *avatar = [mUserDefault valueForKey:@"avatar"];
    if ([avatar isEqual:@""]) {
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
    }else{
        user.portraitUri = [NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
    }
    
    for (int i = 0; i < mFriendArray.count; i++) {
        if ([[mFriendArray[i] objectForKey:@"fid"] isEqual:userId]) {
            user.name = [[mFriendArray[i] objectForKey:@"nick"] isEqual:[NSNull null]]?@"匿名":[mFriendArray[i] objectForKey:@"nick"];
            user.portraitUri = [NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[[mFriendArray[i] objectForKey:@"avatar"] isEqual:[NSNull null]]?@"匿名":[mFriendArray[i] objectForKey:@"avatar"]];
            break;
        }
    }
    return completion(user);
}

-(void)getFriendInfoByUserID:(id)dict{
    NSLog(@"%@",dict);
    int code = [dict[@"code"] intValue];
    if(code == 200){
        mFriendArray = (NSArray *)[[dict objectForKey:@"datas"] objectForKey:@"list"];
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
    }
}

-(NSString *)getUserID
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary *userInfoWithFile1 =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    //   NSLog(@"dict = [%@]",userInfoWithFile);
    NSString *userID = [userInfoWithFile1 objectForKey:@"id"];//获取userID
    
    
    return  userID;
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



- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"chu lai le ");
    UIApplicationState state = app.applicationState;
    NSLog(@"notification %@ state = %ld",notification.alertBody,state);
    //    NSLog(@"%@,%d",notification,state);
    if (state == UIApplicationStateActive) {
         NSLog(@"notification xxxxxxx");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:notification.alertBody
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"OK",nil];
        [alert show];
    }
    else //if (state == UIApplicationStateBackground)
    {
        NSLog(@"notification xxxxxxx");
        
        
        NSString *userId = [self getUserID];
        if(userId == nil)
        {
            return;
        }
        
        NSDictionary *tempDict ;
        NSString *taskId;
        
        
        @try {
            tempDict =notification.userInfo;
            if(tempDict.count>0)
            {
                taskId = [tempDict objectForKey:@"taskid"];
                sId= [tempDict objectForKey:@"sid"];
                _taskDetailMode =(TaskDetailMode)[[tempDict objectForKey:@"taskDetailMode"] integerValue];
            }
            
            
            [self loadTaskDetails:taskId];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        

    }
    
}



#pragma  mark - 获取任务详情
-(void)loadTaskDetails:(NSString *)taskID
{
    NSLog(@"load task Details");
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"taskDetailCallBack:"];
    
    [dataprovider getTaskInfo:taskID];
}


-(void)taskDetailCallBack:(id)dict
{
    
    NSInteger code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    NSDictionary *taskDetailDict;
    
    if(code!=200)
    {
        if(code != 400)
        {
            
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        return;
    }
    
    NSLog(@"task detail dict = [%@]",dict);
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        taskDetailDict = [(NSArray *)[dict objectForKey:@"datas"] objectAtIndex:0];
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    
    @try {
        NSArray *tempArr =[taskDetailDict objectForKey:@"taskerlist"];
        TaskPath * taskDetailPath = [[TaskPath alloc] init];
        taskDetailPath.taskContent = [taskDetailDict objectForKey:@"content"];
        //      taskDetailPath.taskStatus = (ZYTaskStatue)[(NSString *)[taskDetailDict objectForKey:@"state"] integerValue];
        if(tempArr.count > 1)
            taskDetailPath.taskStatus = State_morepeople;
        else
        {
            NSDictionary *tempDict = [tempArr objectAtIndex:0];
            
            taskDetailPath.taskStatus = (ZYTaskStatue)[[tempDict objectForKey:@"tasker_state"] integerValue];
        }
        
        taskDetailPath.taskOwner = [taskDetailDict objectForKey:@"uid"];
        taskDetailPath.taskName = [taskDetailDict objectForKey:@"title"];
        taskDetailPath.repeatMode = (ZYTaskRepeat)[(NSString *)[taskDetailDict objectForKey:@"repeat"] integerValue];
        taskDetailPath.remindTime = (ZYTaskRemind)[(NSString *)[taskDetailDict objectForKey:@"tip"] integerValue];
        taskDetailPath.startTaskDateStr =[taskDetailDict objectForKey:@"start"];
        taskDetailPath.endTaskDateStr =[taskDetailDict objectForKey:@"end"];
        taskDetailPath.taskID =[taskDetailDict objectForKey:@"id"];
        taskDetailPath.sId = sId;
        //  [self setTaskDetails];
        
        if(taskDetailPath.imgSrc.count > 0)
        {
            [taskDetailPath.imgSrc removeAllObjects];
        }
        if((![[taskDetailDict objectForKey:@"imgsrc1"] isEqual:[NSNull null]]))
        {
            if(![[taskDetailDict objectForKey:@"imgsrc1"] isEqualToString:@""])
            {
                [taskDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc1"]];
            }
        }
        if((![[taskDetailDict objectForKey:@"imgsrc2"] isEqual:[NSNull null]]))
        {
            if(![[taskDetailDict objectForKey:@"imgsrc2"] isEqualToString:@""])
            {
                [taskDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc2"]];
            }
        }
        if((![[taskDetailDict objectForKey:@"imgsrc3"] isEqual:[NSNull null]]))
        {
            if(![[taskDetailDict objectForKey:@"imgsrc3"] isEqualToString:@""])
            {
                [taskDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc3"]];
            }
        }

        if(![[taskDetailDict objectForKey:@"taskerlist"] isEqual:[NSNull null]])
        {
            taskDetailPath.taskPerformerDetails = [taskDetailDict objectForKey:@"taskerlist"];
        }
        else
        {
            NSLog(@"taskerlist = NULL");
            // return;
        }
        NSString *contentStr;
        contentStr = [NSString stringWithFormat:@"任务发布人：%@\n任务执行人：%@\n任务内容：%@\n任务开始时间结束时间：%@-%@",taskDetailPath.taskOwner,@"jeff",taskDetailPath.taskContent,taskDetailPath.startTaskDateStr,taskDetailPath.startTaskDateStr];
        NoticePageView *tempView = [[NoticePageView alloc] initWithTitle:taskDetailPath.taskName message:contentStr];
        [tempView addButton:NoticeButton_OK withTitle:@"去执行" handler:^(NoticePageItem *item )
         {
             TaskDetailPageViewController *_taskDetailPageCtl;
             
             _taskDetailPageCtl = [[TaskDetailPageViewController alloc] init];
             _taskDetailPageCtl.delegate = self;
             _taskDetailPageCtl.taskDetailMode = _taskDetailMode;
             _taskDetailPageCtl.navTitle = taskDetailPath.taskName;
             
             // taskDetailPath.taskPerformerDetails =[taskDetailDict objectForKey:@"id"];
             
             
             [_taskDetailPageCtl setDictData:taskDetailDict];
             [_taskDetailPageCtl setDatas:taskDetailPath];
             _taskDetailPageCtl.hidesBottomBarWhenPushed = YES;
             _taskDetailPageCtl.pageChangeMode = Mode_dis;
             [self.window.rootViewController presentViewController:_taskDetailPageCtl animated:YES completion:^{}];
         }];
        
        [tempView addButton:NoticeButton_CANCEL withTitle:@"取消任务" handler:^(NoticePageItem *item )
         {
             DLog(@"run here 2");
         }];
        //   [tempView addButtonWithTitle:@"正点提醒"];
        tempView.buttonHeight = 44;
        [tempView show];
        
        
    }
    @catch (NSException *exception) {
        [SVProgressHUD dismiss];
    }
    @finally {
        
    }
    [SVProgressHUD dismiss];
    
}


#pragma mark - 任务详情代理－>编辑模式
-(void)setEdit//任务详情跳转创建任务至编辑模式
{
    
    NSLog(@"run here -- [%d]",__LINE__);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    
    NSString *str = @"创建任务";
    CreateTaskViewController * _createTaskViewCtl = [[CreateTaskViewController alloc] init];
    _createTaskViewCtl.navTitle = str;
    _createTaskViewCtl.hidesBottomBarWhenPushed = YES;
    [self.window.rootViewController.navigationController pushViewController:_createTaskViewCtl animated:NO];
    
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
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
