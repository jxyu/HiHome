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
#import "TaskPath.h"
#import "DataProvider.h"
#import "SVProgressHUD.h"
#import "JKAlertDialog.h"
#import "UIImageView+WebCache.h"


@interface TaskDetailPageViewController (){
    UITableView *mTableView;
    NSInteger _cellHeight;
    NSMutableArray *_startDateArray;
    
    UITextField *taskName;
    UITextField *executor;
    UITextView *mTextView;
    UILabel *startTimeLabel;
    UILabel *endTimeLabel;
    
    UIButton *btnLeft ;
    UIButton *btnRight;
    NSString *rightBtnStr;
    /*
     *任务参数
     */
    TaskPath *taskPathLocal;
    ZYTaskStatue localTaskStatus;
    
    NSString *TaskId;
    NSString *stateStr; //状态
    NSString *remindStr;//提醒
    NSString *repeatStr;//重复
    NSString *senderNameStr;//发布人
    NSString *taskTitleStr;//任务名
    NSString *taskContentStr;//任务内容
    NSString *startTime;//开始时间
    NSString *endTime;//结束时间
    NSString *btnLeftStr;//左边操作按键
    NSString *btnRightStr;//右边
    
    NSMutableArray *imgSrc;
    NSInteger imgCount;
    
    UIView *showImgView;
    BOOL showImgViewState;
    
}

@end

@implementation TaskDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    taskPathLocal = [[TaskPath alloc] init];
   // self.taskDetailMode = TaskDetail_ReceiveMode;
    _cellHeight = (self.view.frame.size.height-ZY_HEADVIEW_HEIGHT)/11;
    _startDateArray = [[NSMutableArray alloc] init];
    rightBtnStr = @"编辑";
    showImgViewState = false;
    [self initView];
}

-(void)initView{
    //right title button
    [self.mBtnRight setTitle:rightBtnStr forState:UIControlStateNormal];
    
    //UITableView
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    mTableView.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    
    mTableView.dataSource =self;
    mTableView.delegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    mTableView.separatorInset = UIEdgeInsetsZero;
    //下面两句禁止tableview滚动
//    mTableView.scrollEnabled = NO;
//    [mTableView setHidden:NO];
    
    [self.view addSubview:mTableView];
    
    mTableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [mTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [mTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100 -10,_cellHeight+5, 100, _cellHeight -10 -5)];
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(10, _cellHeight+5, 100, _cellHeight -10 -5)];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
    
    showImgView = [[UIView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - ZY_HEADVIEW_HEIGHT)];
    [self.view addGestureRecognizer:tapGesture];
}



