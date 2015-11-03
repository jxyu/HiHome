//
//  ChatPageViewController.m
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ChatPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ChatTableViewCell.h"
#import "UIDefine.h"
#import "ChatlistViewController.h"

@interface ChatPageViewController ()

@end

@implementation ChatPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initViews];
    

//    // Do any additional setup after loading the view from its nib.
//    ChatlistViewController * chatlistVC=[[ChatlistViewController alloc] initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE)] collectionConversationType:@[@(ConversationType_GROUP)]];
//    [self.navigationController pushViewController:chatlistVC animated:YES];
    
//    [self initViews];
    
    
//    //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
//    NSString*token=@"DnhvxLnrPz8IaeYWmCWRcUMc/ULi2rh2Oa0yEbYyvgB+0kt13NTOcUEglJ7S4RMg56wZ2DRIrdewQgWbIHNBdA==";
//    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
//        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
//        [[RCIM sharedRCIM] setUserInfoDataSource:self];
//        NSLog(@"Login successfully with userId: %@.", userId);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            ChatlistViewController *chatListViewController = [[ChatlistViewController alloc]init];
//            [self.navigationController pushViewController:chatListViewController animated:YES];
//        });
//        
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"login error status: %ld.", (long)status);
//    } tokenIncorrect:^{
//        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
//    }];
    
}





- (IBAction)login_WithToken:(UIButton *)sender {
    //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
    NSString*token=@"DnhvxLnrPz8IaeYWmCWRcUMc/ULi2rh2Oa0yEbYyvgB+0kt13NTOcUEglJ7S4RMg56wZ2DRIrdewQgWbIHNBdA==";
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        NSLog(@"Login successfully with userId: %@.", userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            ChatlistViewController *chatListViewController = [[ChatlistViewController alloc]init];
            [self.navigationController pushViewController:chatListViewController animated:YES];
        });
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"login error status: %ld.", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
    }];
    
    
}

/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    //此处为了演示写了一个用户信息
    if ([@"1" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"5";
        user.name = @"测试1";
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        
        return completion(user);
    }else if([@"2" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"4";
        user.name = @"测试2";
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        return completion(user);
    }
}



-(void) initViews
{
//    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, self.view.frame.size.width,self.view.frame.size.height - ZY_HEADVIEW_HEIGHT )];
//    _mainTableView.backgroundColor =[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
//    [_mainTableView setDelegate:self];
//    [_mainTableView setDataSource:self];
    
//    _mainTableView.tableHeaderView.contentMode = UIViewContentModeCenter;
//    _mainTableView.tableHeaderView = [self headerViewForChatPage];
    
    
//    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
//    //_mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//UITableViewCellSeparatorStyleSingleLine;
//    _mainTableView.separatorInset = UIEdgeInsetsZero;
//    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    NSLog(@"WIDTH-----%lf",_mainTableView.frame.size.width);
 //   _mainTableView.separatorColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    _mainTableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
   //_mainTableView.separatorEffect = ;
    
    
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
    
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    _cellCount = 8;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, self.view.frame.size.width
                                                                            , ZY_VIEWHEIGHT_IN_HEADVIEW)];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _mainTableView.tableHeaderView = _searchBar;
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    
    [self.view addSubview:_mainTableView];
    [self.view addSubview:[self headerViewForChatPage]];
  //  [self.view addSubview:_searchBar];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
//    [self.view addGestureRecognizer:tapGesture]
}



#pragma mark - search bar delegate
//搜索栏不会遮挡 navigationbar
-(void) viewWillLayoutSubviews
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancle clicked");
    [self.view bringSubviewToFront: [self headerViewForChatPage]];
//    _searchBar.text = @"";
//    [_searchBar resignFirstResponder];
//    [self setSearchControllerHidden:YES];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"end Search");
    [self.view bringSubviewToFront: [self headerViewForChatPage]];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"start Search");
    for(UIView * v in controller.searchResultsTableView.superview.subviews)
    {
        NSLog(@"%@",[v class]);
        if([v isKindOfClass:NSClassFromString(@"_UISearchDisplayControllerDimmingView")])
        {
            v.frame = CGRectMake(0,ZY_HEADVIEW_HEIGHT,self.view.frame.size.width,400);
        }
    }
        
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



