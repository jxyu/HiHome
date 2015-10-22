//
//  ChatPageViewController.h
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface ChatPageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    @private
    NSInteger _cellCount;
    BOOL    _keyShow;       //标记键盘是否显示
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
}
-(void) initViews;
@property(strong,nonatomic) UITableView *mainTableView;
@end
