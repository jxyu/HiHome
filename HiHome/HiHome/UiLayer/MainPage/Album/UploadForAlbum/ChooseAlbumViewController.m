//
//  ChooseAlbumViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ChooseAlbumViewController.h"
#import "SelectContacterCell.h"
#import "DataProvider.h"
#import "JKAlertDialog.h"
#import "SVProgressHUD.h"

@interface ChooseAlbumViewController ()
{
    UITableView *mTableView;
    
    NSMutableArray *selectContacterArray;//已选择的联系人数组
    
    
    DataProvider *dataProvider;
    
    NSArray *friendArrayNormal;
    NSArray *friendArraySpouse;
    NSArray *friendArrayStar;
    
    int normalNum;
    int spouseNum;
    int starNum;
    
    NSMutableArray *btnState;
    
    NSInteger _cellCount;
    NSMutableArray *albumArray;

}
@end

@implementation ChooseAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
     [self initView];
}

-(void)initData{
    normalNum = 0;
    spouseNum = 0;
    starNum = 0;
    _cellCount = 0;
    dataProvider = [[DataProvider alloc] init];
    _selectAlbumDict = [NSMutableDictionary dictionary];
    albumArray  = [NSMutableArray array];
    btnState = [NSMutableArray array];
    [self getAlbumList:[self getUserID] andNowPage:nil andPerPage:nil];
    
}



-(void)initView{
    
    [self.mBtnRight setTitle:@"确定" forState:UIControlStateNormal];
    
    selectContacterArray = [[NSMutableArray alloc] init];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    mTableView.tableFooterView = [[UIView alloc] init];
}

-(void)friendListBackCall:(id)dict{
    NSLog(@"%@",dict);
    friendArrayNormal = [[NSMutableArray alloc] init];
    friendArrayStar = [[NSMutableArray alloc] init];
    friendArraySpouse = [[NSMutableArray alloc] init];
    
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        friendArrayNormal = (NSArray *)[[dict objectForKey:@"datas"] objectForKey:@"list0"];
        friendArrayStar = (NSArray *)[[dict objectForKey:@"datas"] objectForKey:@"list1"];
        friendArraySpouse = (NSArray *)[[dict objectForKey:@"datas"] objectForKey:@"list2"];
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

-(void)getAlbumList:(NSString *)fid andNowPage:(NSString *)nowPage andPerPage:(NSString *)perPage
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getAlbumListCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    [dataprovider GetAlbumList:fid andUid:userID andNowPage:nowPage andPerPage:perPage];
}


-(void)getAlbumListCallBack:(id)dict
{
    
    NSInteger code;
    NSMutableDictionary *albumDict;
    [SVProgressHUD dismiss];

    DLog(@"[%s] dict = %@",__FUNCTION__,dict);

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
        albumArray = [albumDict objectForKey:@"list"];
        
        if(albumArray.count !=0)
            _cellCount = albumArray.count;
        
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
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return _cellCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * identity = @"SelectContacterCellIdentifier";
    SelectContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    NSDictionary *tempDict;
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectContacterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
    cell.mSelectCheckBoxBtn.tag = ZY_UIBUTTON_TAG_BASE + indexPath.row;
    
    
    [btnState addObject:cell.mSelectCheckBoxBtn];
    [cell.mSelectCheckBoxBtn addTarget:self action:@selector(selectAlbumBtn:) forControlEvents:UIControlEventTouchUpInside];
    if(indexPath.row>albumArray.count-1)
    {
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
            [cell setPreservesSuperviewLayoutMargins:false];
        }
        
        return cell;
    }
    tempDict = [albumArray objectAtIndex:indexPath.row];
    
    @try {
        cell.mHeaderImg.image = [UIImage imageNamed:@"headImg"];
        cell.mName.text = [tempDict objectForKey:@"title"];
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        spouseNum++;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
            [cell setPreservesSuperviewLayoutMargins:false];
        }
        
        return cell;
    }
  
}

