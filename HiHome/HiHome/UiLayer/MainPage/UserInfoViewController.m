//
//  UserInfoViewController.m
//  HiHome
//
//  Created by 于金祥 on 15/10/22.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "ZHPickView.h"

@interface UserInfoViewController ()<ZHPickViewDelegate>
@property(nonatomic,strong)ZHPickView *pickview;
@end

@implementation UserInfoViewController
{
    UITextField * txt_name;
    UITextField * txt_signe;
    NSString * birthDay;
    UILabel * lbl_birtiday;
    BOOL isMan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lblTitle.text = @"个人资料";
    [self addLeftButton:@"goback@2x.png"];
    isMan=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"YES" forKey:@"hide"]];
    self.tabBarController.hidesBottomBarWhenPushed=YES;
    _myTableview.dataSource=self;
    _myTableview.delegate=self;
    _myTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
}




#pragma mark PickViewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    lbl_birtiday.text=resultString;
}


#pragma mark TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==3) {
        [_pickview remove];
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 200;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    @try {
        cell.textLabel.textColor=ZY_UIBASE_FONT_COLOR;
        switch (indexPath.section) {
            case 0:
            {
                cell.textLabel.text=@"名称";
                txt_name=[[UITextField alloc] initWithFrame:CGRectMake(80, 15, cell.frame.size.width-100, 30)];
                txt_name.placeholder=@"请输入您的名称";
                [cell addSubview:txt_name];
            }
                break;
            case 1:
            {
                cell.textLabel.text=@"序列号";
                UILabel * lbl_birtiday=[[UILabel alloc] initWithFrame:CGRectMake(80, 15, cell.frame.size.width-100, 30)];
                lbl_birtiday.text=birthDay?birthDay:@"123456789";
                lbl_birtiday.textColor=ZY_UIBASE_FONT_COLOR;
                [cell addSubview:lbl_birtiday];
            }
                break;
            case 2:
            {
                cell.textLabel.text=@"性别";
                UIView * Sex_BackView=[[UIView alloc] initWithFrame:CGRectMake(80, 0, cell.frame.size.width-100, cell.frame.size.height)];
                
                UIButton * btn_nan=[[UIButton alloc] initWithFrame:CGRectMake(0, 15, Sex_BackView.frame.size.width/2, 30)];
                UIButton * btn_nv=[[UIButton alloc] initWithFrame:CGRectMake(Sex_BackView.frame.size.width/2, btn_nan.frame.origin.y, Sex_BackView.frame.size.width/2, 30)];
                [btn_nan setImage:[UIImage imageNamed:isMan?@"select_Radio_icon@2x.png":@"unselect_Radio_icon@2x.png"] forState:UIControlStateNormal];
                [btn_nv setImage:[UIImage imageNamed:isMan? @"unselect_Radio_icon@2x.png":@"select_Radio_icon@2x.png"] forState:UIControlStateNormal];
                [btn_nan setTitle:@"   男" forState:UIControlStateNormal];
                [btn_nv setTitle:@"   女" forState:UIControlStateNormal];
                [btn_nan setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn_nv setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                btn_nan.tag=1;
                [btn_nan addTarget:self action:@selector(btn_selectSex:) forControlEvents:UIControlEventTouchUpInside];
                [btn_nv addTarget:self action:@selector(btn_selectSex:) forControlEvents:UIControlEventTouchUpInside];
                [Sex_BackView addSubview:btn_nan];
                [Sex_BackView addSubview:btn_nv];
                [cell addSubview:Sex_BackView];
            }
                break;
            case 3:
            {
                cell.textLabel.text=@"生日";
                lbl_birtiday=[[UILabel alloc] initWithFrame:CGRectMake(80, 10, cell.frame.size.width-100, 40)];
                lbl_birtiday.text=birthDay?birthDay:@"年  月  日";
                lbl_birtiday.textAlignment=NSTextAlignmentCenter;
                [cell addSubview:lbl_birtiday];
                
            }
                break;
            case 4:
            {
                cell.textLabel.text=@"签名";
                txt_signe=[[UITextField alloc] initWithFrame:CGRectMake(80, 15, cell.frame.size.width-100, 30)];
                txt_signe.placeholder=@"请输入您的签名";
                [cell addSubview:txt_signe];
            }
                break;
            case 5:
            {
                UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake((cell.frame.size.width-180)/2, 5, 180, 50)];
                
                btn_sure.backgroundColor=ZY_UIBASECOLOR;
                [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
                [btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell addSubview:btn_sure];
            }
                break;
            case 6:
            {
                UILabel * lbl_tishi=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, cell.frame.size.width, 30)];
                lbl_tishi.text=@"下次可以直接用手机号登录";
                lbl_tishi.textColor=[UIColor grayColor];
                lbl_tishi.textAlignment=NSTextAlignmentCenter;
                [cell addSubview:lbl_tishi];
            }
                break;
            default:
                break;
        }
        
        if (indexPath.section==0||indexPath.section==4) {
            UIView * LineVC=[[UIView alloc] initWithFrame:CGRectMake(80, 50, cell.frame.size.width-100, 2)];
            LineVC.backgroundColor=ZY_UIBASE_FONT_COLOR;
            [cell addSubview:LineVC];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        sectionHeaderView.backgroundColor=[UIColor whiteColor];
        CGFloat btn_wh=100;
        UIButton * btn_selectImg=[[UIButton alloc] initWithFrame:CGRectMake((sectionHeaderView.frame.size.width-btn_wh)/2, (sectionHeaderView.frame.size.height-btn_wh)/2, btn_wh, btn_wh)];
        UIImageView * img_avatar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn_wh, btn_wh)];
        [img_avatar sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
        img_avatar.layer.masksToBounds=YES;
        img_avatar.layer.cornerRadius=btn_wh/2;
        img_avatar.layer.borderWidth=0.5;
        img_avatar.layer.borderColor=ZY_UIBASECOLOR.CGColor;
        [btn_selectImg addSubview:img_avatar];
        
        
        [sectionHeaderView addSubview:btn_selectImg];
        
        
        return sectionHeaderView;
    }
    else
    {
        return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}





-(void)btn_selectSex:(UIButton *)sender
{
    if (sender.tag!=0) {
        isMan=YES;
    }
    else
    {
        isMan=NO;
    }
    [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)clickLeftButton:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
