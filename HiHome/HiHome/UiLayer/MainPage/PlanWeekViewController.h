//
//  PlanWeekViewController.h
//  HiHome
//
//  Created by 王建成 on 15/11/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "SegmentedPageView.h"
#import "SVProgressHUD.h"
#import "TaskDetailPageViewController.h"
@interface PlanWeekViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,SegmentedPageViewDelegate>
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

@end
