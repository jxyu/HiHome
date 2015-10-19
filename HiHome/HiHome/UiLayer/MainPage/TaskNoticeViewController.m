//
//  TaskNoticeViewController.m
//  HiHome
//
//  Created by Rain on 15/10/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TaskNoticeViewController.h"

@interface TaskNoticeViewController (){
    UITableView *mTableView;
    NSInteger selectSectionIndex;
}

@end

@implementation TaskNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    [self.view addSubview:mTableView];
}

-(void)initData{
    selectSectionIndex = -1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)selectSectionIndex);
    NSString *CellIdentifier = @"TaskNoticeCellIdentifier";
    if (indexPath.section == selectSectionIndex) {
        SelectTaskNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectTaskNoticeCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.mImageView.image = [UIImage imageNamed:@"xueren.png"];
        cell.mReleaseTaskPerson.text = @"小雪人";
        cell.mStartDate.text = @"01/04";
        cell.mEndDate.text = [NSString stringWithFormat:@"~%@",@"04/05"];
        cell.mDoing.text = @"去超市买东西";
        cell.mRemind.text = @"10分钟前";
        cell.mRepeat.text = @"重复";
        cell.mExecutor.text = @"仅自己";
        //接受任务
        cell.mReceive.layer.masksToBounds = YES;
        cell.mReceive.layer.borderWidth = 1;
        cell.mReceive.layer.borderColor = [UIColor colorWithRed:0.01 green:0.81 blue:0.59 alpha:1].CGColor;
        cell.mReceive.layer.cornerRadius = 10;
        cell.mReceive.backgroundColor = [UIColor colorWithRed:0.01 green:0.81 blue:0.59 alpha:1];
        [cell.mReceive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.mReceive setTitle:@"接受任务" forState:UIControlStateNormal];
        //拒绝任务
        cell.mReject.layer.masksToBounds = YES;
        cell.mReject.layer.borderWidth = 1;
        cell.mReject.layer.borderColor = [UIColor colorWithRed:0.92 green:0.33 blue:0.07 alpha:1].CGColor;
        cell.mReject.layer.cornerRadius = 10;
        [cell.mReject setTitleColor:[UIColor colorWithRed:0.92 green:0.33 blue:0.07 alpha:1] forState:UIControlStateNormal];
        [cell.mReject setTitle:@"拒绝任务" forState:UIControlStateNormal];
        
        return cell;
    }else{
        TaskNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskNoticeTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.mImageView.image = [UIImage imageNamed:@"xueren.png"];
        cell.mReleaseTaskPerson.text = @"小雪人";
        cell.mDate.text = @"2015-10-19";
        cell.mStatus.text = @"待执行";
        cell.mStartDate.text = @"01/04";
        cell.mEndDate.text = [NSString stringWithFormat:@"~%@",@"04/05"];
        cell.mDoing.text = @"去超市买东西";
        cell.mRemind.text = @"10分钟前";
        cell.mRepeat.text = @"重复";
        cell.mExecutor.text = @"仅自己";
        
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectSectionIndex = indexPath.section;
    [tableView reloadData];
}

@end
