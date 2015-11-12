//
//  CreateAnniversaryViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/13.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "CreateAnniversaryViewController.h"
#import "UIDefine.h"
#import "BaseTableViewCell.h"
#import "SegmentedButton.h"
#import "JKAlertDialog.h"
#import "UUDatePicker.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DataProvider.h"
#import "SVProgressHUD.h"

#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface CreateAnniversaryViewController ()<VPImageCropperDelegate,UIActionSheetDelegate,JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *assetsArray;

@end

@implementation CreateAnniversaryViewController
{
    UITextField *titleField;//标题
    UITextField *field;//日期
    NSDictionary *userInfoWithFile;
    UIButton *_uploadBtn;
    NSString * imgAvatar;
    
    NSMutableArray * img_uploaded;
    int uploadImgIndex;
    
    NSMutableArray * img_prm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    uploadImgIndex=0;
    img_uploaded=[[NSMutableArray alloc] init];
    img_prm=[[NSMutableArray alloc] init];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    _cellHeight = (self.view.frame.size.height-ZY_HEADVIEW_HEIGHT)/11;
    _keyShow = false;
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
    
    if (imgAvatar&&titleField.text&&field.text&&_textView.text) {
        [SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeBlack];
        [self BuildSliderData];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请完善信息" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
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
        [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitBackCall:"];
        [dataprovider createAnniversary:userInfoWithFile[@"id"] andImg:imgAvatar andTitle:titleField.text andMdate:field.text andContent:_textView.text andimgsrc1:img_prm.count>=1?img_prm[0]:@"" andimgsrc2:img_prm.count>=2?img_prm[1]:@"" andimgsrc3:img_prm.count>=3?img_prm[2]:@""];
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
            [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitBackCall:"];
            [dataprovider createAnniversary:userInfoWithFile[@"id"] andImg:imgAvatar andTitle:titleField.text andMdate:field.text andContent:_textView.text andimgsrc1:img_prm.count>=1?img_prm[0]:@"" andimgsrc2:img_prm.count>=2?img_prm[1]:@"" andimgsrc3:img_prm.count>=3?img_prm[2]:@""];
        }
        
    }
}


-(void) initViews
{
    
    self.titleLabel.text = @"创建纪念日";
    [self.mBtnRight setTitle:@"完成" forState:UIControlStateNormal];
//    [self.mBtnRight addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
    _cellCount = 5;
    _cellTextViewHeight = _mainTableView.frame.size.height - 2*_cellHeight;
    
    _keyHeight = 216;//default
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    
    _titleField = [[UITextField alloc]init];
    
    _textView = [[UITextView alloc] init];
    //   _textView.text = @"发帖内容";
    
    
//    UIButton *sendBtn = [[UIButton alloc] init];
//    [sendBtn setTitle:@"完成" forState:UIControlStateNormal];
//    sendBtn.frame = CGRectMake(self.view.frame.size.width-ZY_VIEWHEIGHT_IN_HEADVIEW-10, 20, ZY_VIEWHEIGHT_IN_HEADVIEW, ZY_VIEWHEIGHT_IN_HEADVIEW);
//    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//    [_tableHeaderView addSubview:sendBtn];
    
    
    [self.view addSubview:_mainTableView];
    
}




-(void)SubmitBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue]==200) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功" maskType:SVProgressHUDMaskTypeBlack];
        [self quitView];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


