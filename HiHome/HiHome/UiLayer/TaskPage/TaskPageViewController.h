//
//  TaskPageViewController.h
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "CreateTaskViewController.h"
#import "SegmentedPageView.h"
#import "CreateAnniversaryViewController.h"
#import "AnniversaryTaskDetailView.h"
#import "TaskDetailPageViewController.h"

#define ZY_CALENDAR_MENU_HEIGHT    50

#define ZY_CALENDAR_NORMALMODE_HEIGHT  (([[UIScreen mainScreen] bounds].size.height-100)/100*50)
#define ZY_CALENDAR_WEEKMODE_HEIGHT  75


#define ADD_ANNIVERSARY_BTNTAG  (ZY_UIBUTTON_TAG_BASE+1)//创建纪念日
#define ADD_TASK_BTNTAG (ZY_UIBUTTON_TAG_BASE+2)//创建任务

@interface TaskPageViewController : UIViewController<JTCalendarDataSource,UITableViewDelegate,UITableViewDataSource,SegmentedPageViewDelegate,TaskDetailDelegate,CreateTaskViewControllerDelegate>
{
    @private
    NSInteger _cellCount;
    NSInteger _cellCountMyTask;
    NSInteger _cellCountGetTask;
    NSInteger _cellCountSendTask;
    
    SegmentedPageView *_taskPageSeg ;
    NSMutableArray *_tableViews;
    
    UITableView *_getTaskView;
    UITableView *_sendTaskView;
    UITableView *_myTaskView;
    
    //数据
    //自己的任务
    NSMutableArray *_myAnniversaryData;
    NSMutableArray *_myTaskData;
    //接受的任务
    NSMutableArray *_getTaskData;
    //发布的任务
    NSMutableArray *_sendTaskData;
    //任务日历
    NSMutableArray *_taskCalenderData;
    
    /*task分页面*/
    
    
    
    
    //纪念日详情页面
 //   AnniversaryTaskDetailView *_anniversaryTaskDetailCtl;
    //任务详情
 //   TaskDetailPageViewController *_taskDetailPageCtl;
}

-(void) initViews;
-(void) initCalendar;
//@property(strong,nonatomic) UITableView *mainTableView;
//@property(strong,nonatomic) UIScrollView *mainScrollView;
@property(strong,nonatomic) UIView *mainView;
//for calendar
@property (strong, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (strong, nonatomic) JTCalendar *calendar;
@end
