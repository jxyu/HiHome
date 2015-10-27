//
//  CreateTaskViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/13.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "CreateTaskViewController.h"
#import "UIDefine.h"
#import "BaseTableViewCell.h"
#import "SegmentedButton.h"
#import "UUDatePicker.h"
#import "JKAlertDialog.h"
#import "RemindViewController.h"
#import "RepeatViewController.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"
#import "SelectContacterViewController.h"
#import "SVProgressHUD.h"

@interface CreateTaskViewController ()<JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    NSMutableArray *_startDateArray;
    NSString *remindStr;
    NSString *repeatStr;
    UITextField *titleField;
    NSDictionary *userInfoWithFile;
    SegmentedButton *repeatBtn;
    SegmentedButton *remindBtn;
    SegmentedButton *placeBtn;
    
    NSString * tipID;
    NSString * repeatID;
    
    NSInteger *_year;
    NSInteger *_month;
    NSInteger *_day;
    NSInteger *_hour;
    NSInteger *_minute;
    BOOL isday;
    
    NSMutableArray * img_uploaded;
    int uploadImgIndex;
    
    NSMutableArray * img_prm;
}
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *assetsArray;


@end

@implementation CreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    uploadImgIndex=0;
    img_uploaded=[[NSMutableArray alloc] init];
    img_prm=[[NSMutableArray alloc] init];
    isday=NO;
    _startDateArray = [NSMutableArray array];
    _cellHeight = (self.view.frame.size.height-ZY_HEADVIEW_HEIGHT)/11;
    _keyShow = false;
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    [self initViews];
    
    //添加键盘的监听事件
    
    //    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
}


// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    _keyShow = true;
    [keyboardObject getValue:&keyboardRect];
    
    
    _keyHeight = keyboardRect.size.height;
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _keyShow = false;
    [UIView commitAnimations];
    
}

//重写退出页面方法
-(void)quitView
{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}

-(void)btnRightClick:(id)sender{
    NSLog(@"click done button");
    [titleField resignFirstResponder];
    [_titleField resignFirstResponder];
    [_textView resignFirstResponder];
    
    

    if (_titleField.text.length>0&&_textView.text.length>0&&tipID&&repeatID) {
        [SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeBlack];
//        DataProvider * dataprovider=[[DataProvider alloc] init];
//        [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitTaskBackCall:"];
//        [dataprovider createTask:userInfoWithFile[@"id"] andTitle:_titleField.text andContent:_textView.text andIsDay:isday?@"1":@"0" andStartTime:startTimeField.text andEndTime:endTimeField.text andTip:tipID andRepeat:repeatID andTasker:userInfoWithFile[@"id"]];
//        if (self.assetsArray.count>0) {
//            DataProvider * dataprovider=[[DataProvider alloc] init];
//            [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitTaskBackCall:"];
//            dataprovider
//        }
        
        [self BuildSliderData];
    }
    else
    {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"提示" message:@"请完善任务信息，例如：提醒、重复"];
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
    }
}
-(void)UpdateAndRequest
{
    if (img_uploaded.count>0) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"uploadImgBackCall:"];
        [dataprovider UploadImgWithImgdataSlider:img_uploaded[uploadImgIndex]];
    }
    else
    {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitTaskBackCall:"];
        [dataprovider createTask:userInfoWithFile[@"id"] andTitle:_titleField.text andContent:_textView.text andIsDay:isday?@"1":@"0" andStartTime:startTimeField.text andEndTime:endTimeField.text andTip:tipID andRepeat:repeatID andTasker:userInfoWithFile[@"id"] andimgsrc1:img_prm.count>=1?img_prm[0]:@"" andimgsrc2:img_prm.count>=2?img_prm[1]:@"" andimgsrc3:img_prm.count>=3?img_prm[2]:@""];
    }
}

