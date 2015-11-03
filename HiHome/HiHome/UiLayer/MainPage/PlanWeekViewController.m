//
//  PlanWeekViewController.m
//  HiHome
//
//  Created by 王建成 on 15/11/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PlanWeekViewController.h"
#import "BaseTableViewCell.h"
#import "UIDefine.h"
#import "TaskTableViewCell.h"
#import "JKAlertDialog.h"
#import "DataProvider.h"
@interface PlanWeekViewController ()
{
    NSDictionary *_taskDict;
    NSDictionary *_receiveTaskDict;
    NSMutableArray *_myTaskData;
    //接受的任务
    NSMutableArray *_getTaskData;
    
    NSString *_startTime;
    NSString *_endTime;
    
    NSInteger _year;
    NSInteger _month;
    NSInteger _day;
    
    NSInteger myTaskPage;
    NSInteger receiveTaskPage;
    
    NSString *_sID;
    TaskDetailMode _taskDetailMode;
}
@end

@implementation PlanWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getMonthTime];
    
    _cellHeight = self.view.frame.size.height/11;
    _myTaskData = [[NSMutableArray alloc] init];
    _getTaskData = [[NSMutableArray alloc] init];
    [self initViews];
    [self initTaskPage];
    
    
    // self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}
-(NSString *)getUserID
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID
    
    return  userID;
}



#pragma  mark - 我的任务
-(void) loadMyTaskDatas:(NSString *)nowPage andPerPage:(NSString *)perPage andState:(NSString*)state andDate:(NSString *)date andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate
{
    
    NSLog(@"load task datas");
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getTaskCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    [dataprovider getReceiveTask:userID andState:state andMyOrNot:@"1" andPage:nowPage andPerPage:perPage andDate:date andStartDate:startDate andEndDate:endDate];
}




-(void)getTaskCallBack:(id)dict
{
    [SVProgressHUD dismiss];
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
            [self loadMyTaskDatas:[NSString stringWithFormat:@"%ld",myTaskPage] andPerPage:nil andState:nil andDate:nil andStartDate:_startTime andEndDate:_endTime];
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


-(void) loadReceiveTaskDatas:(NSString *)nowPage andPerPage:(NSString *)perPage andState:(NSString *)state andDate:(NSString *)date andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate
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
    [dataprovider getReceiveTask:userID andState:state andMyOrNot:nil andPage:nowPage andPerPage:perPage andDate:date andStartDate:startDate andEndDate:endDate];
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
            [self loadReceiveTaskDatas:[NSString stringWithFormat:@"%ld",receiveTaskPage] andPerPage:nil andState:nil andDate:nil andStartDate:_startTime andEndDate:_endTime];
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
        //  [self.navigationController pushViewController:_taskDetailPageCtl animated:NO];
        _taskDetailPageCtl.pageChangeMode = Mode_dis;
        [self presentViewController:_taskDetailPageCtl animated:YES completion:^{}];
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


-(void)handleGesture:(id)sender
{
    NSLog(@"Hi hi hi");
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) initViews
{
    //    _mainTableView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,60+ [[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.height))];
    //    _mainTableView.backgroundColor = ZY_UIBASECOLOR;
    //
    //    [self.view addSubview:_mainTableView];
}


#pragma mark -  set task page
-(void) initTaskPage
{
    
    //_taskPageSeg 分页器  _tableViews存储所有页面
    _taskPageSeg = [[SegmentedPageView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, [[UIScreen mainScreen]bounds].size.width, 60)];
    _taskPageSeg.segType = SegTypeTitleOnly;//要在numOfPages之前设置
    _taskPageSeg.numOfPages = 2;
    _taskPageSeg.backgroundColor = [UIColor whiteColor];
    _taskPageSeg.titleFont = [UIFont boldSystemFontOfSize:20];
    
    NSArray *title = @[@"自己的任务",@"接受的任务"];
    _taskPageSeg.delegate = self;
    [_taskPageSeg setItemTitle:title];
    
    
    _cellCount = 1;
    _cellCountMyTask = 0;
    _cellCountGetTask = 0;
    
    _myTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT + 60, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -60-ZY_HEADVIEW_HEIGHT)];
    [self setPageIndexPath:_myTaskView indexPage:0];
    
    _getTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT + 60, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -60-ZY_HEADVIEW_HEIGHT)];
    [self setPageIndexPath:_getTaskView indexPage:1];
    
    
    _myTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountMyTask*50);
    _getTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountGetTask*50);
    
    _tableViews = [NSMutableArray array];
    [_tableViews addObject:_myTaskView];
    [_tableViews addObject:_getTaskView];
    
    
    
    [_taskPageSeg setItemTitle:title];
    
    [self.view  addSubview:_taskPageSeg];
    [self.view  addSubview:_myTaskView];
    [self.view  addSubview:_getTaskView];
    
    
    [_taskPageSeg setCurrentPage:0];//页面都设置完成后再调用
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [_taskPageSeg setCurrentPage:_taskPageSeg.currentPage];
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

-(NSString *)getMonthTime
{
    NSString *monthTime;
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth  |NSCalendarUnitDay;
    
    @try {
        NSDateComponents *dd = [cal components:unitFlags fromDate:now];
        _month = [dd month];
        _year = [dd year];
        _day = [dd day];
        
        monthTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld",_year,_month,_day];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return monthTime;
    }
    
    
}

