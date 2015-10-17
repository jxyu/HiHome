//
//  AddressLocalViewController.h
//  HiHome
//
//  Created by 于金祥 on 15/10/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Model.h"
#import "pinyin.h"
#import "BaseNavigationController.h"

@interface AddressLocalViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataSource;
    NSMutableArray *userSource;
    NSMutableArray *numarr1;
    NSMutableDictionary *dic1;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