-(void)uploadImgBackCall:(id)dict
{
    if ([dict[@"code"] intValue]==200) {
        NSLog(@"%@",dict);
        ++uploadImgIndex;
        [img_prm addObject:[dict[@"datas"][@"imgsrc"][@"imgsrc"] isEqual:[NSNull null]]?@"":dict[@"datas"][@"imgsrc"][@"imgsrc"]];
        if (uploadImgIndex<img_uploaded.count) {
            [self UpdateAndRequest];
        }
        else
        {
            [SVProgressHUD dismiss];
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitTaskBackCall:"];
            [dataprovider createTask:userInfoWithFile[@"id"] andTitle:_titleField.text andContent:_textView.text andIsDay:isday?@"1":@"0" andStartTime:startTimeField.text andEndTime:endTimeField.text andTip:tipID andRepeat:repeatID andTasker:userInfoWithFile[@"id"] andimgsrc1:img_prm.count>=1?img_prm[0]:@"" andimgsrc2:img_prm.count>=2?img_prm[1]:@"" andimgsrc3:img_prm.count>=3?img_prm[2]:@""];
        }
        
    }
}
-(void)SubmitTaskBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"提示" message:dict[@"message"]];
    alert.alertType = AlertType_Hint;
    [alert addButtonWithTitle:@"确定"];
    [alert show];
}

-(void) initViews
{
    [self.mBtnRight setTitle:@"完成" forState:UIControlStateNormal];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, self.view.frame.size.width,self.view.frame.size.height - ZY_HEADVIEW_HEIGHT )];
    _mainTableView.backgroundColor =ZY_UIBASE_BACKGROUND_COLOR;
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    _mainTableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    //_mainTableView.separatorEffect = ;
    
    
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    _cellCount = 7;
    _cellTextViewHeight = _mainTableView.frame.size.height - 2*_cellHeight;
    
    _keyHeight = 216;//default
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    
    _titleField = [[UITextField alloc]init];
    
    _textView = [[UITextView alloc] init];
    //   _textView.text = @"发帖内容";
    
    _remindViewCtl = [[RemindViewController alloc] init];
    _repeatViewCtl = [[RepeatViewController alloc] init];
//    UIButton *sendBtn = [[UIButton alloc] init];
//    [sendBtn setTitle:@"完成" forState:UIControlStateNormal];
//    sendBtn.frame = CGRectMake(self.view.frame.size.width-ZY_VIEWHEIGHT_IN_HEADVIEW-10, 20, ZY_VIEWHEIGHT_IN_HEADVIEW, ZY_VIEWHEIGHT_IN_HEADVIEW);
//    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//    [self->_tableHeaderView addSubview:sendBtn];
    
    [self.view addSubview:_mainTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

-(void)viewDidAppear:(BOOL)animated
{
   remindStr = _remindViewCtl.remindModeStr;

    
}


-(void)tapViewAction:(id)sender
{
    NSLog(@"tap view---");
    

    [self.view endEditing:YES];
    
//    if(_keyShow == true)
//    {
//        _keyShow = false;
//        [_textView resignFirstResponder];//关闭textview的键盘
//        [_titleField resignFirstResponder];//关闭titleField的键盘
//        [self setViewMove];
//        
//    }
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
#pragma mark -textField
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//
//    if(!_keyShow)
//    {
//        _keyShow =true;
//        [self setViewMove];
//    }
//}
//
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(!_keyShow)
    {
        _keyShow =true;
        [self setViewMove];
    }
    
    return YES;
}

#pragma mark - TextView
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(!_keyShow)
    {
        _keyShow =true;
        [self setViewMove];
    }
    return YES;
}