-(void)setDatas:(TaskPath *)taskPath
{
    if(taskPath == nil)
        return;
    
    TaskId = taskPath.taskID ;
    
    taskPathLocal = taskPath;
    
    localTaskStatus = taskPath.taskStatus;
    [self setBtnStr:taskPath.taskStatus];
    
    repeatStr = [self modeValueToStr:Mode_Repeat andValue:taskPath.repeatMode];
    remindStr = [self modeValueToStr:Mode_Remind andValue:taskPath.remindTime];
    stateStr = [self modeValueToStr:Mode_state andValue:taskPath.taskStatus];
    
    senderNameStr = taskPath.taskOwner;
    taskTitleStr = taskPath.taskName;
    taskContentStr = taskPath.taskContent;
    
    startTime = taskPath.startTaskDateStr;
    endTime   = taskPath.endTaskDateStr;
    if(imgSrc ==nil)
        imgSrc = [NSMutableArray array];
    else
    {
        if(imgSrc.count!=0)
            [imgSrc removeAllObjects];
    }
    NSLog(@"taskPath.imgSrc.count = %ld",taskPath.imgSrc.count);
    for (int i = 0; i < taskPath.imgSrc.count; i++) {
        
        NSLog(@"i = %d [%@]",i,[taskPath.imgSrc objectAtIndex:i]);
        
        [imgSrc addObject:[taskPath.imgSrc objectAtIndex:i]];
    }
    
    imgCount = imgSrc.count;
    NSLog(@"imgCount1 = %ld",imgCount);
    
    
    [mTableView reloadData];
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (indexPath.row == 0) {
         cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight*2);
        
        //任务状态UILable
        UILabel *taskStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, _cellHeight - 10-5)];
        taskStatus.text= @"任务状态:";
        [cell addSubview:taskStatus];
        
        UILabel *taskStatusShow = [[UILabel alloc] initWithFrame:CGRectMake(taskStatus.frame.size.width + 15, 10, 100, _cellHeight - 10 - 5)];
        taskStatusShow.contentMode = UIViewContentModeLeft;
        taskStatusShow.textColor = ZY_UIBASECOLOR;
        taskStatusShow.text= stateStr;
        [cell addSubview:taskStatusShow];
        
        //UIButon
        if(btnLeftStr != nil)
        {

           
            btnLeft.layer.masksToBounds = YES;
            btnLeft.layer.borderWidth = 1;
            btnLeft.layer.borderColor = [ZY_UIBASECOLOR CGColor];
            btnLeft.layer.cornerRadius = 8;
            
            [btnLeft setTitle:btnLeftStr forState:UIControlStateNormal];
            [btnLeft setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
            
            [btnLeft addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:btnLeft];
        }
        if(btnRightStr != nil)
        {
            
            btnRight.layer.masksToBounds = YES;
            btnRight.layer.borderWidth = 1;
            btnRight.layer.borderColor = [ZY_UIBASECOLOR CGColor];
            btnRight.layer.cornerRadius = 8;
            [btnRight setTitle:btnRightStr forState:UIControlStateNormal];
            [btnRight setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
            
            [btnRight addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:btnRight];
        }
    }
    else if(indexPath.row == 1){
        
        UILabel *head = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, _cellHeight - 10*2)];
        head.text =@"发布人:";
        
        UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+head.frame.size.width+5,5,_cellHeight -10  , _cellHeight - 10 )];
        
        headImgView.image = [UIImage imageNamed:@"me"];
        headImgView.layer.cornerRadius = headImgView.frame.size.width * 0.5;
        headImgView.layer.borderWidth = 0.1;
        headImgView.layer.masksToBounds = YES;
        
        UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(headImgView.frame.origin.x+headImgView.frame.size.width + 10, 10, 200, _cellHeight - 10*2)];
        userName.text = senderNameStr;//发布人
        userName.textColor = [UIColor grayColor];
        userName.font = [UIFont systemFontOfSize:14];
        
        [cell addSubview:headImgView];
        [cell addSubview:head];
        [cell addSubview:userName];
        
    }
    else if(indexPath.row == 2){
        taskName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
        taskName.textColor = [UIColor grayColor];
        taskName.text = taskTitleStr;
//        taskName.font = [UIFont systemFontOfSize:14];
        taskName.enabled = NO;
        //左UILabel
        UILabel *leftlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
        leftlbl.text = @"任务名称:";
        taskName.leftView = leftlbl;
        taskName.leftViewMode = UITextFieldViewModeAlways;
        
        [cell addSubview:taskName];
    }else if(indexPath.row == 3){
        executor = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
        executor.textColor = [UIColor grayColor];
        executor.text = @"自己";
//        executor.font = [UIFont systemFontOfSize:14];
        executor.enabled = NO;
        //左UILabel
        UILabel *leftlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
        leftlbl.textAlignment = NSTextAlignmentLeft;
        leftlbl.text = @"执行人:";
        executor.leftView = leftlbl;
        executor.leftViewMode = UITextFieldViewModeAlways;
        
        [cell addSubview:executor];
    }else if(indexPath.row == 4){
        mTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 80)];
        mTextView.textColor = [UIColor grayColor];
        mTextView.font = [UIFont systemFontOfSize:16];
        mTextView.text = taskContentStr;
        mTextView.editable = NO;
        [cell addSubview:mTextView];
    }else if(indexPath.row == 5){
        NSLog(@"imgCount = %ld",imgCount);
        
       // [self createDate:cell];
        for (int i=0; i<imgCount; i++) {
            UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*(_cellHeight - 6 +5), 1, _cellHeight - 3, _cellHeight - 3)];
            imgBtn.backgroundColor = [UIColor blueColor];
            
            NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[imgSrc objectAtIndex:i]];
            NSLog(@"img url = [%@]",url);
            UIImageView * img_avatar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _cellHeight - 3, _cellHeight - 3)];
            [img_avatar sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
//            img_avatar.layer.masksToBounds=YES;
//            img_avatar.layer.cornerRadius=_cellHeight - 3/2;
//            img_avatar.layer.borderWidth=0.5;
//            img_avatar.layer.borderColor=ZY_UIBASECOLOR.CGColor;
//            [btn_selectImg addSubview:img_avatar];

            imgBtn.tag = ZY_UIBUTTON_TAG_BASE + i;
            [imgBtn addTarget:self action:@selector(clickImgBtns:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addSubview:img_avatar];
            
            [cell addSubview:imgBtn];
            
        }
        
    }
    else if(indexPath.row == 6){
        // [self createDate:cell];
        
       [self showDate:cell];
    }
    else if(indexPath.row == 7){
       
        
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
        [remindBtn setTitle:remindStr forState:UIControlStateNormal];
        [remindBtn setTitleColor:[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1] forState:UIControlStateNormal];
        remindBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        remindBtn.imageView.contentMode = UIViewContentModeCenter;
        remindBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [repeatBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        [repeatBtn setImage:[UIImage imageNamed:@"repeat_2"] forState:UIControlStateNormal];
        [repeatBtn setTitle:repeatStr forState:UIControlStateNormal];
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
    
    switch (indexPath.row) {
        case 0:
        case 3:
        case 4:
            return _cellHeight*2;
        case 1:
        case 2:
        case 5:
        case 6:
            return _cellHeight;
        case 7:
            return _cellHeight*2+50;
        default:
            break;
    }
    
    return _cellHeight;
}

#pragma mark - btn actions

-(void)clickBtns:(UIButton *)sender
{
    NSLog(@"click choose contact btn");
}

-(void)clickImgBtns:(UIButton *)sender
{
    if(showImgViewState == false)
    {
        showImgView.alpha = 0.5;
        showImgView.backgroundColor = [UIColor blackColor];
        
        if(sender.tag - ZY_UIBUTTON_TAG_BASE > imgSrc.count-1)
            return;
        
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[imgSrc objectAtIndex:(sender.tag - ZY_UIBUTTON_TAG_BASE)]];
        UIImageView * img_avatar=[[UIImageView alloc] initWithFrame:CGRectMake(50, ZY_HEADVIEW_HEIGHT+50, SCREEN_WIDTH - 100, SCREEN_HEIGHT - ZY_HEADVIEW_HEIGHT -100)];
        [img_avatar sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
        img_avatar.contentMode =UIViewContentModeScaleAspectFit;
        
        [self.view addSubview:showImgView];
        [self.view addSubview:img_avatar];
        [self.view bringSubviewToFront:img_avatar];
        showImgViewState = true;
    }
}


-(void)clickLeftButton:(UIButton *)sender
{
    ZYTaskStatue oldTaskStatus;
    
    oldTaskStatus = localTaskStatus;
    
    switch (localTaskStatus) {
        case State_unreceive:
        case State_received://不现实已完成 直接显示待执行
            stateStr = @"待执行";
            localTaskStatus = State_needDo;
            break;
        case State_needDo:
            stateStr = @"执行中";
            localTaskStatus ++;
            break;
        case State_onGoing:
            stateStr = @"已完成";
            localTaskStatus ++;
            break;
        case State_finish:
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"删除" message:[NSString stringWithFormat:@"是否删除?"]];
            
            alert.alertType = AlertType_Alert;
            [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item){
                NSLog(@"Click ok");
                
                [self delTask:TaskId];
                
                
            }];
            
            //    typedef void(^JKAlertDialogHandler)(JKAlertDialogItem *item);
            [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item){
                NSLog(@"Click canel");
                
            }];
            [alert show];
            
        }

            return;//如果已是完成状态 则再按删除任务
        //    btnLeftStr = @"删除任务";
        //    btnRightStr = nil;//设置成nil则btn不显示
            break;
        case State_cancel:
            btnLeftStr = @"删除任务";
            stateStr = nil;
            localTaskStatus  = State_received;

           // btnRightStr = @"删除任务";
            break;
            
        default:
            break;
    }
    
    
    [self setTaskState:[NSString stringWithFormat:@"%ld",(long)localTaskStatus]];//上传状态
    
}


