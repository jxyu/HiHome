//
//  TaskPath.h
//  HiHome
//
//  Created by 王建成 on 15/9/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum _taskStatue
{
    ZY_TASkSTATUE_RESERVE = 0xFFFF,
}ZYTaskStatue;

typedef enum _taskRemind
{
    ZY_TASkREMIND_RESERVE = 0xFFFF,
}ZYTaskRemind;


typedef enum _taskRepeat
{
    ZY_TASkREPEAT_RESERVE = 0xFFFF,
}ZYTaskRepeat;

typedef enum _taskType
{
    ZY_TASKTYPE_SEND=0,
    ZY_TASKTYPE_GET,
    ZY_TASKTYPE_MINE,
    
    ZY_TASkTYPE_RESERVE = 0xFFFF,
}ZYTaskType;

@interface TaskPath : NSObject
{

}
@property(nonatomic) NSString *taskName;//任务名称
@property(nonatomic) NSString *taskContent;//任务内容
@property(nonatomic) NSString *taskOwner;//发布者
@property(nonatomic) NSArray *taskPerformers;//执行者
@property(nonatomic) NSDateComponents *startTaskDate;//开始时间
@property(nonatomic) NSDateComponents *endTaskDate;//结束时间

@property(nonatomic) ZYTaskStatue taskStatus;//任务状态
@property(nonatomic) ZYTaskRemind remindTime;//提醒时间
@property(nonatomic) ZYTaskRepeat repeatMode;//任务重复日期
@property(nonatomic) ZYTaskType   taskType;//任务类型
@end
