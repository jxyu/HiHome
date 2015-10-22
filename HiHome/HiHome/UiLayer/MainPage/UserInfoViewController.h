//
//  UserInfoViewController.h
//  HiHome
//
//  Created by 于金祥 on 15/10/22.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface UserInfoViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableview;

@end
