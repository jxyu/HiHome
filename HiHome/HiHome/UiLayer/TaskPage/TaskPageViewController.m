//
//  TaskPageViewController.m
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TaskPageViewController.h"
#import "CalendarViewController.h"
#import "SegmentedPageView.h"
#import "UIDefine.h"
#import "TaskTableViewCell.h"
#import "AnniversaryTaskCell.h"
#import "SVProgressHUD.h"
#import "DataProvider.h"
#import "DataDefine.h"
#import "JKAlertDialog.h"
#import "UIImageView+WebCache.h"

@interface TaskPageViewController ()
{
    
    NSMutableDictionary *eventsByDate;
    NSDictionary *_taskDict;
    NSDictionary *_receiveTaskDict;
    NSDictionary *_sendTaskDict;
    NSDictionary *_AnniversaryDict;
    NSDictionary *_taskCalenderDict;
    
    NSInteger myTaskPage;
    NSInteger receiveTaskPage;
    NSInteger sendTaskPage;
    NSInteger anniversaryPage;
    NSString *dateStr;
    
    TaskDetailMode _taskDetailMode;
    anniversaryPath *anniversaryDetailPath;
    NSString *_sID;
    
}
@end

@implementation TaskPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   [self loadTaskDatas];
    
    [self initCalendar];//初始化日历
    // Do any additional setup after loading the view from its nib.
}


-(NSString *)getUserID
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    //   NSLog(@"dict = [%@]",userInfoWithFile);
    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID
    
    
    return  userID;
}


-(void)viewDidAppear:(BOOL)animated//切至当前页面刷新数据
{
   // [self createTaskForTest];
    
    [self loadTaskCalenderDatas];//获取任务日历
    [_taskPageSeg setCurrentPage:_taskPageSeg.currentPage];
    
    
    
}


-(void)resetDatas
{
    _cellCountMyTask = 1;
    [_myTaskData removeAllObjects];
    [_myAnniversaryData removeAllObjects];
   
}


-(void) initViews
{//[[UIScreen mainScreen] bounds].size.height-ZY_CALENDAR_NORMALMODE_HEIGHT,
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,ZY_CALENDAR_NORMALMODE_HEIGHT+ZY_HEADVIEW_HEIGHT+ZY_CALENDAR_MENU_HEIGHT, [[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.height))];
    _mainView.backgroundColor = ZY_UIBASECOLOR;
    
    [self.view addSubview:_mainView];
    [self initTaskPage];
    [self initData];
    [self.view addSubview:_calendarContentView];
    [self.view addSubview:_calendarMenuView];
    [self.view addSubview:[self headerViewForTaskPage]];
    
    
    _cellCount = 3;
    
}


-(void) initData{
    _myAnniversaryData = [[NSMutableArray alloc] init];
    
    anniversaryDetailPath = [[anniversaryPath alloc] init];
    _myTaskData = [[NSMutableArray alloc] init];
    _getTaskData = [[NSMutableArray alloc] init];
    _sendTaskData =[[NSMutableArray alloc] init];
    _taskCalenderData=[[NSMutableArray alloc] init];
    
   
    
    //    for (int i = 0; i < 40; i++) {
    //        TaskPath * taskPath = [[TaskPath alloc] init];
    //        taskPath.taskName = [NSString stringWithFormat:@"去超市买黄瓜%d",i+1];
    //        taskPath.taskOwner = @"自己";
    //        NSArray *performers = @[@"自己"];
    //        taskPath.taskPerformers = performers;
    //        taskPath.taskContent =@"去超市买根黄瓜";
    //        taskPath.taskStatus = ZY_TASkSTATUE_RESERVE;
    //        taskPath.taskType = ZY_TASKTYPE_MINE;
    //        taskPath.remindTime = ZY_TASkREMIND_RESERVE;
    //        taskPath.repeatMode = ZY_TASkREPEAT_RESERVE;
    //
    //        NSDate* now = [NSDate date];
    //        NSCalendar *cal = [NSCalendar currentCalendar];
    //
    //        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
    //
    //        NSDateComponents *startTaskDate;
    //        NSDateComponents *endTaskDate;
    //        startTaskDate= [cal components:unitFlags fromDate:now];
    //        endTaskDate= [cal components:unitFlags fromDate:now];
    //
    //        taskPath.startTaskDate =startTaskDate;
    //        endTaskDate.day ++;
    //        taskPath.endTaskDate = endTaskDate;
    //
    //        [_myTaskData addObject:taskPath];
    //    }
    
    _cellCountMyTask = _myAnniversaryData.count + _myTaskData.count + 1;//最后一个元素作废，当站位作用，作为最后的横线
    _cellCountGetTask =1;//最后一个元素作废，当站位作用，作为最后的横线
    _cellCountSendTask = 1;//最后一个元素作废，当站位作用，作为最后的横线
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
    [self.navigationController pushViewController:_createTaskViewCtl animated:NO];
    
    
}


#pragma mark -callbacks
-(void)createTaskCallBack:(id)dict
{
    if(dict != nil)
        NSLog(@"createT task dict = [%@]",dict);
}

-(void)createAnniversaryCallBack:(id)dict
{
    if(dict != nil)
        NSLog(@"createT task dict = [%@]",dict);
}

#pragma mark - 从服务器获取数据


//
//-(void) createAnniversaryForTest
//{
//    DataProvider * dataprovider=[[DataProvider alloc] init];
//    [dataprovider setDelegateObject:self setBackFunctionName:@"createAnniversaryCallBack:"];
//    
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                              NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
//    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
//    NSLog(@"dict = [%@]",userInfoWithFile);
//    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID
//    
//    //   NSLog(@"id = [%@]",userID);
//    
//    [dataprovider createAnniversary:userID andImg:@"yuandan" andTitle:@"元旦" andMdate:@"2016-1-1" andContent:@"元旦" and];
//    [dataprovider createAnniversary:userID andImg:@"xueren" andTitle:@"中秋" andMdate:@"2015-8-15" andContent:@"中秋节"];
//    
//}



-(void) loadMyTaskDatas:(NSString *)nowPage andPerPage:(NSString *)perPage andState:(NSString*)state andDate:(NSString *)date
{
    
    NSLog(@"load task datas");
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getTaskCallBack:"];

    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);

    
    [dataprovider getReceiveTask:userID andMyId:nil andState:state andMyOrNot:@"1"  andPage:nowPage andPerPage:perPage andDate:date andStartDate:nil andEndDate:nil andAccept:nil];
}




