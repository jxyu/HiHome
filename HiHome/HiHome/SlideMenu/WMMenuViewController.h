//
//  WMMenuViewController.h
//  QQSlideMenu
//
//  Created by wamaker on 15/6/12.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"

@protocol WMMenuViewControllerDelegate <NSObject>
@optional
- (void)didSelectItem:(NSString *)title;
-(void) swipLeftAction;
@end

@interface WMMenuViewController : WMBaseViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) id<WMMenuViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *mName;
@end
