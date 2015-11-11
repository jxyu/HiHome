//
//  CoupleViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "CoupleViewController.h"
#import "UIDefine.h"
#import "JKAlertDialog.h"
#import "DataProvider.h"

@interface CoupleViewController (){
    DataProvider *mDataProvider;
    NSArray *mSpouseArray;
    NSUserDefaults *mUserDefault;
    NSString *uid;
}

@end

@implementation CoupleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
}

-(void)initData{
    mUserDefault = [NSUserDefaults standardUserDefaults];
    
    mDataProvider = [[DataProvider alloc] init];
    [mDataProvider setDelegateObject:self setBackFunctionName:@"getSpouseDetailBackCall:"];
    [mDataProvider getFriendList:[self getUserID]];
}

-(void)getSpouseDetailBackCall:(id)dict{
    NSLog(@"%@",dict);
    int code = [dict[@"code"] intValue];
    if (code == 200) {
        mSpouseArray = [[dict valueForKey:@"datas"] valueForKey:@"list2"];
    }else{
        [self initViews1];
    }

    if (mSpouseArray && mSpouseArray.count > 0) {
        [self initViews2];
    }else{
        [self initViews1];
    }
}

-(void) initViews1
{
    if(_okBtn==nil)
    {
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height - ZY_VIEWHEIGHT_IN_HEADVIEW)/2,SCREEN_WIDTH - 20 * 2, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    }
    _okBtn.backgroundColor = ZY_UIBASECOLOR;
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(ClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_okBtn];
    
    
    if(_phoneNumField == nil)
    {
        _phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(20,ZY_HEADVIEW_HEIGHT +  (SCREEN_HEIGHT - ZY_VIEWHEIGHT_IN_HEADVIEW)/4, SCREEN_WIDTH-20*2, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    }
    _phoneNumField.placeholder = @"请填写对方的账号或手机号";
   // _phoneNumField.borderStyle = UITextBorderStyleRoundedRect;
    _phoneNumField.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;//[UIColor grayColor];
    _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneNumField];
    
    if(_tapLabel == nil)
    {
        _tapLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ZY_HEADVIEW_HEIGHT+ ((SCREEN_HEIGHT - ZY_VIEWHEIGHT_IN_HEADVIEW)/4 - ZY_HEADVIEW_HEIGHT)/2, SCREEN_WIDTH-20*2, ZY_VIEWHEIGHT_IN_HEADVIEW*2)];
    }
    _tapLabel.text = @"请填写另一半的手机号或家和账号进行绑定";
    _tapLabel.textColor = [UIColor grayColor];
    _tapLabel.numberOfLines = 0;
    [self.view addSubview:_tapLabel];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
}

-(void) initViews2
{
    
    UILabel *name_lbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) / 2, ZY_HEADVIEW_HEIGHT +  (SCREEN_HEIGHT - ZY_VIEWHEIGHT_IN_HEADVIEW)/4, 150, 50)];
    name_lbl.textAlignment = NSTextAlignmentCenter;
    name_lbl.font = [UIFont systemFontOfSize:17];
    name_lbl.text = [NSString stringWithFormat:@"%@%@",@"姓名:",[mSpouseArray[0] valueForKey:@"nick"]];
    name_lbl.textColor = [UIColor grayColor];
    [self.view addSubview:name_lbl];
    
    if(_tapLabel == nil)
    {
        _tapLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ZY_HEADVIEW_HEIGHT+ ((SCREEN_HEIGHT - ZY_VIEWHEIGHT_IN_HEADVIEW)/4 - ZY_HEADVIEW_HEIGHT)/2, SCREEN_WIDTH-20*2, ZY_VIEWHEIGHT_IN_HEADVIEW*2)];
    }
    _tapLabel.text = @"已绑定配偶";
    _tapLabel.font = [UIFont systemFontOfSize:24];
    _tapLabel.numberOfLines = 0;
    _tapLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tapLabel];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
}


