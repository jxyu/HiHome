//
//  MessageNoticeViewController.m
//  HiHome
//
//  Created by Rain on 15/10/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MessageNotice.h"
#import "DataProvider.h"

@interface MessageNotice (){
    UITableView *mTableView;
    DataProvider *dataProvider;
    NSString *applyName;
    NSString *applySign;
    NSArray *personDetailArray;
}

@end

@implementation MessageNotice

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
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getPriendApplyListBackCall:"];
    [dataProvider getFriendApplyList:[self getUserID]];
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

-(void)getPriendApplyListBackCall:(id)dict{
    NSLog(@"%@",dict);
    
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        personDetailArray = (NSArray *)[[dict objectForKey:@"datas"] objectForKey:@"list"];
    }else{
        NSLog(@"访问服务器失败！");
    }
//    applyFriendArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < personDetailDict.count; i++) {
//        MessageNoticeCell * messageNoticeCell = [[MessageNoticeCell alloc] init];
//        messageNoticeCell.mName.text = @"1";
//        [applyFriendArray addObject:messageNoticeCell];
//    }
    [self initView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return personDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"MessageNoticeCellIdentifier";
    MessageNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageNoticeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.mImageView.image = [UIImage imageNamed:@"me"];
    NSLog(@"%@",personDetailArray[indexPath.row]);
    
    cell.mName.text = [personDetailArray[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"nick"];
    cell.mDetail.text = [personDetailArray[indexPath.row][@"sign"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"sign"];
    [cell.mAccept addTarget:self action:@selector(accessEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mAccept setTitle:@"同意" forState:UIControlStateNormal];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    
    return cell;
}

-(void)accessEvent:(id)sender{
    UIView * v=[sender superview];
    UITableViewCell *cell=(UITableViewCell *)[v superview];//找到cell
    NSIndexPath *indexPath=[mTableView indexPathForCell:cell];//找到cell所在的行
    NSLog(@"%ld",(long)indexPath.row);
    
    NSString *FID = [personDetailArray[indexPath.row][@"id"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"id"];
    [dataProvider setDelegateObject:self setBackFunctionName:@"accessApplyFriendBackCall:"];
    [dataProvider accessApplyFriend:FID andStatus:@"2"];
    
}

-(void)accessApplyFriendBackCall:(id)dict{
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"通过好友申请～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"失败～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)quitView{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}

@end