-(void)getTaskCallBack:(id)dict
{
    NSInteger resultAll;
    NSInteger code;
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]);
   
        if(code!=400)  //= 400 不弹框
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        UITableView *tempTableView;
        tempTableView = [_tableViews objectAtIndex:0];
        [tempTableView reloadData];//重新载入数据
        return;
    }
    
    NSLog(@"task dict = [%@]",dict);
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        _taskDict = [dict objectForKey:@"datas"];
        resultAll = [[_taskDict objectForKey:@"resultAll"] integerValue];//获取的任务数
    
        NSLog(@"result all = %ld",resultAll);
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    _cellCountMyTask += ((NSArray *)[_taskDict objectForKey:@"list"]).count;
    [self setTaskDatas];
    
    NSLog(@"_cellCountMyTask = %ld",(long)_cellCountMyTask);
    
}


-(void) setTaskDatas
{
    if(_taskDict == nil)
        return;
    @try {
        NSArray *taskList = [_taskDict objectForKey:@"list"];
        NSInteger resultAll = [[_taskDict objectForKey:@"resultAll"] integerValue];
        for (int i = 0; i < taskList.count; i++) {
            TaskPath * taskPath = [[TaskPath alloc] init];
            
            NSDictionary *tempDict = [taskList objectAtIndex:i];
            
            
            taskPath.taskName = [tempDict objectForKey:@"title"];
            taskPath.taskOwner = @"自己";//[tempDict objectForKey:@"uid"];
            //    NSString *performers = @"自己";
            taskPath.taskPerformers = [tempDict objectForKey:@"tasker"];
            taskPath.taskContent =[tempDict objectForKey:@"content"];
            taskPath.taskStatus =(ZYTaskStatue)[(NSString *)[tempDict objectForKey:@"state"] integerValue];
            taskPath.taskType = ZY_TASKTYPE_MINE;
            taskPath.remindTime = (ZYTaskRemind)[(NSString *)[tempDict objectForKey:@"tip"] integerValue];
            taskPath.repeatMode = (ZYTaskRepeat)[(NSString *)[tempDict objectForKey:@"repeat"] integerValue];
            taskPath.startTaskDateStr = [tempDict objectForKey:@"start"];
            taskPath.endTaskDateStr = [tempDict objectForKey:@"end"];
            taskPath.taskID = [tempDict objectForKey:@"id"];
            taskPath.sId = [tempDict objectForKey:@"sid"];
            
            [_myTaskData addObject:taskPath];
        }
        
        if(resultAll > _myTaskData.count)
        {
            myTaskPage++;
            [self loadMyTaskDatas:[NSString stringWithFormat:@"%ld",myTaskPage] andPerPage:nil andState:nil andDate:dateStr];
        }
        else
        {
            UITableView *tempTableView;
            tempTableView = [_tableViews objectAtIndex:0];
            [tempTableView reloadData];//重新载入数据
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark - 接受的任务


-(void) loadReceiveTaskDatas:(NSString *)nowPage andPerPage:(NSString *)perPage andState:(NSString *)state andDate:(NSString *)date
{
    
    NSLog(@"load Receive task datas");
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"receiveTaskCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    if(date!=nil)
        NSLog(@"date11 =[%@]",date);
    else
        NSLog(@"date  = nil");
    [dataprovider getReceiveTask:userID andMyId:nil andState:state andMyOrNot:nil  andPage:nowPage andPerPage:perPage andDate:date andStartDate:nil andEndDate:nil andAccept:nil];
}




-(void)receiveTaskCallBack:(id)dict
{
    NSString *resultAll;
    NSInteger code;
    
    [SVProgressHUD dismiss];
    NSLog(@"task dict = [%@]",dict);
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        if(code!=400)
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        
        
        UITableView *tempTableView;
        tempTableView = [_tableViews objectAtIndex:1];
        [tempTableView reloadData];//重新载入接收的任务页数据
        
        return;
    }
    
   
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        _receiveTaskDict = [dict objectForKey:@"datas"];
        resultAll = [_receiveTaskDict objectForKey:@"resultAll"];//获取的任务数
        
        NSLog(@"result all = %@",resultAll);
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    _cellCountGetTask +=  ((NSArray *)[_receiveTaskDict objectForKey:@"list"]).count;
    
    NSLog(@"_cellCountGetTask = %ld",(long)_cellCountGetTask);
    
    [self setReceiveTaskDatas];
    
  
    
}


-(void) setReceiveTaskDatas
{
    if(_receiveTaskDict == nil)
        return;
    @try {
        NSArray *taskList = [_receiveTaskDict objectForKey:@"list"];
        NSInteger resultAll = [[_receiveTaskDict objectForKey:@"resultAll"] integerValue];
        
        
        for (int i = 0; i < taskList.count; i++) {
            TaskPath * taskPath = [[TaskPath alloc] init];
            
            NSDictionary *tempDict = [taskList objectAtIndex:i];
            
            
            taskPath.taskName = [tempDict objectForKey:@"title"];
            NSLog(@"[%s]taskPath.taskName = %@ ;",__FUNCTION__,taskPath.taskName );
            
            taskPath.taskOwner = [tempDict objectForKey:@"nick"];
            
            NSInteger tasker =[(NSString *)[tempDict objectForKey:@"tasker"] integerValue];
            NSString *performers;
            if(tasker > 1 )
            {
                performers = [NSString stringWithFormat:@"%ld人",(long)tasker];
            }
            else
                performers = @"仅自己";
            
            taskPath.taskPerformers = performers;
            taskPath.taskContent =[tempDict objectForKey:@"content"];
            taskPath.taskStatus = (ZYTaskStatue)[(NSString *)[tempDict objectForKey:@"state"] integerValue];
            taskPath.taskType = ZY_TASKTYPE_GET;
            taskPath.remindTime = (ZYTaskRemind)[(NSString *)[tempDict objectForKey:@"tip"] integerValue];
            
            NSLog(@"taskPath.remindTime = %d",taskPath.remindTime);
            
            taskPath.repeatMode = (ZYTaskRepeat)[(NSString *)[tempDict objectForKey:@"repeat"] integerValue];
            taskPath.startTaskDateStr = [tempDict objectForKey:@"start"];
            taskPath.endTaskDateStr = [tempDict objectForKey:@"end"];
            taskPath.taskID = [tempDict objectForKey:@"id"];
            taskPath.sId = [tempDict objectForKey:@"sid"];
            
            [_getTaskData addObject:taskPath];
        }
        
        if(resultAll > _getTaskData.count)
        {
            receiveTaskPage ++ ;
            [self loadReceiveTaskDatas:[NSString stringWithFormat:@"%ld",receiveTaskPage] andPerPage:nil andState:nil andDate:dateStr];
        }
        else
        {
            UITableView *tempTableView;
            tempTableView = [_tableViews objectAtIndex:1];
            [tempTableView reloadData];//重新载入接收的任务页数据
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark - 发布的任务

-(void) loadSendTaskDatas:(NSString *)nowPage andPerPage:(NSString *)perPage andState:(NSString *)state andDate:(NSString *)date
{
    
    NSLog(@"load Send task datas");
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"sendTaskCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    if(date!=nil)
        NSLog(@"date =[%@]",date);
    else
        NSLog(@"date  = nil");
    
    [dataprovider getSendTask:userID andState:state andPage:nowPage andPerPage:perPage andDate:date];
}




-(void)sendTaskCallBack:(id)dict
{
    
    NSInteger code;
    
    [SVProgressHUD dismiss];
    
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
     NSLog(@"task dict = [%@]",dict);
    if(code!=200)
    {
        NSLog(@"_cellCountSendTask123 = [%ld] ",_cellCountSendTask);
        if(code != 400)
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        
        
        NSLog(@"reLoad sendTableView datas");
        UITableView *tempTableView;
        tempTableView = [_tableViews objectAtIndex:2];
        [tempTableView reloadData];//重新载入接收的任务页数据
        
        return;
    }
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        _sendTaskDict = [dict objectForKey:@"datas"];
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    _cellCountSendTask += ((NSArray *)[_sendTaskDict objectForKey:@"list"]).count;
    
    NSLog(@"_cellCountSendTask = %ld",(long)_cellCountSendTask);
    
    [self setSendTaskDatas];
    
    
   
    
}


-(void) setSendTaskDatas
{
    if(_sendTaskDict == nil)
        return;
    @try {
        NSArray *taskList = [_sendTaskDict objectForKey:@"list"];
        NSInteger resultAll = [[_sendTaskDict objectForKey:@"resultAll"] integerValue];
        
        
        for (int i = 0; i < taskList.count; i++) {
            TaskPath * taskPath = [[TaskPath alloc] init];
            
            NSDictionary *tempDict = [taskList objectAtIndex:i];
            
            
            taskPath.taskName = [tempDict objectForKey:@"title"];
            NSLog(@"[%s]taskPath.taskName = %@ ;",__FUNCTION__,taskPath.taskName );
            
            taskPath.taskOwner = @"自己";
            
            NSInteger tasker =[(NSString *)[tempDict objectForKey:@"tasker"] integerValue];
            NSString *performers;
            if(tasker == 0)
            {
                performers = @"0人";
            }
            else if(tasker > 1 )
            {
                performers = [NSString stringWithFormat:@"%ld人",(long)tasker];
            }
            else
            {
                NSArray *tempDict1 = [tempDict objectForKey:@"taskerlist"];
                performers = [tempDict1[0] objectForKey:@"nick"];
            }
            
            taskPath.taskPerformers = performers;
            taskPath.taskContent =[tempDict objectForKey:@"content"];
            taskPath.taskStatus = (ZYTaskStatue)[(NSString *)[tempDict objectForKey:@"state"] integerValue];
            if(tasker == 0)
            {
                taskPath.taskStatus = State_unreceive;
            }
            else if([[tempDict objectForKey:@"tasker"] integerValue] > 1)
                taskPath.taskStatus = State_morepeople;
            else{
                NSDictionary *tempDict1;
                
                tempDict1 = [[tempDict objectForKey:@"taskerlist"] objectAtIndex:0];
                
                taskPath.taskStatus = (ZYTaskStatue)[(NSString *)[tempDict1 objectForKey:@"tasker_state"] integerValue];
                
                
            }
            
            taskPath.taskType = ZY_TASKTYPE_GET;
            taskPath.remindTime = (ZYTaskRemind)[(NSString *)[tempDict objectForKey:@"tip"] integerValue];
            
            NSLog(@"taskPath.remindTime = %d",taskPath.remindTime);
            
            taskPath.repeatMode = (ZYTaskRepeat)[(NSString *)[tempDict objectForKey:@"repeat"] integerValue];
            taskPath.startTaskDateStr = [tempDict objectForKey:@"start"];
            taskPath.endTaskDateStr = [tempDict objectForKey:@"end"];
            taskPath.taskID = [tempDict objectForKey:@"id"];
            
            
            [_sendTaskData addObject:taskPath];
        }
        if(resultAll > _sendTaskData.count)
        {
            sendTaskPage++;
            [self loadSendTaskDatas:[NSString stringWithFormat:@"%ld",sendTaskPage] andPerPage:nil andState:nil andDate:dateStr];
        }
        else
        {
            NSLog(@"reLoad sendTableView datas");
            UITableView *tempTableView;
            tempTableView = [_tableViews objectAtIndex:2];
            [tempTableView reloadData];//重新载入接收的任务页数据
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark - 纪念日
-(void) loadAnniversaryDatas:(NSString *)nowPage andPerPage:(NSString *)perPage
{
    NSLog(@"load anniversary datas");
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getAnniversaryCallBack:"];

    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    //[dataprovider getMyTask:userID andPage:nowPage andPerPage:perPage];
    [dataprovider getAnniversaryList:userID andNowPage:nowPage andPerPage:perPage];
}



-(void)getAnniversaryCallBack:(id)dict
{
    NSString *resultAll;
    NSInteger code;
   [SVProgressHUD dismiss];
    NSLog(@"in function [%s]",__FUNCTION__);
    
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    if(code!=200)
    {
        if(code != 400)
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"纪念日获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        
        UITableView *tempTableView;
        tempTableView = [_tableViews objectAtIndex:0];
        [tempTableView reloadData];//重新载入数据
        return;
    }
    
   
    NSLog(@"anniversary dict = [%@]",dict);
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        _AnniversaryDict = [dict objectForKey:@"datas"];
        resultAll = [_AnniversaryDict objectForKey:@"resultAll"];//获取的任务数
        
        NSLog(@"result all = %@",resultAll);
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    _cellCountMyTask += ((NSArray *)[_AnniversaryDict objectForKey:@"list"]).count;
    
    NSLog(@"_cellCountMyTask = %ld",(long)_cellCountMyTask);
    
    [self setAnniversaryDatas];
    
   
    
    
}


-(void) setAnniversaryDatas
{
    if(_AnniversaryDict == nil)
        return;
    
    @try {
        NSArray *anniversaryList = [_AnniversaryDict objectForKey:@"list"];
        NSInteger resultAll = [[_AnniversaryDict objectForKey:@"resultAll"] integerValue];
        
        for (int i = 0; i < anniversaryList.count; i++) {
            
            NSDictionary *tempDict = [anniversaryList objectAtIndex:i];
            
            anniversaryPath *anniversary = [[anniversaryPath alloc] init];
            
            
            NSLog(@"title = %@",[tempDict objectForKey:@"title"]);
            anniversary.title = [tempDict objectForKey:@"title"];
            anniversary.date = [tempDict objectForKey:@"mdate"];
            anniversary.anniversaryID =[tempDict objectForKey:@"id"];
            if((![[tempDict objectForKey:@"imgsrc"] isEqual:[NSNull null]]))
            {
                anniversary.headImgSrc = [tempDict objectForKey:@"imgsrc"];
            }

            [_myAnniversaryData addObject:anniversary];
            
        }
        
        if(resultAll > _myAnniversaryData.count)
        {
            anniversaryPage ++ ;
            [self loadAnniversaryDatas:[NSString stringWithFormat:@"%ld",anniversaryPage] andPerPage:nil];
        }
        else{
            UITableView *tempTableView;
            tempTableView = [_tableViews objectAtIndex:0];
            [tempTableView reloadData];//重新载入数据
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    NSLog(@"++++++++++++_myAnniversaryData count  = [%ld]",(unsigned long)_myAnniversaryData.count);
    
}

#pragma mark - 获取任务日历

-(void) loadTaskCalenderDatas
{
    NSLog(@"load TaskCalender datas");
    if(_taskCalenderData.count!=0)
      [ _taskCalenderData removeAllObjects];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getTaskCalenderCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    //[dataprovider getMyTask:userID andPage:nowPage andPerPage:perPage];
    [dataprovider GetTaskCalender:userID];
}



-(void)getTaskCalenderCallBack:(id)dict
{
   
    NSInteger code;
    [SVProgressHUD dismiss];
    NSLog(@"in function [%s]",__FUNCTION__);
    
  //   NSLog(@"TaskCalender dict = [%@]",dict);
    
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    if(code!=200)
    {
        if(code != 400)
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"任务日历获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        return;
    }
    
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        _taskCalenderDict = [dict objectForKey:@"datas"];
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    
    [self setTaskCalenderDatas];
  //  _cellCountMyTask += [resultAll integerValue];
    
 //   NSLog(@"_cellCountMyTask = %ld",(long)_cellCountMyTask);
    
}


-(void) setTaskCalenderDatas
{
    NSLog(@"start [%s]",__FUNCTION__);
    
    if(_taskCalenderDict == nil)
        return;
    
    NSArray *taskCalenderList = [_taskCalenderDict objectForKey:@"list"];
  //  NSString *resultAll = [_taskCalenderDict objectForKey:@"resultAll"];
    
    for (int i = 0; i < taskCalenderList.count; i++) {
        
        NSDictionary *tempDict = [taskCalenderList objectAtIndex:i];
    
        
        [_taskCalenderData  addObject:tempDict];//这里把数据保存 不直接处理是为了后续使用方便
        
    }
     NSLog(@"_taskCalenderData .count = %ld ",_taskCalenderData.count);
    [self setTaskCalenderS];
    
  //  NSLog(@"++++++++++++_myAnniversaryData count  = [%ld]",(unsigned long)_myAnniversaryData.count);
    
}

-(void)setTaskCalenderS
{
    NSLog(@"start [%s]",__FUNCTION__);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableArray *dateArr = [NSMutableArray array];
    for (int i = 0; i < _taskCalenderData.count; i++)
    {
        NSDictionary *tempDict;
        NSArray *tempArr;
        tempDict=[_taskCalenderData objectAtIndex:i];
        
  //      NSLog(@"[tempDict objectForKey:date] = %@",[tempDict objectForKey:@"date"]);
        
        if([[tempDict objectForKey:@"date"]  isEqual:[NSNull null]])
            return;
        
        tempArr = [tempDict objectForKey:@"date"];
        for(int i = 0;i<tempArr.count;i++)
        {
            NSString *tempDateStr = [tempArr objectAtIndex:i];
            
            if([self checkDate:tempDateStr andBaseDateArr:dateArr])
            {
                [dateArr addObject:tempDateStr];//获取date
            }
        }
        
       
    }
    if(eventsByDate!=nil)
    {
        [eventsByDate removeAllObjects];
    }
    
    for(int i = 0;i<dateArr.count;i++)
    {
        NSDate *date = [formatter dateFromString:[dateArr objectAtIndex:i]];
        [self setCalendarEvent:self.calendar date:date];//日历打点
    }

    
    [self.calendar reloadData];
}

-(BOOL)checkDate:(NSString *)date andBaseDateArr:(NSArray *)baseArr
{
    for(int i = 0;i<baseArr.count;i++)
    {
        if([date isEqualToString:[baseArr objectAtIndex:i]])
            return NO;
    }
    
    return YES;
}

#pragma mark -  set task page
-(void) initTaskPage
{
    _taskPageSeg = [[SegmentedPageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 80)];
    _taskPageSeg.numOfPages = 3;
    _taskPageSeg.backgroundColor = [UIColor whiteColor];
    
    NSArray *title = @[@"自己的任务",@"接受的任务",@"发布的任务"];
    NSArray *imgs = @[@"mytask_gray",@"gettask_gray",@"sendtask_gray"];
    NSArray *imgsSelect = @[@"mytask_red",@"gettask_red",@"sendtask_red"];
    _tableViews = [NSMutableArray array];
    
    
    _myTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - ZY_CALENDAR_NORMALMODE_HEIGHT-ZY_CALENDAR_MENU_HEIGHT-80-50 - TabBar_HEIGHT)];
    _myTaskView.contentSize = CGSizeMake(SCREEN_WIDTH, _cellCountMyTask*50+TabBar_HEIGHT);
    [self setPageIndexPath:_myTaskView indexPage:0];
    
    _getTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - ZY_CALENDAR_NORMALMODE_HEIGHT-ZY_CALENDAR_MENU_HEIGHT-80-50)];
    _getTaskView.contentSize = CGSizeMake(SCREEN_WIDTH, _cellCountGetTask *40+TabBar_HEIGHT);
    [self setPageIndexPath:_getTaskView indexPage:1];
    
    
    _sendTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - ZY_CALENDAR_NORMALMODE_HEIGHT-ZY_CALENDAR_MENU_HEIGHT-80-50)];
    _sendTaskView.contentSize = CGSizeMake(SCREEN_WIDTH, _cellCountSendTask * 50+TabBar_HEIGHT);
    [self setPageIndexPath:_sendTaskView indexPage:2];

//    _myTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountMyTask*50);
//    _getTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountGetTask*50);
//    _sendTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountSendTask*50);
    
    
    [_tableViews addObject:_myTaskView];
    [_tableViews addObject:_getTaskView];
    [_tableViews addObject:_sendTaskView];
    
    _taskPageSeg.delegate = self;
    
    [_taskPageSeg setItemTitle:title];
    [_taskPageSeg setImgTitle:imgs];
    [_taskPageSeg setImgSelectTitle:imgsSelect];
    
    [_mainView addSubview:_taskPageSeg];
    [_mainView addSubview:_myTaskView];
    [_mainView addSubview:_getTaskView];
    [_mainView addSubview:_sendTaskView];
    
    [_taskPageSeg setCurrentPage:0];

}

-(void) setPageIndexPath:(UITableView *) tableView indexPage:(NSInteger)page
{
 //   UITableView *sendTaskView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    tableView.tag = page;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
    
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
}


-(UIView *)headerViewForTaskPage
{
    UIView *tableHeaderView = [[UIView alloc] init];
    tableHeaderView.backgroundColor = ZY_UIBASECOLOR;
    tableHeaderView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, ZY_HEADVIEW_HEIGHT);
    
    UIImageView *threepiontImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 10, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    threepiontImg.image = [UIImage imageNamed:@"threepoint"];
    threepiontImg.contentMode = UIViewContentModeCenter;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, ([[UIScreen mainScreen] bounds].size.width - 100*2), ZY_VIEWHEIGHT_IN_HEADVIEW)];
    titleLabel.text = @"任务";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 10 -30 -20 -30, 20,30, 30)];
    
    [editBtn setImage:[UIImage imageNamed:@"editTask"] forState:UIControlStateNormal];
    editBtn.imageView.contentMode = UIViewContentModeCenter;
    editBtn.tag = ADD_ANNIVERSARY_BTNTAG;
    [editBtn addTarget:self action:@selector(ClickBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addtaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 10 - 30, 20,30, 30)];
    
    [addtaskBtn setImage:[UIImage imageNamed:@"addtask"] forState:UIControlStateNormal];
    addtaskBtn.imageView.contentMode = UIViewContentModeCenter;
    addtaskBtn.tag = ADD_TASK_BTNTAG;
    [addtaskBtn addTarget:self action:@selector(ClickBtns:) forControlEvents:UIControlEventTouchUpInside];
   
    
    tableHeaderView.contentMode = UIViewContentModeCenter;
    [tableHeaderView addSubview:titleLabel];
    [tableHeaderView addSubview:editBtn];
    [tableHeaderView addSubview:addtaskBtn];
    [tableHeaderView addSubview:threepiontImg];
    
    return tableHeaderView;
}

