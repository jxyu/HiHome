//
//  UserInfoViewController.h
//  HiHome
//
//  Created by 于金祥 on 15/10/22.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface UserInfoViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableview;

@property(strong,nonatomic) NSString *mIFlag;
@property(strong,nonatomic) NSString *mName;
@property(strong,nonatomic) NSString *mSex;
@property(strong,nonatomic) NSString *mBirthday;
@property(strong,nonatomic) NSString *mSign;

@end
