//
//  SelectContacterViewController.m
//  HiHome
//
//  Created by Rain on 15/10/24.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SelectContacterViewController.h"
#import "SelectContacterCell.h"

@interface SelectContacterViewController (){
    UITableView *mTableView;
    NSMutableArray *selectContacterArray;//已选择的联系人数组
}

@end

@implementation SelectContacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
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
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * identity = @"SelectContacterCellIdentifier";
    SelectContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectContacterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.mHeaderImg.image = [UIImage imageNamed:@"me"];
    cell.mName.text = @"唐嫣";
    [cell.mSelectCheckBoxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    
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
    if (section == 0) {
        return 0;
    }else{
        return 40;
    }
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
