//
//  AddressPageViewController.h
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressLocalViewController.h"

@interface AddressPageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
@private
    NSInteger _mateCellCount;
    NSInteger _starFriendCellCount;
    NSInteger _normalFriendcellCount;
    UISearchBar *_searchBar;
    BOOL    _keyShow;       //标记键盘是否显示
    UISearchDisplayController *_searchDisplayController;
    AddressLocalViewController *addresslocalVC;
}
-(void) initViews;
@property (weak, nonatomic) IBOutlet UITableView *mytableView;


@end
