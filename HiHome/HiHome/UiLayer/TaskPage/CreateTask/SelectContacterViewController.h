//
//  SelectContacterViewController.h
//  HiHome
//
//  Created by Rain on 15/10/24.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackPageViewController.h"

@protocol  SelectContacterViewControllerDelegate <NSObject>

-(void) setContacterInfo:(NSArray *)selectContacterArrayID andName:(NSArray *)selectContacterArrayName;

@end

@interface SelectContacterViewController : BackPageViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSMutableArray *selectContacterArrayID;//已选择的联系人数组
@property(strong,nonatomic) NSMutableArray *selectContacterArrayName;//已选择的联系人数组
@property(nonatomic)id<SelectContacterViewControllerDelegate> delegate;

@end
