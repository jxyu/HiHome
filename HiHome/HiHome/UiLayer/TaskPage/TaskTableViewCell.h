//
//  TaskTableViewCell.h
//  HiHome
//
//  Created by 王建成 on 15/9/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskPath.h"


#define ZY_DATE_LAB_WIDTH   (self.frame.size.width / 6)
#define ZY_VIEWS_GAP        10

@interface TaskTableViewCell : UITableViewCell
{
    
}


/**
* cell 内部控件
*/
//common
@property(strong,nonatomic)UIImageView *imgViewForRemind;
@property(strong,nonatomic)UIImageView *imgViewForRepeat;
@property(strong,nonatomic)UIImageView *imgViewForSet;

@property(strong,nonatomic)UIView *separatorLine;

@property(strong,nonatomic)UILabel *labelForStartDate;
@property(strong,nonatomic)UILabel *labelForEndDate;
@property(strong,nonatomic)UILabel *labelForTaskName;
@property(strong,nonatomic)UILabel *labelForRemind;
@property(strong,nonatomic)UILabel *labelForRepeat;

//different
@property(strong,nonatomic)UILabel *labelForStatus;
@property(strong,nonatomic)UILabel *labelForSender;
@property(strong,nonatomic)UILabel *labelForPerformers;

@property(strong,nonatomic) TaskPath *taskPath;

-(void)setTaskType:(ZYTaskType) type;
-(void)setDispInfo:(TaskPath *)taskPath;

@end
