//
//  PersonSecondViewController.h
//  HiHome
//
//  Created by Rain on 15/11/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackPageViewController.h"

@interface PersonSecondViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property(strong,nonatomic) NSString *mIFlag;
@property(strong,nonatomic) NSString *mHeadImg;
@property(strong,nonatomic) NSString *mName;
@property(strong,nonatomic) NSString *mSex;
@property(strong,nonatomic) NSString *mBirthday;
@property(strong,nonatomic) NSString *mSign;

@end
