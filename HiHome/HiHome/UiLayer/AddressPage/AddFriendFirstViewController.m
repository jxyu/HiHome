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
    UITextField *mUserNumber;
}

@end

@implementation AddFriendFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    mUserNumber = [[UITextField alloc] initWithFrame:CGRectMake(8, 74, SCREEN_WIDTH - 16 - 70, 40)];
    mUserNumber.delegate = self;
    mUserNumber.borderStyle = UITextBorderStyleRoundedRect;
    mUserNumber.placeholder = @"请输入用户手机号";
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
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"searchContacterBackCall:"];
    [dataProvider getContacterByPhone:mUserNumber.text];
    
}

-(void)searchContacterBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSArray *personDetailDict;
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        personDetailDict = (NSArray *)[[dict objectForKey:@"datas"] objectForKey:@"list"];
    }else{
        NSLog(@"访问服务器失败！");
    }
    addFriendSecondVC = [[AddFriendSecondViewController alloc] init];
    addFriendSecondVC.mContacterID = [[personDetailDict valueForKey:@"id"][0] isEqual:[NSNull null]]?@"":[personDetailDict valueForKey:@"id"][0];
    addFriendSecondVC.mHeaderImgTxt = @"me";
    addFriendSecondVC.mNameTxt = [[personDetailDict valueForKey:@"nick"][0] isEqual: [NSNull null]]?@"":[personDetailDict valueForKey:@"nick"][0];
    addFriendSecondVC.mSexTxt = [[personDetailDict valueForKey:@"sex"][0] isEqual:[NSNull null]]?@"":[personDetailDict valueForKey:@"sex"][0];
    
    addFriendSecondVC.navTitle = @"添加好友";
    [self presentViewController:addFriendSecondVC animated:NO completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
