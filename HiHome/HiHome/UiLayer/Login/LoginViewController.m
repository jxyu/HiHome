//
//  LoginViewController.m
//  HiHome
//
//  Created by 王建成 on 15/9/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "LoginViewController.h"
#import "InputText.h"
#import "UIView+XD.h"
#import "UIDefine.h"
#import "JKAlertDialog.h"
#import "DataProvider.h"
#import "DataDefine.h"
#import "RegisterViewController.h"
#import "SVProgressHUD.h"
#import "UMSocial.h"
#import "NoticePageView.h"

@interface LoginViewController ()<UMSocialUIDelegate>{
    NSUserDefaults *mUserDefault;
    NSString *_mAccount;
    NSString *_mPassword;
}

@end

@implementation LoginViewController
{
    UITextField *userText;
    UITextField *passWordText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    _topView.hidden=YES;
    [self initViews];
  
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    loginBtn.backgroundColor = [UIColor blueColor];
    
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
  //  [self.view addSubview:loginBtn];
    // Do any additional setup after loading the view from its nib.
    



}
-(void) initViews
{
    mUserDefault = [NSUserDefaults standardUserDefaults];
    
    [self initImgViews];
    [self initTexts];
    [self initBtns];
    [self initLines];
    [self initLabels];
    [self initDatas];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
}
-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
}

-(void) initDatas
{
    _userData = [[DataDefine alloc] init];
}


-(UIImageView *)drawLine:(CGFloat)startX andSY:(CGFloat)startY andEX:(CGFloat)endX andEY:(CGFloat)endY andLW:(CGFloat)lineWidth andColor:(zyColor)color
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:imageView];
    
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), color.red,color.green, color.blue, color.alpha);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startX, startY);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endX, endY);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return imageView;
}

-(void)initLines
{
    zyColor tempColor;
    
    tempColor.alpha = 1.0;
    tempColor.red = 191/255.0;
    tempColor.green = 166/255.0;
    tempColor.blue = 128/255.0;
    
    
    [self drawLine:ZY_UIPART_SCREEN_WIDTH*50 andSY:(ZY_UIPART_SCREEN_HEIGHT * 55 + 65) andEX:ZY_UIPART_SCREEN_WIDTH*50 andEY:(ZY_UIPART_SCREEN_HEIGHT * 55 + 65+20) andLW:1 andColor:tempColor];
    
    [self drawLine:ZY_UIPART_SCREEN_WIDTH*5 andSY:ZY_UIPART_SCREEN_HEIGHT*80 andEX:ZY_UIPART_SCREEN_WIDTH*28 andEY:ZY_UIPART_SCREEN_HEIGHT*80 andLW:1 andColor:tempColor];
    
//    
    [self drawLine:(self.view.frame.size.width - ZY_UIPART_SCREEN_WIDTH*28) andSY:ZY_UIPART_SCREEN_HEIGHT*80 andEX:(self.view.frame.size.width - ZY_UIPART_SCREEN_WIDTH*5) andEY:ZY_UIPART_SCREEN_HEIGHT*80 andLW:1 andColor:tempColor];
}


-(void) initLabels
{
    NSString *str =@"你可以使用第三方进行登录";
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
//    
    CGSize labelsize = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    
    UILabel *tapLabel = [[UILabel alloc] initWithFrame:CGRectMake(ZY_UIPART_SCREEN_WIDTH*25, ZY_UIPART_SCREEN_HEIGHT*78.8,ZY_UIPART_SCREEN_WIDTH*50, labelsize.height)];
    tapLabel.text = str;
    tapLabel.font = font;
    tapLabel.textAlignment = NSTextAlignmentCenter;
    tapLabel.textColor = [UIColor colorWithRed:191/255.0 green:166/255.0 blue:128/255.0 alpha:1.0];
    [self.view addSubview:tapLabel];
    
    
}

