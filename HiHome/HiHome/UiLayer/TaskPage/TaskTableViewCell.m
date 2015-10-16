//
//  TaskTableViewCell.m
//  HiHome
//
//  Created by 王建成 on 15/9/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "TaskPath.h"
#import "UIDefine.h"

@implementation TaskTableViewCell


-(id)init
{
    self = [super init];
    self.taskPath = [[TaskPath alloc] init];
    [self initViews];

    
    return  self;
}



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    self.taskPath = [[TaskPath alloc] init];
    [self initViews];
  //  [self setViewsFrame];
    return  self;
}

-(void)setFrame:(CGRect)frame
{
    super.frame = frame;
  //  self.frame =frame;
  //  [self setViewsFrame];
}

//
////common
//@property(strong,nonatomic)UIImageView *imgViewForRemind;
//@property(strong,nonatomic)UIImageView *imgViewForRepeat;
//@property(strong,nonatomic)UIImageView *imgViewForSet;
//
//@property(strong,nonatomic)UILabel *labelForDate;
//@property(strong,nonatomic)UILabel *labelForTaskName;
//@property(strong,nonatomic)UILabel *labelForRemind;
//@property(strong,nonatomic)UILabel *labelForRepeat;
//
////different
//@property(strong,nonatomic)UILabel *labelForStatus;
//@property(strong,nonatomic)UILabel *labelForSender;
//@property(strong,nonatomic)UILabel *labelForPerformers;

-(void) initViews
{
    self.taskPath.taskType = ZY_TASKTYPE_MINE;
    
    self.imgViewForRemind = [[UIImageView alloc] init];
    self.imgViewForRepeat = [[UIImageView alloc] init];
    self.imgViewForSet = [[UIImageView alloc] init];
    
    
    self.imgViewForRemind.image = [UIImage imageNamed:@"remindTime"];
    self.imgViewForRepeat.image = [UIImage imageNamed:@"repeat"];
    self.imgViewForSet.image = [UIImage imageNamed:@"set"];
    
    self.imgViewForRemind.contentMode = UIViewContentModeCenter;
    self.imgViewForRepeat.contentMode = UIViewContentModeCenter;
    self.imgViewForSet.contentMode = UIViewContentModeCenter;

    
    self.separatorLine = [[UIView alloc] init];
    
    self.labelForStartDate = [[UILabel alloc] init];
    self.labelForEndDate = [[UILabel alloc] init];
    self.labelForTaskName = [[UILabel alloc] init];
    self.labelForRemind = [[UILabel alloc] init];
    self.labelForRepeat = [[UILabel alloc] init];
    self.labelForStatus = [[UILabel alloc] init];
    self.labelForSender = [[UILabel alloc] init];
    self.labelForPerformers = [[UILabel alloc] init];
    
    
    
    self.labelForStartDate.font = [UIFont systemFontOfSize:14];
    self.labelForStartDate.textColor = ZY_UIBASECOLOR;
    self.labelForStartDate.textAlignment = NSTextAlignmentCenter;
    
    self.labelForEndDate.font = [UIFont systemFontOfSize:12];
    self.labelForEndDate.textColor = [UIColor grayColor];
    self.labelForEndDate.textAlignment = NSTextAlignmentCenter;
    
    self.labelForTaskName.font = [UIFont systemFontOfSize:14];
    self.labelForTaskName.textColor = ZY_UIBASECOLOR;
    
    self.labelForRemind.font = [UIFont systemFontOfSize:10];
    self.labelForRemind.textColor = [UIColor grayColor];
    
    self.labelForRepeat.font = [UIFont systemFontOfSize:10];
    self.labelForRepeat.textColor = [UIColor grayColor];
    
    self.labelForSender.font = [UIFont systemFontOfSize:12];
    self.labelForSender.textColor = [UIColor grayColor];
    
    self.labelForStatus.font = [UIFont systemFontOfSize:14];
    self.labelForStatus.textColor = [UIColor grayColor];
    self.labelForStatus.textAlignment = NSTextAlignmentRight;

    
    self.labelForPerformers.font = [UIFont systemFontOfSize:14];
    self.labelForPerformers.textColor = [UIColor grayColor];
    self.labelForPerformers.textAlignment = NSTextAlignmentRight;
//    self.imgViewForRemind.backgroundColor = [UIColor redColor];
//    self.imgViewForRepeat.backgroundColor = [UIColor redColor];
//    self.imgViewForSet.backgroundColor = [UIColor redColor];
//    
    self.separatorLine.backgroundColor = ZY_UIBASECOLOR;
//    
//    self.labelForDate.backgroundColor = [UIColor brownColor];
//    self.labelForTaskName.backgroundColor = [UIColor grayColor];
//    self.labelForRemind.backgroundColor = [UIColor purpleColor];
//    self.labelForRepeat.backgroundColor = [UIColor blackColor];
//    self.labelForStatus.backgroundColor = [UIColor greenColor];
//    self.labelForSender.backgroundColor = [UIColor orangeColor];
//    self.labelForPerformers.backgroundColor = [UIColor cyanColor];
    
    
    [self addSubview:self.imgViewForRemind];
    [self addSubview:self.imgViewForRepeat];
    [self addSubview:self.imgViewForSet];
    
    [self addSubview:self.separatorLine];
    
    [self addSubview:self.labelForStartDate];
    [self addSubview:self.labelForEndDate];
    [self addSubview:self.labelForTaskName];
    [self addSubview:self.labelForRemind];
    [self addSubview:self.labelForRepeat];
    [self addSubview:self.labelForStatus];
    [self addSubview:self.labelForSender];
    [self addSubview:self.labelForPerformers];
    
}

