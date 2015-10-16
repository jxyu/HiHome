//
//  BackPageViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/6.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface BackPageViewController : BaseNavigationController<UIGestureRecognizerDelegate>
{
    @public
    UIView *_tableHeaderView;
    
}
@property (strong,nonatomic)UILabel *titleLabel;
@property (nonatomic) NSString *navTitle;
@property ( nonatomic) BOOL POP;
@property(strong,nonatomic) NSMutableArray *contentHeadView;
-(void)quitView;
@end
