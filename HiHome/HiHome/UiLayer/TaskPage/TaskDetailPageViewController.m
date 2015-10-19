//
//  TaskDetailPageViewController.m
//  HiHome
//
//  Created by Rain on 15/10/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TaskDetailPageViewController.h"
#import "BaseTableViewCell.h"
#import "UIDefine.h"
#import "UUDatePicker.h"
#import "SegmentedButton.h"

@interface TaskDetailPageViewController (){
    UITableView *mTableView;
    NSInteger _cellHeight;
    NSMutableArray *_startDateArray;
    
    UITextField *taskName;
    UITextField *executor;
    UITextView *mTextView;
    UITextField *startTimeField;
    UITextField *endTimeField;
}

@end

@implementation TaskDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeight = (self.view.frame.size.height-ZY_HEADVIEW_HEIGHT)/11;
    _startDateArray = [[NSMutableArray alloc] init];
    [self initView];
}

-(void)initView{
    //right title button
    [self.mBtnRight setTitle:@"编辑" forState:UIControlStateNormal];
    
    //UITableView
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    mTableView.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    mTableView.dataSource =self;
    mTableView.delegate = self;
    [self.view addSubview:mTableView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        //任务状态UILable
        UILabel *taskStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 75, 21)];
        taskStatus.text= @"任务状态:";
        [cell addSubview:taskStatus];
        
        UILabel *taskStatusShow = [[UILabel alloc] initWithFrame:CGRectMake(taskStatus.frame.size.width + 12, 15, 100, 21)];
        taskStatusShow.contentMode = UIViewContentModeLeft;
        taskStatusShow.textColor = [UIColor colorWithRed:0.91 green:0.27 blue:0 alpha:1];
        taskStatusShow.text= @"未完成";
        [cell addSubview:taskStatusShow];
        
        //UIButon
        UIButton *btnStatus = [[UIButton alloc] initWithFrame:CGRectMake(10, taskStatus.frame.size.height + 25, 100, 30)];
        btnStatus.layer.masksToBounds = YES;
        btnStatus.layer.borderWidth = 1;
        btnStatus.layer.borderColor = [UIColor redColor].CGColor;
        btnStatus.layer.cornerRadius = 8;
        [btnStatus setTitle:@"删除任务" forState:UIControlStateNormal];
        [btnStatus setTitleColor:[UIColor colorWithRed:0.91 green:0.27 blue:0 alpha:1] forState:UIControlStateNormal];
        [cell addSubview:btnStatus];
    }else if(indexPath.row == 1){
        taskName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
        taskName.textColor = [UIColor grayColor];
        taskName.text = @"下载hihomeapp";
        //左UILabel
        UILabel *leftlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
        leftlbl.textColor = [UIColor grayColor];
        leftlbl.text = @"任务名称:";
        taskName.leftView = leftlbl;
        taskName.leftViewMode = UITextFieldViewModeAlways;
        
        [cell addSubview:taskName];
    }else if(indexPath.row == 2){
        executor = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
        executor.textColor = [UIColor grayColor];
        executor.text = @"自己";
        //左UILabel
        UILabel *leftlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
        leftlbl.textColor = [UIColor grayColor];
        leftlbl.textAlignment = NSTextAlignmentRight;
        leftlbl.text = @"执行人:";
        executor.leftView = leftlbl;
        executor.leftViewMode = UITextFieldViewModeAlways;
        
        [cell addSubview:executor];
    }else if(indexPath.row == 3){
        mTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 80)];
        mTextView.textColor = [UIColor grayColor];
        mTextView.font = [UIFont systemFontOfSize:15];
        mTextView.text = @"学习hihomeapp并且下载";
        [cell addSubview:mTextView];
    }else if(indexPath.row == 4){
        [self createDate:cell];
    }
    else{
        cell.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
        SegmentedButton *remindBtn = [[SegmentedButton alloc] init];
        remindBtn.frame = CGRectMake(20, 20, self.view.frame.size.width/3-20*2, self.view.frame.size.width/3-20*2);
        remindBtn.backgroundColor = [UIColor whiteColor];
        remindBtn.alpha = 0.8;
        remindBtn.tag = ZY_UIBUTTON_TAG_BASE +ZY_REMIND_BTN_TAG;
        
        SegmentedButton *repeatBtn = [[SegmentedButton alloc] init];
        repeatBtn.frame =CGRectMake(self.view.frame.size.width/3+20, 20, self.view.frame.size.width/3-20*2, self.view.frame.size.width/3-20*2);
        repeatBtn.backgroundColor = [UIColor whiteColor];
        repeatBtn.alpha = 0.8;
        repeatBtn.tag = ZY_UIBUTTON_TAG_BASE +ZY_REPEAT_BTN_TAG;
        
        
        SegmentedButton *placeBtn = [[SegmentedButton alloc] init];
        placeBtn.frame =  CGRectMake(self.view.frame.size.width/3*2+20, 20, self.view.frame.size.width/3-20*2, self.view.frame.size.width/3-20*2);
        placeBtn.backgroundColor = [UIColor whiteColor];
        placeBtn.alpha = 0.8;
        placeBtn.tag = ZY_UIBUTTON_TAG_BASE +ZY_PLACE_BTN_TAG;
        
        [remindBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        [remindBtn setImage:[UIImage imageNamed:@"remind"] forState:UIControlStateNormal];
        [remindBtn setTitle:@"提醒" forState:UIControlStateNormal];
        [remindBtn setTitleColor:[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1] forState:UIControlStateNormal];
        remindBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        remindBtn.imageView.contentMode = UIViewContentModeCenter;
        remindBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [repeatBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        [repeatBtn setImage:[UIImage imageNamed:@"repeat_2"] forState:UIControlStateNormal];
        [repeatBtn setTitle:@"重复" forState:UIControlStateNormal];
        [repeatBtn setTitleColor:[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1] forState:UIControlStateNormal];
        repeatBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        repeatBtn.imageView.contentMode = UIViewContentModeCenter;
        repeatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [placeBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        [placeBtn setImage:[UIImage imageNamed:@"place"] forState:UIControlStateNormal];
        [placeBtn setTitle:@"位置" forState:UIControlStateNormal];
        [placeBtn setTitleColor:[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1] forState:UIControlStateNormal];
        placeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        placeBtn.imageView.contentMode = UIViewContentModeCenter;
        placeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [cell addSubview:remindBtn];
        [cell addSubview:repeatBtn];
        [cell addSubview:placeBtn];
    }
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    return cell;
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 91;
    }else if(indexPath.row == 3){
        return 80;
    }else if(indexPath.row == 5){
        return 190;
    }
    return 50;
}

-(void)clickBtns:(UIButton *)sender
{
    NSLog(@"click choose contact btn");
}

//重写返回按钮
-(void)quitView{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}

-(void)btnRightClick:(id)sender;{
    NSLog(@"编辑");
}

-(void)createDate:(UITableViewCell *) cell{
    NSDate *now = [NSDate date];
    
    UILabel *startTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, _cellHeight/2)];
    UILabel *endTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, _cellHeight/2)];
    
    startTimeField = [[UITextField alloc] initWithFrame:CGRectMake(0, _cellHeight/2, self.view.frame.size.width/2, _cellHeight/2)];
    endTimeField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, _cellHeight/2, self.view.frame.size.width/2, _cellHeight/2)];
    
    startTimeField.textAlignment = NSTextAlignmentCenter;
    endTimeField.textAlignment = NSTextAlignmentCenter;
    
    
    startTimeLab.text = @"开始时间";
    startTimeLab.textAlignment = NSTextAlignmentCenter;
    startTimeLab.font = [UIFont boldSystemFontOfSize:14];
    startTimeLab.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
    endTimeLab.text = @"结束时间";
    endTimeLab.textAlignment = NSTextAlignmentCenter;
    endTimeLab.font = [UIFont boldSystemFontOfSize:14];
    endTimeLab.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
    
    {
        NSDateComponents *temp = [self updateLabelForTimer];
        
        NSInteger y = [temp year];
        NSInteger m = [temp month];
        NSInteger d = [temp day];
        
        NSInteger hour = [temp hour];
        NSInteger min = [temp minute];
        
        NSInteger week = [temp weekday];
        NSString *weekStr;
        switch (week) {
            case 1:
                weekStr = @"周日";
                break;
            case 2:
                weekStr = @"周一";
                break;
            case 3:
                weekStr = @"周二";
                break;
            case 4:
                weekStr = @"周三";
                break;
            case 5:
                weekStr = @"周四";
                break;
            case 6:
                weekStr = @"周五";
                break;
            case 7:
                weekStr = @"周六";
                break;
                
            default:
                break;
        }
        
        
        //NSString *timeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld   %02ld:%02ld",y,m,d,hour,min];//年月日 时分
        NSString *timeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",y,m,d];
        startTimeField.text =timeStr;
        startTimeField.font = [UIFont systemFontOfSize:14];
        
        //NSString *timeStr2 = [NSString stringWithFormat:@"%ld-%02ld-%02ld   %02ld:%02ld",y,m,d+1,hour,min];//年月日 时分
        NSString *timeStr2 = [NSString stringWithFormat:@"%ld-%02ld-%02ld",y,m,d+1];
        endTimeField.text =timeStr2;
        endTimeField.font = [UIFont systemFontOfSize:14];
        
        [_startDateArray addObject:[NSString stringWithFormat:@"%ld",y]];
        [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",m]];
        [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",d]];
        [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",hour]];
        [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",min]];
        [_startDateArray addObject:weekStr];
        
    }
    
    //年月日
    UUDatePicker *startDatePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, 0, 320, 200) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        [_startDateArray removeAllObjects];
        [_startDateArray addObject:year];
        [_startDateArray addObject:month];
        [_startDateArray addObject:day];
        [_startDateArray addObject:hour];
        [_startDateArray addObject:minute];
        [_startDateArray addObject:weekDay];
        startTimeField.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }];
    
    startDatePicker.ScrollToDate = now;
    startTimeField.inputView = startDatePicker;
    
    
    
    UUDatePicker *endDatePicker
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, 320, 200)
                             PickerStyle:UUDateStyle_YearMonthDay
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 endTimeField.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                             }];
    
    endDatePicker.ScrollToDate = now;
    endTimeField.inputView = endDatePicker;
    
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 1, 1, _cellHeight - 2)];
    lineView.backgroundColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    
    [cell addSubview:startTimeLab];
    [cell addSubview:endTimeLab];
    [cell addSubview:startTimeField];
    [cell addSubview:endTimeField];
    [cell addSubview:lineView];
}

-(NSDateComponents *)updateLabelForTimer {
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dd;
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
    
    
    @try {
        dd = [cal components:unitFlags fromDate:now];
        
        return dd;
        //  NSInteger sec = [dd second];
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        
    }
}

-(void)tapViewAction:(id)sender{
    [taskName resignFirstResponder];
    [executor resignFirstResponder];
    [mTextView resignFirstResponder];
    [startTimeField resignFirstResponder];
    [endTimeField resignFirstResponder];
}

@end
