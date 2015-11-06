//
//  PersonFirstViewController.h
//  HiHome
//
//  Created by Rain on 15/10/22.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackPageViewController.h"
#import "UIImageView+WebCache.h"
#import "AlbumMainViewController.h"
@interface PersonFirstViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) NSString *mIFlag;
@property(strong,nonatomic) NSString *mFriendID;
@property(strong,nonatomic) NSString *mHeadImg;
@property(strong,nonatomic) NSString *mName;
@property(strong,nonatomic) NSString *mSex;
@property(strong,nonatomic) NSString *mAge;
@property(strong,nonatomic) NSString *mSign;
@property(strong,nonatomic) NSString *mType;

@end
