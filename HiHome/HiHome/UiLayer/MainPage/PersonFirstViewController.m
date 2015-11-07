//
//  PersonFirstViewController.m
//  HiHome
//
//  Created by Rain on 15/10/22.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PersonFirstViewController.h"
#import "UIImage+WM.h"
#import "PersonSecondViewController.h"
#import "DataProvider.h"
#import "MarkFriendViewController.h"
#import "ChatContentViewController.h"
#import "SVProgressHUD.h"
#import "JKAlertDialog.h"
#import "PlanMonthViewController.h"

@interface PersonFirstViewController (){
    UITableView *mTableView;
    NSInteger cellHeight;
    NSArray *userInfoArray;
    DataProvider *dataProvider;
    UITextField *gxqm;
    MarkFriendViewController *markFriendVC;
    NSUserDefaults *mUserDefault;
    
    
    
    NSMutableArray *resentArray;
   // NSInteger resentPage;
}

@end

@implementation PersonFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    cellHeight = SCREEN_HEIGHT / 11;
    resentArray =[NSMutableArray array];
    if ([_mIFlag isEqual:@"1"] || [_mIFlag isEqual:@"2"]) {
        [self initView];
    }else{
        [self initData];
    }
}

-(void)initView{
    
    mUserDefault = [NSUserDefaults standardUserDefaults];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    if ([_mIFlag isEqual:@"1"]) {
        mTableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1];
    }
    [self.view addSubview:mTableView];
    
    mTableView.tableFooterView = [[UIView alloc] init];
}

