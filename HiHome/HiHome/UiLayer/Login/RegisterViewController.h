//
//  RegisterViewController.h
//  HiHome
//
//  Created by 于金祥 on 15/10/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface RegisterViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
