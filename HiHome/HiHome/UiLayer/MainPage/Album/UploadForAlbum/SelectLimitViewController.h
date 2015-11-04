//
//  SelectLimitViewController.h
//  HiHome
//
//  Created by 王建成 on 15/11/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "SelectContacterViewController.h"

typedef enum _permissionMode
{
    Mode_all = 0,
    Mode_mine,
    Mode_friends
}PermissionMode;

@protocol SelectLimitViewControllerDelegate <NSObject>

-(void)setLimitDict:(NSDictionary *)dict;

@end

@interface SelectLimitViewController : BackPageViewController<SelectContacterViewControllerDelegate>
@property (nonatomic) id<SelectLimitViewControllerDelegate> delegate;
@end
