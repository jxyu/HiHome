//
//  AddressPageViewController.m
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AddressPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIDefine.h"
#import "CardTableViewCell.h"
#import "AddressLocalViewController.h"
#import "AddFriendFirstViewController.h"
#import "DataProvider.h"
#import "JKAlertDialog.h"
#import "PersonFirstViewController.h"


@interface AddressPageViewController (){
    DataProvider *dataProvider;
    
    NSMutableArray *friendArrayNormal;
    NSMutableArray *friendArraySpouse;
    NSMutableArray *friendArrayStar;
    
    NSMutableArray *searchResultsNormal;
    NSMutableArray *searchResultsSpouse;
    NSMutableArray *searchResultsStar;
    
    NSIndexPath *currentRow;
    
    PersonFirstViewController *personFirstVC;
    
    BOOL isSearchIFlag;
}

@end

@implementation AddressPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isSearchIFlag = NO;
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetFriendInfoClick) name:@"getFriendInfo" object:nil];
}
-(void)initData{
    
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"friendListBackCall:"];
    [dataProvider getFriendList:[self getUserID]];
}

-(void)friendListBackCall:(id)dict{
    NSLog(@"%@",dict);
    friendArrayNormal = [[NSMutableArray alloc] init];
    friendArrayStar = [[NSMutableArray alloc] init];
    friendArraySpouse = [[NSMutableArray alloc] init];
    
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        friendArrayNormal = (NSMutableArray *)[[dict objectForKey:@"datas"] objectForKey:@"list0"];
        friendArrayStar = (NSMutableArray *)[[dict objectForKey:@"datas"] objectForKey:@"list1"];
        friendArraySpouse = (NSMutableArray *)[[dict objectForKey:@"datas"] objectForKey:@"list2"];
        
        searchResultsNormal = friendArrayNormal;
        searchResultsStar = friendArrayStar;
        searchResultsSpouse = friendArraySpouse;
    }else{
        NSLog(@"访问服务器失败！");
    }

    [self initViews];
    [_mytableView reloadData];
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

-(void) initViews
{
    _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
    
    _mytableView.backgroundColor =ZY_UIBASE_BACKGROUND_COLOR;
    [_mytableView setDelegate:self];
    [_mytableView setDataSource:self];
    
    //    _mytableView.tableHeaderView.contentMode = UIViewContentModeCenter;
    //    _mytableView.tableHeaderView = [self headerViewForChatPage];
    
    
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _mytableView.separatorInset = UIEdgeInsetsZero;
    _mytableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
   
    _mytableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    //_mytableView.separatorEffect = ;
    
     if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
     {
    //设置cell分割线从最左边开始
         if ([_mytableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mytableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
            }
    
         if ([_mytableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mytableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
            }
     }
    
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, SCREEN_WIDTH
                                                                    , ZY_VIEWHEIGHT_IN_HEADVIEW)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    
    //_searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    //_searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    //_searchDisplayController.searchResultsDelegate = self;
    
  //  _mytableView.tableHeaderView = _searchBar;
    
    [self.view addSubview:_mytableView];
    [self.view addSubview:[self headerView]];
    [self.view addSubview:_searchBar];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
//    [self.view addGestureRecognizer:tapGesture];

    
    _mytableView.tableFooterView = [[UIView alloc] init];
    
}


-(void) viewWillLayoutSubviews
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)tapViewAction:(id)sender
{
    NSLog(@"tap view---");
    
    if(_keyShow == true)
    {
        _keyShow = false;
        [_searchBar resignFirstResponder];//关闭textview的键盘
        [_searchDisplayController setActive:NO animated:YES];
    }
}
-(UIView *)headerView
{
    UIView *tableHeaderView = [[UIView alloc] init];
    tableHeaderView.backgroundColor = ZY_UIBASECOLOR;
    tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, ZY_HEADVIEW_HEIGHT);
