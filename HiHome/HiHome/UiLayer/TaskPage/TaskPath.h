//
//  TaskPath.h
//  HiHome
//
//  Created by 王建成 on 15/9/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _valueMode
{
    Mode_Repeat = 0,
    Mode_Remind,
    Mode_state
    
}ValueMode;

typedef enum _taskStatue
{
    State_unreceive =0,
    State_received,
    State_needDo,
    State_onGoing,
    State_finish,
    State_cancel,
    State_morepeople,
    
    ZY_TASkSTATUE_RESERVE = 0xFFFF,
}ZYTaskStatue;

typedef enum _taskRemind
{
    
    Remind_never       = 0,
    Remind_zhengdian,
    Remind_5min,
    Remind_10min,
    Remind_1hour,
    Remind_1day,
    Remind_3day,
    
    
    ZY_TASkREMIND_RESERVE = 0xFFFF,
}ZYTaskRemind;


typedef enum _taskRepeat
{
    Repeat_never        =0,
    Repeat_day,
    Repeat_week,
    Repeat_month,
    Repeat_year,
    
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
@property(nonatomic) NSString *taskID;//任务ID
@property(nonatomic) NSString *taskContent;//任务内容
@property(nonatomic) NSString *taskOwner;//发布者
@property(nonatomic) NSString *taskPerformers;//执行者

@property(nonatomic) NSMutableArray *taskPerformerDetails;//执行者信息

@property(nonatomic) NSDateComponents *startTaskDate;//开始时间
@property(nonatomic) NSDateComponents *endTaskDate;//结束时间

@property(nonatomic) NSString *startTaskDateStr;//开始时间
@property(nonatomic) NSString *endTaskDateStr;//结束时间

@property(nonatomic) NSMutableArray *imgSrc;
@property(nonatomic) BOOL isDay;

@property(nonatomic) ZYTaskStatue taskStatus;//任务状态
@property(nonatomic) ZYTaskRemind remindTime;//提醒时间
@property(nonatomic) ZYTaskRepeat repeatMode;//任务重复日期
@property(nonatomic) ZYTaskType   taskType;//任务类型

-(void)resetDatas;
@end


@interface anniversaryPath : NSObject
{
    
}
@property(nonatomic) NSString *title;//纪念日名称
@property(nonatomic) NSString *anniversaryID;//纪念日ID
@property(nonatomic) NSString *content;//纪念日内容
@property(nonatomic) NSString *date;//日期

@property(nonatomic) NSMutableArray *imgSrc;
@property(nonatomic) NSString *headImgSrc;

@property(nonatomic) NSDateComponents *startTaskDate;//开始时间
@property(nonatomic) NSDateComponents *endTaskDate;//结束时间

@property(nonatomic) NSString *startTaskDateStr;//开始时间
@property(nonatomic) NSString *endTaskDateStr;//结束时间

@end

