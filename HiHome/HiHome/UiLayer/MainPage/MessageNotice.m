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
#import "UIImageView+WebCache.h"
#import "PersonFirstViewController.h"

@interface MessageNotice (){
    UITableView *mTableView;
    DataProvider *dataProvider;
    NSString *applyName;
    NSString *applySign;
    NSArray *personDetailArray;
    NSArray *spouseArray;
    
    NSIndexPath *currentRow;
    
    PersonFirstViewController *personFirstVC;
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
        NSLog(@"%@",dict[@"message"]);
    }
    if([personDetailArray isEqual:[NSNull null]]){
        personDetailArray = [[NSArray alloc] init];
    }
    //获取配偶申请列表
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getSpouseApplyListBackCall:"];
    [dataProvider getSpouseApplayList:[self getUserID]];
    
}

-(void)getSpouseApplyListBackCall:(id)dict{
    NSLog(@"%@",dict);
    spouseArray = [dict valueForKey:@"datas"];
    if ([spouseArray isEqual:[NSNull null]]) {
        spouseArray = [[NSArray alloc] init];
    }
    NSLog(@"%@",spouseArray);
    [self initView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",spouseArray.count + personDetailArray.count);
    return spouseArray.count + personDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"MessageNoticeCellIdentifier";
    MessageNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageNoticeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row < spouseArray.count) {
        NSString *url = [NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[[spouseArray[indexPath.row] valueForKey:@"avatar"] isEqual:[NSNull null]]?@"":[spouseArray[indexPath.row] valueForKey:@"avatar"]];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        cell.mName.text = [spouseArray[indexPath.row][@"name"] isEqual:[NSNull null]]?@"":spouseArray[indexPath.row][@"name"];
        cell.mDetail.text = @"请求添加为配偶!";
        NSString *mState = [spouseArray[indexPath.row][@"state"] isEqual:[NSNull null]]?@"":spouseArray[indexPath.row][@"state"];
        if ([mState isEqual:@"0"]) {
            [cell.mAccept setTitle:@"同意" forState:UIControlStateNormal];
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
    }else{
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[personDetailArray[indexPath.row - spouseArray.count][@"avatar"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row - spouseArray.count][@"avatar"]];
        [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        
        cell.mName.text = [personDetailArray[indexPath.row - spouseArray.count][@"nick"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row - spouseArray.count][@"nick"];
        cell.mDetail.text = @"你好,希望和你成为好朋友!";//[personDetailArray[indexPath.row][@"sign"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"sign"];
        
        NSString *mState = [personDetailArray[indexPath.row - spouseArray.count][@"state"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row - spouseArray.count][@"state"];
        if ([mState isEqual:@"0"]) {
            [cell.mAccept setTitle:@"同意" forState:UIControlStateNormal];
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
 
    if(indexPath.row < spouseArray.count){
        NSString *_mContacterID = [spouseArray[indexPath.row][@"id"] isEqual:[NSNull null]]?@"":spouseArray[indexPath.row][@"id"];
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"accessSpouseApplyBackCall:"];
        [dataProvider handleSpouseApply:_mContacterID andState:@"1"];
    }else{
        NSString *_mContacterID = [personDetailArray[indexPath.row - spouseArray.count][@"id"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row - spouseArray.count][@"id"];
        dataProvider = [[DataProvider alloc] init];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"失败～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)addFriendBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功发送请求～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < spouseArray.count) {
        NSString *mState = [spouseArray[indexPath.row][@"state"] isEqual:[NSNull null]]?@"":spouseArray[indexPath.row][@"state"];
        if ([mState isEqual:@"0"]) {
            AddFriendSecondViewController *addFriendSecondVC = [[AddFriendSecondViewController alloc] init];
            addFriendSecondVC.mType = @"1";
            addFriendSecondVC.navTitle = @"好友申请";
            addFriendSecondVC.mContacterID = [spouseArray[indexPath.row][@"id"] isEqual:[NSNull null]]?@"":spouseArray[indexPath.row][@"id"];
            NSLog(@"%@",addFriendSecondVC.mContacterID);
            addFriendSecondVC.mNameTxt = [spouseArray[indexPath.row][@"name"] isEqual:[NSNull null]]?@"":spouseArray[indexPath.row][@"name"];
            //addFriendSecondVC.mSexTxt = [personDetailArray[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"sex"];
            addFriendSecondVC.mIFlag = @"1";
            //[self presentViewController:addFriendSecondVC animated:NO completion:nil];
            [self.navigationController pushViewController:addFriendSecondVC animated:NO];
        }else if ([mState isEqual:@"1"]){ //同意
            personFirstVC = [[PersonFirstViewController alloc] init];
            personFirstVC.mIFlag = @"3";
            personFirstVC.navTitle = @"好友资料";
            personFirstVC.mFriendID = [spouseArray[indexPath.row][@"uid"] isEqual:[NSNull null]]?@"":spouseArray[indexPath.row][@"uid"];
            
            [self.navigationController pushViewController:personFirstVC animated:NO];
        }else if ([mState isEqual:@"2"]){ //拒绝
            personFirstVC = [[PersonFirstViewController alloc] init];
            personFirstVC.mIFlag = @"4";
            personFirstVC.navTitle = @"好友资料";
            personFirstVC.mFriendID = [spouseArray[indexPath.row][@"uid"] isEqual:[NSNull null]]?@"":spouseArray[indexPath.row][@"uid"];
            
            [self.navigationController pushViewController:personFirstVC animated:NO];
        }
    }else{
        NSString *mState = [personDetailArray[indexPath.row - spouseArray.count][@"state"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row - spouseArray.count][@"state"];
        if ([mState isEqual:@"0"]) {
            AddFriendSecondViewController *addFriendSecondVC = [[AddFriendSecondViewController alloc] init];
            addFriendSecondVC.mType = @"2";
            addFriendSecondVC.navTitle = @"好友申请";
            addFriendSecondVC.mContacterID = [personDetailArray[indexPath.row - spouseArray.count][@"id"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row - spouseArray.count][@"id"];
            NSLog(@"%@",addFriendSecondVC.mContacterID);
            addFriendSecondVC.mNameTxt = [personDetailArray[indexPath.row - spouseArray.count][@"nick"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row - spouseArray.count][@"nick"];
            //addFriendSecondVC.mSexTxt = [personDetailArray[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"sex"];
            addFriendSecondVC.mIFlag = @"1";
            //[self presentViewController:addFriendSecondVC animated:NO completion:nil];
            [self.navigationController pushViewController:addFriendSecondVC animated:NO];
        }else if ([mState isEqual:@"1"]){ //同意
            personFirstVC = [[PersonFirstViewController alloc] init];
            personFirstVC.mIFlag = @"3";
            personFirstVC.navTitle = @"好友资料";
            personFirstVC.mFriendID = [personDetailArray[indexPath.row - spouseArray.count][@"fid"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row - spouseArray.count][@"fid"];
            
            [self.navigationController pushViewController:personFirstVC animated:NO];
        }else if ([mState isEqual:@"2"]){ //拒绝
            personFirstVC = [[PersonFirstViewController alloc] init];
            personFirstVC.mIFlag = @"4";
            personFirstVC.navTitle = @"好友资料";
            personFirstVC.mFriendID = [personDetailArray[indexPath.row - spouseArray.count][@"fid"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row - spouseArray.count][@"fid"];
            
            [self.navigationController pushViewController:personFirstVC animated:NO];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *numberRowOfCellArray = [NSMutableArray array] ;
    [numberRowOfCellArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    
    
    if (indexPath.row < spouseArray.count) {
        alertView.tag = 1;
    }else{
        alertView.tag = 2;
    }
    [alertView show];
    
//    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"删除" message:[NSString stringWithFormat:@"是否删除?"]];
//    
//    alert.alertType = AlertType_Alert;
//    [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item){
//        dataProvider = [[DataProvider alloc] init];
//        [dataProvider setDelegateObject:self setBackFunctionName:@"delApplyFriendBackCall:"];
//        [dataProvider delApplyFriend:[personDetailArray[indexPath.row][@"id"] isEqual:[NSNull null]]?@"":personDetailArray[indexPath.row][@"id"]];
//    }];
//    
//    //    typedef void(^JKAlertDialogHandler)(JKAlertDialogItem *item);
//    [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item){
//        NSLog(@"Click canel");
//        
//    }];
//    [alert show];
    
    currentRow = indexPath;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        dataProvider = [[DataProvider alloc] init];
        if (alertView.tag == 1) {
            [dataProvider setDelegateObject:self setBackFunctionName:@"delSpouseApplyBackCall:"];
            [dataProvider delSpouseApply:[spouseArray[currentRow.row][@"id"] isEqual:[NSNull null]]?@"":spouseArray[currentRow.row][@"id"]];
        }else if(alertView.tag == 2){
            [dataProvider setDelegateObject:self setBackFunctionName:@"delApplyFriendBackCall:"];
            [dataProvider delApplyFriend:[personDetailArray[currentRow.row - spouseArray.count][@"id"] isEqual:[NSNull null]]?@"":personDetailArray[currentRow.row - spouseArray.count][@"id"]];
        }
        
        
    }
}

-(void)delSpouseApplyBackCall:(id)dict{
    NSLog(@"dict");
    int code = [dict[@"code"] intValue];
    if (code == 200) {
        NSMutableArray *tempArray;
        tempArray = [[NSMutableArray alloc] initWithArray:spouseArray];
        [tempArray removeObjectAtIndex:currentRow.row];
        spouseArray = [[NSArray alloc] initWithArray:tempArray];
        [mTableView reloadSections:[[NSIndexSet alloc]initWithIndex:currentRow.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)delApplyFriendBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        NSMutableArray *tempArray;
        tempArray = [[NSMutableArray alloc] initWithArray:personDetailArray];
        [tempArray removeObjectAtIndex:currentRow.row - spouseArray.count];
        personDetailArray = [[NSArray alloc] initWithArray:tempArray];
        
        
        [mTableView reloadSections:[[NSIndexSet alloc]initWithIndex:currentRow.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
