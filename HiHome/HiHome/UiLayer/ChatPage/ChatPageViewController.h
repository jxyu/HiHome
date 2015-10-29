//
//  ChatPageViewController.h
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import <RongCloudIMKit/RongIMLib/RongIMLib.h>


@interface ChatPageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,RCIMUserInfoDataSource>
{
    @private
    NSInteger _cellCount;
    BOOL    _keyShow;       //标记键盘是否显示
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
}
- (IBAction)login_WithToken:(UIButton *)sender;
-(void) initViews;
@property(strong,nonatomic) UITableView *mainTableView;
@end
