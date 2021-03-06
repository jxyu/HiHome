//
//  TaskNoticeViewController.m
//  HiHome
//
//  Created by Rain on 15/10/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TaskNoticeViewController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"

@interface TaskNoticeViewController (){
    UITableView *mTableView;
    NSInteger selectSectionIndex;
    DataProvider *dataProvider;
    NSMutableArray *mTaskNoticeArray;
    
    NSString *mTaskIFlag;
}

@end

@implementation TaskNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

-(void)initData{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getTaskNoticeBackCall:"];
   // [dataProvider getReceiveTask: andState:nil andMyOrNot:nil andPage:nil andPerPage:nil andDate:nil andStartDate:nil andEndDate:nil];
    
    [dataProvider getReceiveTask:[self getUserID] andMyId:nil andState:nil andMyOrNot:nil andPage:@"1" andPerPage:@"9999" andDate:nil andStartDate:nil andEndDate:nil andAccept:@"1"];
    
}

-(void)getTaskNoticeBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        mTaskNoticeArray = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"datas"] objectForKey:@"list"]];
        [self initView];
    }else{
        NSLog(@"访问服务器失败！");
    }
}

-(NSString *)getUserID
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID
    
    return  userID;
}

-(void)initView{
    selectSectionIndex = -1;
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    [self.view addSubview:mTableView];
    
    mTableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return mTaskNoticeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"TaskNoticeCellIdentifier";
    
    NSString *mStart = [mTaskNoticeArray[indexPath.section][@"start"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"start"];
    if (![mStart isEqual:@""]) {
        mStart = [mStart substringWithRange:NSMakeRange(5, 5)];
        NSRange mRange = [mStart rangeOfString:@"-"];
        if (mRange.location > 0) {
            mStart = [mStart stringByReplacingCharactersInRange:mRange withString:@"/"];
        }
    }
    NSString *mEnd = [mTaskNoticeArray[indexPath.section][@"end"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"end"];
    if (![mEnd isEqual:@""]) {
        mEnd = [mEnd substringWithRange:NSMakeRange(5, 5)];
        NSRange mRange = [mEnd rangeOfString:@"-"];
        if (mRange.location > 0) {
            mEnd = [mEnd stringByReplacingCharactersInRange:mRange withString:@"/"];
        }
    }
    
    if (selectSectionIndex == indexPath.section) {
        SelectTaskNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectTaskNoticeCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSString *avatar = [mTaskNoticeArray[indexPath.section][@"avatar"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"avatar"];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
        cell.mReleaseTaskPerson.text = [mTaskNoticeArray[indexPath.section][@"nick"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"nick"];
        cell.mStartDate.text = mStart;
        cell.mEndDate.text = [NSString stringWithFormat:@"~%@",mEnd];
        cell.mDoing.text = [mTaskNoticeArray[indexPath.section][@"title"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"title"];
        int mTip = [[mTaskNoticeArray[indexPath.section][@"tip"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"tip"] intValue];
        switch (mTip) {
            case 0:
                cell.mRemind.text = @"不提醒";
                break;
            case 1:
                cell.mRemind.text = @"正点";
                break;
            case 2:
                cell.mRemind.text = @"五分钟";
                break;
            case 3:
                cell.mRemind.text = @"十分钟";
                break;
            case 4:
                cell.mRemind.text = @"一小时";
                break;
            case 5:
                cell.mRemind.text = @"一天";
                break;
            case 6:
                cell.mRemind.text = @"三天";
                break;
                
            default:
                break;
        }
        int mRepeat = [[mTaskNoticeArray[indexPath.section][@"repeat"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"repeat"] intValue];
        switch (mRepeat) {
            case 0:
                cell.mRepeat.text = @"不重复";
                break;
            case 1:
                cell.mRepeat.text = @"每天";
                break;
            case 2:
                cell.mRepeat.text = @"每周";
                break;
            case 3:
                cell.mRepeat.text = @"每月";
                break;
            case 4:
                cell.mRepeat.text = @"每年";
                break;
                
            default:
                break;
        }
        int mTasker = [[mTaskNoticeArray[indexPath.section][@"tasker"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"tasker"] intValue];
        if (mTasker > 1) {
            cell.mExecutor.text = [NSString stringWithFormat:@"%d人",mTasker];
        }else{
            cell.mExecutor.text = @"仅自己";
        }
        
        NSString *mState = [mTaskNoticeArray[indexPath.section][@"state"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"state"];
        
        //接受任务
        cell.mReceive.layer.masksToBounds = YES;
        cell.mReceive.layer.borderWidth = 1;
        cell.mReceive.layer.borderColor = [UIColor colorWithRed:0.01 green:0.81 blue:0.59 alpha:1].CGColor;
        cell.mReceive.layer.cornerRadius = 10;
        cell.mReceive.backgroundColor = [UIColor colorWithRed:0.01 green:0.81 blue:0.59 alpha:1];
        [cell.mReceive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        //拒绝任务
        cell.mReject.layer.masksToBounds = YES;
        cell.mReject.layer.borderWidth = 1;
        cell.mReject.layer.borderColor = [UIColor colorWithRed:0.92 green:0.33 blue:0.07 alpha:1].CGColor;
        cell.mReject.layer.cornerRadius = 10;
        [cell.mReject setTitleColor:[UIColor colorWithRed:0.92 green:0.33 blue:0.07 alpha:1] forState:UIControlStateNormal];
        
        
        if ([mState isEqual:@"0"]) {
            mTaskIFlag = @"2";
            [cell.mReceive setTitle:@"接受任务" forState:UIControlStateNormal];
            [cell.mReceive addTarget:self action:@selector(executeTaskEvent) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.mReject setTitle:@"拒绝任务" forState:UIControlStateNormal];
            [cell.mReject addTarget:self action:@selector(cancelTaskEvent) forControlEvents:UIControlEventTouchUpInside];
        }else if([mState isEqual:@"2"]){
            mTaskIFlag= @"3";
            [cell.mReceive setTitle:@"执行任务" forState:UIControlStateNormal];
            [cell.mReceive addTarget:self action:@selector(executeTaskEvent) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.mReject setTitle:@"取消任务" forState:UIControlStateNormal];
            [cell.mReject addTarget:self action:@selector(cancelTaskEvent) forControlEvents:UIControlEventTouchUpInside];

        }else if([mState isEqual:@"3"]){
            mTaskIFlag= @"4";
            [cell.mReceive setTitle:@"标记完成" forState:UIControlStateNormal];
            [cell.mReceive addTarget:self action:@selector(executeTaskEvent) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.mReject setTitle:@"取消任务" forState:UIControlStateNormal];
            [cell.mReject addTarget:self action:@selector(cancelTaskEvent) forControlEvents:UIControlEventTouchUpInside];
        }else if([mState isEqual:@"4"]){
            mTaskIFlag= @"6";
            [cell.mReceive setTitle:@"删除任务" forState:UIControlStateNormal];
            [cell.mReceive addTarget:self action:@selector(executeTaskEvent) forControlEvents:UIControlEventTouchUpInside];
            
            cell.mReject.hidden = YES;
        }else if([mState isEqual:@"5"]){
            mTaskIFlag= @"6";
            [cell.mReceive setTitle:@"删除任务" forState:UIControlStateNormal];
            [cell.mReceive addTarget:self action:@selector(executeTaskEvent) forControlEvents:UIControlEventTouchUpInside];
            
            cell.mReject.hidden = YES;
        }
       
        
        return cell;
    }else{
        TaskNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskNoticeTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
     
        NSString *avatar = [mTaskNoticeArray[indexPath.section][@"avatar"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"avatar"];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
        cell.mReleaseTaskPerson.text = [mTaskNoticeArray[indexPath.section][@"nick"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"nick"];
        NSString *releaseData = [mTaskNoticeArray[indexPath.section][@"addtime"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"addtime"];
        cell.mDate.text = [releaseData substringToIndex:10];
        NSString *mState = [mTaskNoticeArray[indexPath.section][@"state"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"state"];
        if ([mState isEqual:@"0"]) {
            cell.mStatus.text = @"未接受";
        }else if([mState isEqual:@"1"] || [mState isEqual:@"2"]){
            cell.mStatus.text = @"待执行";
        }else if([mState isEqual:@"3"]){
            cell.mStatus.text = @"执行中";
        }else if([mState isEqual:@"4"]){
            cell.mStatus.text = @"已完成";
        }else if([mState isEqual:@"5"]){
            cell.mStatus.text = @"已取消";
        }
        
        cell.mStartDate.text = mStart;
        cell.mEndDate.text = [NSString stringWithFormat:@"~%@",mEnd];
        cell.mDoing.text = [mTaskNoticeArray[indexPath.section][@"title"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"title"];
        int mTip = [[mTaskNoticeArray[indexPath.section][@"tip"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"tip"] intValue];
        switch (mTip) {
            case 0:
                cell.mRemind.text = @"不提醒";
                break;
            case 1:
                cell.mRemind.text = @"正点";
                break;
            case 2:
                cell.mRemind.text = @"五分钟";
                break;
            case 3:
                cell.mRemind.text = @"十分钟";
                break;
            case 4:
                cell.mRemind.text = @"一小时";
                break;
            case 5:
                cell.mRemind.text = @"一天";
                break;
            case 6:
                cell.mRemind.text = @"三天";
                break;
                
            default:
                break;
        }
        int mRepeat = [[mTaskNoticeArray[indexPath.section][@"repeat"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"repeat"] intValue];
        switch (mRepeat) {
            case 0:
                cell.mRepeat.text = @"不重复";
                break;
            case 1:
                cell.mRepeat.text = @"每天";
                break;
            case 2:
                cell.mRepeat.text = @"每周";
                break;
            case 3:
                cell.mRepeat.text = @"每月";
                break;
            case 4:
                cell.mRepeat.text = @"每年";
                break;
                
            default:
                break;
        }
        int mTasker = [[mTaskNoticeArray[indexPath.section][@"tasker"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[indexPath.section][@"tasker"] intValue];
        if (mTasker > 1) {
            cell.mExecutor.text = [NSString stringWithFormat:@"%d人",mTasker];
        }else{
            cell.mExecutor.text = @"仅自己";
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == selectSectionIndex){
        return 154;
    }else{
        return 108;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)quitView{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectSectionIndex = indexPath.section;
    [tableView reloadData];
}

-(void)executeTaskEvent{
    if ([mTaskIFlag isEqual:@"6"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除任务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        alertView.tag = 2;
        [alertView show];
    }else{
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"executeTaskBackCall:"];
        [dataProvider ChangeTaskState:[mTaskNoticeArray[selectSectionIndex][@"sid"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[selectSectionIndex][@"sid"] andState:mTaskIFlag];
    }
}

-(void)cancelTaskEvent{
    NSString *msg = [mTaskIFlag isEqual:@"2"]?@"确定拒绝任务?":@"确定取消任务?";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = 1;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 1) {
            mTaskIFlag = @"5";
            [self executeTaskEvent];
        }else{
            dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"delTaskBackCall:"];
            [dataProvider delTask:[mTaskNoticeArray[selectSectionIndex][@"id"] isEqual:[NSNull null]]?@"":mTaskNoticeArray[selectSectionIndex][@"id"]];
        }
    }
}

-(void)delTaskBackCall:(id)dict{
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:mTaskNoticeArray];
        [tempArray removeObjectAtIndex:selectSectionIndex];
        mTaskNoticeArray = [[NSMutableArray alloc] initWithArray:tempArray];

        [mTableView reloadData];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

-(void)executeTaskBackCall:(id)dict{
    NSLog(@"%@",mTaskNoticeArray);
    NSInteger code = [dict[@"code"] integerValue];
    
    if (code == 200) {
        if ([mTaskIFlag isEqual:@"2"]) {
            NSMutableDictionary *tempDict = [[mTaskNoticeArray objectAtIndex:selectSectionIndex] mutableCopy];
            [tempDict setValue:@"2" forKey:@"state"];
            NSDictionary * mDict = [[NSDictionary alloc] initWithDictionary:tempDict];
            [mTaskNoticeArray replaceObjectAtIndex:selectSectionIndex withObject:mDict];
            [mTableView reloadSections:[[NSIndexSet alloc]initWithIndex:selectSectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else if([mTaskIFlag isEqual:@"3"]){
            NSMutableDictionary *tempDict = [[mTaskNoticeArray objectAtIndex:selectSectionIndex] mutableCopy];
            [tempDict setValue:@"3" forKey:@"state"];
            NSDictionary * mDict = [[NSDictionary alloc] initWithDictionary:tempDict];
            [mTaskNoticeArray replaceObjectAtIndex:selectSectionIndex withObject:mDict];
            [mTableView reloadSections:[[NSIndexSet alloc]initWithIndex:selectSectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else if ([mTaskIFlag isEqual:@"4"]){
            NSMutableDictionary *tempDict = [[mTaskNoticeArray objectAtIndex:selectSectionIndex] mutableCopy];
            [tempDict setValue:@"4" forKey:@"state"];
            NSDictionary * mDict = [[NSDictionary alloc] initWithDictionary:tempDict];
            [mTaskNoticeArray replaceObjectAtIndex:selectSectionIndex withObject:mDict];
            [mTableView reloadSections:[[NSIndexSet alloc]initWithIndex:selectSectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else if ([mTaskIFlag isEqual:@"5"]){
            NSMutableDictionary *tempDict = [[mTaskNoticeArray objectAtIndex:selectSectionIndex] mutableCopy];
            [tempDict setValue:@"5" forKey:@"state"];
            NSDictionary * mDict = [[NSDictionary alloc] initWithDictionary:tempDict];
            [mTaskNoticeArray replaceObjectAtIndex:selectSectionIndex withObject:mDict];
            [mTableView reloadSections:[[NSIndexSet alloc]initWithIndex:selectSectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
