//
//  AddressPageViewController.h
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressLocalViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "PushView.h"
#import "MySearchDisplayController.h"

@interface AddressPageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
@private
    NSInteger _mateCellCount;
    NSInteger _starFriendCellCount;
    NSInteger _normalFriendcellCount;
    UISearchBar *_searchBar;
    BOOL    _keyShow;       //标记键盘是否显示
    UISearchDisplayController *_searchDisplayController;
    AddressLocalViewController *addresslocalVC;
    
    //for search
    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
}

//@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (strong,nonatomic) UITableView *mytableView;

@end
