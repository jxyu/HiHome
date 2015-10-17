//
//  TaskDetailPageViewController.m
//  HiHome
//
//  Created by Rain on 15/10/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TaskDetailPageViewController.h"
#import "UIDefine.h"
#import "BaseTableViewCell.h"

@interface TaskDetailPageViewController (){
    UITableView *mTableView;
}

@end

@implementation TaskDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    //UITableView
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    mTableView.dataSource =self;
    mTableView.delegate = self;
    [self.view addSubview:mTableView];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        //任务状态UILable
        UILabel *taskStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 75, 21)];
        taskStatus.text= @"任务状态:";
        [cell addSubview:taskStatus];
        
        UILabel *taskStatusShow = [[UILabel alloc] initWithFrame:CGRectMake(taskStatus.frame.size.width + 10, 15, 100, 21)];
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
        UITextField *taskName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
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
        UITextField *taskName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
        taskName.textColor = [UIColor grayColor];
        taskName.text = @"自己";
        //左UILabel
        UILabel *leftlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
        leftlbl.textColor = [UIColor grayColor];
        leftlbl.textAlignment = NSTextAlignmentRight;
        leftlbl.text = @"执行人:";
        taskName.leftView = leftlbl;
        taskName.leftViewMode = UITextFieldViewModeAlways;
        
        [cell addSubview:taskName];
    }
    else{
        UILabel *taskStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 21)];
        taskStatus.text= @"任务状态11111";
        [cell addSubview:taskStatus];
    }
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 91;
    }else if(indexPath.row == 3){
        return 80;
    }
    return 50;
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

@end
