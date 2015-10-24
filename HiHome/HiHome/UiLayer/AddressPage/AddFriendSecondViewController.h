//
//  AddFriendSecondViewController.h
//  HiHome
//
//  Created by Rain on 15/10/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackPageViewController.h"

@interface AddFriendSecondViewController : BackPageViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UIImageView *mHeadImg;
    UILabel *mName;
    UILabel *mSex;
}

@property(nonatomic) NSString *mHeaderImg;
@property(nonatomic) NSString *mName;
@property(nonatomic) NSString *mSex;

@end
