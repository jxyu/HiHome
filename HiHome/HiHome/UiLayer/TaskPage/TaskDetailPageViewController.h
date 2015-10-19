//
//  TaskDetailPageViewController.h
//  HiHome
//
//  Created by Rain on 15/10/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackPageViewController.h"

#define ZY_PICPICK_BTN_TAG      1
#define ZY_TAKEPIC_BTN_TAG      2
#define ZY_REMIND_BTN_TAG       3
#define ZY_REPEAT_BTN_TAG       4
#define ZY_PLACE_BTN_TAG        5

@interface TaskDetailPageViewController : BackPageViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end
