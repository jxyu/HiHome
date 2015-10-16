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


@interface TaskPageViewController ()
{
    
    NSMutableDictionary *eventsByDate;
}
@end

@implementation TaskPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCalendar];//初始化日历
    // Do any additional setup after loading the view from its nib.
}

-(void) initViews
{//[[UIScreen mainScreen] bounds].size.height-ZY_CALENDAR_NORMALMODE_HEIGHT,
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,ZY_CALENDAR_NORMALMODE_HEIGHT+ZY_HEADVIEW_HEIGHT+ZY_CALENDAR_MENU_HEIGHT, [[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.height))];
    _mainView.backgroundColor = ZY_UIBASECOLOR;
    
    [self.view addSubview:_mainView];
    [self initTaskPage];
    [self.view addSubview:_calendarContentView];
    [self.view addSubview:_calendarMenuView];
    [self.view addSubview:[self headerViewForTaskPage]];
    

    _cellCount = 3;
    
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
    
    _cellCountMyTask = 3;
    _cellCountGetTask =4;
    _cellCountSendTask = 15;
    
    _myTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - ZY_CALENDAR_NORMALMODE_HEIGHT-ZY_CALENDAR_MENU_HEIGHT-80-50)];
    [self setPageIndexPath:_myTaskView indexPage:0];
    
    _getTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - ZY_CALENDAR_NORMALMODE_HEIGHT-ZY_CALENDAR_MENU_HEIGHT-80-50)];
    [self setPageIndexPath:_getTaskView indexPage:1];
    
    
    _sendTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - ZY_CALENDAR_NORMALMODE_HEIGHT-ZY_CALENDAR_MENU_HEIGHT-80-50)];
    [self setPageIndexPath:_sendTaskView indexPage:2];

    _myTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountSendTask*50);
    _getTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountSendTask*50);
    _sendTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountSendTask*50);
    
    
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
            
            
            if(_createAnniversaryViewCtl == nil)
            {
                _createAnniversaryViewCtl = [[CreateAnniversaryViewController alloc] init];
            }
            //_createAnniversaryViewCtl.navTitle = @"创建纪念日";
            _createAnniversaryViewCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_createAnniversaryViewCtl animated:NO];
            break;
        case ADD_TASK_BTNTAG:
        {
            NSString *str = @"创建任务";
            if(_createTaskViewCtl == nil)
            {
                _createTaskViewCtl = [[CreateTaskViewController alloc] init];

            }
            _createTaskViewCtl.navTitle = str;
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


-(void)setPageIndex:(NSInteger)page
{
    NSLog(@"Page = %ld",page);
    if(_tableViews.count>0)
        [_mainView bringSubviewToFront:[_tableViews objectAtIndex:page]];
}


- (void)transitionExampleForTask
{
    CGFloat newY = ZY_CALENDAR_NORMALMODE_HEIGHT+50+ZY_CALENDAR_MENU_HEIGHT;
    CGFloat newTableViewHeight ;
    
    if(self.calendar.calendarAppearance.isWeekMode){
        newY = 175;
        
    }
    newTableViewHeight = [[UIScreen mainScreen] bounds].size.height - newY -80;
    
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
            
            return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText];
        };
    }
    self.calendar.calendarAppearance.isWeekMode = false;
    //日历
    _calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT+ZY_CALENDAR_MENU_HEIGHT, [[UIScreen mainScreen] bounds].size.width, ZY_CALENDAR_NORMALMODE_HEIGHT)];
    _calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, [[UIScreen mainScreen] bounds].size.width, ZY_CALENDAR_MENU_HEIGHT)];
    

    
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
    
    [self createRandomEvents];
    
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
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    NSArray *events = eventsByDate[key];
    
    NSLog(@"Date: %@ - %ld events", date, [events count]);
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
                         self.calendarContentView.frame =CGRectMake(0, 50+50, self.view.frame.size.width, newHeight);
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

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
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
    
    TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    NSLog(@"self.view.frame.size.width = %lf",self.view.frame.size.width);
    
    if(tableView.tag == 1)
    {
        TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        
        TaskPath *taskPath = [[TaskPath alloc] init];
        
        taskPath.taskName = @"去超市买油条";
        taskPath.taskOwner = @"铁蛋";
        NSArray *performers = @[@"自己"];
        taskPath.taskPerformers = performers;
        taskPath.taskContent =@"去超市买根油条";
        taskPath.taskStatus = ZY_TASkSTATUE_RESERVE;
        taskPath.taskType = ZY_TASKTYPE_MINE;
        taskPath.remindTime = ZY_TASkREMIND_RESERVE;
        taskPath.repeatMode = ZY_TASkREPEAT_RESERVE;
        
        NSDate* now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
        
        NSDateComponents *startTaskDate;
        NSDateComponents *endTaskDate;
        @try {
            startTaskDate= [cal components:unitFlags fromDate:now];
            endTaskDate= [cal components:unitFlags fromDate:now];
        }
        
        @catch (NSException *exception) {
            return cell;
        }
        @finally {
        }
        
        taskPath.startTaskDate =startTaskDate;
        endTaskDate.day ++;
        taskPath.endTaskDate = endTaskDate;
        
        [cell setDispInfo:taskPath];
        [cell setTaskType:ZY_TASKTYPE_GET];
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
         return cell;
    }
    else if(tableView.tag == 0)
    {
        TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        TaskPath *taskPath = [[TaskPath alloc] init];
        
        taskPath.taskName = @"去超市买黄瓜";
        taskPath.taskOwner = @"自己";
        NSArray *performers = @[@"自己"];
        taskPath.taskPerformers = performers;
        taskPath.taskContent =@"去超市买根黄瓜";
        taskPath.taskStatus = ZY_TASkSTATUE_RESERVE;
        taskPath.taskType = ZY_TASKTYPE_MINE;
        taskPath.remindTime = ZY_TASkREMIND_RESERVE;
        taskPath.repeatMode = ZY_TASkREPEAT_RESERVE;
        
        NSDate* now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
        
        NSDateComponents *startTaskDate;
        NSDateComponents *endTaskDate;
        @try {
            startTaskDate= [cal components:unitFlags fromDate:now];
            endTaskDate= [cal components:unitFlags fromDate:now];
            }
        
        @catch (NSException *exception) {
            return cell;
        }
        @finally {
        }
        
        taskPath.startTaskDate =startTaskDate;
        endTaskDate.day ++;
        taskPath.endTaskDate = endTaskDate;
        
        [cell setDispInfo:taskPath];
        [cell setTaskType:ZY_TASKTYPE_MINE];
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
         return cell;
    }
    else if(tableView.tag == 2)
    {
        TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        
        TaskPath *taskPath = [[TaskPath alloc] init];
        
        taskPath.taskName = @"去超市买煎饼";
        taskPath.taskOwner = @"自己";
        NSArray *performers = @[@"二丫",@"铁蛋"];
        taskPath.taskPerformers = performers;
        taskPath.taskContent =@"去超市买斤煎饼";
        taskPath.taskStatus = ZY_TASkSTATUE_RESERVE;
        taskPath.taskType = ZY_TASKTYPE_MINE;
        taskPath.remindTime = ZY_TASkREMIND_RESERVE;
        taskPath.repeatMode = ZY_TASkREPEAT_RESERVE;
        
        NSDate* now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
        
        NSDateComponents *startTaskDate;
        NSDateComponents *endTaskDate;
        @try {
            startTaskDate= [cal components:unitFlags fromDate:now];
            endTaskDate= [cal components:unitFlags fromDate:now];
        }
        
        @catch (NSException *exception) {
            return cell;
        }
        @finally {
        }
        
        taskPath.startTaskDate =startTaskDate;
        endTaskDate.day ++;
        taskPath.endTaskDate = endTaskDate;
        
        [cell setDispInfo:taskPath];
        
        [cell setTaskType:ZY_TASKTYPE_SEND];
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
         return cell;
    }
    //分割线设置
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *numberRowOfCellArray = [NSMutableArray array] ;
    [numberRowOfCellArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",indexPath.section,indexPath.row);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
#endif



-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    
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
