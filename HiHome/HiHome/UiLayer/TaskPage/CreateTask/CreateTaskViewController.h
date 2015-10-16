//
//  CreateTaskViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/13.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "RemindViewController.h"
#import "RepeatViewController.h"
#define ZY_PICPICK_BTN_TAG      1
#define ZY_TAKEPIC_BTN_TAG      2
#define ZY_REMIND_BTN_TAG       3
#define ZY_REPEAT_BTN_TAG       4
#define ZY_PLACE_BTN_TAG        5

@interface CreateTaskViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
@private
    NSInteger _cellCount;
    NSInteger _cellHeight;
    NSInteger _cellTextViewHeight;//包含textview的cell的高度
    UITableView *_mainTableView;
    BOOL    _keyShow;       //标记键盘是否显示
    UITextView *_textView;
    UITextField *_titleField;//标题
    
    CGFloat _keyHeight;
    
    UITextField *startTimeField ;
    UITextField *endTimeField;
    
    
    RemindViewController *_remindViewCtl;
    RepeatViewController *_repeatViewCtl;
}
@end
