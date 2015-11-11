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
#import "UIImageView+WebCache.h"
#import "BaseTableViewCell.h"

@interface LoginViewController ()<UMSocialUIDelegate,UIGestureRecognizerDelegate>{
    NSUserDefaults *mUserDefault;
    NSString *_mAccount;
    NSString *_mPassword;
    UIImageView *headImg;
    
    CGFloat _cellHeight;
    NSInteger _cellCount;

    //UIView *_moveDownGroup;
    UIView *_account_box;
    UITableView *_accountTableView;
  //  NSMutableArray *_userAccountArr;
    NSMutableArray *_AccountArrCache;
    
    
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
    _AccountArrCache = [NSMutableArray array];
    _cellCount = 0;
    _cellHeight = 40;
    [self initDatas];
    [self initViews];
  
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];//测试按钮
    loginBtn.backgroundColor = [UIColor blueColor];
    
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//   [self.view addSubview:loginBtn];
    // Do any additional setup after loading the view from its nib.
    

}

-(void)initDatas
{
    
    _userData = [[DataDefine alloc] init];
    mUserDefault = [NSUserDefaults standardUserDefaults];
    _AccountArrCache = [mUserDefault valueForKey:@"userAccountList"];
    if(_AccountArrCache!=nil)
    {
        _cellCount = _AccountArrCache.count;
    }
    
    
}

-(void) initViews
{
   
    
    [self initImgViews];
    [self initTexts];
    [self initBtns];
    [self initLines];
    [self initLabels];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
}
-(void)tapViewAction:(id)sender
{
    [self.view endEditing:YES];
    
    [self hideAccountBox];
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
    
    
    headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me"]];
    headImg.frame =CGRectMake((self.view.frame.size.width - 2*ZY_UISTART_X)/3+ZY_UISTART_X +20/2 ,
                              ZY_UIPART_SCREEN_HEIGHT * 20-((self.view.frame.size.width - 2*ZY_UISTART_X - 30)/3-20)/2,
                              (self.view.frame.size.width - 2*ZY_UISTART_X )/3-20,
                              (self.view.frame.size.width - 2*ZY_UISTART_X )/3-20);
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = headImg.frame.size.width * 0.5;
    headImg.layer.borderWidth = 1.0;
    headImg.layer.borderColor = [[UIColor yellowColor] CGColor];
    [self.view addSubview:headImg];
    

//    UIImageView *accountImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
//    accountImgView.frame = CGRectMake(ZY_UISTART_X, ZY_UIPART_SCREEN_HEIGHT * 35, 20, 20);
//    accountImgView.contentMode = UIViewContentModeCenter;
//    [self.view addSubview:accountImgView];
//    
//    
//    UIImageView *passwordImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
//    passwordImgView.frame = CGRectMake(ZY_UISTART_X, ZY_UIPART_SCREEN_HEIGHT * 45, 20, 20);
//    passwordImgView.contentMode = UIViewContentModeCenter;
//    [self.view addSubview:passwordImgView];
    
    

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
    userText = [inputText setupWithIcon:@"account" textY:userY centerX:centerX point:nil];
    userText.tag = USER_TEXT_TAG;
    userText.delegate = self;
    userText.keyboardType = UIKeyboardTypeNumberPad;//设置键盘为数字键盘
    [userText setReturnKeyType:UIReturnKeyNext];
    [userText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [userText addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [userText addTarget:self action:@selector(textFieldBeginChange:) forControlEvents:UIControlEventEditingDidBegin];
    
    [self.view addSubview:userText];
    
    _account_box = [[UIScrollView alloc] initWithFrame:CGRectMake(userText.frame.origin.x, userText.frame.origin.y+userText.frame.size.height+1, userText.frame.size.width, _cellCount >3 ?40*3:40*_cellCount)];
    _account_box.hidden = YES;
  //  _account_box.layer.borderWidth = 0.5;
    _account_box.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    
   // _account_box.backgroundColor = [UIColor greenColor];
    
    _accountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _account_box.frame.size.width, _account_box.frame.size.height)];
    _accountTableView.delegate = self;
    _accountTableView.dataSource = self;
    _accountTableView.tableFooterView = [[UIView alloc] init];
    _accountTableView.contentSize = CGSizeMake(_account_box.frame.size.width, _cellCount >3 ?40*_cellCount:_account_box.frame.size.height);
    _accountTableView.separatorInset = UIEdgeInsetsMake(10, _cellHeight + 10, 10, 20);
    
    _accountTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _accountTableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
//    _accountTableView.separatorInset = UIEdgeInsetsZero;
//    _accountTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    
//    //_mainTableView.separatorEffect = ;
//    
//    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
//    {
//        //设置cell分割线从最左边开始
//        if ([_accountTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//            [_accountTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//        }
//        
//        if ([_accountTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//            [_accountTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//        }
//    }
    
    [_account_box addSubview:_accountTableView];
    [self.view addSubview:_account_box];
    
    //[self.view addSubview:_moveDownGroup];
    
    passWordText = [inputText setupWithIcon:@"password" textY:ZY_UIPART_SCREEN_HEIGHT * 45 centerX:self.view.width * 0.5 point:nil];
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

#pragma mark - UIGestureRecognizer delegate

//设置点在某个view时部触发事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"-%@", NSStringFromClass([touch.view class]));
    
    //||[NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] [NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]||
    
    // if(gestureRecognizer.d)
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    //  NSLog(@"return YES");
    return  YES;
}