-(void)clickRightButton:(UIButton *)sender
{
    switch (localTaskStatus) {

        case State_received://取消
        case State_needDo://取消
        case State_onGoing://取消
            [self setTaskState:[NSString stringWithFormat:@"%ld",(long)State_cancel]];//上传状态
            break;
        case State_finish://删除
        case State_unreceive://删除
        case State_cancel://删除
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"删除" message:[NSString stringWithFormat:@"是否删除?"]];
            
            alert.alertType = AlertType_Alert;
            [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item){
                NSLog(@"Click ok");
    
                [self delTask:TaskId];
                        

            }];
            
            //    typedef void(^JKAlertDialogHandler)(JKAlertDialogItem *item);
            [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item){
                NSLog(@"Click canel");
                
            }];
            [alert show];

        }
            break;
            
        default:
            break;
    }
}




-(void)delTask:(NSString *)taskID
{
    
    NSLog(@"del task datas");
    
    [SVProgressHUD showWithStatus:@"删除中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"delTaskCallBack:"];
    
    [dataprovider delTask:taskID];
}



-(void)delTaskCallBack:(id)dict
{
    
    NSInteger code;
    [SVProgressHUD dismiss];
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"删除失败"]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        return;
    }
    //[self loadTaskDetails:TaskId];
    
    [self quitView];

}




