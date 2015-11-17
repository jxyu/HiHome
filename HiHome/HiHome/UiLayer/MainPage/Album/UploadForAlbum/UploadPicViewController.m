//
//  UploadPicViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UploadPicViewController.h"
#import "UIDefine.h"
#import "BaseTableViewCell.h"
#import "JKImagePickerController.h"
#import "PullDownButtonsTab.h"
#import "PhotoCell.h"
#import "TempCustomButton.h"


@interface UploadPicViewController ()<JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    UITextField *albumField ;
    NSDictionary *albumDict;
    NSMutableArray *picSrc;
    
    NSString *fullPath;
    //UIButton *pickPicBtns ;
    //图片上传
    NSMutableArray * img_uploaded;
    int uploadImgIndex;
    NSMutableArray * img_prm;
}
@property (nonatomic, strong) NSMutableArray   *assetsArray;
@property (nonatomic, retain) UICollectionView *collectionView;
@end

@implementation UploadPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellHeight = self.view.frame.size.height/11;
    uploadImgIndex=0;
    img_uploaded=[[NSMutableArray alloc] init];
    img_prm=[[NSMutableArray alloc] init];
    
    fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    [self initViews];
    
    //添加键盘的监听事件
    
    
//    // Do any additional setup after loading the view from its nib.
}



