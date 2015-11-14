//
//  PersonSecondViewController.m
//  HiHome
//
//  Created by Rain on 15/11/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PersonSecondViewController.h"
#import "UIImageView+WebCache.h"
#import "DataProvider.h"
#import "SVProgressHUD.h"
#import "UUDatePicker.h"

@interface PersonSecondViewController (){
    UITableView *mTableView;
    NSInteger cellHeight;
    
    UIImageView *mHeadImageView;
    UITextField * txt_name;
    UITextField *key_txt;
    UIButton * btn_nan;
    UIButton * btn_nv;
    UITextField * txt_signe;
    UITextField *txt_birthday;
    BOOL isMan;
    NSUserDefaults *mUserDefault;
    
    NSString *_mImgStr;
    
    UIView *mView;
}

@end

@implementation PersonSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

-(void)initView{
    cellHeight = SCREEN_HEIGHT / 11;
    isMan = [_mSex isEqual:@"男"]?YES:NO;
    mUserDefault = [NSUserDefaults standardUserDefaults];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    
    mTableView.tableFooterView = [[UIView alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne)];
    [self.view addGestureRecognizer:tap];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:{
            UIButton *btn_head = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - cellHeight*2) / 2, cellHeight * 3 / 2 - cellHeight, cellHeight * 2, cellHeight * 2)];
            btn_head.layer.masksToBounds=YES;
            btn_head.layer.cornerRadius=(btn_head.frame.size.width)/2;
            btn_head.layer.borderWidth=0.5;
            btn_head.layer.borderColor=ZY_UIBASECOLOR.CGColor;
            [btn_head addTarget:self action:@selector(onClickHeadImg) forControlEvents:UIControlEventTouchUpInside];
            
            NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,_mHeadImg];
            mHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn_head.frame.size.width, btn_head.frame.size.height)];
            [mHeadImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
            [btn_head addSubview:mHeadImageView];
            
            [cell addSubview:btn_head];
            
        }
            break;
        case 1:{
            txt_name = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, cellHeight)];
            txt_name.placeholder = @"请输入您的名称";
            txt_name.text = _mName;
            UILabel *name_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, cellHeight)];
            name_lbl.text = @"名称:";
            txt_name.leftView = name_lbl;
            txt_name.leftViewMode = UITextFieldViewModeAlways;
            [cell addSubview:txt_name];
        }
            break;
        case 2:{
            key_txt = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, cellHeight)];
            key_txt.enabled = NO;
            key_txt.text = [mUserDefault valueForKey:@"mAccountID"];
            UILabel *key_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, cellHeight)];
            key_lbl.text = @"序列号:";
            key_txt.leftView = key_lbl;
            key_txt.leftViewMode = UITextFieldViewModeAlways;
            [cell addSubview:key_txt];
        }
            break;
        case 3:{
            UILabel *sex_lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, cellHeight)];
            sex_lbl.text = @"性别:";
            [cell addSubview:sex_lbl];
            
            btn_nan = [[UIButton alloc] initWithFrame:CGRectMake(55, 0, 100, cellHeight)];
            btn_nan.tag=1;
            btn_nv = [[UIButton alloc] initWithFrame:CGRectMake(170, 0, 100, cellHeight)];
            [btn_nan setImage:[UIImage imageNamed:isMan?@"select_Radio_icon@2x.png":@"unselect_Radio_icon@2x.png"] forState:UIControlStateNormal];
            [btn_nv setImage:[UIImage imageNamed:isMan? @"unselect_Radio_icon@2x.png":@"select_Radio_icon@2x.png"] forState:UIControlStateNormal];
            [btn_nan setTitle:@"   男" forState:UIControlStateNormal];
            [btn_nv setTitle:@"   女" forState:UIControlStateNormal];
            [btn_nan setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn_nv setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn_nan addTarget:self action:@selector(btn_selectSex:) forControlEvents:UIControlEventTouchUpInside];
            [btn_nv addTarget:self action:@selector(btn_selectSex:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_nan];
            [cell addSubview:btn_nv];
        }
            break;
        case 4:{
            NSDate *now = [NSDate date];
            txt_birthday = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, cellHeight)];
            txt_birthday.delegate = self;
            txt_birthday.placeholder = @"请选择您的生日";
            txt_birthday.text = _mBirthday;
            UILabel *age_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, cellHeight)];
            age_lbl.text = @"生日:";
            txt_birthday.leftView = age_lbl;
            txt_birthday.leftViewMode = UITextFieldViewModeAlways;
            
            
            
            UUDatePicker *datePicker
            = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, 320, 200)
                                     PickerStyle:UUDateStyle_YearMonthDay
                                     didSelected:^(NSString *year,
                                                   NSString *month,
                                                   NSString *day,
                                                   NSString *hour,
                                                   NSString *minute,
                                                   NSString *weekDay) {
                                         txt_birthday.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                                     }];
            
            datePicker.ScrollToDate = now;
            txt_birthday.inputView = datePicker;
            [cell addSubview:txt_birthday];
        }
            break;
        case 5:{
            txt_signe = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, cellHeight)];
            txt_signe.delegate = self;
            txt_signe.placeholder = @"请输入您的签名";
            txt_signe.text = _mSign;
            UILabel *signe_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, cellHeight)];
            signe_lbl.text = @"签名:";
            txt_signe.leftView = signe_lbl;
            txt_signe.leftViewMode = UITextFieldViewModeAlways;
            [cell addSubview:txt_signe];
        }
            break;
        case 6:{
            UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake((cell.frame.size.width-180)/2, 15, 180, 50)];
            
            btn_sure.backgroundColor=ZY_UIBASECOLOR;
            [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
            [btn_sure addTarget:self action:@selector(btn_sureEvent:) forControlEvents:UIControlEventTouchUpInside];
            [btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:btn_sure];
        }
            break;
        default:
            break;
    }
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]<=7.0) {
        mView = [[[textField superview] superview] superview];
    }else{
        mView = [[textField superview] superview];
    }
    CGRect frame = mView.frame;
    NSLog(@"%f",frame.origin.y);
    if (frame.origin.y != 0) {
        return;
    }
    frame.origin.y -= frame.size.height * 0.3;
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.3];
    mView.frame = frame;
    [UIView commitAnimations];
}