//根据键盘是否出现调整高度
-(void)setViewMove
{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.1];
//    
//    CGRect rect = _mainTableView.frame;
//    
//    if(_keyShow)
//    {
//        NSLog(@"move up");
//        rect.size.height = self.view.frame.size.height -ZY_HEADVIEW_HEIGHT -_keyHeight;
//        _mainTableView.frame = rect;
//        
//    }
//    else{
//        NSLog(@"move down");
//        rect.size.height = self.view.frame.size.height -ZY_HEADVIEW_HEIGHT;
//        _mainTableView.frame = rect;
//    }
//    _cellTextViewHeight = _mainTableView.frame.size.height - 2*_cellHeight;
//    [_mainTableView reloadData];
//    [UIView commitAnimations];
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellHeight)];
    
    if (indexPath.row == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100, _cellHeight)];
        
        titleLabel.text = @"   任务名称:";
        _titleField.frame = CGRectMake(0, 0, cell.frame.size.width, _cellHeight);
        _titleField.placeholder = @"请输入任务名字";
        _titleField.delegate = self;
        _titleField.leftView = titleLabel;
        _titleField.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:_titleField];
    }else if (indexPath.row == 1){
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100, _cellHeight)];
        titleField = [[UITextField alloc]init];
        titleLabel.text = @"   执行人:";
        titleField.frame = CGRectMake(0, 0, cell.frame.size.width, _cellHeight);
        titleField.placeholder = @"请输入执行人";
        titleField.delegate = self;
        titleField.leftView = titleLabel;
        titleField.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *chooseContactsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, _cellHeight)];
        chooseContactsBtn.tag = ZY_UIBUTTON_TAG_BASE + ZY_CONTACTER_BTN_TAG;
        [chooseContactsBtn setImage:[UIImage imageNamed:@"chooseContacts"] forState:UIControlStateNormal];//UIControlEventTouchUpInside
        [chooseContactsBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        titleField.rightView = chooseContactsBtn;
        titleField.rightViewMode =UITextFieldViewModeAlways;
        
        [cell addSubview:titleField];
    }else if(indexPath.row == 2){
        _textView.frame = CGRectMake(10, 0, cell.frame.size.width, _cellHeight * 3);
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, -15, 200, 60)];
        _placeHolderLabel.text = @"请输入任务内容";
        _placeHolderLabel.textColor = [UIColor grayColor];
        
        [_textView addSubview:_placeHolderLabel];
        [cell addSubview:_textView];

    }else if(indexPath.row == 3){
        UIButton *picBtns = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height)];
        [picBtns setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
        picBtns.tag = ZY_UIBUTTON_TAG_BASE + ZY_PICPICK_BTN_TAG;
        [picBtns addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        
        if (!_collectionView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing = 5.0;
            layout.minimumInteritemSpacing = 5.0;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(picBtns.frame.size.width+picBtns.frame.origin.x+5, 0, SCREEN_WIDTH-(2*cell.frame.size.height), cell.frame.size.height) collectionViewLayout:layout];
            _collectionView.backgroundColor = [UIColor clearColor];
            [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            _collectionView.showsHorizontalScrollIndicator = NO;
            _collectionView.showsVerticalScrollIndicator = NO;
            
            [cell addSubview:_collectionView];
            
        }
        
        UIButton *otherBtns = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width - cell.frame.size.height, 0, cell.frame.size.height, cell.frame.size.height)];
        [otherBtns setImage:[UIImage imageNamed:@"other"] forState:UIControlStateNormal];
        
        [cell addSubview:picBtns];