-(void)initImgViews
{
    //logo
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImgView.frame = CGRectMake(ZY_UISTART_X, ZY_UIPART_SCREEN_HEIGHT * 20,self.view.frame.size.width - 2*ZY_UISTART_X ,ZY_UIPART_SCREEN_HEIGHT * 5 );
  //  logoImgView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:logoImgView];
    
    
    UIImageView *headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me"]];
    headImg.frame =CGRectMake((self.view.frame.size.width - 2*ZY_UISTART_X)/3+ZY_UISTART_X +20/2 ,
                              ZY_UIPART_SCREEN_HEIGHT * 20-((self.view.frame.size.width - 2*ZY_UISTART_X - 30)/3-20)/2,
                              (self.view.frame.size.width - 2*ZY_UISTART_X )/3-20,
                              (self.view.frame.size.width - 2*ZY_UISTART_X )/3-20);
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = headImg.frame.size.width * 0.5;
    headImg.layer.borderWidth = 1.0;
    headImg.layer.borderColor = [[UIColor yellowColor] CGColor];
    [self.view addSubview:headImg];
    

    UIImageView *accountImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
    accountImgView.frame = CGRectMake(ZY_UISTART_X, ZY_UIPART_SCREEN_HEIGHT * 35, 20, 20);
    accountImgView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:accountImgView];
    
    
    UIImageView *passwordImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    passwordImgView.frame = CGRectMake(ZY_UISTART_X, ZY_UIPART_SCREEN_HEIGHT * 45, 20, 20);
    passwordImgView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:passwordImgView];
    
    

}

