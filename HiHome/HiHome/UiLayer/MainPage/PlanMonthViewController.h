//
//  PlanMonthViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "SegmentedPageView.h"
#import "SVProgressHUD.h"
#import "TaskDetailPageViewController.h"

typedef enum _showTaskMode
{
    Mode_month = 0,
    Mode_today
}ShowTaskMode;

@interface PlanMonthViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,SegmentedPageViewDelegate>
{
    @private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    SegmentedPageView *_taskPageSeg;
    
    NSMutableArray *_tableViews;
    
    UITableView *_getTaskView;
    UITableView *_myTaskView;
    
    NSInteger _cellCountMyTask;
    NSInteger _cellCountGetTask;
}
@property(nonatomic) NSString *friendUserId;
@property(nonatomic) ShowTaskMode showTaskMode;
@end