#define ANIMATION_DURATION 0.5f

-(void)showAccountBox
{
    
//    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
//    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y)]];
//    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y+_account_box.frame.size.height)]];
//    [move setDuration:ANIMATION_DURATION];
//    [_moveDownGroup.layer addAnimation:move forKey:nil];
    
    
    [_account_box setHidden:NO];
    [self.view bringSubviewToFront:_account_box];
    
    //模糊处理

    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y-_account_box.bounds.size.height/2)]];
    [center setToValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y)]];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    [group setDuration:ANIMATION_DURATION];
    [_account_box.layer addAnimation:group forKey:nil];
    
    
    
 //   [_moveDownGroup setCenter:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y+_account_box.frame.size.height)];
    
}

-(void)hideAccountBox
{

//    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
//    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y)]];
//    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y-_account_box.frame.size.height)]];
//    [move setDuration:ANIMATION_DURATION];
//    [_moveDownGroup.layer addAnimation:move forKey:nil];
//    
//    [_moveDownGroup setCenter:CGPointMake(_moveDownGroup.center.x, _moveDownGroup.center.y-_account_box.frame.size.height)];

    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    
    CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y)]];
    [center setToValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y-_account_box.bounds.size.height/2)]];
    
//    [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.frame.size.width, _account_box.frame.size.height)]];
//    [center setToValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.frame.size.width, _account_box.frame.size.height-_account_box.bounds.size.height/2)]];
    
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    [group setDuration:ANIMATION_DURATION];
    [_account_box.layer addAnimation:group forKey:nil];
    
   // [self performSelectorOnMainThread:@selector(viewDisappeared:) withObject:nil waitUntilDone:NO];
   // _account_box.hidden = YES;
    [self performSelector:@selector(viewSetHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:ANIMATION_DURATION - 0.1];
 //
}

-(void)viewSetHidden:(id)info
{
   _account_box.hidden = YES;
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

- (void)textFieldBeginChange:(id)sender
{
    NSLog(@"begin edit");
    [self showAccountBox];
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
            if (tempText.text.length == 11) {
                [self getHeadImgByPhone:tempText.text];
            }
            break;
        case PASSWORD_TEXT_TAG:
            _userData.passWord = tempText.text;
            break;
        default:
            break;
    }
}

-(void)getHeadImgByPhone:(NSString *)phone{
    DataProvider *mDataProvider = [[DataProvider alloc] init];
    [mDataProvider setDelegateObject:self setBackFunctionName:@"getHeadImgByPhoneBackCall:"];
    [mDataProvider getContacterByPhone:phone];
}