-(void) ClickBtns:(UIButton *)sender
{
    switch (sender.tag) {
        case ADD_ANNIVERSARY_BTNTAG:
        {
            CreateAnniversaryViewController *_createAnniversaryViewCtl = [[CreateAnniversaryViewController alloc] init];
            _createAnniversaryViewCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_createAnniversaryViewCtl animated:NO];
        }
            break;
        case ADD_TASK_BTNTAG:
        {
            NSString *str = @"创建任务";
            CreateTaskViewController * _createTaskViewCtl = [[CreateTaskViewController alloc] init];
            _createTaskViewCtl.navTitle = str;
            _createTaskViewCtl.delegate = self;
            _createTaskViewCtl.tag = 100;
            _createTaskViewCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_createTaskViewCtl animated:NO];
        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
}


#pragma mark - CreateTaskViewController delegate
-(void)quitViewDelegate:(CreateTaskViewController *)createTaskView
{
    if(createTaskView.tag == 100)
    {
        [self loadTaskCalenderDatas];//获取任务日历
        [_taskPageSeg setCurrentPage:_taskPageSeg.currentPage];
    }
}

-(void)setPageIndex:(NSInteger)page//分页的代理方法
{
    NSLog(@"Page = %ld",(long)page);
    
    
    if(self.calendar.currentDateSelected == nil)
    {
        NSLog(@"NO SELECT DATE");
        dateStr = [[[self dateFormatterForLoadFromNet] stringFromDate:self.calendar.currentDate] substringToIndex:10];
    }
    else
    {
        dateStr = [[[self dateFormatterForLoadFromNet] stringFromDate:self.calendar.currentDateSelected] substringToIndex:10];
        NSLog(@"dateStr = %@",dateStr);
    }
    
    
    
    if(_tableViews.count>0)
        [_mainView bringSubviewToFront:[_tableViews objectAtIndex:page]];
    if(page == 0)
    {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
        
        [self resetDatas];
        
        [self loadAnniversaryDatas:nil andPerPage:nil];
        
        
        
       // dateStr = [[[self dateFormatterForLoadFromNet] stringFromDate:self.calendar.currentDateSelected] substringToIndex:10];
        anniversaryPage = 1;
        myTaskPage = 1;
        [self loadMyTaskDatas:nil andPerPage:nil andState:nil andDate:dateStr];

    }
    if(page == 1)
    {
        _cellCountGetTask = 1;
        
        [_getTaskData removeAllObjects];
        
        receiveTaskPage = 1;
        [self loadReceiveTaskDatas:nil andPerPage:nil andState:nil andDate:dateStr];
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    }
    if(page == 2)
    {
         _cellCountSendTask = 1;
         [_sendTaskData removeAllObjects];
        sendTaskPage = 1;
         [self loadSendTaskDatas:nil andPerPage:nil andState:nil andDate:dateStr];
         [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];

    }
}