-(void)initData{
    [SVProgressHUD showWithStatus:@"请稍等..." maskType:SVProgressHUDMaskTypeBlack];
    dataProvider=[[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"GetInfoBackCall:"];
    [dataProvider GetUserInfoWithUid:[self getUserID]];
}

-(void)GetInfoBackCall:(id)dict
{
    [SVProgressHUD dismiss];
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
    if([_mIFlag isEqual:@"2"]){
        return 7;
    }else{
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    
    
    if (indexPath.row == 0) {
        UIImageView *mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight * 3)];
        mImageView.image = [UIImage imageNamed:@"person_top_bg"];
        [cell addSubview:mImageView];
        
        UIButton *mHeadImg = [[UIButton alloc] initWithFrame:CGRectMake(10, cellHeight * 1.8 - 5, cellHeight * 1.2, cellHeight * 1.2)];
        
        mHeadImg.layer.masksToBounds=YES;
        mHeadImg.layer.cornerRadius=(mHeadImg.frame.size.width)/2;
        mHeadImg.layer.borderWidth=0.5;
        mHeadImg.layer.borderColor=ZY_UIBASECOLOR.CGColor;
        
        NSString *avatar;
        if ([_mIFlag isEqual:@"1"] || [_mIFlag isEqual:@"2"]) {
            avatar = _mHeadImg;
        }else{
            avatar = [userInfoArray[0][@"avatar"] isEqual:[NSNull null]]?@"":userInfoArray[0][@"avatar"];
        }
        
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mHeadImg.frame.size.width, mHeadImg.frame.size.height)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        [mHeadImg addSubview:imgView];
        [cell addSubview:mHeadImg];
        
        UILabel *mDetail = [[UILabel alloc] initWithFrame:CGRectMake(10 + mHeadImg.frame.size.width + 10, mHeadImg.frame.origin.y + mHeadImg.frame.size.height / 2 - 10,SCREEN_WIDTH - 100, 21)];
        mDetail.textColor = [UIColor whiteColor];
        if ([_mIFlag isEqual:@"1"] || [_mIFlag isEqual:@"2"]) {
            mDetail.text = [NSString stringWithFormat:@"%@   %@   %@",_mName,_mSex,_mAge];//@"唐嫣  女  21岁";
        }else{
            mDetail.text = [NSString stringWithFormat:@"%@   %@   %@岁",[userInfoArray[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":userInfoArray[indexPath.row][@"nick"],[userInfoArray[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":userInfoArray[indexPath.row][@"sex"],[userInfoArray[indexPath.row][@"age"] isEqual:[NSNull null]]?@"":userInfoArray[indexPath.row][@"age"]];//@"唐嫣  女  21岁";
        }
        
        [cell addSubview:mDetail];
    }else if(indexPath.row == 1){
        UITextField *accountInfo = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, cellHeight)];
        accountInfo.text = [mUserDefault valueForKey:@"mAccountID"];
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
        if ([_mIFlag isEqual:@"1"] || [_mIFlag isEqual:@"2"]) {
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
    }else{
        if ([_mIFlag isEqual:@"2"]) {
            if (indexPath.row == 3) {
                UITextField *relation = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, cellHeight)];
                if ([_mType isEqual:@"0"]) {
                    relation.text = @"普通好友";
                }else if([_mType isEqual:@"1"]){
                    relation.text = @"星标好友";
                }else{
                    relation.text = @"配偶";
                }
                [relation setEnabled:NO];
                relation.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.54 alpha:1];
                UILabel *relationLeftlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
                relationLeftlabel.text = @"与其关系:";
                relationLeftlabel.textColor = [UIColor colorWithRed:0.62 green:0.41 blue:0.24 alpha:1];
                relation.leftView = relationLeftlabel;
                relation.leftViewMode = UITextFieldViewModeAlways;
                [cell addSubview:relation];
                UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 15, cellHeight / 2 - 10, 15, 20)];
                rightImg.image = [UIImage imageNamed:@"right_img.png"];
                [cell addSubview:rightImg];
            }else if(indexPath.row == 4){
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
            }else if(indexPath.row == 5){
                UILabel *xcdt = [[UILabel alloc] initWithFrame:CGRectMake(10, cellHeight - 10, 80, 21)];
                xcdt.text = @"相册动态:";
                xcdt.textColor = [UIColor colorWithRed:0.62 green:0.41 blue:0.24 alpha:1];
                [cell addSubview:xcdt];
                
                UIImageView *mImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10 + xcdt.frame.size.width + 10, 5, cellHeight * 2 - 10, cellHeight * 2 - 10)];
               // mImageView1.image = [UIImage imageNamed:@"recentPic"];
                UIImageView *mImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10 + xcdt.frame.size.width + 10 + mImageView1.frame.size.width + 10, 5, cellHeight * 2 - 10, cellHeight * 2 - 10)];
                
                NSDictionary *tempDict;
                NSString * url;
                for (int i =0; i<2 && i<resentArray.count; i++) {
                    tempDict = [resentArray objectAtIndex:i];
                    if(i == 0)
                    {
                        
                        url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[tempDict objectForKey:@"imgsrc"]];
                        NSLog(@"img url = [%@]",url);
                        [mImageView1 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
                        
                        [cell addSubview:mImageView1];
                    }
                    else{
                        
                        
                        url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[tempDict objectForKey:@"imgsrc"]];
                        NSLog(@"img url = [%@]",url);
                        [mImageView2 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
                        
                        [cell addSubview:mImageView2];

                    }
                }
               
                
                           }else{
                UIButton *mHiBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, cell.frame.size.height - 10, SCREEN_WIDTH - 20, 40)];
                [mHiBtn addTarget:self action:@selector(mHiEvent:) forControlEvents:UIControlEventTouchUpInside];
                mHiBtn.layer.borderWidth = 1;
                mHiBtn.layer.borderColor = [UIColor colorWithRed:0.94 green:0.56 blue:0.46 alpha:1].CGColor;
                [mHiBtn setTitle:@"打招呼" forState:UIControlStateNormal];
                [mHiBtn setTitleColor:[UIColor colorWithRed:0.94 green:0.56 blue:0.46 alpha:1] forState:UIControlStateNormal];
                [cell addSubview:mHiBtn];

            }
        }else{
            if(indexPath.row == 3){
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
                // mImageView1.image = [UIImage imageNamed:@"recentPic"];
                UIImageView *mImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10 + xcdt.frame.size.width + 10 + mImageView1.frame.size.width + 10, 5, cellHeight * 2 - 10, cellHeight * 2 - 10)];
                
                NSDictionary *tempDict;
                NSString * url;
                for (int i =0; i<2 && i<resentArray.count; i++) {
                    tempDict = [resentArray objectAtIndex:i];
                    if(i == 0)
                    {
                        
                        url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[tempDict objectForKey:@"imgsrc"]];
                        NSLog(@"img url = [%@]",url);
                        [mImageView1 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
                        
                        [cell addSubview:mImageView1];
                    }
                    else{
                        
                        
                        url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[tempDict objectForKey:@"imgsrc"]];
                        NSLog(@"img url = [%@]",url);
                        [mImageView2 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
                        
                        [cell addSubview:mImageView2];
                        
                    }
                }
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
    if ([_mIFlag isEqual:@"2"]) {
        if (indexPath.row == 0) {
            return cellHeight * 3;
        }else if(indexPath.row == 5){
            return cellHeight * 2;
        }else if(indexPath.row == 6){
            return cellHeight * 2;
        }
    }else{
        if (indexPath.row == 0) {
            return cellHeight * 3;
        }else if(indexPath.row == 4){
            return cellHeight * 2;
        }else if(indexPath.row == 5){
            return cellHeight * 2;
        }
    }
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    
    
    if (![_mIFlag isEqual:@"2"])//个人的资料
    {
        if(indexPath.row == 3)
        {
            PlanMonthViewController *personTask = [[PlanMonthViewController alloc] init];
            personTask.showTaskMode = Mode_today;
            personTask.navTitle = @"今日任务";
            personTask.pageChangeMode = Mode_dis;
          //  [self.navigationController pushViewController:personTask animated:YES];
            [self presentViewController:personTask animated:YES completion:^{}];
        }
        if(indexPath.row == 4)
        {
            AlbumMainViewController *_AlbumPage = [[AlbumMainViewController alloc] init];
            _AlbumPage.pageChangeMode = Mode_dis;
           // [self.navigationController pushViewController:_AlbumPage animated:YES];
            [self presentViewController:_AlbumPage animated:YES completion:^{}];
            
        }
    }
    else//好友资料
    {
        if(indexPath.row == 4)
        {
            PlanMonthViewController *personTask = [[PlanMonthViewController alloc] init];
            personTask.showTaskMode = Mode_today;
            personTask.friendUserId = _mFriendID;
            personTask.navTitle = @"今日任务";
            personTask.pageChangeMode = Mode_nav;
            [self.navigationController pushViewController:personTask animated:YES];
          //  [self presentViewController:personTask animated:YES completion:^{}];
        }
        if(indexPath.row == 5)
        {
            AlbumMainViewController *_AlbumPage = [[AlbumMainViewController alloc] init];
            _AlbumPage.albumUserId = _mFriendID;
            _AlbumPage.pageChangeMode = Mode_nav;
            [self.navigationController pushViewController:_AlbumPage animated:YES];
            
        }
    }
    
    if (indexPath.row == 3) {
        markFriendVC = [[MarkFriendViewController alloc] init];
        markFriendVC.navTitle = @"选择与其关系";
        markFriendVC.mType = _mType;
        markFriendVC.mFriendID = _mFriendID;
        [self.navigationController pushViewController:markFriendVC animated:NO];
    }
}