//        [cell addSubview:photoBtns];
        [cell addSubview:otherBtns];

    }else if(indexPath.row == 4){
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, _cellHeight)];
        
        lab.text = @"是否创建全天日程";
        
        UISwitch *swtBtn = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(20+50), _cellHeight/3, 50, _cellHeight/3)];
        swtBtn.center =  CGPointMake( self.view.frame.size.width-(20+50)+20,_cellHeight/2);
        swtBtn.tag = ZY_UISWITCH_TAG_BASE + indexPath.section*10+indexPath.row;
        [swtBtn addTarget:self action:@selector(CreatAllDayTaskOrNot:)forControlEvents:UIControlEventValueChanged];
        [cell addSubview:lab];
        [cell addSubview:swtBtn];
    }else if(indexPath.row == 5){
        NSDate *now = [NSDate date];
        
        UILabel *startTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, _cellHeight/2)];
        UILabel *endTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, _cellHeight/2)];
        
        startTimeField = [[UITextField alloc] initWithFrame:CGRectMake(0, _cellHeight/2, self.view.frame.size.width/2, _cellHeight/2)];
        endTimeField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, _cellHeight/2, self.view.frame.size.width/2, _cellHeight/2)];
        
        startTimeField.textAlignment = NSTextAlignmentCenter;
        endTimeField.textAlignment = NSTextAlignmentCenter;
        
        
        startTimeLab.text = @"开始时间";
        startTimeLab.textAlignment = NSTextAlignmentCenter;
        startTimeLab.font = [UIFont boldSystemFontOfSize:14];
        startTimeLab.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
        endTimeLab.text = @"结束时间";
        endTimeLab.textAlignment = NSTextAlignmentCenter;
        endTimeLab.font = [UIFont boldSystemFontOfSize:14];
        endTimeLab.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
        
        {
            NSDateComponents *temp = [self updateLabelForTimer];
            
            NSInteger y = [temp year];
            NSInteger m = [temp month];
            NSInteger d = [temp day];
            
            NSInteger hour = [temp hour];
            NSInteger min = [temp minute];
            
            NSInteger week = [temp weekday];
            NSString *weekStr;
            switch (week) {
                case 1:
                    weekStr = @"周日";
                    break;
                case 2:
                    weekStr = @"周一";
                    break;
                case 3:
                    weekStr = @"周二";
                    break;
                case 4:
                    weekStr = @"周三";
                    break;
                case 5:
                    weekStr = @"周四";
                    break;
                case 6:
                    weekStr = @"周五";
                    break;
                case 7:
                    weekStr = @"周六";
                    break;
                    
                default:
                    break;
            }
            _year=&y;
            _month=&m;
            _day=&d;
            _hour=&hour;
            _minute=&min;
            
            NSString *timeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld   %02ld:%02ld",(long)y,(long)m,(long)d,(long)hour,(long)min];
            startTimeField.text =timeStr;
            startTimeField.font = [UIFont systemFontOfSize:14];
            
            NSString *timeStr2 = [NSString stringWithFormat:@"%ld-%02ld-%02ld   %02ld:%02ld",(long)y,(long)m,(long)d+1,(long)hour,(long)min];
            endTimeField.text =timeStr2;
            endTimeField.font = [UIFont systemFontOfSize:14];
            
            [_startDateArray addObject:[NSString stringWithFormat:@"%ld",(long)y]];
            [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",(long)m]];
            [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",(long)d]];
            [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",(long)hour]];
            [_startDateArray addObject:[NSString stringWithFormat:@"%02ld",(long)min]];
            [_startDateArray addObject:weekStr];
            
        }
        
        UUDatePicker *endDatePicker
        = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, 320, 200)
                                 PickerStyle:UUDateStyle_YearMonthDayHourMinute
                                 didSelected:^(NSString *year,
                                               NSString *month,
                                               NSString *day,
                                               NSString *hour,
                                               NSString *minute,
                                               NSString *weekDay) {
                                     endTimeField.text = [NSString stringWithFormat:@"%@-%@-%@  %@:%@",year,month,day,hour,minute];
                                 }];
        
        
        endDatePicker.ScrollToDate = now;
        endTimeField.inputView = endDatePicker;

        
        UUDatePicker *startDatePicker
        = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, 320, 200)
                                 PickerStyle:UUDateStyle_YearMonthDayHourMinute
                                 didSelected:^(NSString *year,
                                               NSString *month,
                                               NSString *day,
                                               NSString *hour,
                                               NSString *minute,
                                               NSString *weekDay) {
                                     [_startDateArray removeAllObjects];
                                     [_startDateArray addObject:year];
                                     [_startDateArray addObject:month];
                                     [_startDateArray addObject:day];
                                     [_startDateArray addObject:hour];
                                     [_startDateArray addObject:minute];
                                     [_startDateArray addObject:weekDay];
                                    
                                     
                                     startTimeField.text = [NSString stringWithFormat:@"%@-%@-%@  %@:%@",year,month,day,hour,minute];
                                     NSLog(@"---%@",startTimeField.text);
                                     
                                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                     [formatter setDateFormat:@"yyyy-MM-dd"];
                                     NSLog(@"[startTimeField.text substringToIndex:10] = %@",[startTimeField.text substringToIndex:10]);
                                     NSDate *date = [formatter dateFromString:[startTimeField.text substringToIndex:10]];
                                     
                                     endDatePicker.ScrollToDate = date;
                                     endDatePicker.minLimitDate = date;
                                     
                                 }];
        
        startDatePicker.ScrollToDate = now;
        startTimeField.inputView = startDatePicker;
        
    
        
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 1, 1, _cellHeight - 2)];
        lineView.backgroundColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
        
        [cell addSubview:startTimeLab];
        [cell addSubview:endTimeLab];
        [cell addSubview:startTimeField];
        [cell addSubview:endTimeField];
        [cell addSubview:lineView];
    }else{
        cell.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
        //            UIButtonTypeDetailDisclosure,
        //            UIButtonTypeInfoLight,
        //            UIButtonTypeInfoDark,
        //            UIButtonTypeContactAdd,
        
        remindBtn = [[SegmentedButton alloc] init];
        remindBtn.frame = CGRectMake(20, 20, self.view.frame.size.width/3-20*2, self.view.frame.size.width/3-20*2);
        // remindBtn.layer.borderWidth = 1.0;
        //  remindBtn.layer.borderColor = [[UIColor grayColor] CGColor];
        remindBtn.backgroundColor = [UIColor whiteColor];
        remindBtn.alpha = 0.8;
        remindBtn.tag = ZY_UIBUTTON_TAG_BASE +ZY_REMIND_BTN_TAG;
        
        repeatBtn = [[SegmentedButton alloc] init];
        repeatBtn.frame =CGRectMake(self.view.frame.size.width/3+20, 20, self.view.frame.size.width/3-20*2, self.view.frame.size.width/3-20*2);
        repeatBtn.backgroundColor = [UIColor whiteColor];
        repeatBtn.alpha = 0.8;
        repeatBtn.tag = ZY_UIBUTTON_TAG_BASE +ZY_REPEAT_BTN_TAG;
        
        
        placeBtn = [[SegmentedButton alloc] init];
        placeBtn.frame =  CGRectMake(self.view.frame.size.width/3*2+20, 20, self.view.frame.size.width/3-20*2, self.view.frame.size.width/3-20*2);
        placeBtn.backgroundColor = [UIColor whiteColor];
        placeBtn.alpha = 0.8;
        placeBtn.tag = ZY_UIBUTTON_TAG_BASE +ZY_PLACE_BTN_TAG;
        
        [remindBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        [remindBtn setImage:[UIImage imageNamed:@"remind"] forState:UIControlStateNormal];
        [remindBtn setTitle:@"提醒" forState:UIControlStateNormal];
        [remindBtn setTitleColor:[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1] forState:UIControlStateNormal];
        remindBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        remindBtn.imageView.contentMode = UIViewContentModeCenter;
        remindBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [repeatBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        [repeatBtn setImage:[UIImage imageNamed:@"repeat_2"] forState:UIControlStateNormal];
        [repeatBtn setTitle:@"重复" forState:UIControlStateNormal];
        [repeatBtn setTitleColor:[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1] forState:UIControlStateNormal];
        repeatBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        repeatBtn.imageView.contentMode = UIViewContentModeCenter;
        repeatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [placeBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        [placeBtn setImage:[UIImage imageNamed:@"place"] forState:UIControlStateNormal];
        [placeBtn setTitle:@"位置" forState:UIControlStateNormal];
        [placeBtn setTitleColor:[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1] forState:UIControlStateNormal];
        placeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        placeBtn.imageView.contentMode = UIViewContentModeCenter;
        placeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [cell addSubview:remindBtn];
        [cell addSubview:repeatBtn];
        [cell addSubview:placeBtn];
    }
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}


-(void)CreatAllDayTaskOrNot:(UISwitch *)sender
{
    {
        NSDateComponents *temp = [self updateLabelForTimer];
        
        NSInteger y = [temp year];
        NSInteger m = [temp month];
        NSInteger d = [temp day];
        
        NSInteger hour = [temp hour];
        NSInteger min = [temp minute];
        
        NSInteger week = [temp weekday];
        NSString *weekStr;
        switch (week) {
            case 1:
                weekStr = @"周日";
                break;
            case 2:
                weekStr = @"周一";
                break;
            case 3:
                weekStr = @"周二";
                break;
            case 4:
                weekStr = @"周三";
                break;
            case 5:
                weekStr = @"周四";
                break;
            case 6:
                weekStr = @"周五";
                break;
            case 7:
                weekStr = @"周六";
                break;
                
            default:
                break;
        }
        
        
        
        
        if (sender.isOn) {
            NSString *timeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)y,(long)m,(long)d];
            startTimeField.text =timeStr;
            
            NSString *timeStr2 = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)y,(long)m,(long)d];
            endTimeField.text =timeStr2;
            isday=YES;
        }
        else
        {
            NSString *timeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld   %02ld:%02ld",(long)y,(long)m,(long)d,(long)hour,(long)min];
            startTimeField.text =timeStr;
            startTimeField.font = [UIFont systemFontOfSize:14];
            
            NSString *timeStr2 = [NSString stringWithFormat:@"%ld-%02ld-%02ld   %02ld:%02ld",(long)y,(long)m,(long)d+1,(long)hour,(long)min];
            endTimeField.text =timeStr2;
            endTimeField.font = [UIFont systemFontOfSize:14];
            isday=NO;
        }
    }
}