-(void)setTaskType:(ZYTaskType) type
{
    self.taskPath.taskType = type;
//    NSLog(@"type = %d",type);
    [self setViewsFrame];
}


-(void)setDispInfo:(TaskPath *)taskPath
{
    
//    self.imgViewForRemind.image = taskPath.;
//    self.imgViewForRepeat.backgroundColor = [UIColor redColor];
//    self.imgViewForSet.backgroundColor = [UIColor redColor];
    
//    self.labelForDate.backgroundColor = taskPath];
    if(taskPath == nil)
        return;
    
    NSLog(@"set task Path");
    self.labelForTaskName.text = taskPath.taskName;
    self.labelForStartDate.text = [NSString stringWithFormat:@"%02ld/%02ld",[taskPath.startTaskDate month],[taskPath.startTaskDate day]];
    self.labelForEndDate.text = [NSString stringWithFormat:@"~%02ld/%02ld",[taskPath.endTaskDate month],[taskPath.endTaskDate day]];

    switch (taskPath.repeatMode) {
    case ZY_TASkREPEAT_RESERVE:
            self.labelForRepeat.text = @"每天";
        break;
        
    default:
        break;
    }
    
    switch (taskPath.remindTime) {
        case ZY_TASkREPEAT_RESERVE:
            self.labelForRemind.text = @"五分钟前";
            break;
            
        default:
            break;
    }
    
    switch (taskPath.taskStatus) {
        case ZY_TASkREPEAT_RESERVE:
            self.labelForStatus.text = @"未执行";
            break;
            
        default:
            break;
    }

    if(taskPath.taskPerformers.count == 1)
    {
        self.labelForPerformers.text = [taskPath.taskPerformers objectAtIndex:0];
    }
    else
    {
        self.labelForPerformers.text = [[NSString alloc] initWithFormat:@"%ld人",taskPath.taskPerformers.count];
    }

    if(taskPath.taskOwner != nil)
        self.labelForSender.text = [[NSString alloc] initWithFormat:@"发布人:%@",taskPath.taskOwner];
    
    
    
//    self.labelForRemind.backgroundColor = [UIColor purpleColor];
//    self.labelForRepeat.backgroundColor = [UIColor blackColor];
//    self.labelForStatus.backgroundColor = [UIColor greenColor];
//    self.labelForSender.backgroundColor = [UIColor orangeColor];
//    self.labelForPerformers.backgroundColor = [UIColor cyanColor];
    
    
}


-(void) setViewsFrame
{

    NSLog(@"cell width ＝ %lf",self.frame.size.width);
    
    self.imgViewForSet.frame = CGRectMake(self.frame.size.width-20,0,15,self.frame.size.height );
    self.separatorLine.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP/2, ZY_VIEWS_GAP/2,1 , self.frame.size.height - ZY_VIEWS_GAP);
    self.labelForEndDate.frame = CGRectMake(0, self.frame.size.height/2,ZY_DATE_LAB_WIDTH , self.frame.size.height/3);
    self.labelForStartDate.frame = CGRectMake(0, self.frame.size.height/6,ZY_DATE_LAB_WIDTH , self.frame.size.height/3);
    
    NSLog(@"set type in setframe = %d",self.taskPath.taskType );
    
    if(self.taskPath.taskType == ZY_TASKTYPE_GET)
    {
        self.labelForTaskName.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+3, ZY_VIEWS_GAP-3,200 , 15);
        
        self.imgViewForRemind.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+5, 15+ZY_VIEWS_GAP,10 , 15);
        self.labelForRemind.frame = CGRectMake  (ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+10+5+5,ZY_VIEWS_GAP+15, 100 , 15);
        
        self.imgViewForRepeat.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+10+100+5,15+ZY_VIEWS_GAP,10 , 15);
        self.labelForRepeat.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+100+20+5+5,15+ZY_VIEWS_GAP,100 , 15);
        
        
        self.labelForSender.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+5,20+10+ZY_VIEWS_GAP,150  , (self.frame.size.height - ZY_VIEWS_GAP*2)/3.0);
        
    }
    else
    {
        self.labelForTaskName.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+3, ZY_VIEWS_GAP-3,200 , 15);
        
        self.imgViewForRemind.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+5, (self.frame.size.height - ZY_VIEWS_GAP*2)/2.0+ZY_VIEWS_GAP,10, 15);
        self.labelForRemind.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+10+5+5,ZY_VIEWS_GAP+(self.frame.size.height - ZY_VIEWS_GAP*2)/2.0, 100 , 15);
        
        
        self.imgViewForRepeat.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+10+100+5,(self.frame.size.height - ZY_VIEWS_GAP*2)/2.0+ZY_VIEWS_GAP,10  ,15);
        self.labelForRepeat.frame = CGRectMake(ZY_DATE_LAB_WIDTH+ZY_VIEWS_GAP+10+100+10+5+5,(self.frame.size.height - ZY_VIEWS_GAP*2)/2.0+ZY_VIEWS_GAP,100 , 15);
        
        
    }
    
    
    if(self.taskPath.taskType == ZY_TASKTYPE_MINE)
    {
        self.labelForStatus.frame = CGRectMake(self.frame.size.width-20-50, 0,50 , self.frame.size.height);
    }
    else
    {
        self.labelForPerformers.frame = CGRectMake(self.frame.size.width-20-50, self.frame.size.height/2-20,50 , 20);
        self.labelForStatus.frame = CGRectMake(self.frame.size.width-20-50, self.frame.size.height/2,50 , 20);
    }
    
    
}

@end
