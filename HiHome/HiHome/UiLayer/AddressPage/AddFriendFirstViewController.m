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
#import "AddFriendTableViewCell.h"
#import "PersonFirstViewController.h"

@interface AddFriendFirstViewController (){
    DataProvider *dataProvider;
    AddFriendSecondViewController *addFriendSecondVC;
    UITextField *mUserNumber;
    UILabel *detail1;
    UIButton *detail2;
    UILabel *detail3;
    UITableView *mTableView;
    NSMutableArray *searchFriendArray;
    PersonFirstViewController *personFirstVC;
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
    mUserNumber.keyboardType = UIKeyboardTypeNumberPad;//设置键盘为数字键盘
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
    
    detail1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 74 + mUserNumber.frame.size.height + 50, SCREEN_WIDTH - 20, 21)];
    detail1.textColor = [UIColor grayColor];
    detail1.textAlignment = NSTextAlignmentCenter;
    detail1.text = @"没有找到符合搜索条件的用户";
    detail1.hidden = YES;
    [self.view addSubview:detail1];
    
    detail2 = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 175) / 2, detail1.frame.origin.y + detail1.frame.size.height + 10, 175, 21)];
    [detail2 setTitle:@"点击此处邀请好友加入" forState:UIControlStateNormal];
    detail2.titleLabel.font = [UIFont systemFontOfSize:17];
    [detail2 setTitleColor:[UIColor colorWithRed:0.92 green:0.47 blue:0.35 alpha:1] forState:UIControlStateNormal];
    detail2.hidden = YES;
    [self.view addSubview:detail2];
    
    detail3 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 170) / 2, detail2.frame.origin.y + detail2.frame.size.height, 170, 1)];
    detail3.backgroundColor = [UIColor colorWithRed:0.92 green:0.47 blue:0.35 alpha:1];
    detail3.hidden = YES;
    [self.view addSubview:detail3];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, SCREEN_HEIGHT - 120)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    
    mTableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchAction:(id)sender {
    if ([mUserNumber.text isEqual:@""]) {
        return;
    }
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"searchContacterBackCall:"];
    [dataProvider getContacterByPhone:mUserNumber.text];
    
}

-(void)searchContacterBackCall:(id)dict{
    NSLog(@"%@",dict);
    [mUserNumber resignFirstResponder];
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        searchFriendArray = (NSMutableArray *)[[dict objectForKey:@"datas"] objectForKey:@"list"];
        [mTableView reloadData];
//        addFriendSecondVC = [[AddFriendSecondViewController alloc] init];
//        addFriendSecondVC.mContacterID = [[personDetailDict valueForKey:@"id"][0] isEqual:[NSNull null]]?@"":[personDetailDict valueForKey:@"id"][0];
//        addFriendSecondVC.mHeaderImgTxt = @"me";
//        addFriendSecondVC.mNameTxt = [[personDetailDict valueForKey:@"nick"][0] isEqual: [NSNull null]]?@"":[personDetailDict valueForKey:@"nick"][0];
//        addFriendSecondVC.mSexTxt = [[personDetailDict valueForKey:@"sex"][0] isEqual:[NSNull null]]?@"":[personDetailDict valueForKey:@"sex"][0];
//        
//        addFriendSecondVC.navTitle = @"添加好友";
//        [self.navigationController pushViewController:addFriendSecondVC animated:NO];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    }else{
        NSLog(@"访问服务器失败！");
        detail1.hidden = NO;
        detail2.hidden = NO;
        detail3.hidden = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchFriendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"AddFriendCellIdentifier";
    AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddFriendTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *avatar = [searchFriendArray[indexPath.row][@"avatar"] isEqual:[NSNull null]]?@"":searchFriendArray[indexPath.row][@"avatar"];
    NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
    [cell.mHeadImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
    cell.mName.text = [searchFriendArray[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":searchFriendArray[indexPath.row][@"nick"];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    personFirstVC = [[PersonFirstViewController alloc] init];
    personFirstVC.mIFlag = @"1";
    personFirstVC.navTitle = @"好友资料";
    personFirstVC.mFriendID = [searchFriendArray[indexPath.row][@"id"] isEqual:[NSNull null]]?@"":searchFriendArray[indexPath.row][@"id"];
    personFirstVC.mHeadImg = [searchFriendArray[indexPath.row][@"avatar"] isEqual:[NSNull null]]?@"":searchFriendArray[indexPath.row][@"avatar"];
    personFirstVC.mName = [searchFriendArray[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":searchFriendArray[indexPath.row][@"nick"];
    personFirstVC.mSex = [searchFriendArray[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":searchFriendArray[indexPath.row][@"sex"];
    personFirstVC.mAge = [searchFriendArray[indexPath.row][@"age"] isEqual:[NSNull null]]?@"":searchFriendArray[indexPath.row][@"age"];
    personFirstVC.mSign = [searchFriendArray[indexPath.row][@"sign"] isEqual:[NSNull null]]?@"":searchFriendArray[indexPath.row][@"sign"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    
    [self.navigationController pushViewController:personFirstVC animated:NO];
}

@end