////关闭日历
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [self.view endEditing:YES];
//}

//打开相册
-(void)showLocalAlbum
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

-(void)openCamera
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}




-(void)clickBtns:(UIButton *)sender
{
    switch (sender.tag) {
        case ZY_UIBUTTON_TAG_BASE + ZY_CONTACTER_BTN_TAG:
        {
            SelectContacterViewController *selectContacterVC = [[SelectContacterViewController alloc] init];
            selectContacterVC.navTitle = @"选择执行人";
            [self presentViewController:selectContacterVC animated:NO completion:nil];
        }
            break;
        case ZY_UIBUTTON_TAG_BASE + ZY_PICPICK_BTN_TAG:
//            [self showLocalAlbum];
            [self composePicAdd];
            break;
        case ZY_UIBUTTON_TAG_BASE + ZY_TAKEPIC_BTN_TAG:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [self openCamera];
            }
            else
            {
                JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"提示" message:@"没有摄像头"];
                alert.alertType = AlertType_Hint;
                [alert addButtonWithTitle:@"确定"];
                [alert show];
                
            }
            break;
            
        case ZY_UIBUTTON_TAG_BASE+ZY_REPEAT_BTN_TAG:
        {
           
            
            if(_startDateArray.count>5)
                NSLog(@"date 22 : %@",[NSString stringWithFormat:@"%@-%@-%@  %@:%@  %@",[_startDateArray objectAtIndex:0] ,[_startDateArray objectAtIndex:1] ,[_startDateArray objectAtIndex:2] ,[_startDateArray objectAtIndex:3] ,[_startDateArray objectAtIndex:4] ,[_startDateArray objectAtIndex:5] ]
                  );
            _repeatViewCtl.dateArr = _startDateArray;
            _repeatViewCtl.navTitle = sender.titleLabel.text;
            [_repeatViewCtl setDelegateObject:self setBackFunctionName:@"ChongfuBackCall:"];
            [self.navigationController pushViewController:_repeatViewCtl animated:YES];
        }
            break;
        case ZY_UIBUTTON_TAG_BASE+ZY_REMIND_BTN_TAG:
        {
            if(_startDateArray.count>5)
                NSLog(@"date 22 : %@",[NSString stringWithFormat:@"%@-%@-%@  %@:%@  %@",[_startDateArray objectAtIndex:0] ,[_startDateArray objectAtIndex:1] ,[_startDateArray objectAtIndex:2] ,[_startDateArray objectAtIndex:3] ,[_startDateArray objectAtIndex:4] ,[_startDateArray objectAtIndex:5] ]
                      );
            _remindViewCtl.dateArr = _startDateArray;
            _remindViewCtl.navTitle = sender.titleLabel.text;
            [_remindViewCtl setDelegateObject:self setBackFunctionName:@"TixingBackCall:"];
            [self.navigationController pushViewController:_remindViewCtl animated:YES];
        }
            
            break;
        default:
            break;
    }
    NSLog(@"click choose contact btn");
}