-(void)getHeadImgByPhoneBackCall:(id)dict{
    NSLog(@"%@",dict);
    int code = [dict[@"code"] intValue];
    if (code == 200) {
        NSString *avatar = [[[dict valueForKey:@"datas"] valueForKey:@"list"][0] valueForKey:@"avatar"];
        NSLog(@"%@",avatar);
        NSString *url = [NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [headImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
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

-(void)setNotice:(NSDate *)noticeDate andNoticeStr:(NSString *)noticeStr andRepeat:(NSCalendarUnit) repeatMode andTaskId:(NSString *)taskId andSid:(NSString *)sid andTaskDetailMode:(NSString *)taskDetailMode
{
    if(noticeDate && noticeStr && taskId &&sid && taskDetailMode)
    {
        NSLog(@"noticeDate = [%@]",noticeDate);
        UILocalNotification *notification=[[UILocalNotification alloc] init];
        if (notification!=nil) {
            //  NSDate *now=[NSDate date];
            
            notification.fireDate=noticeDate;
            notification.repeatInterval=repeatMode;//循环次数，
            notification.timeZone=[NSTimeZone defaultTimeZone];
            notification.applicationIconBadgeNumber=1; //应用的红色数字
            notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
            //去掉下面2行就不会弹出提示框
            
            notification.alertBody=[NSString stringWithFormat:@"您有任务（%@）待执行",noticeStr];//[NSString stringWithFormat:@"%@设置的小家提醒您",noticeDate];//@"通知内容";//提示信息 弹出提示框
            notification.alertAction = @"打开";  //提示框按钮
            //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
            NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithObject:taskId forKey:@"taskid"];
            [infoDict setObject:sid forKey:@"sid"];
            [infoDict setObject:taskDetailMode forKey:@"taskDetailMode"];
            notification.userInfo = infoDict; //添加额外的信息
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            //  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        }
    }
}

#pragma  mark - key click action
-(void) btnClick:(id)sender
{
    
    NSDate *nowDate = [NSDate date];
    
    [self setNotice:[nowDate dateByAddingTimeInterval:30] andNoticeStr:@"测试用" andRepeat:0 andTaskId:@"374" andSid:@"468" andTaskDetailMode:@"0"];
    
    
//    NoticePageView *tempView = [[NoticePageView alloc] initWithTitle:@"测试" message:@"测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面测试页面"];
//    [tempView addButtonWithTitle:@"去执行"];
//    [tempView addButtonWithTitle:@"取消任务"];
// //   [tempView addButtonWithTitle:@"正点提醒"];
//    tempView.buttonHeight = 44;
//    [tempView show];
//    
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
    @try {
           [mUserDefault setValue:[dict valueForKey:@"mobile"] forKey:@"mAccountID"];
           [mUserDefault setValue:[dict valueForKey:@"avatar"] forKey:@"avatar"];
           
           NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
           
           [tempDict setObject:[dict valueForKey:@"mobile"] forKey:@"mAccountID"];
           [tempDict setObject:[dict valueForKey:@"avatar"] forKey:@"avatar"];
           [tempDict setObject:passWordText.text forKey:@"password"];
           
           for (int i = 0; i<_AccountArrCache.count; i++)
           {
               NSDictionary *checkDict = [_AccountArrCache objectAtIndex:i];
               
               if([tempDict[@"mAccountID"] isEqualToString:checkDict[@"mAccountID"]])
               {
                   
                   if([tempDict isEqualToDictionary:checkDict])//存在的账号信息完全相同则不保存
                   {
                       //                [mUserDefault setValue:_AccountArrCache forKey:@"userAccountList"];
                       return;
                   }
                   //   goto end;
                   else//否则替换掉之前的
                   {
                       [_AccountArrCache replaceObjectAtIndex:i withObject:tempDict];
                       [mUserDefault setValue:_AccountArrCache forKey:@"userAccountList"];
                       //  goto end;
                   }
               }
               
               
           }
           
           NSMutableArray *mutaArray = [[NSMutableArray alloc] init];//反复给_AccountArrCache赋值会崩溃 这里参考网上的解决方案
           [mutaArray addObjectsFromArray:_AccountArrCache];
           [mutaArray addObject:tempDict];
           _AccountArrCache = mutaArray;
           
           [mUserDefault setValue:_AccountArrCache forKey:@"userAccountList"];
    
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
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
                
                _mAccount = [NSString stringWithFormat:@"%@%@",snsAccount.userName,[snsAccount.usid substringFromIndex:snsAccount.usid.length - 3]];
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

#pragma mark - delegate tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    //    switch (section) {
    //        case 0:
    //            return 3;
    //            break;
    //        default:
    //            break;
    //    }
    
    return _cellCount;
}


#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
//    NSMutableArray *Labels = [NSMutableArray array];
//    NSMutableArray *Imgs = [NSMutableArray array];
    
    
    NSDictionary *tempDict;
    @try {
        tempDict = [_AccountArrCache objectAtIndex:indexPath.row];
        
        UIImageView *cellHeadImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, _cellHeight - 10, _cellHeight -10)];
        NSString *avatar = [tempDict valueForKey:@"avatar"];
        NSString *url = [NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [cellHeadImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        
        cellHeadImg.layer.masksToBounds = YES;
        cellHeadImg.layer.cornerRadius = cellHeadImg.frame.size.width * 0.5;
        cellHeadImg.layer.borderWidth = 0.1;
      //  cellHeadImg.layer.borderColor = [[UIColor yellowColor] CGColor];
    
        [cell addSubview:cellHeadImg];
        //[Imgs addObject:cellHeadImg];
        
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + _cellHeight +10, 0, 150, _cellHeight)];
        
        cellLabel.text =[tempDict valueForKey:@"mAccountID"];
        cellLabel.font = [UIFont systemFontOfSize:14];
        [cell addSubview:cellLabel];
        
        
//        cell.contentImgs = Imgs;
//        cell.contentLabels = Labels;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        return cell;

    }
}



//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    
    @try {
        NSDictionary *tempDict;
        tempDict = [_AccountArrCache objectAtIndex:indexPath.row];
        
        passWordText.text = [tempDict valueForKey:@"password"];
        _userData.passWord =passWordText.text ;
       
        userText.text = [tempDict valueForKey:@"mAccountID"];
        _userData.phoneNum =userText.text;
        
        NSString *avatar = [tempDict valueForKey:@"avatar"];
        NSString *url = [NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,avatar];
        [headImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"me"]];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [self hideAccountBox];
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
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        @try {
//            [_AccountArrCache removeObjectAtIndex:indexPath.row];
            
            NSMutableArray *mutaArray = [[NSMutableArray alloc] init];//反复给_AccountArrCache赋值会崩溃 这里参考网上的解决方案
            [mutaArray addObjectsFromArray:_AccountArrCache];
            [mutaArray removeObject:_AccountArrCache[indexPath.row]];
            _AccountArrCache = mutaArray;
            
            _cellCount = _AccountArrCache.count;
            [mUserDefault setValue:_AccountArrCache forKey:@"userAccountList"];
            
            _accountTableView.contentSize = CGSizeMake(_account_box.frame.size.width, _cellCount >3 ?40*_cellCount:_account_box.frame.size.height);
            
            
            [_accountTableView reloadData];
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"222");
        }
        @finally {
            
        }
        
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
    
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    //    if(section == 0)
    //    {
    //        tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    //        UILabel *titleLabel = [[UILabel alloc] init];
    //        titleLabel.frame = CGRectMake(20,0 , 150, 30);
    //        titleLabel.text = @"权限选择";
    //        titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //        titleLabel.textColor  = ZY_UIBASECOLOR;
    //        [tempView addSubview:titleLabel];
    //    }
    
    return tempView;
}

//设置section的footer view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    if(section == 0)
    {
        tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        tempView.backgroundColor =[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    }
    return tempView;
    
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
    
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