-(void)quitView{
    [self dismissViewControllerAnimated:NO completion:^{}];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([_mIFlag isEqual:@"2"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    [self getResentPic:nil andPerPage:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    
    if ([_mIFlag isEqual:@"2"]) {
        if (markFriendVC.mType) {
            _mType = markFriendVC.mType;
            [mTableView reloadData];
        }
    }else{
        [self initData];
        
    }
}

#pragma mark - 获取最近相片
-(void)getResentPic:(NSString *)nowPage andPerPage:(NSString *)perPage
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getResentListCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    if(_mFriendID == nil)
        [dataprovider GetResentPic:userID andNowPage:nowPage andPerPage:perPage];
    else
        [dataprovider GetResentPic:_mFriendID andNowPage:nowPage andPerPage:perPage];
}

-(void)getResentListCallBack:(id)dict
{
    
    NSInteger code;
    NSMutableDictionary *albumDict;
    NSInteger resultAll;
    [SVProgressHUD dismiss];
#if DEBUG
    NSLog(@"[%s] prm = %@",__FUNCTION__,dict);
#endif
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]);
        
        if(code!=400)  //= 400 不弹框
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"相册获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
            [mTableView reloadData];
        }
        return;
    }
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        albumDict = [dict objectForKey:@"datas"];
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    @try {
        
        [resentArray addObjectsFromArray:[albumDict objectForKey:@"list"]];
        resultAll = [[albumDict objectForKey:@"resultAll"] integerValue];
        NSLog(@"resultAll = %ld",resultAll);
//        if(resultAll > resentArray.count)
//        {
//            resentPage++;
//            
//            [self getResentPic:[NSString stringWithFormat:@"%ld",resentPage] andPerPage:nil];
//            return;
//        }
        
//        if(resentArray.count !=0)
//            _cellCountRecentPic = resentArray.count;
        
        [mTableView reloadData];
        
    }
    @catch (NSException *exception) {
        
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"数据解析错误"]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        
        
        return;
    }
    @finally {
        [mTableView reloadData];
    }
    
}


-(void)btnEditInfo:(id)sender{
    PersonSecondViewController *userInfoVC = [[PersonSecondViewController alloc] init];
    userInfoVC.navTitle = @"个人资料";
    userInfoVC.mHeadImg = [userInfoArray[0][@"avatar"] isEqual:[NSNull null]]?@"":userInfoArray[0][@"avatar"];
    userInfoVC.mName = [userInfoArray[0][@"nick"] isEqual:[NSNull null]]?@"":userInfoArray[0][@"nick"];
    userInfoVC.mSex = [userInfoArray[0][@"sex"] isEqual:[NSNull null]]?@"":userInfoArray[0][@"sex"];
    userInfoVC.mAge = [userInfoArray[0][@"age"] isEqual:[NSNull null]]?@"":userInfoArray[0][@"age"];
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

//打招呼
-(void)mHiEvent:(id)sender{
    ChatContentViewController *conversationVC = [[ChatContentViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = _mFriendID; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId
    
//    conversationVC.userName = @"测试1";
//    conversationVC.title = @"自问自答";
    conversationVC.mIFlag = @"2";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [self.navigationController pushViewController:conversationVC animated:YES];
}

@end