-(void) initBtns
{
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame = CGRectMake(ZY_UIPART_SCREEN_WIDTH*25, ZY_UIPART_SCREEN_HEIGHT * 55, ZY_UIPART_SCREEN_WIDTH*50, 50);
    loginBtn.backgroundColor = ZY_UIBASECOLOR;
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.adjustsImageWhenHighlighted = YES;
    [self.view addSubview:loginBtn];
    
    
//    UIButton *testBtn = [[UIButton alloc] init];
//    testBtn.frame = CGRectMake(100, 100, 100, 50);
//   // [testBtn setHeight: YES];
//    [testBtn setHighlighted:YES];
//    testBtn.backgroundColor = ZY_UIBASECOLOR;
//    [testBtn setTitle:@"密码错误" forState:UIControlStateNormal];
//    [testBtn addTarget:self action:@selector(tempClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testBtn];
    
    
    UIButton *registerBtn = [[UIButton alloc] init];
    registerBtn.frame = CGRectMake(ZY_UIPART_SCREEN_WIDTH*25, ZY_UIPART_SCREEN_HEIGHT * 55 + 65, ZY_UIPART_SCREEN_WIDTH*50/2, 20);
    [registerBtn setTitleColor:[UIColor colorWithRed:191/255.0 green:166/255.0 blue:128/255.0 alpha:1.0] forState:UIControlStateNormal];
    [registerBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [registerBtn addTarget:self action:@selector(JumpToregisterVC:) forControlEvents:UIControlEventTouchUpInside];
    //设置文字居左
//    registerBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    
    
    registerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    registerBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);

    [self.view addSubview:registerBtn];
    
//    tempColor.red = 191/255.0;
//    tempColor.green = 166/255.0;
//    tempColor.blue = 128/255.0;
    
    UIButton *forgetBtn = [[UIButton alloc] init];
    forgetBtn.frame = CGRectMake(ZY_UIPART_SCREEN_WIDTH*25*2, ZY_UIPART_SCREEN_HEIGHT * 55+ 65, ZY_UIPART_SCREEN_WIDTH*50/2, 20);
    [forgetBtn setTitleColor:[UIColor colorWithRed:191/255.0 green:166/255.0 blue:128/255.0 alpha:1.0] forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [forgetBtn addTarget:self action:@selector(JumpToForgetVC:) forControlEvents:UIControlEventTouchUpInside];
//    forgetBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    forgetBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [self.view addSubview:forgetBtn];
    
    
    UIButton *QQLoginBtn = [[UIButton alloc] init];
    QQLoginBtn.frame = CGRectMake(ZY_UIPART_SCREEN_WIDTH*25, ZY_UIPART_SCREEN_HEIGHT * 90, 40, 40);
    QQLoginBtn.contentMode = UIViewContentModeCenter;
    [QQLoginBtn setImage:[UIImage imageNamed:@"qqlogin"] forState:UIControlStateNormal];
    [QQLoginBtn addTarget:self action:@selector(QQLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QQLoginBtn];
    
    
    UIButton *WechatBtn = [[UIButton alloc] init];
    WechatBtn.frame = CGRectMake(ZY_UIPART_SCREEN_WIDTH*75-40, ZY_UIPART_SCREEN_HEIGHT * 90, 40, 40);
    WechatBtn.contentMode = UIViewContentModeCenter;
    [WechatBtn setImage:[UIImage imageNamed:@"wechatlogin"] forState:UIControlStateNormal];
    [WechatBtn addTarget:self action:@selector(weChatLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:WechatBtn];
    
}

-(void) initTexts
{
    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = ZY_UIPART_SCREEN_HEIGHT * 35 ;
    userText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userText.tag = USER_TEXT_TAG;
    userText.delegate = self;
    userText.keyboardType = UIKeyboardTypeNumberPad;//设置键盘为数字键盘
    [userText setReturnKeyType:UIReturnKeyNext];
    [userText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [userText addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.view addSubview:userText];
    
    
    
    
    passWordText = [inputText setupWithIcon:nil textY:ZY_UIPART_SCREEN_HEIGHT * 45 centerX:self.view.width * 0.5 point:nil];
    passWordText.delegate = self;
    passWordText.tag = PASSWORD_TEXT_TAG;
    passWordText.secureTextEntry = YES;//设置输入后变为“＊”
    passWordText.clearsOnBeginEditing = YES;//重新选中后清空
    passWordText.keyboardAppearance = UIKeyboardAppearanceLight;
    [passWordText setReturnKeyType:UIReturnKeyNext];
    [passWordText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [passWordText addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.view addSubview:passWordText];
}


- (void)webViewDidStartLoad{
    if (myAlert==nil){
        myAlert = [[UIAlertView alloc] initWithTitle:nil
                                             message: @"登陆中..."
                                            delegate: self
                                   cancelButtonTitle: nil
                                   otherButtonTitles: nil];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(120.f, 48.0f, 38.0f, 38.0f);
        [myAlert addSubview:activityView];
        [activityView startAnimating];
        
        [myAlert show];
    }
}

- (void)webViewDidFinishLoad{
    [myAlert dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - textField delegate

#define NUMBERS @"0123456789\n"

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == USER_TEXT_TAG)
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
    
        return canChange;
    }
    else
    {
        return  YES;
    }
}

- (void)textFieldDidChange:(id)sender
{
    UITextField *tempText;
    tempText =(UITextField *)sender;
//    tempText.text
    NSLog(@"text tag [%ld] tempText.text = %@",(long)tempText.tag,tempText.text);
    
    switch (tempText.tag) {
        case USER_TEXT_TAG:
            _userData.phoneNum = tempText.text;
            break;
        case PASSWORD_TEXT_TAG:
            _userData.passWord = tempText.text;
            break;
        default:
            break;
    }
}


- (void)textFieldDidEnd:(id)sender
{
    UITextField *tempText;
    tempText =(UITextField *)sender;
    NSLog(@"text tag [%ld] tempText.text = %@",(long)tempText.tag,tempText.text);

    switch (tempText.tag) {
        case USER_TEXT_TAG:
            _userData.phoneNum = tempText.text;
            break;
        case PASSWORD_TEXT_TAG:
            _userData.passWord = tempText.text;
            break;
        default:
            break;
    }
    //    tempText.text
}


#pragma  mark - key click action
-(void) btnClick:(id)sender
{
    NoticePageView *tempView = [[NoticePageView alloc] initWithTitle:@"测试" message:@"测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面"];
    [tempView addButtonWithTitle:@"去执行"];
    [tempView addButtonWithTitle:@"取消任务"];
 //   [tempView addButtonWithTitle:@"正点提醒"];
    tempView.buttonHeight = 44;
    [tempView show];
    
    NSLog(@"Click btn");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:nil ];
}

-(void) loginBtnClick:(id)sender
{
    
    NSLog(@"Click btn");
    if(_userData.phoneNum.length == 0|| _userData.passWord.length == 0)
    {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"提示" message:@"请输入正确的用户名和密码"];
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
         NSLog(@"Out of click");
        return;
    }
    
    [self LoginFunc];
//    [self webViewDidStartLoad];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:nil userInfo:[NSDictionary dictionaryWithObject:@"mainpage" forKey:@"rootView"]];
}

-(void)LoginFunc
{
    if (_userData.phoneNum.length > 0) {
        [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"loginBackcall:"];
        [dataprovider Login:userText.text andpwd:passWordText.text andreferrer:@""];
    }
}
-(void)loginBackcall:(id)dict
{
    [SVProgressHUD dismiss];
    printf("[%s] start \r\n",__FUNCTION__);
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200 ) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        NSArray * itemdict=[[NSArray alloc] initWithArray:dict[@"datas"]];
        BOOL result= [itemdict[0] writeToFile:plistPath atomically:YES];
        if (result) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:nil userInfo:[NSDictionary dictionaryWithObject:@"mainpage" forKey:@"rootView"]];
            
            //设置默认值
            [self setLoginValue:itemdict[0]];
            
            //设置通知
            [self setNotificate];
            
            
            //[NSNotificationCenter defaultCenter] postNotificationName:@"Login_success" object:nil];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    printf("[%s] end\r\n",__FUNCTION__);
}

