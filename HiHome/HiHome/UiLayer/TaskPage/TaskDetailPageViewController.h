//
//  TaskDetailPageViewController.h
//  HiHome
//
//  Created by Rain on 15/10/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackPageViewController.h"
#import "TaskPath.h"

#define ZY_PICPICK_BTN_TAG      1
#define ZY_TAKEPIC_BTN_TAG      2
#define ZY_REMIND_BTN_TAG       3
#define ZY_REPEAT_BTN_TAG       4
#define ZY_PLACE_BTN_TAG        5

typedef enum _taskDetailMode
{
    TaskDetail_MyMode= 0,//自己的任务
    TaskDetail_ReceiveMode,//接受的任务
    TaskDetail_SendMode,// 发送的任务
    TaskDetail_OtherMode//查看别人的任务
    
    
}TaskDetailMode;

@protocol TaskDetailDelegate <NSObject>

-(void)setEdit;

@end


@interface TaskDetailPageViewController : BackPageViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic)TaskDetailMode taskDetailMode;
@property (nonatomic)id<TaskDetailDelegate> delegate;
@property (nonatomic)NSDictionary *dictData;
-(void)setDatas:(TaskPath *)taskPath;


@end