-(void)setTaskState:(NSString *)state
{
    NSLog(@"start update state");
   [SVProgressHUD showWithStatus:@"更新数据" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"setTaskStateCallBack:"];
    NSLog(@"Task id  =%@",TaskId);
    [dataprovider ChangeTaskState:TaskId andState:state];
}


-(void)setTaskStateCallBack:(id)dict
{
    NSInteger code;

    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    NSLog(@" update state callBack");
    
    NSLog(@"dict = %@",dict);
    
    if(code!=200)
    {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"状态提交失败:%ld",(long)code]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        return;
    }
    
    
    
//    [self setBtnStr:localTaskStatus];
    [self loadTaskDetails:TaskId];
   
}


-(void)loadTaskDetails:(NSString *)taskID
{
    NSLog(@"load task Details");
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"taskDetailCallBack:"];
    
    [dataprovider getTaskInfo:taskID];
}


-(void)taskDetailCallBack:(id)dict
{
    
    NSInteger code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    NSDictionary *taskDetailDict;
    TaskPath *taskDetailPath = [[TaskPath alloc] init];
    
    if(code!=200)
    {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"任务详情获取失败:%ld",(long)code]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        return;
    }
    
    NSLog(@"task detail dict = [%@]",dict);
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        taskDetailDict = [(NSArray *)[dict objectForKey:@"datas"] objectAtIndex:0];
    }
    else
    {
        NSLog(@"datas = NULL");
    }
    
    taskDetailPath.taskContent = [taskDetailDict objectForKey:@"content"];
    taskDetailPath.taskStatus = (ZYTaskStatue)[(NSString *)[taskDetailDict objectForKey:@"state"] integerValue];
    taskDetailPath.taskOwner = [taskDetailDict objectForKey:@"uid"];
    taskDetailPath.taskName = [taskDetailDict objectForKey:@"title"];
    taskDetailPath.repeatMode = (ZYTaskRepeat)[(NSString *)[taskDetailDict objectForKey:@"repeat"] integerValue];
    taskDetailPath.remindTime = (ZYTaskRemind)[(NSString *)[taskDetailDict objectForKey:@"tip"] integerValue];
    taskDetailPath.startTaskDateStr =[taskDetailDict objectForKey:@"start"];
    taskDetailPath.endTaskDateStr =[taskDetailDict objectForKey:@"end"];
    taskDetailPath.taskID =[taskDetailDict objectForKey:@"id"];
    
    if(taskDetailPath.imgSrc.count > 0)
    {
        [taskDetailPath.imgSrc removeAllObjects];
    }
    
    if(![[taskDetailDict objectForKey:@"imgsrc1"] isEqualToString:@""])
    {
        [taskDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc1"]];
    }
    if(![[taskDetailDict objectForKey:@"imgsrc2"] isEqualToString:@""])
    {
        [taskDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc2"]];
    }
    if(![[taskDetailDict objectForKey:@"imgsrc3"] isEqualToString:@""])
    {
        [taskDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc3"]];
    }

    //  [self setTaskDetails];
    
    [self setDatas:taskDetailPath];
    
    [SVProgressHUD dismiss];
    [mTableView reloadData];
    
}


-(TaskPath *)setTaskDetails
{
    TaskPath *tempPath = [[TaskPath alloc] init];
    
    
    return tempPath;
}



-(void)setBtnStr:(NSInteger)state
{
    NSLog(@"state = %ld",(long)state);
    
    switch (state) {
        case State_unreceive:
            btnLeftStr = @"接受任务";
            btnRightStr = @"删除任务";
            break;
        case State_received:
            btnLeftStr = @"开始执行";
            btnRightStr = @"取消任务";
            break;
        case State_needDo:
            btnLeftStr = @"开始执行";
            btnRightStr = @"取消任务";
            break;
        case State_onGoing:
            btnLeftStr = @"标记完成";
            btnRightStr = @"取消任务";
            break;
        case State_finish:
            btnLeftStr = @"删除任务";
            btnRightStr = nil;//设置成nil则btn不显示
            break;
        case State_cancel:
//            btnLeftStr = @"接受任务";
//            btnRightStr = @"删除任务";
            btnLeftStr = @"删除任务";
            btnRightStr = nil;
            break;
            
        default:
            break;
    }
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

-(void)btnRightClick:(id)sender
{
    NSLog(@"编辑 TaskDetail_MyMode = %d",self.taskDetailMode);
    if(self.taskDetailMode == TaskDetail_MyMode)
    {
        if([rightBtnStr isEqualToString:@"编辑"])
        {
            mTextView.editable = YES;
            taskName.enabled = YES;
            rightBtnStr = @"完成";
            [taskName becomeFirstResponder];
            
        }
        else if([rightBtnStr isEqualToString:@"完成"])
        {
            mTextView.editable = NO;
            taskName.enabled = NO;
            rightBtnStr = @"编辑";
        }
        
        [self.mBtnRight setTitle:rightBtnStr forState:UIControlStateNormal];
    }
        
}

-(void)setTaskDetailMode:(TaskDetailMode)taskDetailMode
{
    _taskDetailMode = taskDetailMode;
    if(_taskDetailMode != TaskDetail_MyMode)
    {
        self.mBtnRight.hidden = YES;
    }
    else
    {
        self.mBtnRight.hidden = NO;
    }
}

-(void)showDate:(UITableViewCell *) cell
{
    
    UILabel *startTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, _cellHeight/2)];
    UILabel *endTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, _cellHeight/2)];