-(void)TixingBackCall:(id)dict
{
    NSLog(@"%@",dict);
    tipID=dict[@"tip"];
    [remindBtn setTitle:dict[@"tipname"] forState:UIControlStateNormal];
}

-(void)ChongfuBackCall:(id)dict
{
    NSLog(@"%@",dict);
    repeatID=dict[@"repeat"];
    [repeatBtn setTitle:dict[@"repeatname"] forState:UIControlStateNormal];
}


-(NSDateComponents *)updateLabelForTimer {
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dd;
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
    
    
    @try {
        dd = [cal components:unitFlags fromDate:now];
        
        return dd;
        //  NSInteger sec = [dd second];
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        
    }
    
}


//-(void)setOptionCell:(BaseTableViewCell *)cell andTitleLabels:(NSString *)title
//{
//    NSMutableArray *Labels = [NSMutableArray array];
//
//    if([title isEqualToString:@"nil"])
//    {
//        title = nil;
//    }
//    if(title != nil)
//    {
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.frame =CGRectMake(20, _cellHeight/3 , 200, _cellHeight/3);
//        titleLabel.text =title;
//        titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//
//        //     titleLabel.textColor = ZY_UIBASECOLOR;//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
//        titleLabel.textColor = [UIColor grayColor];
//        [Labels addObject:titleLabel];
//    }
//
//    if(cell != nil && Labels.count>0)
//    {
//        cell.contentLabels = Labels;
//    }
//}
//
//
//
//-(void)setOptionCell:(BaseTableViewCell *)cell andTitleField:(NSString *)title andFieldTag:(NSInteger)fieldtag
//{
//
//    NSMutableArray *Others = [NSMutableArray array];
//
//    if([title isEqualToString:@"nil"])
//    {
//        title = nil;
//    }
//
//    if(title != nil)
//    {
//        CGFloat fieldHeight = _cellHeight;
//
//        if(fieldtag == ZY_UIFIELD_TAG_BASE + 1)
//            fieldHeight = _mainTableView.frame.size.height - 2*_cellHeight;
//
//        UITextField *cellField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, fieldHeight)];
//        cellField.placeholder = title;
//     //   cellField.backgroundColor = [UIColor blueColor];
//
//        [Others addObject:cellField];
//
//    }
//
//    if(cell != nil && Others.count>0)
//    {
//        cell.contentOtherViews = Others;
//    }
//
//}