//    UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20,30, 30)];
//
//    [titleBtn setImage:[UIImage imageNamed:@"me"] forState:UIControlStateNormal];
//    titleBtn.layer.masksToBounds = YES;
//    titleBtn.layer.cornerRadius = titleBtn.frame.size.width * 0.5;
//    titleBtn.layer.borderWidth = 1.0;
//    titleBtn.layer.borderColor = [[UIColor yellowColor] CGColor];
//    titleBtn.backgroundColor = [UIColor blueColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, (SCREEN_WIDTH - 100*2), ZY_VIEWHEIGHT_IN_HEADVIEW)];
    titleLabel.text = @"好友";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    UIImageView *threepiontImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 10, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    threepiontImg.image = [UIImage imageNamed:@"threepoint"];
    threepiontImg.contentMode = UIViewContentModeCenter;
    
    UIButton *addtaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 10 - 30, 20,ZY_VIEWHEIGHT_IN_HEADVIEW, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    
    [addtaskBtn setImage:[UIImage imageNamed:@"addtask"] forState:UIControlStateNormal];
    addtaskBtn.imageView.contentMode = UIViewContentModeCenter;
    [addtaskBtn addTarget:self action:@selector(addFriendEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    tableHeaderView.contentMode = UIViewContentModeCenter;
    [tableHeaderView addSubview:titleLabel];
//    [tableHeaderView addSubview:titleBtn];
    [tableHeaderView addSubview:addtaskBtn];
    [tableHeaderView addSubview:threepiontImg];
    return tableHeaderView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    switch (section) {
        case 0:
            return  1;
            break;
        case 1:
            return searchResultsSpouse.count;
            break;
        case 2:
             return searchResultsStar.count;
            break;
        case 3:
            return searchResultsNormal.count;
            break;
        default:
            break;
    }
    
    return 0;
}

-(void)addFriendEvent:(id)sender{
    AddFriendFirstViewController *addFriendFirstVC = [[AddFriendFirstViewController alloc] init];
    addFriendFirstVC.navTitle = @"添加联系人";
    [self.navigationController pushViewController:addFriendFirstVC animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
// 
//    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",
//             @"H",@"I",@"J",@"K",@"L",@"M",@"N",
//             @"O",@"P",@"Q",@"R",@"S",@"T",@"U",
//             @"V",@"W",@"X",@"Y",@"Z",@"#"];
//}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardTableViewCell *cell = [[CardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    NSLog(@"%ld",(long)indexPath.row);
    if(indexPath.section == 0)
    {
        cell.iconView.image = [UIImage imageNamed:@"addressBook"];
        cell.nameLabel.text = @"通讯录";
        cell.nameLabel.textColor = [UIColor grayColor];
    }else if(indexPath.section == 1){
        NSString *avatar = [searchResultsSpouse[indexPath.row][@"avatar"] isEqual:[NSNull null]]?@"":searchResultsSpouse[indexPath.row][@"avatar"];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
        cell.nameLabel.text = [searchResultsSpouse[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":searchResultsSpouse[indexPath.row][@"nick"];
        cell.nameLabel.textColor = [UIColor grayColor];
    }else if(indexPath.section == 2){
        NSString *avatar = [searchResultsStar[indexPath.row][@"avatar"] isEqual:[NSNull null]]?@"":searchResultsStar[indexPath.row][@"avatar"];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
        cell.nameLabel.text = [searchResultsStar[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":searchResultsStar[indexPath.row][@"nick"];
        cell.nameLabel.textColor = [UIColor grayColor];
    }else if(indexPath.section == 3){
        NSString *avatar = [searchResultsNormal[indexPath.row][@"avatar"] isEqual:[NSNull null]]?@"":searchResultsNormal[indexPath.row][@"avatar"];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
        cell.nameLabel.text = [searchResultsNormal[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":searchResultsNormal[indexPath.row][@"nick"];
        cell.nameLabel.textColor = [UIColor grayColor];
    }
    //分割线设置
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}


//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.section) {
//        case 0:
//            if(indexPath.row == (_cellCount - 1))
//                return 1;
//            else
//                return 50;
//            break;
//        case 1:
//            if(indexPath.row == (_mateCellCount - 1))
//                return 1;
//            else
//                return 50;
//            break;
//        case 2:
//            if(indexPath.row == (_starFriendCellCount - 1))
//                return 1;
//            else
//                return 50;
//        case 3:
//            if(indexPath.row == (_normalFriendcellCount - 1))
//                return 1;
//            else
//                return 50;
//        default:
//            break;
//    }
//    
//    if(indexPath.row == (_cellCount - 1))
//        return 0;
//    else
        return 80;
}


//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIScrollView *tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 0, 100, 100)];
//
//
//    cell.backgroundView = tempView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if (indexPath.section==0) {
        //AddressLocalViewController * addresslocalVC=[[AddressLocalViewController alloc] initWithNibName:@"AddressLocalViewController" bundle:[NSBundle mainBundle]];
        addresslocalVC = [[AddressLocalViewController alloc] init];
        addresslocalVC.navTitle = @"手机通讯录";
        [self.navigationController pushViewController:addresslocalVC animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    }else if(indexPath.section == 1){
        personFirstVC = [[PersonFirstViewController alloc] init];
        personFirstVC.navTitle = @"好友资料";
        personFirstVC.mIFlag = @"2";
        personFirstVC.mFriendID = [searchResultsSpouse[indexPath.row][@"fid"] isEqual:[NSNull null]]?@"":searchResultsSpouse[indexPath.row][@"fid"];
        personFirstVC.mHeadImg = [searchResultsSpouse[indexPath.row][@"avatar"] isEqual:[NSNull null]]?@"":searchResultsSpouse[indexPath.row][@"avatar"];
        personFirstVC.mName = [searchResultsSpouse[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":searchResultsSpouse[indexPath.row][@"nick"];
        personFirstVC.mSex = [searchResultsSpouse[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":searchResultsSpouse[indexPath.row][@"sex"];
        personFirstVC.mAge = [searchResultsSpouse[indexPath.row][@"age"] isEqual:[NSNull null]]?@"":searchResultsSpouse[indexPath.row][@"age"];
        personFirstVC.mSign = [searchResultsSpouse[indexPath.row][@"sign"] isEqual:[NSNull null]]?@"":searchResultsSpouse[indexPath.row][@"sign"];
        personFirstVC.mType = [searchResultsSpouse[indexPath.row][@"type"] isEqual:[NSNull null]]?@"":searchResultsSpouse[indexPath.row][@"type"];
        [self.navigationController pushViewController:personFirstVC animated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    }else if (indexPath.section == 2){
        personFirstVC = [[PersonFirstViewController alloc] init];
        personFirstVC.navTitle = @"好友资料";
        personFirstVC.mIFlag = @"2";
        personFirstVC.mFriendID = [searchResultsStar[indexPath.row][@"fid"] isEqual:[NSNull null]]?@"":searchResultsStar[indexPath.row][@"fid"];
        personFirstVC.mHeadImg = [searchResultsStar[indexPath.row][@"avatar"] isEqual:[NSNull null]]?@"":searchResultsStar[indexPath.row][@"avatar"];
        personFirstVC.mName = [searchResultsStar[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":searchResultsStar[indexPath.row][@"nick"];
        personFirstVC.mSex = [searchResultsStar[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":searchResultsStar[indexPath.row][@"sex"];
        personFirstVC.mAge = [searchResultsStar[indexPath.row][@"age"] isEqual:[NSNull null]]?@"":searchResultsStar[indexPath.row][@"age"];
        personFirstVC.mSign = [searchResultsStar[indexPath.row][@"sign"] isEqual:[NSNull null]]?@"":searchResultsStar[indexPath.row][@"sign"];
        personFirstVC.mType = [searchResultsStar[indexPath.row][@"type"] isEqual:[NSNull null]]?@"":searchResultsStar[indexPath.row][@"type"];
        [self.navigationController pushViewController:personFirstVC animated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    }else{
        personFirstVC = [[PersonFirstViewController alloc] init];
        personFirstVC.navTitle = @"好友资料";
        personFirstVC.mIFlag = @"2";
        personFirstVC.mFriendID = [searchResultsNormal[indexPath.row][@"fid"] isEqual:[NSNull null]]?@"":searchResultsNormal[indexPath.row][@"fid"];
        personFirstVC.mHeadImg = [searchResultsNormal[indexPath.row][@"avatar"] isEqual:[NSNull null]]?@"":searchResultsNormal[indexPath.row][@"avatar"];
        personFirstVC.mName = [searchResultsNormal[indexPath.row][@"nick"] isEqual:[NSNull null]]?@"":searchResultsNormal[indexPath.row][@"nick"];
        personFirstVC.mSex = [searchResultsNormal[indexPath.row][@"sex"] isEqual:[NSNull null]]?@"":searchResultsNormal[indexPath.row][@"sex"];
        personFirstVC.mAge = [searchResultsNormal[indexPath.row][@"age"] isEqual:[NSNull null]]?@"":searchResultsNormal[indexPath.row][@"age"];
        personFirstVC.mSign = [searchResultsNormal[indexPath.row][@"sign"] isEqual:[NSNull null]]?@"":searchResultsNormal[indexPath.row][@"sign"];
        personFirstVC.mType = [searchResultsNormal[indexPath.row][@"type"] isEqual:[NSNull null]]?@"":searchResultsNormal[indexPath.row][@"type"];
        [self.navigationController pushViewController:personFirstVC animated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    }
    
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, 10, 100, 10));
}


//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return NO;
    }else{
        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *numberRowOfCellArray = [NSMutableArray array] ;
    [numberRowOfCellArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
    currentRow = indexPath;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"delFriendBackCall:"];
        if (currentRow.section == 1) {
            [dataProvider delFriend:searchResultsSpouse[currentRow.row][@"fid"] andUserID:[self getUserID]];
        }else if(currentRow.section == 2){
            [dataProvider delFriend:searchResultsStar[currentRow.row][@"fid"] andUserID:[self getUserID]];
        }else if(currentRow.section == 3){
            [dataProvider delFriend:searchResultsNormal[currentRow.row][@"fid"] andUserID:[self getUserID]];
        }
    }
}

-(void)delFriendBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        NSMutableArray *tempArray;
        if (currentRow.section == 1) {
            tempArray = [[NSMutableArray alloc] initWithArray:searchResultsSpouse];
            [tempArray removeObjectAtIndex:currentRow.row];
            searchResultsSpouse = [[NSMutableArray alloc] initWithArray:tempArray];
        }else if(currentRow.section == 2){
            tempArray = [[NSMutableArray alloc] initWithArray:searchResultsStar];
            [tempArray removeObjectAtIndex:currentRow.row];
            searchResultsStar = [[NSMutableArray alloc] initWithArray:tempArray];
        }else if(currentRow.section == 3){
            tempArray = [[NSMutableArray alloc] initWithArray:searchResultsNormal];
            [tempArray removeObjectAtIndex:currentRow.row];
            searchResultsNormal = [[NSMutableArray alloc] initWithArray:tempArray];
        }
        
        
        [_mytableView reloadSections:[[NSIndexSet alloc]initWithIndex:currentRow.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除好友成功～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        //[self.navigationController popToRootViewControllerAnimated:NO];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除好友失败～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
    if(section == 0)
    {
//        tempView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50);
//        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
//                                                                               , 44)];
//        searchBar.placeholder = @"搜索";
//        [tempView addSubview:searchBar];
    }
    else
    {
        tempView.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
        tempView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        switch (section) {
            case 1:
                titleLabel.text = @"配偶";
                break;
            case 2:
                titleLabel.text = @"星标好友";
                break;
            case 3:
                titleLabel.text = @"亲友列表";
                break;
                
            default:
                break;
        }
        titleLabel.textColor = ZY_UIBASE_FONT_COLOR;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [tempView addSubview:titleLabel];
        
    }
    
    return tempView;
}

//设置section的footer view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
//    if(section == 0)
//    {
//        tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
//        tempView.backgroundColor =[UIColor whiteColor];//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
//        
//    }
    return tempView;
    
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }else{
        if (section == 1) {
            if (searchResultsSpouse.count > 0) {
                return 40;
            }
        }else if(section == 2){
            if (searchResultsStar.count > 0) {
                return 40;
            }
        }else{
            if(searchResultsNormal.count > 0){
                return 40;
            }
        }
    }
    return 0;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [self initData];
}

-(void)didGetFriendInfoClick{
    [self initData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
  
}

@end