- (void)transitionExampleForTask
{
    CGFloat newY = ZY_CALENDAR_NORMALMODE_HEIGHT+50+ZY_CALENDAR_MENU_HEIGHT;
    CGFloat newTableViewHeight ;
    
    if(self.calendar.calendarAppearance.isWeekMode){
        newY = 175;
        
    }
    newTableViewHeight = [[UIScreen mainScreen] bounds].size.height - newY -100;
    
    NSLog(@" newTableViewHeight =%lf",newTableViewHeight);
    
    [UIView animateWithDuration:.5
                     animations:^{
                         //  self.calendarContentViewHeight.constant = newHeight;
                         self.mainView.frame =CGRectMake(0, newY , self.view.frame.size.width, ([[UIScreen mainScreen] bounds].size.height));
                         
                         
                         _myTaskView.frame = CGRectMake(0, 80, self.view.frame.size.width, newTableViewHeight);
                         _getTaskView.frame = CGRectMake(0, 80, self.view.frame.size.width, newTableViewHeight);
                         _sendTaskView.frame = CGRectMake(0, 80, self.view.frame.size.width, newTableViewHeight);
                
                         [self.view layoutIfNeeded];
                         
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.mainView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                       //  [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.mainView.layer.opacity = 1;
                                          }];
                     }];
}


