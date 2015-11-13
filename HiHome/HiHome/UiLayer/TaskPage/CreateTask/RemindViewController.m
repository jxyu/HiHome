//
//  RepeatViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "RemindViewController.h"
#import "UIDefine.h"


#define MULTI_CHOICE       0

//#define  Remind_never       0
//#define  Remind_zhengdian   1
//#define  Remind_5min        2
//#define  Remind_10min       3
//#define  Remind_1hour       4
//#define  Remind_1day        5
//#define  Remind_3day        6



#define YEAR_INDEX       0
#define MONTH_INDEX       1
#define DAY_INDEX       2
#define HOUR_INDEX       3
#define MIN_INDEX       4
#define WEEK_INDEX       5

@implementation remindLineInfo



@end

@interface RemindViewController ()
{
    NSMutableArray *_arrayBtn;
    NSMutableArray *_arrayRemind;
    NSInteger _oneLineHight;
    UIView *customView;
    
    NSString * tip;
    NSString * tipName;
}
@end

@implementation RemindViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayBtn = [NSMutableArray array];
    _arrayRemind = [NSMutableArray array];
    _btnWidth = (self.view.frame.size.width-10)/4;
    
    self.view.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    [self initViews];
    [self setDefault];
    
    // Do any additional setup after loading the view from its nib.
}

-(id)init
{
    
    self = [super init];
    if (self) {
        _dateArr = [NSMutableArray array];
    }
    
    
    return self;
}