//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row)
    {
        case 0:
        case 1:
        case 3:
        case 4:
        case 5:
            return _cellHeight;
            break;
        case 2:
            return _cellHeight*3;
            break;
        case 6:
            return _cellHeight*4;
            break;
    }
    return _cellHeight;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
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
    
    return NO;
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
    NSMutableArray *numberRowOfCellArray = [NSMutableArray array] ;
    [numberRowOfCellArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //        [_mainTableView.cell.infoItems removeObjectAtIndex:(indexPath.row*2)];
        //        [_mainTableView.cell.infoItems removeObjectAtIndex:(indexPath.row*2)];
        //        [_mainTableView beginUpdates];
        //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        //        [_mainTableView endUpdates];
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

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHolderLabel.text = @"请输入任务内容";
    }else{
        _placeHolderLabel.text = @"";
    }
}






#pragma mark 新浪图片多选


- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 3;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
    cell.tag=indexPath.row;
    
    cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    
}





-(void)BuildSliderData
{
    [SVProgressHUD showWithStatus:@"正在保存数据" maskType:SVProgressHUDMaskTypeBlack];
    @try {
        NSUserDefaults * userdefaults=[NSUserDefaults standardUserDefaults];
        for (int i=0; i<self.assetsArray.count; i++) {
            //            UIImage * itemimg=[UIImage imageWithCGImage:[[self.assetsArray[i] defaultRepresentation] fullScreenImage]];
            
            //            if (uplodaimage<self.assetsArray.count) {
            //                JKAssets * itemasset=(JKAssets *)self.assetsArray[i];
            //                ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            //                [lib assetForURL:itemasset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            //                    if (asset) {
            //                        [sliderSelectArray addObject:UIImageJPEGRepresentation([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]], 1.0)];
            //                    }
            //                } failureBlock:^(NSError *error) {
            //
            //                }];
            //
            //            }
            [img_uploaded addObject:[userdefaults objectForKey:[NSString stringWithFormat:@"%d",i]]];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"构造轮播图数据出错");
    }
    @finally {
        [self UpdateAndRequest];
    }
    
    
    
    
}





//-(BOOL)compareDatewittyear:(NSString *)year andmoth:(NSString *)moth andday:(NSString *)day


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
