//
//  OptionsViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "OptionsUnit.h"

//[(NSArray *)[(NSArray *)[_cellInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1]


@interface OptionsViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
@private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    UITableView *_mainTableView;
    NSMutableArray *_cellInfo;
#pragma mark -  分页面
    TaskLimitViewController *_taskLimitViewCtl ;
     //   TextViewController *_taskLimitViewCtl;
    MessageNoticeViewController *_messageNoticeViewCtl;
    SoundSetViewController *_soundsetViewCtl;
    ChatLogViewController *_chatLogViewCtl;
    HelpAndFeedbackViewController *_helpAndFeedBackViewCtl;
}
@end