-(void) initViews
{
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
    _cellCount = 1;
    _cellTextViewHeight = self.view.frame.size.height/4;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    
    _titleField = [[UITextField alloc]init];
    albumField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    _textView = [[UITextView alloc] init];
    //   _textView.text = @"发帖内容";
    
    [self.mBtnRight setTitle:@"上传" forState:UIControlStateNormal];
  //  self.mBtnRight.hidden = NO;
//    UIButton *sendBtn = [[UIButton alloc] init];
//    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
//    sendBtn.frame = CGRectMake(self.view.frame.size.width-ZY_VIEWHEIGHT_IN_HEADVIEW-10, 20, ZY_VIEWHEIGHT_IN_HEADVIEW, ZY_VIEWHEIGHT_IN_HEADVIEW);
//    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//    [self->_tableHeaderView addSubview:sendBtn];
    
    [self.view addSubview:_mainTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

-(void)btnRightClick:(id)sender
{
    [self.view endEditing:NO];
    
    if (albumField.text.length>0&&_textView.text.length>0&&(albumDict||_aid)) {

        [SVProgressHUD showWithStatus:@"正在上传..." maskType:SVProgressHUDMaskTypeBlack];
        [self BuildSliderData];
    }
    else
    {
//        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"提示" message:@"请完善信息"];
//        alert.alertType = AlertType_Hint;
//        [alert addButtonWithTitle:@"确定"];
//        [alert show];
        if(albumField.text.length==0||(_aid == nil||[_aid  isEqual: @""]))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        if(_textView.text.length==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入描述信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }

    //if(albumDict && _textView.text &&)
}

-(void)tapViewAction:(id)sender
{
    NSLog(@"tap view---");
    
    [self.view endEditing:YES];
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellCount;
}


#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // BaseTableViewCell *cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellHeight)];
   

    switch (indexPath.section) {
            
        case 0:
        {
            //            UITableViewCell *cell = [[UITableViewCell alloc] init];
            //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //             cell.frame =CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellTextViewHeight);
            
            BaseTableViewCell *cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellTextViewHeight)];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _textView.frame = CGRectMake(0, 0, cell.frame.size.width, _cellTextViewHeight);
            
            _textView.delegate = self;
            _textView.returnKeyType = UIReturnKeyDefault;
            _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            [cell addSubview:_textView];
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
        }
            break;
        case 1:
        {
//            _titleField.frame = CGRectMake(0, 0, cell.frame.size.width, _cellHeight);
//        
//            _titleField.placeholder = @"标题";
//            _titleField.delegate = self;
//            [cell addSubview:_titleField];
//            UITableViewCell *cell = [[UITableViewCell alloc] init];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.frame =CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellHeight);
//            
            
            BaseTableViewCell *cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellHeight)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            TempCustomButton *setAlbumBtn = [[TempCustomButton alloc] initWithFrame:CGRectMake(0, 0, 100 , _cellHeight)];
            
            [setAlbumBtn setTitle:@"相册名字" forState:UIControlStateNormal];
            [setAlbumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [setAlbumBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
            setAlbumBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            setAlbumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [setAlbumBtn addTarget:self action:@selector(btnChooseAlbums:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel *_textLabel= [[UILabel alloc] init];
            _textLabel.text = @"   上传到:";
            _textLabel.frame = CGRectMake(10, 0, 80 , _cellHeight);
            _textLabel.font = [UIFont systemFontOfSize:14];
            
            
            albumField.rightView = setAlbumBtn;
            albumField.rightViewMode = UITextFieldViewModeAlways;
            
            albumField.leftView = _textLabel;
            albumField.leftViewMode = UITextFieldViewModeAlways;

            albumField.font = [UIFont systemFontOfSize:14];
            if(_albumName)
                albumField.text = _albumName;
            [cell addSubview:albumField];
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
        }
            break;
        case 2:
        {
//            UITableViewCell *cell = [[UITableViewCell alloc] init];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.frame =CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,  _cellHeight*2);
            
             BaseTableViewCell *cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _cellHeight*2)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *pickPicBtns ;
            pickPicBtns = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, _cellHeight*2 - 20,  _cellHeight*2-20)];
            if(self.ChoosPicByCamera == YES)
            {
                pickPicBtns.frame = CGRectMake(10, 10, 0,  0);
               
            }
            else
            {
                [pickPicBtns setImage:[UIImage imageNamed:@"pickPicBtn"] forState:UIControlStateNormal];
                
                [pickPicBtns addTarget:self action:@selector(btnPickPicture:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell addSubview:pickPicBtns];
            }
            
            if (!_collectionView) {
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                layout.minimumLineSpacing = 5.0;
                layout.minimumInteritemSpacing = 5.0;
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                
                // _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(picBtns.frame.size.width+picBtns.frame.origin.x+5, 0, SCREEN_WIDTH-(2*cell.frame.size.height), cell.frame.size.height) collectionViewLayout:layout];
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(pickPicBtns.frame.size.width+pickPicBtns.frame.origin.x+5, 20,(SCREEN_WIDTH-(pickPicBtns.frame.size.width + pickPicBtns.frame.origin.x)),_cellHeight*2-40) collectionViewLayout:layout];
                _collectionView.backgroundColor = [UIColor clearColor];
                [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
                _collectionView.delegate = self;
                _collectionView.dataSource = self;
                _collectionView.showsHorizontalScrollIndicator = NO;
                _collectionView.showsVerticalScrollIndicator = NO;
                
                [cell addSubview:_collectionView];
                if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
                {
                    [cell setSeparatorInset:UIEdgeInsetsZero];
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
                return cell;
                
            }

            

        }
            break;
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
      return cell;
}

-(void)setAlbumName:(NSString *)albumName
{
    _albumName = albumName;
    
    albumField.text = albumName;
}

-(void)btnChooseAlbums:(UIButton *)sender
{
    ChooseAlbumViewController *chooseViewCtl = [[ChooseAlbumViewController alloc] init];
    chooseViewCtl.navTitle =@"选择相册";
    chooseViewCtl.delegate = self;
    chooseViewCtl.defaultAlbumName = albumField.text;
    [self presentViewController:chooseViewCtl animated:YES completion:^{}];
    
}
#pragma mark - delegate or choose view
-(void)pickedAlbum:(NSDictionary *)dict
{
    NSLog(@"dict1 = %@",dict);
    if(dict != nil)
    {
        albumDict = dict;
        albumField.text = [dict objectForKey:@"title"];
        self.aid = [dict objectForKey:@"id"];
    }
}


//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0)
        return _cellTextViewHeight;
    if(indexPath.section==1)
        return _cellHeight;
    if(indexPath.section==2)
         return _cellHeight*2;
    
    return 0;
    
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


//设置选中的行所执行的动作

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];

    
    tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    //tempView.backgroundColor =[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];//[UIColor colorWithRed:189/255.0 green:
    
    
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
    if (section == 0) {
         return 0;
    }
    return 20;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
    
}

#pragma mark - 照片选择

-(void)btnPickPicture:(UIButton *)sender
{
    [self composePicAdd];
    [_collectionView reloadData];
}

- (void)composePicAdd
{
    JKImagePickerController *imagePickerController;
    UINavigationController *navigationController ;
    
    imagePickerController = [[JKImagePickerController alloc] init];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 10;
    imagePickerController.selectedAssetArray = self.assetsArray;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

-(void)BuildSliderData
{
    [SVProgressHUD showWithStatus:@"正在保存数据" maskType:SVProgressHUDMaskTypeBlack];
    @try {
        NSUserDefaults * userdefaults=[NSUserDefaults standardUserDefaults];
        for (int i=0; i<self.assetsArray.count; i++) {
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
    if(self.ChoosPicByCamera == YES)
        return  1;
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
 
    if(self.ChoosPicByCamera == YES)
    {
        @try {
            
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
            UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0  , cell.frame.size.width,  cell.frame.size.height)];
            
            [tempImgView setImage:savedImage];
            [cell addSubview:tempImgView];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            return cell;
        }
      

    }
    else
    {
        cell.tag=indexPath.row;
    
        cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
    }
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_cellHeight*2-40, _cellHeight*2-40);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    
}

#pragma mark - 服务器交互

-(void)UpdateAndRequest
{
    if(self.ChoosPicByCamera == YES)
    {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"uploadImgBackCall:"];
        [dataprovider UploadImgWithImgdata:fullPath];
        
    }
    else
    {
    
        if (img_uploaded.count>0) {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"uploadImgBackCall:"];
            [dataprovider UploadImgWithImgdataSlider:img_uploaded[uploadImgIndex]];
        }
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
//            DataProvider * dataprovider=[[DataProvider alloc] init];
//            [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitTaskBackCall:"];
            
            for (int i = 0; i < img_prm.count; i++) {
                NSDictionary *tempDict;
                
                tempDict = [img_prm objectAtIndex:i];
                NSLog(@"img dict  = %@",tempDict);
            }
            
            
            [self uploadImgToAlbum];
            
        }
    }
}


-(void)uploadImgToAlbum
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"uploadAlbumCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
//    -(void)UploadPicture:(NSString *)uid andAlbumID:(NSString *)aId andImgSrc:(NSString *)imgSrc andIntro:(NSString *)intro
    NSString *albumId;
    if(_aid)
        albumId = _aid;
    else
        albumId = [albumDict objectForKey:@"id"];
        
    for(int i =0;i<img_prm.count;i++)
    {
        [dataprovider UploadPicture:[self getUserID] andAlbumID:albumId andImgSrc:[img_prm objectAtIndex:i] andIntro:_textView.text];
    }

}



-(void)uploadAlbumCallBack:(id)dict
{
    
    NSInteger code;
    
    DLog(@" dict = %@",dict);
    
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]);
        
        if(code!=400)  //= 400 不弹框
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        
        return;
    }
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"成功" message:[NSString stringWithFormat:@"上传成功"]];
    
    alert.alertType = AlertType_Hint;
 //   [alert addButtonWithTitle:@"确定" ];
    [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item)
     {
         [self quitView];
    }];
    [alert show];
    
    
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