-(void)tapViewAction:(id)sender
{
    NSLog(@"tap view---");
    
    if(_keyShow == true)
    {
        _keyShow = false;
        [_textView resignFirstResponder];//关闭textview的键盘
        [_titleField resignFirstResponder];//关闭titleField的键盘
        [self setViewMove];
        
    }
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
        _uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, _cellHeight*2 - 20, _cellHeight*2 - 20)];
        [_uploadBtn setImage:[UIImage imageNamed:@"redcamera"] forState:UIControlStateNormal];
        [_uploadBtn addTarget:self action:@selector(editPortrait) forControlEvents:UIControlEventTouchUpInside];
        
        _uploadBtn.layer.masksToBounds=YES;
        _uploadBtn.layer.cornerRadius=(_uploadBtn.frame.size.width)/2;
        _uploadBtn.layer.borderWidth=0;
        _uploadBtn.layer.borderColor=ZY_UIBASECOLOR.CGColor;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cellHeight*2+20, 0, 200, _cellHeight*2)];
        
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.text = @"请上传纪念日主图";
        textLabel.textColor = [UIColor grayColor];
        textLabel.font = [UIFont systemFontOfSize:18];
        [cell addSubview:textLabel];
        [cell addSubview:_uploadBtn];
    }else if(indexPath.row == 1){
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,120, _cellHeight)];
        titleField = [[UITextField alloc]init];
        titleLabel.text = @"   纪念日标题:";
        titleField.frame = CGRectMake(0, 0, cell.frame.size.width, _cellHeight);
        titleField.placeholder = @"请输入纪念日标题";
        titleField.delegate = self;
        titleField.leftView = titleLabel;
        titleField.leftViewMode = UITextFieldViewModeAlways;
        
        [cell addSubview:titleField];
    }else if(indexPath.row == 2){
        NSDate *now = [NSDate date];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100, _cellHeight)];
        titleLabel.text = @"   选择日期:";
        
        field = [[UITextField alloc]init];
        field.frame = CGRectMake(0, 0, cell.frame.size.width, _cellHeight);
        field.placeholder = @"请输入纪念日标题";
        field.delegate = self;
        field.leftView = titleLabel;
        field.leftViewMode = UITextFieldViewModeAlways;
        
        
        {
            NSDateComponents *temp = [self updateLabelForTimer];
            
            NSInteger y = [temp year];
            NSInteger m = [temp month];
            NSInteger d = [temp day];
            NSString *timeStr = [NSString stringWithFormat:@"%02ld-%02ld-%02ld",(long)y,(long)m,d];
            field.text =timeStr;
            
        }
        
        UUDatePicker *datePicker
        = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, 320, 200)
                                 PickerStyle:UUDateStyle_YearMonthDay
                                 didSelected:^(NSString *year,
                                               NSString *month,
                                               NSString *day,
                                               NSString *hour,
                                               NSString *minute,
                                               NSString *weekDay) {
                                     field.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                                 }];
        
        datePicker.ScrollToDate = now;
        //            datePicker.maxLimitDate = now;
        //            datePicker.minLimitDate = [now dateByAddingTimeInterval:-111111111];
        field.inputView = datePicker;
        [cell addSubview:titleLabel];
        [cell addSubview:field];
    }else if(indexPath.row == 3){
        _textView.frame = CGRectMake(0, 0, cell.frame.size.width, 3*_cellHeight);
        
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [cell addSubview:_textView];
    }else{
        cell.bounds=CGRectMake(0, 0, cell.frame.size.width, 50);
        
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
        
        
//        UIButton *photoBtns = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.height, 0, cell.frame.size.height, cell.frame.size.height)];
//        [photoBtns setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
//        photoBtns.tag = ZY_UIBUTTON_TAG_BASE + ZY_TAKEPIC_BTN_TAG;
        
//        [photoBtns addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
//        UIButton *otherBtns = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width - cell.frame.size.height, 0, cell.frame.size.height, cell.frame.size.height)];
//        [otherBtns setImage:[UIImage imageNamed:@"other"] forState:UIControlStateNormal];
//        [otherBtns addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
//        
        [cell addSubview:picBtns];
//        [cell addSubview:photoBtns];
  //      [cell addSubview:otherBtns];

    }
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}



//打开相册
-(void)showLocalAlbum
{
    NSLog(@"上传图片");
    [self editPortrait];
}

-(void)openCamera
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}



-(void)clickBtns:(UIButton *)sender
{
    switch (sender.tag) {
        case ZY_UIBUTTON_TAG_BASE + ZY_PICPICK_BTN_TAG:
//              [self showLocalAlbum];
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
        default:
            break;
    }
    NSLog(@"click choose contact btn");
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

-(void)viewDidAppear:(BOOL)animated
{
    DLog(@"run here ");
    
}


//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row)
    {
        case 1:
        case 2:
        case 4:
            return _cellHeight;
            break;
        case 3:
            return _cellHeight*3;
            break;
        case 0:
            return _cellHeight*2;
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





#pragma mark 上传图片
/********************************上传图片开始*************************************/

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        [self saveImage:editedImage withName:@"avatar.jpg"];
        
        [_uploadBtn setImage:editedImage forState:UIControlStateNormal];
        
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.jpg"];
        NSLog(@"选择完成");
        [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
        NSData* imageData = UIImageJPEGRepresentation(editedImage, 0.8) ;
        id  imagebase64= [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadBackCall:"];
        [dataprovider UploadImgWithImgdata:fullPath ];
    }];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
} 

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [picker dismissViewControllerAnimated:YES completion:^(){
//    }];
//}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)UploadBackCall:(id)dict
{
    NSLog(@"%@",dict);
    //    [img_touxiang setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]]]]
    //     ];
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue]==200) {
        imgAvatar=[dict[@"datas"][@"imgsrc"][@"imgsrc"] isEqual:[NSNull null]]?@"":dict[@"datas"][@"imgsrc"][@"imgsrc"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

/*************************************上传图片结束******************************************/


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
