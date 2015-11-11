//
//  MarkFriendViewController.m
//  HiHome
//
//  Created by Rain on 15/10/28.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MarkFriendViewController.h"
#import "DataProvider.h"

@interface MarkFriendViewController (){
    UITableView *mTableView;
    NSIndexPath *oldIndexPath;
    DataProvider *dataProvider;
}

@end

@implementation MarkFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    [self.mBtnRight setTitle:@"发送" forState:UIControlStateNormal];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.scrollEnabled = NO;
    [self.view addSubview:mTableView];
    
    mTableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"普通好友";
        if ([_mType isEqual:@"0"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            oldIndexPath = indexPath;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"星标好友";
        if ([_mType isEqual:@"1"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            oldIndexPath = indexPath;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
//    else{
//        cell.textLabel.text = @"配偶";
//        if ([_mType isEqual:@"2"]) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            oldIndexPath = indexPath;
//        }else{
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//    }
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    //清除原先的选中行状态
    cell = [tableView cellForRowAtIndexPath:oldIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    //设置当前选中的行
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    oldIndexPath = indexPath;
}

//发送
-(void)btnRightClick:(id)sender{
    if (![_mType isEqual:[NSString stringWithFormat:@"%d",(int)oldIndexPath.row]]) {
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"changeFriendType:"];
        [dataProvider changeFriendType:_mFriendID andUserID:[self getUserID] andType:[NSString stringWithFormat:@"%d",(int)oldIndexPath.row]];
    }
}

-(void)changeFriendType:(id)dict{
    NSLog(@"%@",dict);
    int code = [dict[@"code"] intValue];
    if (code == 200) {
        _mType = [NSString stringWithFormat:@"%d",(int)oldIndexPath.row];
        [self dismissViewControllerAnimated:NO completion:^{}];
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
        {
            [self popoverPresentationController];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
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

-(void)quitView{
    [self dismissViewControllerAnimated:NO completion:^{}];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
}

@end
