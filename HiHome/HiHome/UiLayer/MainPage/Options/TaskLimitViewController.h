//
//  TaskLimitViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "SelectContacterViewController.h"
#import "DataProvider.h"
#import "SVProgressHUD.h"
#import "JKAlertDialog.h"
@interface TaskLimitViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,SelectContacterViewControllerDelegate>
{
@private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    UITableView *_mainTableView;
    NSMutableArray *_cellInfo;
}
@end
