//
//  ViewController.h
//  QQSlideMenu
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"
#import "CustomTabBarViewController.h"
#import "MainSettings.h"
#import "PersonFirstViewController.h"

@interface ViewController : WMBaseViewController<UIGestureRecognizerDelegate,CustomTabBarViewControllerDelegate>
{
    @private
    BOOL swipFlag;
    OptionsViewController *_optionPage;
    AnniversaryViewController *_anniversaryPage;
    CoupleViewController *_CoupleSetPage;
    PlanMonthViewController *_planMonthPage;
    PlanWeekViewController *_planWeekPage;
    AlbumMainViewController *_AlbumPage;
    PersonFirstViewController *_personFirstVC;
}
@end

