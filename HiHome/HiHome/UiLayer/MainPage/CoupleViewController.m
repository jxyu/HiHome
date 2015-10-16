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


@interface CoupleViewController ()

@end

@implementation CoupleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    // Do any additional setup after loading the view from its nib.
}

-(void) initViews
{
    if(_okBtn==nil)
    {
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height - ZY_VIEWHEIGHT_IN_HEADVIEW)/2, self.view.frame.size.width-20*2, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    }
    _okBtn.backgroundColor = ZY_UIBASECOLOR;
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(ClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_okBtn];
    
    
    if(_phoneNumField == nil)
    {
        _phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(40,ZY_HEADVIEW_HEIGHT +  (self.view.frame.size.height - ZY_VIEWHEIGHT_IN_HEADVIEW)/4, self.view.frame.size.width-40*2, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    }
    _phoneNumField.placeholder = @"请填写对方的账号或手机号";
   // _phoneNumField.borderStyle = UITextBorderStyleRoundedRect;
    _phoneNumField.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;//[UIColor grayColor];
    _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneNumField];
    
    if(_tapLabel == nil)
    {
        _tapLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, ZY_HEADVIEW_HEIGHT+ ((self.view.frame.size.height - ZY_VIEWHEIGHT_IN_HEADVIEW)/4 - ZY_HEADVIEW_HEIGHT)/2, self.view.frame.size.width-40*2, ZY_VIEWHEIGHT_IN_HEADVIEW*2)];
    }
    _tapLabel.text = @"请填写另一半的手机号或家和账号进行绑定";
    _tapLabel.textColor = [UIColor grayColor];
    _tapLabel.numberOfLines = 0;
    [self.view addSubview:_tapLabel];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
}


-(void)ClickBtn
{
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"恭喜成功" message:@"亲爱的用户恭喜您成功发送邀请通知"];
    [_phoneNumField resignFirstResponder];//关闭键盘
   
    alert.alertType = AlertType_Hint;
    [alert addButtonWithTitle:@"确定"];
    
    [alert show];
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
