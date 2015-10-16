//
//  SoundSetViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"

@interface SoundSetViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource>
{
@private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    UITableView *_mainTableView;
    NSMutableArray *_cellInfo;
}
@end
