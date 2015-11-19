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
#import "CreateAlbumViewController.h"
#import "AlbumShowViewController.h"
@interface AlbumMainViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,SegmentedPageViewDelegate,PullDownButtonsTabDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UploadPicViewControllerDelegate>
{
@private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    NSInteger _reCentCellHeight;
    UITableView *_mainTableView;
    NSMutableArray *_cellInfo;
    SegmentedPageView *_taskPageSeg;
    
    NSMutableArray *_tableViews;
    
    UITableView *_albumView;
    UITableView *_recentPicView;
    
    NSInteger _cellCountRecentPic;
    NSInteger _cellCountAlbum;
    
    BOOL _pullDownBtnsTabFlag;
    PullDownButtonsTab *_pullDownBtnTab;
    
    /*上传照片*/
   // UploadPicViewController *_uploadPicViewCtl;
//重新构建最近图片列表
    NSMutableDictionary *reSetResentDict;
    NSMutableArray *dateStrArr;
    NSMutableArray *arrForCellDisp;
    
}
@property(nonatomic)NSString *albumUserId;
@end
