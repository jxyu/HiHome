//
//  AlbumShowViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/30.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "UIImageView+WebCache.h"
#import "UploadPicViewController.h"
#import "SVProgressHUD.h"
#import "PictureShowView.h"

@interface AlbumShowViewController : BackPageViewController<PictureShowViewDelegate>

@property (nonatomic) NSMutableArray *picArr;
@property (nonatomic)NSString *aid;
@property (nonatomic)NSString *albumUserId;
@end
