//
//  SelectContacterViewController.m
//  HiHome
//
//  Created by Rain on 15/10/24.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SelectContacterViewController.h"
#import "SelectContacterCell.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"

@interface SelectContacterViewController (){
    UITableView *mTableView;
    
    NSMutableArray *selectContacterArray;//已选择的联系人数组
    
    
    DataProvider *dataProvider;
    
    NSArray *friendArrayNormal;
    NSArray *friendArraySpouse;
    NSArray *friendArrayStar;
    
    int normalNum;
    int spouseNum;
    int starNum;
    
    NSUserDefaults *mUserDefault;
}

@end

@implementation SelectContacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

-(void)initData{
    normalNum = 0;
    spouseNum = 0;
    starNum = 0;
    
    mUserDefault = [NSUserDefaults standardUserDefaults];
    
    dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"friendListBackCall:"];
    [dataProvider getFriendList:[self getUserID]];
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
    [self initView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return friendArraySpouse.count;
    }else if(section == 2){
        return friendArrayStar.count;
    }else{
        return friendArrayNormal.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * identity = @"SelectContacterCellIdentifier";
    SelectContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectContacterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        NSString *avatar = [mUserDefault valueForKey:@"avatar"];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cell.mHeaderImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
        cell.mName.text = @"自己";
        if (_selectContactMode == Mode_DefaultSelectOneself) {
            [selectContacterArray addObject:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row]];
            [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
        }else{
            [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        }
    }else if(indexPath.section == 1){
        NSString *avatar = [friendArraySpouse[spouseNum][@"avatar"] isEqual:[NSNull null]]?@"":friendArraySpouse[spouseNum][@"avatar"];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cell.mHeaderImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
        cell.mName.text = [friendArraySpouse[spouseNum][@"nick"] isEqual:[NSNull null]]?@"":friendArraySpouse[spouseNum][@"nick"];
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        spouseNum++;
    }else if(indexPath.section == 2){
        NSString *avatar = [friendArrayStar[starNum][@"avatar"] isEqual:[NSNull null]]?@"":friendArrayStar[starNum][@"avatar"];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cell.mHeaderImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
        cell.mName.text = [friendArrayStar[starNum][@"nick"] isEqual:[NSNull null]]?@"":friendArrayStar[starNum][@"nick"];
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        starNum++;
    }else{
        NSString *avatar = [friendArrayNormal[normalNum][@"avatar"] isEqual:[NSNull null]]?@"":friendArrayNormal[normalNum][@"avatar"];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cell.mHeaderImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
        cell.mName.text = [friendArrayNormal[normalNum][@"nick"] isEqual:[NSNull null]]?@"":friendArrayNormal[normalNum][@"nick"];
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        normalNum++;
    }
    
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectContactMode == Mode_DefaultSelectOneself && indexPath.section == 0) {
        return;
    }
    SelectContacterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectContacterArray containsObject:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row]]) {
        [selectContacterArray removeObject:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row]];
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    }else{
        [selectContacterArray addObject:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row]];
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
    }
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

-(void)quitView{
    

    if(self.pageChangeMode == Mode_nav)
    {
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
        {
            [self popoverPresentationController];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

-(void)btnRightClick:(id)sender{
     _selectContacterArrayID = [[NSMutableArray alloc] init];
     _selectContacterArrayName = [[NSMutableArray alloc] init];
    
    int mSection;
    int mIndex;
    for (int i = 0; i<selectContacterArray.count; i++) {
        mSection = [selectContacterArray[i] componentsSeparatedByString:@"-"][0].intValue;
        mIndex = [selectContacterArray[i] componentsSeparatedByString:@"-"][1].intValue;
        if (mSection == 0) {
            [_selectContacterArrayID addObject:[self getUserID]];
            [_selectContacterArrayName addObject:@"自己"];
        }else if (mSection == 1) {
            [_selectContacterArrayID addObject:[friendArraySpouse[mIndex][@"fid"] isEqual:[NSNull null]]?@"":friendArraySpouse[mIndex][@"fid"]];
            [_selectContacterArrayName addObject:[friendArraySpouse[mIndex][@"nick"] isEqual:[NSNull null]]?@"":friendArraySpouse[mIndex][@"nick"]];
        }else if(mSection == 2){
            [_selectContacterArrayID addObject:[friendArrayStar[mIndex][@"fid"] isEqual:[NSNull null]]?@"":friendArrayStar[mIndex][@"fid"]];
            [_selectContacterArrayName addObject:[friendArrayStar[mIndex][@"nick"] isEqual:[NSNull null]]?@"":friendArrayStar[mIndex][@"nick"]];
        }else{
            [_selectContacterArrayID addObject:[friendArrayNormal[mIndex][@"fid"] isEqual:[NSNull null]]?@"":friendArrayNormal[mIndex][@"fid"]];
            [_selectContacterArrayName addObject:[friendArrayNormal[mIndex][@"nick"] isEqual:[NSNull null]]?@"":friendArrayNormal[mIndex][@"nick"]];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(setContacterInfo:andName:)])
    {
        [self.delegate setContacterInfo:_selectContacterArrayID andName:_selectContacterArrayName];
    }
    
    
    [self quitView];
}

@end
