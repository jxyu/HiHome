//
//  PersonFirstViewController.m
//  HiHome
//
//  Created by Rain on 15/10/22.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PersonFirstViewController.h"
#import "UIImage+WM.h"
#import "UserInfoViewController.h"
#import "DataProvider.h"

@interface PersonFirstViewController (){
    UITableView *mTableView;
    NSInteger cellHeight;
    NSArray *userInfoArray;
    DataProvider *dataProvider;
    UITextField *gxqm;
}

@end

@implementation PersonFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([_mIFlag isEqual:@"1"]) {
        [self initView];
    }else{
        [self initData];
    }
}

-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1];
    [self.view addSubview:mTableView];
    
    mTableView.tableFooterView = [[UIView alloc] init];
}

-(void)initData{
    cellHeight = SCREEN_HEIGHT / 11;
    
    dataProvider=[[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"GetInfoBackCall:"];
    [dataProvider GetUserInfoWithUid:[self getUserID]];
}

-(void)GetInfoBackCall:(id)dict
{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        userInfoArray = (NSArray *)[dict objectForKey:@"datas"];
        NSLog(@"%@",userInfoArray);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    
    if (indexPath.row == 0) {
        UIImageView *mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight * 3)];
        mImageView.image = [UIImage imageNamed:@"person_top_bg"];
        [cell addSubview:mImageView];
        
        UIButton *mHeadImg = [[UIButton alloc] initWithFrame:CGRectMake(10, cellHeight * 1.8 - 5, cellHeight * 1.2, cellHeight * 1.2)];
        [mHeadImg setImage:[[UIImage imageNamed:@"me"] getRoundImage] forState:UIControlStateNormal];
        [cell addSubview:mHeadImg];
        
        UILabel *mDetail = [[UILabel alloc] initWithFrame:CGRectMake(10 + mHeadImg.frame.size.width + 10, mHeadImg.frame.origin.y + mHeadImg.frame.size.height / 2 - 10,SCREEN_WIDTH - 100, 21)];
        mDetail.textColor = [UIColor whiteColor];
        if ([_mIFlag isEqual:@"1"]) {
            mDetail.text = [NSString stringWithFormat:@"%@   %@   %@",_mName,_mSex,_mAge];//@"唐嫣  女  21岁";
        }else{
            mDetail.text = [NSString stringWithFormat:@"%@   %@   %@岁",[userInfoArray[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":userInfoArray[indexPath.row][@"nick"],[userInfoArray[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":userInfoArray[indexPath.row][@"sex"],[userInfoArray[indexPath.row][@"age"] isEqual:[NSNull null]]?@"":userInfoArray[indexPath.row][@"age"]];//@"唐嫣  女  21岁";
        }
        
        [cell addSubview:mDetail];
    }else if(indexPath.row == 1){
        UITextField *accountInfo = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, cellHeight)];
        accountInfo.text = @"123456789";
        accountInfo.enabled = NO;
        accountInfo.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.54 alpha:1];
        UILabel *accountInfoLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
        accountInfoLeftLabel.text = @"账号信息:";
        accountInfoLeftLabel.textColor = [UIColor colorWithRed:0.62 green:0.41 blue:0.24 alpha:1];
        accountInfo.leftView = accountInfoLeftLabel;
        accountInfo.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:accountInfo];
    }else if(indexPath.row == 2){
        gxqm = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, cellHeight)];
        gxqm.enabled = NO;
        if ([_mIFlag isEqual:@"1"]) {
            gxqm.text = _mSign;
        }else{
            gxqm.text = [userInfoArray[0][@"sign"] isEqual:[NSNull null]]?@"":userInfoArray[0][@"sign"];
        }
        gxqm.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.54 alpha:1];
        UILabel *gxqmLeftlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
        gxqmLeftlabel.text = @"个性签名:";
        gxqmLeftlabel.textColor = [UIColor colorWithRed:0.62 green:0.41 blue:0.24 alpha:1];
        gxqm.leftView = gxqmLeftlabel;
        gxqm.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:gxqm];
    }else if(indexPath.row == 3){
        UITextField *jrrw = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, cellHeight)];
        jrrw.text = @"点击查看";
        [jrrw setEnabled:NO];
        jrrw.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.54 alpha:1];
        UILabel *jrrwLeftlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
        jrrwLeftlabel.text = @"今日任务:";
        jrrwLeftlabel.textColor = [UIColor colorWithRed:0.62 green:0.41 blue:0.24 alpha:1];
        jrrw.leftView = jrrwLeftlabel;
        jrrw.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:jrrw];
    }else if(indexPath.row == 4){
        UILabel *xcdt = [[UILabel alloc] initWithFrame:CGRectMake(10, cellHeight - 10, 80, 21)];
        xcdt.text = @"相册动态:";
        xcdt.textColor = [UIColor colorWithRed:0.62 green:0.41 blue:0.24 alpha:1];
        [cell addSubview:xcdt];
        
        UIImageView *mImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10 + xcdt.frame.size.width + 10, 5, cellHeight * 2 - 10, cellHeight * 2 - 10)];
        mImageView1.image = [UIImage imageNamed:@"recentPic"];
        [cell addSubview:mImageView1];
        
        UIImageView *mImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10 + xcdt.frame.size.width + 10 + mImageView1.frame.size.width + 10, 5, cellHeight * 2 - 10, cellHeight * 2 - 10)];
        mImageView2.image = [UIImage imageNamed:@"recentPic"];
        [cell addSubview:mImageView2];
    }else{
        if ([_mIFlag isEqual:@"1"]) {
            cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1];
            UIButton *mAddFriendBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, (SCREEN_WIDTH - 30) / 2, 40)];
            [mAddFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
            [mAddFriendBtn setTitleColor:[UIColor colorWithRed:0.94 green:0.57 blue:0.48 alpha:1] forState:UIControlStateNormal];
            [mAddFriendBtn addTarget:self action:@selector(mAddFriendEvent:) forControlEvents:UIControlEventTouchUpInside];
            mAddFriendBtn.backgroundColor = [UIColor whiteColor];
            [cell addSubview:mAddFriendBtn];
            
            UIButton *mHiBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + mAddFriendBtn.frame.size.width + 10, 20, (SCREEN_WIDTH - 30) / 2, 40)];
            [mHiBtn setTitle:@"打招呼" forState:UIControlStateNormal];
            [mHiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            mHiBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0.57 blue:0.48 alpha:1];
            [mHiBtn addTarget:self action:@selector(mHiEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:mHiBtn];
        }else{
            UIButton *editInfo = [[UIButton alloc] initWithFrame:CGRectMake(10, cell.frame.size.height - 10, SCREEN_WIDTH - 20, 40)];
            [editInfo addTarget:self action:@selector(btnEditInfo:) forControlEvents:UIControlEventTouchUpInside];
            editInfo.layer.borderWidth = 1;
            editInfo.layer.borderColor = [UIColor colorWithRed:0.94 green:0.56 blue:0.46 alpha:1].CGColor;
            [editInfo setTitle:@"编辑资料" forState:UIControlStateNormal];
            [editInfo setTitleColor:[UIColor colorWithRed:0.94 green:0.56 blue:0.46 alpha:1] forState:UIControlStateNormal];
            [cell addSubview:editInfo];
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
    if (indexPath.row == 0) {
        return cellHeight * 3;
    }else if(indexPath.row == 4){
        return cellHeight * 2;
    }else if(indexPath.row == 5){
        return cellHeight * 2;
    }
    return cellHeight;
}

-(void)quitView{
    [self dismissViewControllerAnimated:NO completion:^{}];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}

-(void)viewDidAppear:(BOOL)animated{
    [self initData];
    [mTableView reloadData];
}

-(void)btnEditInfo:(id)sender{
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    userInfoVC.mName = [userInfoArray[0][@"nick"] isEqual:[NSNull null]]?@"":userInfoArray[0][@"nick"];
    userInfoVC.mSex = [userInfoArray[0][@"sex"] isEqual:[NSNull null]]?@"":userInfoArray[0][@"sex"];
    userInfoVC.mSign = [userInfoArray[0][@"sign"] isEqual:[NSNull null]]?@"":userInfoArray[0][@"sign"];
    [self presentViewController:userInfoVC animated:NO completion:^{}];
}

//加为好友
-(void)mAddFriendEvent:(id)sender{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"addFriendBackCall:"];
    [dataProvider addFriend:_mFriendID andUserID:[self getUserID] andRemark:gxqm.text];
}

-(void)addFriendBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

//打招呼
-(void)mHiEvent:(id)sender{
}

@end