#pragma mark - Calendar setting
-(void) initCalendar
{
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld\n%@", (long)comps.year, monthText];
        };
    }
    self.calendar.calendarAppearance.isWeekMode = false;
    //日历
    _calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT+ZY_CALENDAR_MENU_HEIGHT, [[UIScreen mainScreen] bounds].size.width, ZY_CALENDAR_NORMALMODE_HEIGHT)];
    _calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, [[UIScreen mainScreen] bounds].size.width, ZY_CALENDAR_MENU_HEIGHT)];
    
    eventsByDate = [NSMutableDictionary new];//保存事件日期
    
    _calendarMenuView.backgroundColor = ZY_UIBASECOLOR;
    _calendarContentView.backgroundColor = ZY_UIBASECOLOR;
    
    //添加上下划动的手势
    UISwipeGestureRecognizer* recognizerSwipeUp;
    recognizerSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeModeTouch:)];
    
//    _calendarContentView.userInteractionEnabled = YES;
    // 不同的 Recognizer 有不同的实体变数
    // 例如 SwipeGesture 可以指定方向
    // 而 TapGesture 則可以指定次數
    recognizerSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [_calendarContentView addGestureRecognizer:recognizerSwipeUp];
    
    UISwipeGestureRecognizer* recognizerSwipeDown;
    recognizerSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeModeTouch:)];
    
        //    _calendarContentView.userInteractionEnabled = YES;
    // 不同的 Recognizer 有不同的实体变数
    // 例如 SwipeGesture 可以指定方向
    // 而 TapGesture 則可以指定次數
    recognizerSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [_calendarContentView addGestureRecognizer:recognizerSwipeDown];
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
   // [self createRandomEvents];
    
    [self.calendar reloadData];
}

- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

#pragma mark - Buttons callback

- (IBAction)todayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
    
}

- (IBAction)changeModeTouch:(id)sender
{
    BOOL mode;
    UISwipeGestureRecognizer* recognizerSwipe = (UISwipeGestureRecognizer*)sender;
    if(recognizerSwipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        mode = false;
    }
    else
        mode = true;
    if(mode == self.calendar.calendarAppearance.isWeekMode)
        return;
    
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
    [self transitionExampleForTask];
//    _taskPageSeg
}

- (IBAction)changeModeTouch
{
    
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
    [self transitionExampleForTask];
    //    _taskPageSeg
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    
    if(!eventsByDate[key]){
        eventsByDate[key] = [NSMutableArray new];
    }
    
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}


-(void)setCalendarEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    
    // Use the date as key for eventsByDate
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
  //  NSLog(@"randomDate: [%@]",key);
    
    if(!eventsByDate[key]){
        eventsByDate[key] = [NSMutableArray new];
    }

    [eventsByDate[key] addObject:date];

}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    NSArray *events = eventsByDate[key];
    
    NSLog(@"Date: %@ - %ld events", date, (unsigned long)[events count]);
    
    [_taskPageSeg setCurrentPage:_taskPageSeg.currentPage];
    
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = ZY_CALENDAR_NORMALMODE_HEIGHT;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = ZY_CALENDAR_WEEKMODE_HEIGHT;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                       //  self.calendarContentViewHeight.constant = newHeight;
                         self.calendarContentView.frame =CGRectMake(0, ZY_HEADVIEW_HEIGHT+ZY_CALENDAR_MENU_HEIGHT, self.view.frame.size.width, newHeight);
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (NSDateFormatter *)dateFormatterForLoadFromNet
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        NSLog(@"randomDate: [%@]",key);
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
}

