//
//  ChooseAlbumViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"

@protocol ChooseAlbumViewControllerDelegate <NSObject>

-(void)pickedAlbum:(NSDictionary*)dict;

@end

@interface ChooseAlbumViewController : BackPageViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic) id<ChooseAlbumViewControllerDelegate> delegate;

@property(strong,nonatomic) NSMutableArray *selectContacterArrayID;//已选择的联系人数组
@property(strong,nonatomic) NSMutableArray *selectContacterArrayName;//已选择的联系人数组
@property(nonatomic,readonly)NSMutableDictionary  *selectAlbumDict;
@property(nonatomic) NSString *defaultAlbumName;
@end
