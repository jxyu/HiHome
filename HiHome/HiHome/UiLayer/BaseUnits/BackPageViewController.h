//
//  BackPageViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/6.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
typedef enum _pageDisApperMode
{
    Mode_nav = 0,
    Mode_dis
    
    
}PageDisApperMode;

@interface BackPageViewController : BaseNavigationController<UIGestureRecognizerDelegate>
{
    @public
    UIView *_tableHeaderView;
    
}
@property (strong,nonatomic)UILabel *titleLabel;
@property (strong,nonatomic)UIButton *mBtnRight;
@property (nonatomic) NSString *navTitle;
@property ( nonatomic) BOOL POP;
@property ( nonatomic) PageDisApperMode pageChangeMode;

@property(strong,nonatomic) NSMutableArray *contentHeadView;
-(void)quitView;
-(void)btnRightClick:(id)sender;
@end
