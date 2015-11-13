//
//  AddFriendSecondViewController.m
//  HiHome
//
//  Created by Rain on 15/10/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AddFriendSecondViewController.h"
#import "UIImage+WM.h"
#import "DataProvider.h"
#import "AddressPageViewController.h"


@interface AddFriendSecondViewController (){
    UITableView *mTableView;
    DataProvider *dataProvider;
}

@end

@implementation AddFriendSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    mTableView.scrollEnabled = NO;
    [self.view addSubview:mTableView];
    
    mTableView.tableFooterView = [[UIView alloc] init];
}

-(void)initData{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        UIImageView *mHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 70 , 70)];
        mHeadImage.image = [[UIImage imageNamed:@"me"] getRoundImage];
        [cell addSubview:mHeadImage];
        
        UILabel *mUserLbl = [[UILabel alloc] initWithFrame:CGRectMake(10 + mHeadImage.frame.size.width + 10, 15 + 35 - 10, 120, 21)];
        mUserLbl.text = [NSString stringWithFormat:@"%@",_mNameTxt];//@"唐嫣   女";
        [cell addSubview:mUserLbl];
    }
//    else if(indexPath.section == 1){
//        UITextField *mRemark = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 40)];
//        mRemark.delegate = self;
//        mRemark.placeholder = @"请输入备注信息";
//        UILabel *mLeftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, cell.frame.size.height)];
//        mLeftLbl.text = @"备注信息:";
//        mRemark.leftView = mLeftLbl;
//        mRemark.leftViewMode = UITextFieldViewModeAlways;
//        [cell addSubview:mRemark];
//    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        if ([_mIFlag isEqual:@"1"]) {
            UIButton *mRejectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, (SCREEN_WIDTH - 30) / 2, 40)];
            [mRejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [mRejectBtn setTitleColor:[UIColor colorWithRed:0.94 green:0.57 blue:0.48 alpha:1] forState:UIControlStateNormal];
            [mRejectBtn addTarget:self action:@selector(rejectBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            mRejectBtn.backgroundColor = [UIColor whiteColor];
            [cell addSubview:mRejectBtn];
            
            UIButton *mAccesstBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + mRejectBtn.frame.size.width + 10, 20, (SCREEN_WIDTH - 30) / 2, 40)];
            [mAccesstBtn setTitle:@"同意" forState:UIControlStateNormal];
            [mAccesstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            mAccesstBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0.57 blue:0.48 alpha:1];
            [mAccesstBtn addTarget:self action:@selector(accessBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:mAccesstBtn];
        }else{
            UIButton *mAddFriendBtn =[[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20, 40)];
            [mAddFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
            [mAddFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            mAddFriendBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0.57 blue:0.48 alpha:1];
            [mAddFriendBtn addTarget:self action:@selector(addFriendEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:mAddFriendBtn];
        }
    }
    
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
//    else if(indexPath.section == 1){
//        return 50;
//    }
    return SCREEN_HEIGHT - 64 -3 * 10 - 100 - 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//拒绝好友事件
-(void)rejectBtnEvent:(id)sender{
    dataProvider = [[DataProvider alloc] init];
    if ([_mType isEqual:@"1"]) {
        [dataProvider setDelegateObject:self setBackFunctionName:@"rejectSpouseApplyBackCall:"];
        [dataProvider handleSpouseApply:_mContacterID andState:@"2"];
    }else if([_mType isEqual:@"2"]){
        [dataProvider setDelegateObject:self setBackFunctionName:@"rejectApplyFriendBackCall:"];
        [dataProvider accessApplyFriend:_mContacterID andStatus:@"2"];
    }
}

-(void)rejectSpouseApplyBackCall:(id)dict{
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拒绝配偶申请～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:NO];
        //设置显示/隐藏tabbar
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)rejectApplyFriendBackCall:(id)dict{
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拒绝好友申请～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:NO];
        //设置显示/隐藏tabbar
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

//同意好友事件
-(void)accessBtnEvent:(id)sender{
    dataProvider = [[DataProvider alloc] init];
    if ([_mType isEqual:@"1"]) {
        [dataProvider setDelegateObject:self setBackFunctionName:@"accessSpouseApplyBackCall:"];
        [dataProvider handleSpouseApply:_mContacterID andState:@"1"];
    }else{
        [dataProvider setDelegateObject:self setBackFunctionName:@"accessApplyFriendBackCall:"];
        [dataProvider accessApplyFriend:_mContacterID andStatus:@"1"];
    }
}

-(void)accessSpouseApplyBackCall:(id)dict{
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"通过配偶申请～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:NO];
        //设置显示/隐藏tabbar
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)accessApplyFriendBackCall:(id)dict{
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"通过好友申请～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:NO];
        //设置显示/隐藏tabbar
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

//添加好友事件
-(void)addFriendEvent:(id)sender{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"addFriendBackCall:"];
    [dataProvider addFriend:_mContacterID andUserID:[self getUserID] andRemark:@"12333"];
}

-(void)addFriendBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加失败～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    [self dismissViewControllerAnimated:NO completion:nil];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
}

@end
