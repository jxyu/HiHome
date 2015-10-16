//
//  AlbumMainViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "SegmentedPageView.h"
#import "PullDownButtonsTab.h"

#import "UploadPicViewController.h"

@interface AlbumMainViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,SegmentedPageViewDelegate,PullDownButtonsTabDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
@private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    NSInteger _reCentCellHeight;
    UITableView *_mainTableView;
    NSMutableArray *_cellInfo;
    SegmentedPageView *_taskPageSeg;
    
    NSMutableArray *_tableViews;
    
    UITableView *_getTaskView;
    UITableView *_myTaskView;
    
    NSInteger _cellCountMyTask;
    NSInteger _cellCountGetTask;
    
    BOOL _pullDownBtnsTabFlag;
    PullDownButtonsTab *_pullDownBtnTab;
    
    /*上传照片*/
    UploadPicViewController *_uploadPicViewCtl;
    
}
@end
