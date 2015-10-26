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

@interface SelectContacterViewController (){
    UITableView *mTableView;
    NSMutableArray *selectContacterArray;//已选择的联系人数组
    
    DataProvider *dataProvider;
    
    NSArray *friendArray;
    NSMutableArray *friendArrayNormal;
    NSMutableArray *friendArraySpouse;
    NSMutableArray *friendArrayStar;
    
    int normalNum;
    int spouseNum;
    int starNum;
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
        friendArray = (NSArray *)[[dict objectForKey:@"datas"] objectForKey:@"list"];
        for (int i =0; i < friendArray.count; i++) {
            if([friendArray[i][@"type"] isEqual:@"0"]){
                NSArray *mTempArray = [[NSArray alloc] initWithObjects:friendArray[i][@"nick"], nil];
                [friendArrayNormal addObject:mTempArray];
            }else if([friendArray[i][@"type"] isEqual:@"1"]){
                NSArray *mTempArray = [[NSArray alloc] initWithObjects:friendArray[i][@"nick"], nil];
                [friendArrayStar addObject:mTempArray];
            }else if([friendArray[i][@"type"] isEqual:@"2"]){
                NSArray *mTempArray = [[NSArray alloc] initWithObjects:friendArray[i][@"nick"], nil];
                [friendArraySpouse addObject:mTempArray];
            }
        }
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
        cell.mHeaderImg.image = [UIImage imageNamed:@"headImg"];
        cell.mName.text = @"自己";
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    }else if(indexPath.section == 1){
        cell.mHeaderImg.image = [UIImage imageNamed:@"headImg"];
        cell.mName.text = [friendArraySpouse[spouseNum][0] isEqual:[NSNull null]]?@"":friendArraySpouse[spouseNum][0];
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        spouseNum++;
    }else if(indexPath.section == 2){
        cell.mHeaderImg.image = [UIImage imageNamed:@"headImg"];
        cell.mName.text = [friendArrayStar[starNum][0] isEqual:[NSNull null]]?@"":friendArrayStar[starNum][0];
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        starNum++;
    }else{
        cell.mHeaderImg.image = [UIImage imageNamed:@"headImg"];
        cell.mName.text = [friendArrayNormal[normalNum][0] isEqual:[NSNull null]]?@"":friendArrayNormal[normalNum][0];
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
    SelectContacterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectContacterArray containsObject:[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row]]) {
        [selectContacterArray removeObject:[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row]];
        [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        
    }else{
        [selectContacterArray addObject:[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row]];
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

@end