#pragma mark - end of Calendar setting



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (tableView.tag) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    switch (tableView.tag) {
        case 0:
            return _cellCountMyTask;
            break;
        case 1:
            return _cellCountGetTask;
            break;
        case 2:
            return _cellCountSendTask;
            break;
        default:
            break;
    }
    
    return _cellCount;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TaskTableViewCell *cell = [[TaskTableViewCell alloc] init];
    
    if(tableView.tag == 0)
    {
        if (indexPath.row < _myAnniversaryData.count) {
            NSString *CellIdentifier = @"AnniversaryTaskCellIdentifier";
            AnniversaryTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnniversaryTaskCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            anniversaryPath *anniversaryValue = [_myAnniversaryData objectAtIndex:indexPath.row];
           // cell.mImage = anniversaryValue.mImage;
            NSLog(@"name = [%@]",anniversaryValue.title);
            cell.mName.text = anniversaryValue.title;
            
           
            cell.mDate.text = [anniversaryValue.date substringToIndex:10];
            NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,anniversaryValue.headImgSrc];
            NSLog(@"img url = [%@]",url);
            
            [cell.mImage  sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            
            return cell;
        }
        else if(indexPath.row == _cellCountMyTask - 1)
        {
            NSString *CellIdentifier = @"AnniversaryTaskCellIdentifier";
            AnniversaryTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnniversaryTaskCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            return cell;
        }
        else
        {
            TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            
            if(_myTaskData.count ==0||_myTaskData == nil)
            {
                return cell;
            }
            
            if (indexPath.row == _cellCountMyTask - 1) {
                return cell;
            }
            if(indexPath.row - _myAnniversaryData.count > _myTaskData.count - 1)
                return cell;
            @try {
                TaskPath *taskValue = [_myTaskData objectAtIndex:(indexPath.row - _myAnniversaryData.count )];
                
                [cell setDispInfo:taskValue];
                [cell setTaskType:ZY_TASKTYPE_MINE];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
                if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
                {
                    [cell setSeparatorInset:UIEdgeInsetsZero];
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
                
                return cell;

            }
        }
    }
    else if(tableView.tag == 1)
    {
        TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        
        if(_getTaskData.count ==0||_getTaskData == nil)
        {
            return cell;
        }
        if(indexPath.row >_getTaskData.count - 1)
            return cell;
        
    
        @try {
            TaskPath *taskValue = [_getTaskData objectAtIndex:(indexPath.row)];
            
            NSLog(@"indexPath name = [%@]",taskValue.taskName);
            
            
            [cell setDispInfo:taskValue];
            [cell setTaskType:ZY_TASKTYPE_GET];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            NSLog(@"run here [%d]----------",__LINE__);
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
        }
        
       
    }
    else if(tableView.tag == 2)
    {
        TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        NSLog(@"_cellCountSendTask = %ld",(long)_cellCountSendTask);
        NSLog(@"indexPath.row= %ld",(long)indexPath.row);

        if(_sendTaskData.count ==0||_sendTaskData == nil)
        {
            return cell;
        }
        if(indexPath.row == _cellCountSendTask -1 || indexPath.row > _sendTaskData.count)
            return cell;
        
        @try {
            TaskPath *taskValue = [_sendTaskData objectAtIndex:(indexPath.row)];
            
            NSLog(@"indexPath name = [%@]",taskValue.taskName);
            [cell setDispInfo:taskValue];
            [cell setTaskType:ZY_TASKTYPE_SEND];
        }
        @catch (NSException *exception) {
            

        }
        @finally {
            NSLog(@"run here [%d]----------",__LINE__);
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
        }
        
        
       
    }
    return cell;

}


//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 0:
            if(indexPath.row == (_cellCountMyTask - 1))
                return 1;
            else
                return 50;
            break;
        case 1:
            if(indexPath.row == (_cellCountGetTask - 1))
                return 1;
            else
                return 60;

            break;
        case 2:
            if(indexPath.row == (_cellCountSendTask - 1))
                return 1;
            else
                return 50;

            break;
            
        default:
            break;
    }
    if(indexPath.row == (_cellCount - 1))
        return 1;
    else
        return 50;

    
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
        taskDetailPath.sId = _sID;
      //  [self setTaskDetails];

        
        TaskDetailPageViewController *_taskDetailPageCtl;
        
        _taskDetailPageCtl = [[TaskDetailPageViewController alloc] init];
        _taskDetailPageCtl.delegate = self;
        _taskDetailPageCtl.taskDetailMode = _taskDetailMode;
        _taskDetailPageCtl.navTitle = taskDetailPath.taskName;
        
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
        NSLog(@"img1 = [%@]",[taskDetailDict objectForKey:@"imgsrc1"]);
        NSLog(@"img2 = [%@]",[taskDetailDict objectForKey:@"imgsrc2"]);
        NSLog(@"img3 = [%@]",[taskDetailDict objectForKey:@"imgsrc3"]);
        
        NSLog(@"taskDetailPath.imgSrc count = %ld",taskDetailPath.imgSrc.count);
        
        
        if(![[taskDetailDict objectForKey:@"taskerlist"] isEqual:[NSNull null]])
        {
            taskDetailPath.taskPerformerDetails = [taskDetailDict objectForKey:@"taskerlist"];
        }
        else
        {
            NSLog(@"taskerlist = NULL");
           // return;
        }
        
       // taskDetailPath.taskPerformerDetails =[taskDetailDict objectForKey:@"id"];
        
        
        [_taskDetailPageCtl setDictData:taskDetailDict];
        [_taskDetailPageCtl setDatas:taskDetailPath];
        _taskDetailPageCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:_taskDetailPageCtl animated:NO];
    }
    @catch (NSException *exception) {
        [SVProgressHUD dismiss];
    }
    @finally {
        
    }
    [SVProgressHUD dismiss];

}


-(TaskPath *)setTaskDetails
{
    TaskPath *tempPath = [[TaskPath alloc] init];
    

    return tempPath;
}

#pragma mark - 获取纪念日详情

-(void)loadAnniversaryDetails:(NSString *)anniversaryID
{
    NSLog(@"load Anniversary Details");
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"AnniversaryDetailCallBack:"];
    
    [dataprovider getAnniversaryInfo:anniversaryID];
}


