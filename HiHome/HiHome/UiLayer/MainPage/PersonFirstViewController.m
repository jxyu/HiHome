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
}

@end

@implementation PersonFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
}

-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    [self.view addSubview:mTableView];
    
    mTableView.tableFooterView = [[UIView alloc] init];
}

-(void)initData{
    cellHeight = SCREEN_HEIGHT / 11;
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetInfoBackCall:"];
    [dataprovider GetUserInfoWithUid:[self getUserID]];
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
        mDetail.text = [NSString stringWithFormat:@"%@   %@   %@",[userInfoArray[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":userInfoArray[indexPath.row][@"nick"],[userInfoArray[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":userInfoArray[indexPath.row][@"sex"],@"22"];//@"唐嫣  女  21岁";
        [cell addSubview:mDetail];
    }else if(indexPath.row == 1){
        UITextField *accountInfo = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, cellHeight)];
        accountInfo.text = @"123456789";
        accountInfo.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.54 alpha:1];
        UILabel *accountInfoLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
        accountInfoLeftLabel.text = @"账号信息:";
        accountInfoLeftLabel.textColor = [UIColor colorWithRed:0.62 green:0.41 blue:0.24 alpha:1];
        accountInfo.leftView = accountInfoLeftLabel;
        accountInfo.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:accountInfo];
    }else if(indexPath.row == 2){
        UITextField *gxqm = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, cellHeight)];
        gxqm.text = @"做自己喜欢的事情";
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
        UIButton *editInfo = [[UIButton alloc] initWithFrame:CGRectMake(10, cell.frame.size.height - 10, SCREEN_WIDTH - 20, 40)];
        [editInfo addTarget:self action:@selector(btnEditInfo:) forControlEvents:UIControlEventTouchUpInside];
        editInfo.layer.borderWidth = 1;
        editInfo.layer.borderColor = [UIColor colorWithRed:0.94 green:0.56 blue:0.46 alpha:1].CGColor;
        [editInfo setTitle:@"编辑资料" forState:UIControlStateNormal];
        [editInfo setTitleColor:[UIColor colorWithRed:0.94 green:0.56 blue:0.46 alpha:1] forState:UIControlStateNormal];
        [cell addSubview:editInfo];
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
    [mTableView reloadData];
}

-(void)btnEditInfo:(id)sender{
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    [self presentViewController:userInfoVC animated:NO completion:^{}];
}

@end
