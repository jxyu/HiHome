//
//  AddFriendFirstViewController.m
//  HiHome
//
//  Created by Rain on 15/10/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AddFriendFirstViewController.h"
#import "AddFriendSecondViewController.h"
#import "DataProvider.h"
#import "AddFriendSecondViewController.h"

@interface AddFriendFirstViewController (){
    DataProvider *dataProvider;
    AddFriendSecondViewController *addFriendSecondVC;
}

@end

@implementation AddFriendFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    UITextField *mUserNumber = [[UITextField alloc] initWithFrame:CGRectMake(8, 74, SCREEN_WIDTH - 16 - 70, 40)];
    mUserNumber.delegate = self;
    mUserNumber.borderStyle = UITextBorderStyleRoundedRect;
    mUserNumber.placeholder = @"请输入用户序列号";
    UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *search_img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2.5, 25, 25)];
    search_img.contentMode = UIViewContentModeCenter;
    search_img.image = [UIImage imageNamed:@"search_img"];
    [mView addSubview:search_img];
    mUserNumber.leftView = mView;
    mUserNumber.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:mUserNumber];
    
    UIButton *mSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(8 + mUserNumber.frame.size.width + 10,74, 60, 40)];
    [mSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mSearchBtn setTitle:@"查找" forState:UIControlStateNormal];
    mSearchBtn.backgroundColor = [UIColor colorWithRed:0.92 green:0.35 blue:0.14 alpha:1];
    [mSearchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mSearchBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchAction:(id)sender {
    NSString *userID = [self getUserID];
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"searchContacterBackCall:"];
    [dataProvider getContacterByPhone:@"15165561652"];
    
}

-(NSString *)getUserID
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    //   NSLog(@"dict = [%@]",userInfoWithFile);
    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID
    
    return  userID;
}

-(void)searchContacterBackCall:(id)dict{
    NSLog(@"%@",dict);
    addFriendSecondVC = [[AddFriendSecondViewController alloc] init];
    addFriendSecondVC.mHeaderImg = @"me";
    addFriendSecondVC.mName = @"唐嫣";
    addFriendSecondVC.mSex = @"女";
    
    addFriendSecondVC.navTitle = @"添加好友";
    [self presentViewController:addFriendSecondVC animated:NO completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