-(void) initViews
{
    NSArray *repeatMode;
    if(self.isDay == YES)
    {
        NSArray *tempArr = @[@"不提醒",@"正点",@"一天前",@"三天前"];
        repeatMode =tempArr;
    }
    else
    {
        NSArray *tempArr = @[@"不提醒",@"正点",@"五分钟前",@"十分钟前",@"一小时之前",@"一天前",@"三天前"];
        repeatMode =tempArr;
    }
   
    NSInteger rownum  = 0;
    for (int i = 0; i<repeatMode.count; i++) {
       // if(rownum)
        rownum = i/4;
        
//        UIButtonTypeSystem NS_ENUM_AVAILABLE_IOS(7_0),  // standard system button
//        
//        UIButtonTypeDetailDisclosure,
//        UIButtonTypeInfoLight,
//        UIButtonTypeInfoDark,
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =  CGRectMake( 10+(i%4)*_btnWidth, ZY_HEADVIEW_HEIGHT + rownum*_btnWidth+10, _btnWidth-10, _btnWidth-10);
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = [[UIColor grayColor] CGColor];
   //     btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor whiteColor];
        btn.alpha = 0.5;
        
        btn.tag = ZY_UIBUTTON_TAG_BASE + i;
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [btn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:[repeatMode objectAtIndex:i] forState:UIControlStateNormal];
        [_arrayBtn addObject:btn];
        [self.view addSubview:btn];
        
        NSString *str;
        NSTimeInterval tempTime;
        remindLineInfo *tempInfo = [[remindLineInfo alloc] init];
        tempInfo->existState = NO;
        tempInfo->title = [repeatMode objectAtIndex:i];
        if(self.isDay)
        {
            
            switch (i) {
                case Remind_zhengdian:
                    str = [NSString stringWithFormat:@"%@-%@-%@  %@:%@",[_dateArr objectAtIndex:YEAR_INDEX],[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX],[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
                    tempInfo->remindTime = str;
                    break;
                case 2://一天前
                {
                    str = [NSString stringWithFormat:@"%@%@%@%@%@",[_dateArr objectAtIndex:YEAR_INDEX],[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX],[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
                    
                    tempTime = [self timeconvert:str andFormat:@"yyyyMMddHHmm"];//string 类型的时间转换为时间戳
                    tempTime -=(24*60*60);//减掉时间偏移
                    str = [NSString stringWithFormat:@"%@",[self timeIntervalToDate:tempTime]/*重新转化为字符*/];
                    tempInfo->remindTime = str;
                }
                    break;
                case 3://三天前
                {
                    str = [NSString stringWithFormat:@"%@%@%@%@%@",[_dateArr objectAtIndex:YEAR_INDEX],[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX],[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
                    
                    tempTime = [self timeconvert:str andFormat:@"yyyyMMddHHmm"];//string 类型的时间转换为时间戳
                    tempTime -=(3*24*60*60);//减掉时间偏移
                    str = [NSString stringWithFormat:@"%@",[self timeIntervalToDate:tempTime]/*重新转化为字符*/];
                    tempInfo->remindTime = str;
                }
                    break;
                case Remind_never:
                    
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            switch (i) {
                case Remind_zhengdian:
                    str = [NSString stringWithFormat:@"%@-%@-%@  %@:%@",[_dateArr objectAtIndex:YEAR_INDEX],[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX],[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
                    tempInfo->remindTime = str;
                    break;
                case Remind_5min:
                {
                    str = [NSString stringWithFormat:@"%@%@%@%@%@",[_dateArr objectAtIndex:YEAR_INDEX],[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX],[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
                    
                    tempTime = [self timeconvert:str andFormat:@"yyyyMMddHHmm"];//string 类型的时间转换为时间戳
                    tempTime -=(5*60);//减掉时间偏移
                    str = [NSString stringWithFormat:@"%@",[self timeIntervalToDate:tempTime]/*重新转化为字符*/];
                     tempInfo->remindTime = str;
                }
            
                    break;
                case Remind_10min:
                {
                    str = [NSString stringWithFormat:@"%@%@%@%@%@",[_dateArr objectAtIndex:YEAR_INDEX],[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX],[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
                    
                    tempTime = [self timeconvert:str andFormat:@"yyyyMMddHHmm"];//string 类型的时间转换为时间戳
                    tempTime -=(10*60);//减掉时间偏移
                    str = [NSString stringWithFormat:@"%@",[self timeIntervalToDate:tempTime]/*重新转化为字符*/];
                    tempInfo->remindTime = str;
                }
                    break;
                case Remind_1hour:
                {
                    str = [NSString stringWithFormat:@"%@%@%@%@%@",[_dateArr objectAtIndex:YEAR_INDEX],[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX],[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
                    
                    tempTime = [self timeconvert:str andFormat:@"yyyyMMddHHmm"];//string 类型的时间转换为时间戳
                    tempTime -=(60*60);//减掉时间偏移
                    str = [NSString stringWithFormat:@"%@",[self timeIntervalToDate:tempTime]/*重新转化为字符*/];
                    tempInfo->remindTime = str;
                }
                    break;
                case Remind_1day:
                {
                    str = [NSString stringWithFormat:@"%@%@%@%@%@",[_dateArr objectAtIndex:YEAR_INDEX],[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX],[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
                    
                    tempTime = [self timeconvert:str andFormat:@"yyyyMMddHHmm"];//string 类型的时间转换为时间戳
                    tempTime -=(24*60*60);//减掉时间偏移
                    str = [NSString stringWithFormat:@"%@",[self timeIntervalToDate:tempTime]/*重新转化为字符*/];
                    tempInfo->remindTime = str;
                }
                    break;
                case Remind_3day:
                {
                    str = [NSString stringWithFormat:@"%@%@%@%@%@",[_dateArr objectAtIndex:YEAR_INDEX],[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX],[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
                    
                    tempTime = [self timeconvert:str andFormat:@"yyyyMMddHHmm"];//string 类型的时间转换为时间戳
                    tempTime -=(3*24*60*60);//减掉时间偏移
                    str = [NSString stringWithFormat:@"%@",[self timeIntervalToDate:tempTime]/*重新转化为字符*/];
                    tempInfo->remindTime = str;
                }
                    break;
                case Remind_never:
                    
                    break;
                    
                default:
                    break;
            }
        }
        [_arrayRemind addObject:tempInfo];
    }
    
//    UIButton *finishBtn = [[UIButton alloc] init];
//    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
//    finishBtn.frame = CGRectMake(self.view.frame.size.width-ZY_VIEWHEIGHT_IN_HEADVIEW-10, 20, ZY_VIEWHEIGHT_IN_HEADVIEW, ZY_VIEWHEIGHT_IN_HEADVIEW);
//    finishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//    finishBtn.tag = ZY_UIBUTTON_TAG_BASE + 20;
    //[self->_tableHeaderView addSubview:finishBtn];
    //[finishBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];

    [self.mBtnRight setTitle:@"完成" forState:UIControlStateNormal];
    
    _oneLineHight = (self.view.frame.size.height -(ZY_HEADVIEW_HEIGHT + (rownum+1)*_btnWidth+10+20) -20)/repeatMode.count;

    customView = [[UIView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT + (rownum+1)*_btnWidth+10+20, self.view.frame.size.width, _oneLineHight*0)];
    
    customView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:customView];
//
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, customView.frame.size.height, _oneLineHight)];
//    imgView.image = [UIImage imageNamed:@"remind"];
//    imgView.contentMode = UIViewContentModeCenter;
//    [customView addSubview:imgView];
//    
//    _textLab = [[UILabel alloc] initWithFrame:CGRectMake(customView.frame.size.height, 0, 200, _oneLineHight)];
//    _textLab.text =_remindStr;
//    [customView addSubview:_textLab];
}



-(NSTimeInterval)timeconvert:(NSString*)str andFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:str];
    NSTimeInterval dis = [date timeIntervalSince1970];
    
    return dis;
}

-(NSString *)timeIntervalToDate:(NSTimeInterval)sec
{
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sec];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *dateString = [formatter stringFromDate:date];
    
    str = [NSString stringWithFormat:@"%@-%@-%@  %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)]/*年*/,[dateString substringWithRange:NSMakeRange(4, 2)]/*月*/,[dateString substringWithRange:NSMakeRange(6, 2)]/*日*/,[dateString substringWithRange:NSMakeRange(8, 2)]/*时*/,[dateString substringWithRange:NSMakeRange(10, 2)]/*分*/];
    
    return str;
}




-(void) setDefault//默认正点提醒
{
    remindLineInfo *tempInfo;
    
    _remindModeStr  = [self modeValueToStr:Mode_Remind andValue:Remind_zhengdian];
    NSLog(@"1213123123123123123213123123123123213_remindModeStr = %@",_remindModeStr);
    ;    tempInfo = [_arrayRemind objectAtIndex:Remind_zhengdian];
    
    tempInfo->existState = YES;
    UIButton *tempBtn;
    tempBtn = [_arrayBtn objectAtIndex:Remind_zhengdian];
    tempBtn.selected = YES;
    tempBtn.backgroundColor = [UIColor blueColor];
    [customView addSubview:[self remindView:0 andInfo:tempInfo]];
    
}


-(NSString *) modeValueToStr:(ValueMode)mode andValue:(NSInteger)value
{
    NSString *str;
    
    switch (mode) {
        case Mode_Repeat:
            switch (value) {
                case Repeat_never :
                    str = @"不重复";
                    break;
                case Repeat_day:
                    str = @"每天";
                    break;
                case Repeat_week:
                    str = @"每周";
                    break;
                case Repeat_month:
                    str = @"每月";
                    break;
                case Repeat_year:
                    str = @"每年";
                    break;
                case ZY_TASkREPEAT_RESERVE:
                    str = @"不重复";
                    break;
                    
                default:
                    break;
            }
            break;
        case  Mode_Remind:
            switch (value) {
                    
                    
                case Remind_never:
                    str = @"从不提醒";
                    break;
                case Remind_zhengdian:
                    str = @"正点";
                    break;
                case Remind_5min:
                    str = @"五分钟前";
                    break;
                case Remind_10min:
                    str = @"十分钟前";
                    break;
                case Remind_1hour:
                    str = @"一小时前";
                    break;
                case Remind_1day:
                    str = @"一天前";
                    break;
                case Remind_3day:
                    str = @"三天前";
                    break;
                    
                case ZY_TASkREPEAT_RESERVE:
                    str = @"从不提醒";
                    break;
                    
                default:
                    break;
            }
            break;
        case Mode_state:
            switch (value) {
                case State_unreceive:
                    str= @"未接受";
                    break;
                case State_received:
                    str = @"已接受";
                    break;
                case State_needDo:
                    str = @"待执行";
                    break;
                case State_onGoing:
                    str = @"执行中";
                    break;
                case State_finish:
                    str = @"已完成";
                    break;
                case State_cancel:
                    str = @"已取消";
                    break;
                case State_morepeople:
                    str = @"多人任务";
                    break;
                case ZY_TASkREPEAT_RESERVE:
                    str = @"未接受";
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            str = nil;
            break;
    }
    
    return str;
    
}




-(void)setDateArr:(NSMutableArray *)dateArr
{
    [_dateArr removeAllObjects];
    for (int i = 0; i<dateArr.count; i++) {
        [_dateArr addObject:[dateArr objectAtIndex:i]];
    }
    NSLog(@"date : %@",[NSString stringWithFormat:@"%@-%@-%@  %@:%@  %@",[_dateArr objectAtIndex:0] ,[_dateArr objectAtIndex:1] ,[_dateArr objectAtIndex:2] ,[_dateArr objectAtIndex:3] ,[_dateArr objectAtIndex:4] ,[_dateArr objectAtIndex:5] ]
          );
}

-(void) clearCustomSubView
{
  //  UIView *tempView;
    /*清理掉之前的view*/
    for (UIView * subview in [customView subviews]) {
        [subview removeFromSuperview];
      //  customView.backgroundColor = [UIColor whiteColor];
    }
}

-(void) relayoutCustomView
{
#if 1
    NSInteger availedCount =0 ;
    CGRect tempRect;
    remindLineInfo *tempInfo;
    UIView *tempView;
    /*清理掉之前的view*/
    [self clearCustomSubView];
    
    
    for(int i =1/*跳过不提醒的显示*/ ;i < _arrayRemind.count ;i++)
    {
        tempInfo = [_arrayRemind objectAtIndex:i];
        if(tempInfo->existState == YES)
        {
            tempView = [self remindView:availedCount andInfo:tempInfo];
            [customView addSubview:tempView];
            availedCount++;
        }
    }
    tempRect= customView.frame;
    customView.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y, tempRect.size.width, _oneLineHight*availedCount);
    
#endif
}

-(UIView *) remindView:(NSInteger)lineNum  andInfo:(remindLineInfo *)remindInfo
{
    UIView *remindView = [[UIView alloc] initWithFrame:CGRectMake(0, lineNum * _oneLineHight, self.view.frame.size.width, _oneLineHight)];
    remindView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:customView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _oneLineHight, _oneLineHight)];
    imgView.image = [UIImage imageNamed:@"remind"];
    imgView.contentMode = UIViewContentModeCenter;
    [remindView addSubview:imgView];
    
    UILabel *textTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(_oneLineHight, 0, (customView.frame.size.width - _oneLineHight)/3, _oneLineHight)];
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(textTitleLab.frame.origin.x+textTitleLab.frame.size.width, 0,(customView.frame.size.width - _oneLineHight)/3*2-5, _oneLineHight)];

    NSString *str;
    str = [NSString stringWithFormat:@"%@提醒:",remindInfo->title];
    textTitleLab.text =str;
    textTitleLab.font = [UIFont systemFontOfSize:12];
    
    timeLab.text = remindInfo->remindTime;
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [remindView addSubview:textTitleLab];
    [remindView addSubview:timeLab];
    return remindView;
}

#if MULTI_CHOICE

-(void) clickBtns:(UIButton *)sender
{
    UIButton *tempBtn;
    remindLineInfo *tempInfo;
    
    if(sender.tag == ZY_UIBUTTON_TAG_BASE + 20)
    {
        [self clearCustomSubView];
        
        return;
    }
    if([sender.titleLabel.text isEqualToString:@"不提醒"])
    {//设置为未提醒关闭所有提醒
        for(int i =0;i <_arrayBtn.count;i++)
        {
            tempBtn = [_arrayBtn objectAtIndex:i];
            tempBtn.selected = NO;
            tempBtn.backgroundColor = [UIColor whiteColor];
            
            tempInfo = [_arrayRemind objectAtIndex:i];
            tempInfo->existState =NO;
        }
        
        tempInfo = [_arrayRemind objectAtIndex:Remind_never];
        tempInfo->existState =YES;
        
        sender.backgroundColor = [UIColor blueColor];
        sender.selected = YES;
    }
    else
    {
        sender.selected =!sender.selected;
        if(sender.selected == YES)
            sender.backgroundColor = [UIColor blueColor];
        else
            sender.backgroundColor = [UIColor whiteColor];
        
        tempInfo = [_arrayRemind objectAtIndex:(sender.tag-ZY_UIBUTTON_TAG_BASE)];
        tempInfo->existState =sender.selected;
        
        tempInfo = [_arrayRemind objectAtIndex:Remind_never];
        tempInfo->existState =NO;
        
        tempBtn = [_arrayBtn objectAtIndex:(_arrayBtn.count-1)];
        tempBtn.backgroundColor = [UIColor whiteColor];
        tempBtn.selected = NO;
        BOOL noSelectFlag = true;
        //按键都是未选中状态时 设置为未提醒
        for(tempBtn in _arrayBtn)
        {
            if(tempBtn.selected == YES)
            {
                noSelectFlag = false;
                break;
            }
        }
        
        if(noSelectFlag == true)
        {
            tempBtn = [_arrayBtn objectAtIndex:Remind_never];
            tempBtn.backgroundColor = [UIColor blueColor];
            tempBtn.selected = YES;
        }
        
    }
    
    [self relayoutCustomView];
    
}
#else//单选模式

-(void) clickBtns:(UIButton *)sender
{
    UIButton *tempBtn;
    remindLineInfo *tempInfo;
    
    if(sender.tag == ZY_UIBUTTON_TAG_BASE + 20)
    {
        [self clearCustomSubView];
        
        return;
    }
   // if([sender.titleLabel.text isEqualToString:@"不提醒"])
    {//设置为未提醒关闭所有提醒
        for(int i =0;i <_arrayBtn.count;i++)
        {
            tempBtn = [_arrayBtn objectAtIndex:i];
            tempBtn.selected = NO;
            tempBtn.backgroundColor = [UIColor whiteColor];
            
            tempInfo = [_arrayRemind objectAtIndex:i];
            tempInfo->existState =NO;
        }
        
        tempInfo = [_arrayRemind objectAtIndex:(sender.tag-ZY_UIBUTTON_TAG_BASE)];
        tempInfo->existState =YES;
        
     //   _remindMode = (ZYTaskRemind)(sender.tag-ZY_UIBUTTON_TAG_BASE);
        _remindModeStr  = [self modeValueToStr:Mode_Remind andValue:(ZYTaskRemind)(sender.tag-ZY_UIBUTTON_TAG_BASE)];
        
        sender.backgroundColor = [UIColor blueColor];
        sender.selected = YES;
    }
    
    [self relayoutCustomView];
    
    tip=[NSString stringWithFormat:@"%ld",sender.tag-2315];
    tipName=[sender currentTitle];
}

#endif
//重写退出页面方法
-(void)quitView
{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)btnRightClick:(id)sender{
    NSLog(@"tixing done");
    SEL func_selector = NSSelectorFromString(callBackFunctionName);
    if ([CallBackObject respondsToSelector:func_selector]) {
        NSDictionary * dict=[[NSDictionary alloc] initWithObjectsAndKeys:tip,@"tip",tipName,@"tipname", nil];
        [CallBackObject performSelector:func_selector withObject:dict];
        [self quitView];
    }else{
        NSLog(@"回调失败...");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