-(UIView *)headerViewForChatPage
{
    UIView *tableHeaderView = [[UIView alloc] init];
    tableHeaderView.backgroundColor = ZY_UIBASECOLOR;
    tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, ZY_HEADVIEW_HEIGHT);
    
//    UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20,30, 30)];
//    [titleBtn setImage:[UIImage imageNamed:@"me"] forState:UIControlStateNormal];
//    titleBtn.layer.masksToBounds = YES;
//    titleBtn.layer.cornerRadius = titleBtn.frame.size.width * 0.5;
//    titleBtn.layer.borderWidth = 1.0;
//    titleBtn.layer.borderColor = [[UIColor yellowColor] CGColor];
//    titleBtn.backgroundColor = [UIColor blueColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, (self.view.frame.size.width - 100*2), ZY_VIEWHEIGHT_IN_HEADVIEW)];
    titleLabel.text = @"聊天";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    
    UIButton *titleBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(320, 20,50, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    [titleBtn2 setTitle:@"＋" forState:UIControlStateNormal];
    [titleBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:35];
    titleBtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIImageView *threepiontImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 10, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    threepiontImg.image = [UIImage imageNamed:@"threepoint"];
    threepiontImg.contentMode = UIViewContentModeCenter;
    
    tableHeaderView.contentMode = UIViewContentModeCenter;
    [tableHeaderView addSubview:titleLabel];
 //   [tableHeaderView addSubview:titleBtn];
    [tableHeaderView addSubview:titleBtn2];
    [tableHeaderView addSubview:threepiontImg];
    return tableHeaderView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1	

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellCount;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatTableViewCell *cell = [[ChatTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    //分割线设置
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if(indexPath.row == (_cellCount -1))
    {
        cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        cell.backgroundColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    }
    
    cell.iconView.image = [UIImage imageNamed:@"me"];
    cell.nameLabel.text = @"唐嫣";
    cell.nameLabel.textColor = [UIColor grayColor];
    
    cell.introLabel.text = @"Nice to meet you";
    cell.introLabel.font = [UIFont systemFontOfSize:12];
    cell.introLabel.textColor = [UIColor grayColor];
    
    cell.timeLabel.text = @"下午 15:30";
    cell.timeLabel.frame = CGRectMake((self.view.frame.size.width - 10 - 80), ZY_TIME_CELL_Y, 80, ZY_TIME_CELL_HIGHT);
    cell.timeLabel.font = [UIFont systemFontOfSize:12];
    cell.timeLabel.textColor = [UIColor grayColor];
    cell.timeLabel.textAlignment = NSTextAlignmentCenter;
    
//    cell.gestureRecognizers
    
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   // [cell didTransitionToState:UITableViewCellStateShowingDeleteConfirmationMask];
       return cell;
    
}


//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == (_cellCount - 1))
        return 0;
    else
        return 50;
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
    
    return YES;
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
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
//        [_mainTableView.cell.infoItems removeObjectAtIndex:(indexPath.row*2)];
//        [_mainTableView.cell.infoItems removeObjectAtIndex:(indexPath.row*2)];
//        [_mainTableView beginUpdates];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
//        [_mainTableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}




-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
    if(section == 0)
    {
//        tempView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50);
//
////        UITextField *searchText= [[UITextField alloc] init];
////        searchText.frame = CGRectMake(10, 5, [[UIScreen mainScreen] bounds].size.width-20, 40);
////        searchText.backgroundColor = [UIColor whiteColor];
////        [searchText setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
////        [tempView addSubview:searchText];
//        
//        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
//                                                                               , 44)];
//    
//        searchBar.placeholder = @"搜索";
//        [tempView addSubview:searchBar];
        
        
    }
    
    return tempView;
}

//设置section的footer view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    if(section == 0)
    {
        tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        tempView.backgroundColor =[UIColor whiteColor];//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
        
    }
    return tempView;
    
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    

    return 50;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