-(void)ClickBtn
{
    [_phoneNumField resignFirstResponder];//关闭键盘
    if (_phoneNumField.text.length != 11) {
        JKAlertDialog *alert = [[JKAlertDialog alloc] initWithTitle:@"提示" message:@"请输入11位手机号~"];
        alert.alertType = AlertType_Alert;
        [alert addButton:Button_CANCEL withTitle:@"确定" handler:nil];
        [alert show];
        return;
    }
    mDataProvider = [[DataProvider alloc] init];
    [mDataProvider setDelegateObject:self setBackFunctionName:@"getUserIDByPhoneBackCall:"];
    [mDataProvider getContacterByPhone:_phoneNumField.text];
}

-(void)getUserIDByPhoneBackCall:(id)dict{
    NSLog(@"%@",dict);
    int code = [dict[@"code"] intValue];
    if (code == 200) {
        uid = [[[dict valueForKey:@"datas"] valueForKey:@"list"][0] valueForKey:@"id"];
        if (uid) {
            if([uid isEqual:[self getUserID]]){
                JKAlertDialog *alert = [[JKAlertDialog alloc] initWithTitle:@"提示" message:@"不能给自己发送"];
                alert.alertType = AlertType_Alert;
                [alert addButton:Button_CANCEL withTitle:@"确定" handler:nil];
                [alert show];
            }else{
                mDataProvider = [[DataProvider alloc] init];
                [mDataProvider setDelegateObject:self setBackFunctionName:@"getSpouseApplyList:"];
                [mDataProvider getSpouseApplayList:uid];
            }
        }else{
            JKAlertDialog *alert = [[JKAlertDialog alloc] initWithTitle:@"提示" message:@"该用户不存在~"];
            alert.alertType = AlertType_Alert;
            [alert addButton:Button_CANCEL withTitle:@"确定" handler:nil];
            [alert show];
        }
    }else{
        JKAlertDialog *alert = [[JKAlertDialog alloc] initWithTitle:@"提示" message:dict[@"message"]];
        alert.alertType = AlertType_Alert;
        [alert addButton:Button_CANCEL withTitle:@"确定" handler:nil];
        [alert show];
    }
}

-(void)getSpouseApplyList:(id)dict{
    NSLog(@"%@",dict);
    NSArray *mArray = [dict valueForKey:@"datas"];

    for (int i = 0; i < mArray.count; i++) {
        if ([[mArray[i] valueForKey:@"state"] isEqual:@"0"] && [[mArray[i] valueForKey:@"uid"] isEqual:[self getUserID]]) {
            JKAlertDialog *alert = [[JKAlertDialog alloc] initWithTitle:@"提示" message:@"已向对方发送过邀请了"];
            alert.alertType = AlertType_Alert;
            [alert addButton:Button_CANCEL withTitle:@"确定" handler:nil];
            [alert show];
            _phoneNumField.text = @"";
            return;
        }
    }
    mDataProvider = [[DataProvider alloc] init];
    [mDataProvider setDelegateObject:self setBackFunctionName:@"sendSpouseInvite:"];
    [mDataProvider changeFriendType:uid andUserID:[self getUserID] andType:@"2"];
}

-(void)sendSpouseInvite:(id)dict{
    NSLog(@"%@",dict);
    int code = [dict[@"code"] intValue];
    if (code == 200) {
        JKAlertDialog *alert = [[JKAlertDialog alloc] initWithTitle:@"提示" message:@"已向对方发送过邀请了"];
        alert.alertType = AlertType_Alert;
        [alert addButton:Button_CANCEL withTitle:@"确定" handler:nil];
        [alert show];
        [self dismissViewControllerAnimated:NO completion:nil];
        //设置显示/隐藏tabbar
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil];
    }else{
        JKAlertDialog *alert = [[JKAlertDialog alloc] initWithTitle:@"提示" message:dict[@"message"]];
        alert.alertType = AlertType_Alert;
        [alert addButton:Button_CANCEL withTitle:@"提示" handler:^(JKAlertDialogItem *item) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
        [alert show];
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

//重写返回按钮
-(void)quitView{

    [self dismissViewControllerAnimated:YES completion:^{}];
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backFrom" object:nil userInfo:[NSDictionary dictionaryWithObject:@"slideTabView" forKey:@"backFrom"]];
}


-(void)tapViewAction:(id)sender
{
    [_phoneNumField resignFirstResponder];//关闭titleField的键盘
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
