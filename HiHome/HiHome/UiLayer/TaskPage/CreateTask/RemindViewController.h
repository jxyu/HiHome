//
//  RepeatViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "TaskPath.h"
#import "UUDatePicker.h"

//typedef enum _RemindMode
//{
//    Remind_ONTIME = 0x00000001,
//    Remind_5minBefore = 0x00000002,
//    Remind_10minBefore = 0x00000004,
//    Remind_1hourBefore = 0x00000008,
//    Remind_1dayBefore = 0x00000010,
//    Remind_3dayBefore = 0x00000020,
//    Remind_NONE = 0xffffffff,
//}RemindMode;

@interface  remindLineInfo: NSObject
{
@public
    BOOL existState;
    NSString *title;
    NSString *remindTime;
    
    
//    ZYTaskRemind _remindMode;//不知为何定义了不识别
}
@end

@interface RemindViewController : BackPageViewController
{
    CGFloat _btnWidth;

    id CallBackObject;
    NSString * callBackFunctionName;
    NSInteger btnTag;
}
@property(nonatomic)NSMutableArray *dateArr;
@property(nonatomic)NSString *remindDate;
@property(strong,nonatomic)NSString *remindModeStr;
@property(nonatomic)BOOL isDay;


- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

//-(ZYTaskRemind)getRemindMode;
@end