-(void)tapOne{
    
    [txt_name resignFirstResponder];
    [txt_birthday resignFirstResponder];
    [txt_signe resignFirstResponder];
    
    CGRect frame = mView.frame;
    if (frame.origin.y == 0) {
        return;
    }
    frame.origin.y += frame.size.height * 0.3;
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.3];
    mView.frame = frame;
    [UIView commitAnimations];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 6) {
        return cellHeight * 3;
    }else{
        return cellHeight;
    }
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
    [mTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//保存资料
-(void)btn_sureEvent:(id)sender{
    
    if (txt_name.text.length > 0 && txt_birthday.text.length > 0 && txt_signe.text.length > 0) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"SaveUserInfoBackCall:"];
        [dataprovider SaveUserInfo:[_mIFlag isEqual:@"1"]?_mUID:[self getUserID] andNick:txt_name.text andSex:isMan?@"男":@"女" andAge:txt_birthday.text andSign:txt_signe.text];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请完善信息～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)SaveUserInfoBackCall:(id)dict{
    NSLog(@"%@",dict);
    NSInteger code = [dict[@"code"] integerValue];
    
    if (code == 200) {
        if ([_mIFlag isEqual:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CallLoginFun" object:nil];
        }else{
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfo" object:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
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

-(void)onClickHeadImg{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        UIImagePickerController *mImagePick = [[UIImagePickerController alloc] init];
        mImagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        mImagePick.delegate = self;
        mImagePick.allowsEditing = YES;
        [self presentViewController:mImagePick animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        UIImagePickerController *mImagePick = [[UIImagePickerController alloc] init];
        mImagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        mImagePick.delegate = self;
        mImagePick.allowsEditing = YES;
        [self presentViewController:mImagePick animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *smallImage = [self scaleFromImage:image andSize:CGSizeMake(800, 800)];
    NSData *imageData = UIImagePNGRepresentation(smallImage);
    mHeadImageView.image = smallImage;
    [self changeHeadImage:imageData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)scaleFromImage:(UIImage *)image andSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)changeHeadImage:(NSData *) data{
    [SVProgressHUD showWithStatus:@"请稍等..." maskType:SVProgressHUDMaskTypeBlack];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"didGetImageName:"];
    [dataProvider UploadImgWithImgdataSlider:data];
    //[dataProvider changeHeadImg:[userInfoWithFile objectForKey:@"id"] andImgsrc:imageBase64];
}

-(void)didGetImageName:(id)dict{
    _mImgStr = [[dict[@"datas"] valueForKey:@"imgsrc"] valueForKey:@"imgsrc"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"didChangeHeadImg:"];
    [dataProvider changeHeadImg:[self getUserID] andImgsrc:[[dict[@"datas"] valueForKey:@"imgsrc"] valueForKey:@"imgsrc"]];
}

-(void)didChangeHeadImg:(id)dict{
    NSLog(@"%@",dict);
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setHeadImg" object:nil];
    [mUserDefault setValue:_mImgStr forKey:@"avatar"];
}

@end
