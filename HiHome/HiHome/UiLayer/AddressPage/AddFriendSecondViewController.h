//
//  AddFriendSecondViewController.h
//  HiHome
//
//  Created by Rain on 15/10/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackPageViewController.h"

@interface AddFriendSecondViewController : BackPageViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UIImageView *mHeadImg;
    UILabel *mName;
    UILabel *mSex;
    int IFlag;
}

@property(nonatomic) NSString *mContacterID;
@property(nonatomic) NSString *mHeaderImgTxt;
@property(nonatomic) NSString *mNameTxt;
@property(nonatomic) NSString *mSexTxt;
@property(nonatomic) NSString *mIFlag;

@end
