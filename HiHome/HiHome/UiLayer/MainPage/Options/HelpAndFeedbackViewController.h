//
//  HelpAndFeedbackViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"

@interface HelpAndFeedbackViewController : BackPageViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
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

}
@end
