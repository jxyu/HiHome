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
    return 3;
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
        mUserLbl.text = @"唐嫣   女";
        [cell addSubview:mUserLbl];
    }else if(indexPath.section == 1){
        UITextField *mRemark = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 40)];
        mRemark.delegate = self;
        mRemark.placeholder = @"请输入备注信息";
        UILabel *mLeftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, cell.frame.size.height)];
        mLeftLbl.text = @"备注信息:";
        mRemark.leftView = mLeftLbl;
        mRemark.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:mRemark];
    }else{
        cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        
        UIButton *mAddFriendBtn =[[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20, 40)];
        [mAddFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        [mAddFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        mAddFriendBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0.57 blue:0.48 alpha:1];
        [mAddFriendBtn addTarget:self action:@selector(addFriendEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:mAddFriendBtn];
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
    }else if(indexPath.section == 1){
        return 50;
    }
    return SCREEN_HEIGHT - 64 -3 * 10 - 100 - 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)addFriendEvent:(id)sender{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"addFriendBackCall:"];
    [dataProvider addFriend:@"8" andUserID:@"10" andRemark:@"12333"];
}

-(void)addFriendBackCall:(id)dict{
    NSLog(@"%@",dict);
}

@end