//    
    startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _cellHeight/2, self.view.frame.size.width/2, _cellHeight/2)];
    endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, _cellHeight/2, self.view.frame.size.width/2, _cellHeight/2)];
    
    startTimeLabel.textAlignment = NSTextAlignmentCenter;
    startTimeLabel.text = startTime;
    startTimeLabel.font = [UIFont systemFontOfSize:14];
    endTimeLabel.font = [UIFont systemFontOfSize:14];
    endTimeLabel.textAlignment = NSTextAlignmentCenter;
    endTimeLabel.text= endTime;
//
    startTimeLab.text = @"开始时间";
    startTimeLab.textAlignment = NSTextAlignmentCenter;
    startTimeLab.font = [UIFont boldSystemFontOfSize:14];
    startTimeLab.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
    endTimeLab.text = @"结束时间";
    endTimeLab.textAlignment = NSTextAlignmentCenter;
    endTimeLab.font = [UIFont boldSystemFontOfSize:14];
    endTimeLab.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 1, 1, _cellHeight - 2)];
    lineView.backgroundColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    
    [cell addSubview:startTimeLab];
    [cell addSubview:endTimeLab];
    [cell addSubview:startTimeLabel];
    [cell addSubview:endTimeLabel];
    [cell addSubview:lineView];
}


-(void)createDate:(UITableViewCell *) cell{
    NSDate *now = [NSDate date];
    
    UILabel *startTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, _cellHeight/2)];
    UILabel *endTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, _cellHeight/2)];
    
    UITextField * startTimeField = [[UITextField alloc] initWithFrame:CGRectMake(0, _cellHeight/2, self.view.frame.size.width/2, _cellHeight/2)];
    UITextField * endTimeField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, _cellHeight/2, self.view.frame.size.width/2, _cellHeight/2)];
    
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
        NSString *timeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)y,(long)m,d];
        startTimeField.text =timeStr;
        startTimeField.font = [UIFont systemFontOfSize:14];
        
        //NSString *timeStr2 = [NSString stringWithFormat:@"%ld-%02ld-%02ld   %02ld:%02ld",y,m,d+1,hour,min];//年月日 时分
        NSString *timeStr2 = [NSString stringWithFormat:@"%ld-%02ld-%02ld",y,m,d+1];
        endTimeField.text =timeStr2;
        endTimeField.font = [UIFont systemFontOfSize:14];
        
        [_startDateArray addObject:[NSString stringWithFormat:@"%ld",(long)y]];
        [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",(long)m]];
        [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",(long)d]];
        [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",(long)hour]];
        [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",(long)min]];
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
    
    if(showImgViewState == true)
    {
        showImgViewState = false;
        
        [showImgView removeFromSuperview];
        [[self.view.subviews objectAtIndex:(self.view.subviews.count-1)] removeFromSuperview];//移除图片展示view
    }
    else
    {
        [taskName resignFirstResponder];
        [executor resignFirstResponder];
        [mTextView resignFirstResponder];

    }
//    [startTimeField resignFirstResponder];
//    [endTimeField resignFirstResponder];
}

@end