-(NSString *)timeIntervalToDate:(NSTimeInterval)sec
{
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sec];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *dateString = [formatter stringFromDate:date];
    
  //  str = [NSString stringWithFormat:@"%@-%@-%@  %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)]/*年*/,[dateString substringWithRange:NSMakeRange(4, 2)]/*月*/,[dateString substringWithRange:NSMakeRange(6, 2)]/*日*/,[dateString substringWithRange:NSMakeRange(8, 2)]/*时*/,[dateString substringWithRange:NSMakeRange(10, 2)]/*分*/];
    
    str = [NSString stringWithFormat:@"%@-%@-%@",[dateString substringWithRange:NSMakeRange(0, 4)]/*年*/,[dateString substringWithRange:NSMakeRange(4, 2)]/*月*/,[dateString substringWithRange:NSMakeRange(6, 2)]/*日*/];
    
    return str;
}


-(void)setPageIndex:(NSInteger)page
{
    [self getMonthTime];
    NSDate *tempDate = [NSDate date];
    NSTimeInterval temp;
    
    
    temp = [tempDate timeIntervalSince1970];
    
    
    
    _startTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld",_year,_month,_day];
    _endTime = [self timeIntervalToDate:(temp+7*24*60*60)];
    
    NSLog(@"_endTime = %ld",(long)_endTime);
    if(_tableViews.count>0)
        [self.view bringSubviewToFront:[_tableViews objectAtIndex:page]];
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    if(page == 0)
    {
        // [self resetDatas];
        myTaskPage = 1;
        _cellCountMyTask = 0;
        [_myTaskData removeAllObjects];
        [self loadMyTaskDatas:nil andPerPage:nil andState:nil andDate:nil andStartDate:_startTime andEndDate:_endTime];
    }
    if(page == 1)
    {
        receiveTaskPage = 1;
        _cellCountGetTask = 0;
        [_getTaskData removeAllObjects];
        
        [self loadReceiveTaskDatas:nil andPerPage:nil andState:nil andDate:nil andStartDate:_startTime andEndDate:_endTime];
        
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
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
        default:
            break;
    }
    
    return _cellCount;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TaskTableViewCell *cell;
    
    if(tableView.tag == 1)
    {
        TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        
        if(_getTaskData.count ==0||_getTaskData == nil)
        {
            return cell;
        }
        
        @try {
            TaskPath *taskValue = [_getTaskData objectAtIndex:(indexPath.row)];
            
            NSLog(@"indexPath name = [%@]",taskValue.taskName);
            
            
            [cell setDispInfo:taskValue];
            [cell setTaskType:ZY_TASKTYPE_GET];
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
    else if(tableView.tag == 0)
    {
        TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        
        if(_myTaskData.count ==0||_myTaskData == nil)
        {
            return cell;
        }
        
        if(indexPath.row  > _myTaskData.count - 1)
            return cell;
        @try {
            TaskPath *taskValue = [_myTaskData objectAtIndex:(indexPath.row )];
            
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
    else
    {
        cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    }
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}

-(void)setOptionCell:(BaseTableViewCell *)cell andTitleLabels:(NSString *)title
{
    NSMutableArray *Labels = [NSMutableArray array];
    
    if([title isEqualToString:@"nil"])
    {
        title = nil;
    }
    if(title != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame =CGRectMake(20, _cellHeight/3 , 150, _cellHeight/3);
        titleLabel.text =title;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        //     titleLabel.textColor = ZY_UIBASECOLOR;//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
        titleLabel.textColor = [UIColor grayColor];
        [Labels addObject:titleLabel];
    }
    
    
    if(cell != nil)
    {
        cell.contentLabels = Labels;
    }
}



//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 0:
            return _cellHeight;
        case 1:
            return 60;
        default:
            break;
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    if (tableView.tag == 0) {
        
        TaskPath *tempPath;
        tempPath = [_myTaskData objectAtIndex:indexPath.row];
        _sID = tempPath.sId;
        _taskDetailMode = TaskDetail_MyMode;
        [self loadTaskDetails:tempPath.taskID];
        
        
    }else if(tableView.tag == 1){
        TaskPath *tempPath;
        tempPath = [_getTaskData objectAtIndex:indexPath.row];
        
        _sID = tempPath.sId;
        _taskDetailMode = TaskDetail_ReceiveMode;
        [self loadTaskDetails:tempPath.taskID];
    }
    
    
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, 10, 100, 10));
}


//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *numberRowOfCellArray = [NSMutableArray array] ;
    [numberRowOfCellArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //        [_mainTableView.cell.infoItems removeObjectAtIndex:(indexPath.row*2)];
        //        [_mainTableView.cell.infoItems removeObjectAtIndex:(indexPath.row*2)];
        //        [_mainTableView beginUpdates];
        //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        //        [_mainTableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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
    tempView.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    if(tableView.tag == 0)
    {
        if(section == 0)
        {
            tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(10,0 , 150, 30);
            titleLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",_year,_month,_day];
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            titleLabel.textColor  = ZY_UIBASECOLOR;
            [tempView addSubview:titleLabel];
        }
    }
    else if(tableView.tag == 1)
    {
        if(section == 0)
        {
            tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(10,0 , 150, 30);
            titleLabel.text =[NSString stringWithFormat:@"%ld-%02ld-%02ld",_year,_month,_day];
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            titleLabel.textColor  = ZY_UIBASECOLOR;
            [tempView addSubview:titleLabel];
        }
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
        tempView.backgroundColor =[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    }
    return tempView;
    
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
    
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