-(void)AnniversaryDetailCallBack:(id)dict
{
    
    NSInteger code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    NSDictionary *taskDetailDict;
    [SVProgressHUD dismiss];
    
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
    
    
    NSLog(@"taskDetailDict = %@",taskDetailDict);

    
    anniversaryDetailPath.title = [taskDetailDict objectForKey:@"title"];
    anniversaryDetailPath.content = [taskDetailDict objectForKey:@"content"];
    anniversaryDetailPath.date =[taskDetailDict objectForKey:@"mdate"];
    
    
    if(anniversaryDetailPath.imgSrc.count > 0)
    {
        [anniversaryDetailPath.imgSrc removeAllObjects];
    }
    if((![[taskDetailDict objectForKey:@"imgsrc"] isEqual:[NSNull null]]))
    {
        if(![[taskDetailDict objectForKey:@"imgsrc"] isEqualToString:@""])//头像
        {
            anniversaryDetailPath.headImgSrc = [taskDetailDict objectForKey:@"imgsrc"];
        }
    }
    
    
    if((![[taskDetailDict objectForKey:@"imgsrc1"] isEqual:[NSNull null]]))
    {
        if(![[taskDetailDict objectForKey:@"imgsrc1"] isEqualToString:@""])
        {
            [anniversaryDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc1"]];
        }
    }
    if((![[taskDetailDict objectForKey:@"imgsrc2"] isEqual:[NSNull null]]))
    {
        if(![[taskDetailDict objectForKey:@"imgsrc2"] isEqualToString:@""])
        {
            [anniversaryDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc2"]];
        }
    }
    if((![[taskDetailDict objectForKey:@"imgsrc3"] isEqual:[NSNull null]]))
    {
        if(![[taskDetailDict objectForKey:@"imgsrc3"] isEqualToString:@""])
        {
            [anniversaryDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc3"]];
        }
    }
    NSLog(@"img = [%@]",[taskDetailDict objectForKey:@"imgsrc"]);
    NSLog(@"img1 = [%@]",[taskDetailDict objectForKey:@"imgsrc1"]);
    NSLog(@"img2 = [%@]",[taskDetailDict objectForKey:@"imgsrc2"]);
    NSLog(@"img3 = [%@]",[taskDetailDict objectForKey:@"imgsrc3"]);
    

    AnniversaryTaskDetailView* _anniversaryTaskDetailCtl = [[AnniversaryTaskDetailView alloc] init];
    
    [_anniversaryTaskDetailCtl setDatas:anniversaryDetailPath];
    _anniversaryTaskDetailCtl.navTitle = @"纪念日详情";
    _anniversaryTaskDetailCtl.hidesBottomBarWhenPushed = YES;
    _anniversaryTaskDetailCtl.pageChangeMode = Mode_nav;
    [self.navigationController pushViewController:_anniversaryTaskDetailCtl animated:NO];
 
    
    
}


-(TaskPath *)setAnniversaryDetails
{
    TaskPath *tempPath = [[TaskPath alloc] init];
    
    
    return tempPath;
}

#pragma mark - -


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (tableView.tag == 0) {
        if (indexPath.row < _myAnniversaryData.count) {
//            if (_anniversaryTaskDetailCtl == nil) {
//                _anniversaryTaskDetailCtl = [[AnniversaryTaskDetailView alloc] init];
//            }
            
            
            anniversaryPath *tempPath;
            tempPath = [_myAnniversaryData objectAtIndex:indexPath.row];
            
            [self loadAnniversaryDetails:tempPath.anniversaryID];
            
           
        }else{
            TaskPath *tempPath;
            tempPath = [_myTaskData objectAtIndex:indexPath.row-_myAnniversaryData.count];
            _sID = tempPath.sId;
            _taskDetailMode = TaskDetail_MyMode;
            [self loadTaskDetails:tempPath.taskID];
            
        }
    }else if(tableView.tag == 1){
        TaskPath *tempPath;
        tempPath = [_getTaskData objectAtIndex:indexPath.row];
        
        _sID = tempPath.sId;
       // NSLog(@"task ID" = );
        _taskDetailMode = TaskDetail_ReceiveMode;
        [self loadTaskDetails:tempPath.taskID];
    }
    else if(tableView.tag == 2){
        TaskPath *tempPath;
        tempPath = [_sendTaskData objectAtIndex:indexPath.row];
        _sID = tempPath.sId;
        // NSLog(@"task ID" = );
        _taskDetailMode = TaskDetail_SendMode;
        [self loadTaskDetails:tempPath.taskID];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
}

//设置划动cell是否出现del按钮，可供删除数据里进行处理
#if 1
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

#pragma  mark - 删除任务

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *numberRowOfCellArray = [NSMutableArray array] ;
    [numberRowOfCellArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
    
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"删除" message:[NSString stringWithFormat:@"是否删除?"]];
    
    alert.alertType = AlertType_Alert;
    [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item){
        NSLog(@"Click ok");
        
        if (tableView.tag == 0) {
            if (indexPath.row < _myAnniversaryData.count) {
                
                anniversaryPath *tempPath;
                tempPath = [_myAnniversaryData objectAtIndex:indexPath.row];

                [self delAnniversary:tempPath.anniversaryID];
                
                
            }else{
                TaskPath *tempPath;
                tempPath = [_myTaskData objectAtIndex:indexPath.row-_myAnniversaryData.count];
                [self delTask:tempPath.taskID];
                
            }
        }else if(tableView.tag == 1){
            TaskPath *tempPath;
            tempPath = [_getTaskData objectAtIndex:indexPath.row];
            
            [self delTask:tempPath.taskID];
        }
        else if(tableView.tag == 2){
            TaskPath *tempPath;
            tempPath = [_sendTaskData objectAtIndex:indexPath.row];
            
            [self delTask:tempPath.taskID];
        }
        
        
    }];
    
//    typedef void(^JKAlertDialogHandler)(JKAlertDialogItem *item);
    [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item){
        NSLog(@"Click canel");
    
    }];
    [alert show];
    
    
  //  [_taskPageSeg setCurrentPage:_taskPageSeg.currentPage];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



#endif

-(void)delTask:(NSString *)taskID
{
    
    NSLog(@"del task datas");
    
    [SVProgressHUD showWithStatus:@"删除中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"delTaskCallBack:"];
    
    [dataprovider delTask:taskID];
}

-(void)delAnniversary:(NSString *)anniversaryID
{
    
    NSLog(@"del anniversary datas");
    
    [SVProgressHUD showWithStatus:@"删除中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"delTaskCallBack:"/*可和任务用相同的callback*/];
    
    [dataprovider delAnniversary:anniversaryID];
}




-(void)delTaskCallBack:(id)dict
{
   
    NSInteger code;
    [SVProgressHUD dismiss];
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"删除失败"]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        return;
    }
    
    [_taskPageSeg setCurrentPage:_taskPageSeg.currentPage];//刷新数据
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];

    
    if(section == 0)
    {
        tempView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 400);
        
        tempView.contentMode = UIViewContentModeCenter;
        tempView.backgroundColor = ZY_UIBASECOLOR;
    }
    
    return tempView;
}

//设置section的footer view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    if(section == 0)
    {
        tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        tempView.backgroundColor =[UIColor whiteColor];//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
        
    }
    return tempView;
    
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (tableView.tag) {
        case 0:
            return 0;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 0;
            break;
        default:
            break;
    }
    
    return 0;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    switch (tableView.tag) {
        case 0:
            return 50;
            break;
        case 1:
            return 60;
            break;
        case 2:
            return 50;
            break;
        default:
            break;
    }
    
    return 50;
    
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
