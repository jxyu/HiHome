//
//  UploadPicViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "ChooseAlbumViewController.h"
#import "DataProvider.h"
#import "SVProgressHUD.h"
#import "JKAlertDialog.h"
@protocol UploadPicViewControllerDelegate <NSObject>

-(void)selectUploadAlbum;

@end

@interface UploadPicViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChooseAlbumViewControllerDelegate>

{
@private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    NSInteger _cellTextViewHeight;//包含textview的cell的高度
    UITableView *_mainTableView;
    NSMutableArray *_cellInfo;

    UITextView *_textView;
    UITextField *_titleField;//标题

    
}

@property(nonatomic) id<UploadPicViewControllerDelegate> delegate;
@property(nonatomic)BOOL ChoosPicByCamera;
@property(nonatomic)NSString  *albumName;
@property(nonatomic)NSString  *aid;
@end
