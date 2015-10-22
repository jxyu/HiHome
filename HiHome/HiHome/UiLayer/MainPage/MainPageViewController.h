//
//  MainPageViewController.h
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageNotice.h"
#import "TaskNoticeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"

#define ZY_MAINCELL0_HEIGHT     ((self.view.frame.size.height-100)/80.0*18)
#define ZY_MAINCELL1_HEIGHT     ((self.view.frame.size.height-100)/80.0*22)
#define ZY_MAINCELL2_HEIGHT     ((self.view.frame.size.height-100)/80.0*10)
#define ZY_MAINCELL3_HEIGHT     ((self.view.frame.size.height-100)/80.0*10)
#define ZY_MAINCELL4_HEIGHT     ((self.view.frame.size.height-100)/80.0*20)


typedef struct _ZY_time_t
{
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
}ZY_time_t;

typedef struct _ZY_date_t
{
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
}ZY_date_t;

@interface MainPageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    @private
    UILabel *_timeLabel;
    UILabel *_dateLabel;
    ZY_time_t *_time;
    ZY_date_t *_date;
    
    MessageNotice *_messageNoticeVC;
    TaskNoticeViewController *_taskNoticeVC;
}
-(void) initViews;

@property(strong,nonatomic) UITableView *mainTableView;
@end
