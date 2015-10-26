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


@interface AddressPageViewController (){
    DataProvider *dataProvider;
    NSArray *friendArray;
}

@end

@implementation AddressPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
}
-(void)initData{
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"friendListBackCall:"];
    [dataProvider getFriendList:[self getUserID]];
}

-(void)friendListBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        friendArray = (NSArray *)[[dict objectForKey:@"datas"] objectForKey:@"list"];
    }else{
        NSLog(@"访问服务器失败！");
    }
    _mateCellCount =2;
    _starFriendCellCount =3;
    _normalFriendcellCount =4;
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
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT+ZY_VIEWHEIGHT_IN_HEADVIEW-20, SCREEN_WIDTH,SCREEN_HEIGHT -ZY_HEADVIEW_HEIGHT )];
    _mainTableView.backgroundColor =ZY_UIBASE_BACKGROUND_COLOR;
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    
    //    _mainTableView.tableHeaderView.contentMode = UIViewContentModeCenter;
    //    _mainTableView.tableHeaderView = [self headerViewForChatPage];
    
    
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
   
    _mainTableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    //_mainTableView.separatorEffect = ;
    
     if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
     {
    //设置cell分割线从最左边开始
         if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
            }
    
         if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
            }
     }
    
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, self.view.frame.size.width
                                                                    , ZY_VIEWHEIGHT_IN_HEADVIEW)];
    _searchBar.placeholder = @"搜索";
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController.searchResultsDelegate = self;
    
  //  _mainTableView.tableHeaderView = _searchBar;
    
    [self.view addSubview:_mainTableView];
    [self.view addSubview:[self headerView]];
    [self.view addSubview:_searchBar];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
//    [self.view addGestureRecognizer:tapGesture];

    
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, (self.view.frame.size.width - 100*2), ZY_VIEWHEIGHT_IN_HEADVIEW)];
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
             return _mateCellCount;
            break;
        case 2:
             return _starFriendCellCount;
            break;
        case 3:
             return _normalFriendcellCount;
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
    //[self.navigationController presentViewController:addFriendFirstVC animated:NO completion:nil];
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
    
    if(indexPath.section == 0)
    {
        cell.iconView.image = [UIImage imageNamed:@"addressBook"];
        cell.nameLabel.text = @"通讯录";
        cell.nameLabel.textColor = [UIColor grayColor];
    }
    else
    {
       // cell.iconView.image = [UIImage imageNamed:@"headImg"];
        cell.iconView.image = [UIImage imageNamed:@"headImg"];
        cell.nameLabel.text = @"唐嫣";
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
    if(section == 0)
        return 0;
    return 40;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0;
    
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