-(void)btnRightClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"quitView---");
        if([self.delegate respondsToSelector:@selector(pickedAlbum:)])
            [self.delegate pickedAlbum:(self.selectAlbumDict)];
        
    }];
}



-(void)selectAlbumBtn:(UIButton *)sender
{
   
    if(sender.tag - ZY_UIBUTTON_TAG_BASE > btnState.count - 1)
        return;
    sender.selected = YES;
    
    for(int i = 0;i<btnState.count;i++)
    {
        UIButton *tempBtn;
        tempBtn = [btnState objectAtIndex:i];
        if(i == sender.tag- ZY_UIBUTTON_TAG_BASE)
            continue;
        
        tempBtn.selected = NO;
    }

    _selectAlbumDict = [albumArray objectAtIndex:sender.tag- ZY_UIBUTTON_TAG_BASE];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row > albumArray.count -1)
        return;
    
    SelectContacterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.mSelectCheckBoxBtn.selected = YES;
    
    for(int i = 0;i<btnState.count;i++)
    {
        UIButton *tempBtn;
        tempBtn = [btnState objectAtIndex:i];
        if(i == cell.mSelectCheckBoxBtn.tag- ZY_UIBUTTON_TAG_BASE)
            continue;
        
        tempBtn.selected = NO;
    }
    
    _selectAlbumDict = [albumArray objectAtIndex:indexPath.row];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        if (section == 1) {
            if (friendArraySpouse.count > 0) {
                return 40;
            }
        }else if(section == 2){
            if (friendArrayStar.count > 0) {
                return 40;
            }
        }else{
            if(friendArrayNormal.count > 0){
                return 40;
            }
        }
    }
    return 0;
}

//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
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
    
    return tempView;
}


//-(void)btnRightClick:(id)sender{
//    _selectContacterArrayID = [[NSMutableArray alloc] init];
//    _selectContacterArrayName = [[NSMutableArray alloc] init];
//    
//    int mSection;
//    int mIndex;
//    for (int i = 0; i<selectContacterArray.count; i++) {
//        mSection = [selectContacterArray[i] componentsSeparatedByString:@"-"][0].intValue;
//        mIndex = [selectContacterArray[i] componentsSeparatedByString:@"-"][1].intValue;
//        if (mSection == 0) {
//            [_selectContacterArrayID addObject:[self getUserID]];
//            [_selectContacterArrayName addObject:@"自己"];
//        }else if (mSection == 1) {
//            [_selectContacterArrayID addObject:[friendArraySpouse[mIndex][@"fid"] isEqual:[NSNull null]]?@"":friendArraySpouse[mIndex][@"fid"]];
//            [_selectContacterArrayName addObject:[friendArraySpouse[mIndex][@"nick"] isEqual:[NSNull null]]?@"":friendArraySpouse[mIndex][@"nick"]];
//        }else if(mSection == 2){
//            [_selectContacterArrayID addObject:[friendArrayStar[mIndex][@"fid"] isEqual:[NSNull null]]?@"":friendArrayStar[mIndex][@"fid"]];
//            [_selectContacterArrayName addObject:[friendArrayStar[mIndex][@"nick"] isEqual:[NSNull null]]?@"":friendArrayStar[mIndex][@"nick"]];
//        }else{
//            [_selectContacterArrayID addObject:[friendArrayNormal[mIndex][@"fid"] isEqual:[NSNull null]]?@"":friendArrayNormal[mIndex][@"fid"]];
//            [_selectContacterArrayName addObject:[friendArrayNormal[mIndex][@"nick"] isEqual:[NSNull null]]?@"":friendArrayNormal[mIndex][@"nick"]];
//        }
//    }
//    
//    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
//    {
//        [self popoverPresentationController];
//    }
//    [self.navigationController popViewControllerAnimated:NO];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