-(void)setLoginValue:(NSDictionary *)dict{
    [mUserDefault setValue:[dict valueForKey:@"mobile"] forKey:@"mAccountID"];
    [mUserDefault setValue:[dict valueForKey:@"avatar"] forKey:@"avatar"];
}

-(void)setNotificate{
    //重新获取好友信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getFriendInfo" object:nil];
    
    //获取聊天Token
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getTokenInfo" object:nil];
    
    //登陆时重新获取头像
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setHeadImg" object:nil];
    
    //获取左侧栏用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfo" object:nil];
    
    //设置显示/隐藏tabbar
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil];
}

-(void)tempClick:(id)sender
{
     NSLog(@"Click btn2");
   // JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"家和提醒您" message:@"对不起您的账户不存在请前往注册"];
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"解除关系" message:@"解除关系后，你们之间的关系就会成为陌生人，不在接收信息"];

  //  alert.alertType = AlertType_Alert;
    alert.alertType = AlertType_Hint;
    [alert addButtonWithTitle:@"确定"];
  //  [alert addButtonWithTitle:@"取消"];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)JumpToregisterVC:(UIButton *)sender
{
    NSLog(@"跳转");
    RegisterViewController * registerVC=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:registerVC animated:YES completion:^{}];
}
-(void)QQLogin:(UIButton *)sender
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
            NSLog(@"SnsInformation is %@",response.data);
        }];
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            _mAccount = [NSString stringWithFormat:@"%@%@",snsAccount.userName,[snsAccount.usid substringFromIndex:snsAccount.usid.length - 3]];
            _mPassword = snsAccount.usid;
            
            //调用注册接口
            [self registerInterface];
            
        }});
}

-(void)weChatLogin:(UIButton *)sender
{
    @try {
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
                _mAccount = [NSString stringWithFormat:@"%@%@",snsAccount.userName,[snsAccount.usid substringFromIndex:snsAccount.usid.length - 4]];
                _mPassword = snsAccount.usid;
                //调用注册接口
                [self registerInterface];
                
            }
        });
    }
    @catch (NSException *exception) {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"该功能暂时不能使用" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    @finally {
        
    }
}

-(void)registerInterface{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"registerInterfaceBackCall:"];
    NSDictionary * prm=@{@"mob":[NSString stringWithFormat:@"%@",_mAccount],@"pass":_mPassword};//oRxyawTtX2lCkMW0JRtnZDmHXkpM
    [dataProvider RegisterUserInfo:prm];
}

-(void)registerInterfaceBackCall:(id)dict{
    NSLog(@"%@",dict);
    int code = [dict[@"code"] intValue];
    if (code == 200) {
        
        [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"loginBackcall:"];
        [dataprovider Login:_mAccount andpwd:_mPassword andreferrer:@""];
        
    }else{
        if ([dict[@"message"] isEqual:@"手机号码已存在"]) {
            
            [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"loginBackcall:"];
            [dataprovider Login:_mAccount andpwd:_mPassword andreferrer:@""];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
}

-(void)JumpToForgetVC:(UIButton *)sender
{
    NSLog(@"跳转");
    RegisterViewController * registerVC=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]];
    registerVC.pageMode = MODE_forget;
    [self presentViewController:registerVC animated:YES completion:^{}];
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
