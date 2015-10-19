//
//  RegisterViewController.m
//  HiHome
//
//  Created by 于金祥 on 15/10/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    UITextField * txt_phoneNum;
    UITextField * txt_vrifyCode;
    UITextField * txt_newPwd;
    UITextField * txt_againNewPwd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"注册";
    
    [self loadAllView];
}

-(void)loadAllView
{
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    switch (indexPath.row) {
        case 0:
        {
            txt_phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-140, 30)];
            txt_phoneNum.placeholder=@"请输入您的手机号";
            [cell addSubview:txt_phoneNum];
            UIButton * btn_GetvrifyCode=[[UIButton alloc] initWithFrame:CGRectMake(txt_phoneNum.frame.size.width+txt_phoneNum.frame.origin.x, 10, 100, 30)];
            [btn_GetvrifyCode setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
            [btn_GetvrifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
            btn_GetvrifyCode.layer.masksToBounds=YES;
            btn_GetvrifyCode.layer.borderWidth=0.4;
            btn_GetvrifyCode.layer.borderColor=[ZY_UIBASECOLOR CGColor];
            [cell addSubview:btn_GetvrifyCode];
        }
            break;
        case 1:
            txt_vrifyCode=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 30)];
            txt_vrifyCode.placeholder=@"请输入您的验证码";
            [cell addSubview:txt_vrifyCode];
            break;
        case 2:
            txt_newPwd=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 30)];
            txt_newPwd.placeholder=@"请输入您的新密码";
            [cell addSubview:txt_newPwd];
            break;
        case 3:
            txt_againNewPwd=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 30)];
            txt_againNewPwd.placeholder=@"请再次输入您的验证码";
            [cell addSubview:txt_againNewPwd];
            break;
        case 4:
        {
            UIButton * btn_fuwuxieyi=[[UIButton alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
            [btn_fuwuxieyi setImage:[UIImage imageNamed:@"regster_select_icon@2x.png"] forState:UIControlStateNormal];
            [btn_fuwuxieyi setTitle:@"服务协议" forState:UIControlStateNormal];
            [btn_fuwuxieyi setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
            [cell addSubview:btn_fuwuxieyi];
            
            UIButton * btn_yinsi=[[UIButton alloc] initWithFrame:CGRectMake(btn_fuwuxieyi.frame.size.width+btn_fuwuxieyi.frame.origin.x+ 20, 10, 100, 30)];
            [btn_yinsi setImage:[UIImage imageNamed:@"regster_select_icon@2x.png"] forState:UIControlStateNormal];
            [btn_yinsi setTitle:@"隐私政策" forState:UIControlStateNormal];
            [btn_yinsi setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
            [cell addSubview:btn_yinsi];
        }
            break;
        case 5:
        {
            UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 10, 100, 30)];
            btn_sure.backgroundColor=ZY_UIBASECOLOR;
            [btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
            [cell addSubview:btn_sure];
        }
            break;
        default:
            break;
    }
    
    if (indexPath.row<4) {
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(20,cell.frame.size.height-1 , SCREEN_WIDTH-40, 1)];
        fenge.backgroundColor=ZY_UIBASECOLOR;
        [cell addSubview:fenge];
    }
    
    
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
