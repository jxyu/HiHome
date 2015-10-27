//
//  MessageNoticeViewController.m
//  HiHome
//
//  Created by Rain on 15/10/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MessageNotice.h"
#import "DataProvider.h"
#import "AddFriendSecondViewController.h"
#import "JKAlertDialog.h"

@interface MessageNotice (){
    UITableView *mTableView;
    DataProvider *dataProvider;
    NSString *applyName;
    NSString *applySign;
    NSArray *personDetailArray;
    
    NSIndexPath *currentRow;
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
    
    NSString *mState = [personDetailArray[indexPath.row][@"state"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"state"];
    if ([mState isEqual:@"0"]) {
        [cell.mAccept setTitle:@"处理" forState:UIControlStateNormal];
        [cell.mAccept addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    }else if([mState isEqual:@"1"]){
        [cell.mAccept setTitle:@"已同意" forState:UIControlStateNormal];
        [cell.mAccept setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        cell.mAccept.backgroundColor = [UIColor clearColor];
    }else{
        [cell.mAccept setTitle:@"已拒绝" forState:UIControlStateNormal];
        [cell.mAccept setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        cell.mAccept.backgroundColor = [UIColor clearColor];
    }
    
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    
    return cell;
}

-(void)handleEvent:(id)sender{
    UIView * v=[sender superview];
    UITableViewCell *cell=(UITableViewCell *)[v superview];//找到cell
    NSIndexPath *indexPath=[mTableView indexPathForCell:cell];//找到cell所在的行
    
    
    AddFriendSecondViewController *addFriendSecondVC = [[AddFriendSecondViewController alloc] init];
    addFriendSecondVC.navTitle = @"好友申请";
    NSLog(@"%@",personDetailArray);
    addFriendSecondVC.mContacterID = [[personDetailArray valueForKey:@"id"][0] isEqual:[NSNull null]]?@"":[personDetailArray valueForKey:@"id"][0];
    NSLog(@"%@",personDetailArray[indexPath.row][@"sex"]);
    addFriendSecondVC.mNameTxt = [personDetailArray[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"nick"];
    addFriendSecondVC.mSexTxt = [personDetailArray[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"sex"];
    addFriendSecondVC.mIFlag = @"1";
    NSLog(@"ddddd=%@",addFriendSecondVC.mNameTxt);
    //[self presentViewController:addFriendSecondVC animated:NO completion:nil];
    [self.navigationController pushViewController:addFriendSecondVC animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *numberRowOfCellArray = [NSMutableArray array] ;
    [numberRowOfCellArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
    
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"删除" message:[NSString stringWithFormat:@"是否删除?"]];
    
    alert.alertType = AlertType_Alert;
    [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item){
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"delApplyFriendBackCall:"];
        [dataProvider delApplyFriend:[personDetailArray[indexPath.row][@"id"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"id"]];
    }];
    
    //    typedef void(^JKAlertDialogHandler)(JKAlertDialogItem *item);
    [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item){
        NSLog(@"Click canel");
        
    }];
    [alert show];
    
    currentRow = indexPath;
}

-(void)delApplyFriendBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        NSMutableArray *tempArray;
        tempArray = [[NSMutableArray alloc] initWithArray:personDetailArray];
        [tempArray removeObjectAtIndex:currentRow.row];
        personDetailArray = [[NSArray alloc] initWithArray:tempArray];
        
        
        [mTableView reloadSections:[[NSIndexSet alloc]initWithIndex:currentRow.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
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
