//
//  PlanMonthViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "SegmentedPageView.h"

@interface PlanMonthViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,SegmentedPageViewDelegate>
{
    @private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    UITableView *_mainTableView;
    NSMutableArray *_cellInfo;
    SegmentedPageView *_taskPageSeg;
    
    NSMutableArray *_tableViews;
    
    UITableView *_getTaskView;
    UITableView *_myTaskView;
    
    NSInteger _cellCountMyTask;
    NSInteger _cellCountGetTask;
}
@end
