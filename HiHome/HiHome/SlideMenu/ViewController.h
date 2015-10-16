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

@interface ViewController : WMBaseViewController<UIGestureRecognizerDelegate,CustomTabBarViewControllerDelegate>
{
    @private
    BOOL swipFlag;
    
    OptionsViewController *_optionPage;
    AnniversaryViewController *_anniversaryPage;
    CoupleViewController *_CoupleSetPage;
    PlanMonthViewController *_planMonthPage;
    AlbumMainViewController *_AlbumPage;
}
@end

