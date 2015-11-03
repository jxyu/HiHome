//
//  AnniversaryViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/6.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "UIImageView+WebCache.h"
#import "AnniversaryTaskDetailView.h"

#define CELL_HEIGHT     50

@interface AnniversaryViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource>
{
@private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    UITableView *_mainTableView;
}
//@property(strong,nonatomic) UITableView *mainTableView;
@end
