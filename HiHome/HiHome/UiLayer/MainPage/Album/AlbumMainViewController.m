//
//  AlbumMainViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AlbumMainViewController.h"

#import "BaseTableViewCell.h"
#import "UIDefine.h"
#import "TaskTableViewCell.h"
#import "AlbumTableViewCell.h"
#import "AlbumPath.h"
#import "PullDownButtonsTab.h"
#import "JKAlertDialog.h"
#import "DataProvider.h"
#import "CreateAlbumViewController.h"
#import "SVProgressHUD.h"
#define CELL_TITLE(section,row)     ([(NSArray *)[(NSArray *)[_cellInfo objectAtIndex:section] objectAtIndex:row] objectAtIndex:0])


@interface AlbumMainViewController ()
{
    NSMutableArray *albumArray;
    NSMutableArray *resentArray;
    NSMutableArray *picListArr;
    NSString *albumStr;
    
    NSInteger picPage;
    NSInteger albumPage;
    NSInteger resentPage;
    NSInteger _currentPage;
    NSString *selectAlbumID;
    UIButton *upLoadBtn;
    
    UIButton *TempBtn;
    
    BOOL pickPicOK;
}
@end

@implementation AlbumMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellInfo = [[NSMutableArray alloc] initWithArray: @[@[/*第0个section*/
                                                             /*最右侧图标，标题，内容*/
                                                             @[@"只对家庭圈"],
                                                             @[@"对所有人"],
                                                             @[@"对好友"],
                                                             @[@"你好"],
                                                             @[@"对好友"],
                                                             @[@"对好友"],
                                                             ],
                                                         
                                                         ]];
    _currentPage = 0;
    _cellHeight = self.view.frame.size.height/8;
    _reCentCellHeight = self.view.frame.size.height/4;
    _pullDownBtnsTabFlag  = false;
    picPage = 1;
    resentPage = 1;
    albumPage = 1;
    albumArray = [NSMutableArray array];
    resentArray =[NSMutableArray array];
    picListArr = [NSMutableArray array];
    dateStrArr = [NSMutableArray array];
    arrForCellDisp = [NSMutableArray array];
    reSetResentDict = [NSMutableDictionary dictionary];
    [self initViews];
    [self initTaskPage];
    
    
    // self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
     [_pullDownBtnTab dismiss];
    if(pickPicOK == YES)
    {
        pickPicOK = NO;
        UploadPicViewController *_uploadPicViewCtl = [[UploadPicViewController alloc] init];
        _uploadPicViewCtl.navTitle = @"上传照片";
        _uploadPicViewCtl.ChoosPicByCamera = YES;
        [self presentViewController:_uploadPicViewCtl animated:YES completion:^{}];
    }
    
    [_taskPageSeg setCurrentPage:_taskPageSeg.currentPage];
}

-(void)handleGesture:(id)sender
{
    NSLog(@"Hi hi hi");
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) initViews
{
    //    _mainTableView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,60+ [[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.height))];
    //    _mainTableView.backgroundColor = ZY_UIBASECOLOR;
    //
    //    [self.view addSubview:_mainTableView];
//    upLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - ZY_VIEWHEIGHT_IN_HEADVIEW -10, 20, ZY_VIEWHEIGHT_IN_HEADVIEW, ZY_VIEWHEIGHT_IN_HEADVIEW)];
//    [upLoadBtn setImage:[UIImage imageNamed:@"addtask"] forState:UIControlStateNormal];
//    [upLoadBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    upLoadBtn.backgroundColor = [UIColor blueColor];
    
    
    [ self.mBtnRight setImage:[UIImage imageNamed:@"addtask"] forState:UIControlStateNormal];
    [ self.mBtnRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
  //  self->_tableHeaderView.alpha = 0.3;
    self.mBtnRight.hidden = NO;
    //[self->_tableHeaderView addSubview:upLoadBtn];
    _pullDownBtnTab = [[PullDownButtonsTab alloc] init];
    _pullDownBtnTab.delegate = self;
    /*上传照片各view*/
    
    
   
}
/*响应三个相片上传相关的按键*/
-(void)respondBtns:(NSInteger)btnIndex
{
    switch (btnIndex) {
        case ZY_UIBUTTON_TAG_BASE+1:
        {
            UploadPicViewController *_uploadPicViewCtl = [[UploadPicViewController alloc] init];
            _uploadPicViewCtl.navTitle = @"上传照片";
            [self presentViewController:_uploadPicViewCtl animated:YES completion:^{}];
        }
            break;
        case ZY_UIBUTTON_TAG_BASE+2:
            
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
        case ZY_UIBUTTON_TAG_BASE+3:
        {
            CreateAlbumViewController *_createAlbum;
            _createAlbum = [[CreateAlbumViewController alloc] init];
            _createAlbum.navTitle = @"新建相册";
            [self presentViewController:_createAlbum animated:YES completion:^{}];
        }
            break;
        default:
            break;
    }
}
-(void)openCamera
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    
    NSLog(@"info = %@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    /* 此处info 有六个值
     08
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     09
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     10
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     11
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     12
     * UIImagePickerControllerMediaURL;       // an NSURL
     13
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     14
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     15
     */
    
    // 保存图片至本地，方法见下文
    
    [self saveImage:image withName:@"currentImage.png"];
    
    pickPicOK = YES;

    
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



-(void)btnClick:(id)sender
{
    
    
    if(!_pullDownBtnsTabFlag)
    {
        NSLog(@"1111");
        [_pullDownBtnTab show];
    }
    else
    {
        NSLog(@"2222");
        [_pullDownBtnTab dismiss];
    }
    
    _pullDownBtnsTabFlag = !_pullDownBtnsTabFlag;
    
}

#pragma mark -  set task page
-(void) initTaskPage
{
    
    //_taskPageSeg 分页器  _tableViews存储所有页面
    _taskPageSeg = [[SegmentedPageView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, [[UIScreen mainScreen]bounds].size.width, 60)];
    _taskPageSeg.segType = SegTypeTitleOnly;//要在numOfPages之前设置
    _taskPageSeg.numOfPages = 2;
    _taskPageSeg.backgroundColor = [UIColor whiteColor];
    _taskPageSeg.titleFont = [UIFont boldSystemFontOfSize:20];
    
    NSArray *title = @[@"最近相片",@"相册列表"];
    _taskPageSeg.delegate = self;
    [_taskPageSeg setItemTitle:title];
    
    
    _cellCount = 1;
    _cellCountRecentPic = 0;
    _cellCountAlbum = 0;
    
    _recentPicView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT + 60, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -60-ZY_HEADVIEW_HEIGHT)];
    [self setPageIndexPath:_recentPicView indexPage:0];
    
    _albumView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT + 60, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -60-ZY_HEADVIEW_HEIGHT)];
    [self setPageIndexPath:_albumView indexPage:1];
    
    
    _recentPicView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountRecentPic*50);
    _albumView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountAlbum*50);
    
    _tableViews = [NSMutableArray array];
    [_tableViews addObject:_recentPicView];
    [_tableViews addObject:_albumView];
    
    
    
    [_taskPageSeg setItemTitle:title];
    
    [self.view  addSubview:_taskPageSeg];
    [self.view  addSubview:_recentPicView];
    [self.view  addSubview:_albumView];
    
    
    [_taskPageSeg setCurrentPage:0];//页面都设置完成后再调用
    
    
}

-(void) setPageIndexPath:(UITableView *) tableView indexPage:(NSInteger)page
{
    //   UITableView *sendTaskView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    tableView.tag = page;
    tableView.delegate = self;
    tableView.dataSource = self;
    if(page == 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    else
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
}


-(void)setPageIndex:(NSInteger)page
{
    NSLog(@"Page = %ld",(long)page);
    _currentPage = page;
    if(_tableViews.count>0)
        [self.view bringSubviewToFront:[_tableViews objectAtIndex:page]];
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    switch (page) {
        case 0:
            NSLog(@"get resent list");
            _cellCountRecentPic = 0;
            resentPage = 1;
            if(resentArray !=nil)
            {
                [resentArray removeAllObjects];
            }
            
            [self getResentPic:nil andPerPage:nil];
            break;
        case 1:
            NSLog(@"get Album list");
            _cellCountAlbum = 0;
            albumPage = 1;
            if(albumArray !=nil)
            {
                [albumArray removeAllObjects];
            }
            
            [self getAlbumList:[self getUserID] andNowPage:nil andPerPage:nil];
            break;
            
        default:
        {
            [SVProgressHUD dismiss];
        }
            break;
    }
    
}

#pragma mark - 与服务器数据交互



-(NSString *)getUserID
{
    
    if(_albumUserId == nil)
    {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
        NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID
        
        return  userID;
    }
    else
    {
        return  _albumUserId;
    }
}
#pragma mark - 获取最近相片
-(void)getResentPic:(NSString *)nowPage andPerPage:(NSString *)perPage
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getResentListCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    if(reSetResentDict != nil)
        [reSetResentDict removeAllObjects];
    else
    {
        reSetResentDict =[NSMutableDictionary dictionary];
    }
    [dataprovider GetResentPic:userID andNowPage:nowPage andPerPage:perPage];
}


////重写返回按钮
-(void)quitView{

    if(self.pageChangeMode == Mode_nav)
    {
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
        {
            [self popoverPresentationController];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backFrom" object:nil userInfo:[NSDictionary dictionaryWithObject:@"slideTabView" forKey:@"backFrom"]];
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}
//

-(void)getResentListCallBack:(id)dict
{
    
    NSInteger code;
    NSMutableDictionary *albumDict;
    NSInteger resultAll;
    [SVProgressHUD dismiss];
#if DEBUG
    NSLog(@"[%s] prm = %@",__FUNCTION__,dict);
#endif
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]);
        
        if(code!=400)  //= 400 不弹框
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"相册获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        return;
    }
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        albumDict = [dict objectForKey:@"datas"];
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    @try {
        
        [resentArray addObjectsFromArray:[albumDict objectForKey:@"list"]];
        resultAll = [[albumDict objectForKey:@"resultAll"] integerValue];
        NSLog(@"resultAll = %ld",resultAll);
        if(resultAll > resentArray.count)
        {
            resentPage++;
            
            [self getResentPic:[NSString stringWithFormat:@"%ld",resentPage] andPerPage:nil];
            return;
        }
        
        if(resentArray.count !=0)
        {
          //  _cellCountRecentPic = resentArray.count;
            _cellCountRecentPic = 0;
            [self resetResentDict:resentArray];
            [self setDateArr:resentArray];
            [self buildArrForCellDisp];//和上面的两个接口或许可以简化
            NSLog(@"reSetResentDict = %@",reSetResentDict);
            NSLog(@"dateStrArr = %@",dateStrArr);
            NSLog(@"_cellCountRecentPic = %ld",_cellCountRecentPic);
        }
        
        [_recentPicView reloadData];
        
    }
    @catch (NSException *exception) {
        
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"数据解析错误"]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        
        
        return;
    }
    @finally {
        
    }
    
}


#pragma mark - 照片合并显示的处理
-(void)setDateArr:(NSArray *)arr
{
    NSDictionary *tempDict;
    NSString *dateStr;
    if(arr == nil)
        return;
    
    for(int i = 0; i<arr.count;i++)
    {
        tempDict = arr[i];
        dateStr = [tempDict objectForKey:@"addtime"];
        dateStr = [dateStr substringToIndex:10];
        if([dateStrArr containsObject:dateStr])
            continue;
        else{
            [dateStrArr addObject:dateStr];
        }
    }
}

-(void)resetResentDict:(NSArray *)arr
{
    NSString *dateStr;
    NSString *intro;
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    if(arr == nil)
        return;
/*    reSetResentDict  结构
{
  date = {
    intro = (
    {}//照片
 
    {}
 )
 
 }
}
*/
    @try {
        for(int i = 0; i<arr.count;i++)
        {
          //  tempDict = arr[i];
            tempDict = [NSMutableDictionary dictionary];
            [tempDict addEntriesFromDictionary:arr[i]];
            
            [tempDict setObject:@"NO" forKey:@"show"];//添加是否已显示的标识
            
            dateStr = [tempDict objectForKey:@"addtime"];
            
            dateStr = [dateStr substringToIndex:10];
            intro = [tempDict objectForKey:@"intro"];
            
            if([[reSetResentDict allKeys] containsObject:dateStr])
            {
//                NSMutableArray *tempArr;
//                tempArr = [reSetResentDict objectForKey:dateStr];
//                [tempArr addObject:tempDict];
                
                NSMutableDictionary *dateDict;
                dateDict = [reSetResentDict objectForKey:dateStr];//获取相同日期的dic
                if([[dateDict allKeys] containsObject:intro])//判断是否存在该详情  存在则添加
                {
                    if(dateDict.count >=4)
                        continue;//最多保存4张 节省时间 空间
                    
                    NSMutableArray *tempArr ;//= [NSMutableArray array]
                    tempArr = [dateDict objectForKey:intro];
                    [tempArr addObject:tempDict];
                    [dateDict setObject:tempArr forKey:intro];
                    
                }
                else//否则新建
                {
                    NSMutableArray *tempArr;
                    tempArr = [NSMutableArray array];
                    
                    [tempArr addObject:tempDict];
                    
                    [dateDict setObject:tempArr forKey:intro];
                    _cellCountRecentPic++;
                }
                
                
            }
            else//否则新建该日期key
            {
                NSMutableDictionary *dateDict;
                NSMutableArray *introArr;
                dateDict = [NSMutableDictionary dictionary];
                introArr = [NSMutableArray array];
                
                [introArr addObject:tempDict];//添加到intro 数组
                
                [dateDict setObject:introArr forKey:intro];//添加到 date key
                _cellCountRecentPic ++;
                [reSetResentDict setObject:dateDict forKey:dateStr];
            }

        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}


-(NSString *)checkDateDict:(NSDictionary *) dict
{
    NSArray *tempArr;
    NSString *tempStr;
    if(dict == nil)
        return nil;
    
    for(tempStr in [dict allKeys])
    {
        
        tempArr = [dict objectForKey:tempStr];
        
        if(tempArr==nil || tempArr.count <= 0)
            return nil;
        if([[tempArr[0] objectForKey:@"show"] isEqualToString:@"YES"])//检测是否显示过
        {
            continue;
        }
        else
            return tempStr;
    }
    
    return nil;
}
-(void)buildArrForCellDisp
{
    if(arrForCellDisp != nil)
        [arrForCellDisp removeAllObjects];
    
    for(int i = 0;i < _cellCountRecentPic;i++)
    {
        @try {
            NSArray *dispArr;
            NSString *dateStr;
            NSMutableDictionary *dateDict;
            NSString *introStr;
            for (int i = 0; i< dateStrArr.count; i++) {
                dateStr = dateStrArr[i];//获取存在日期的列表
                
                if([[reSetResentDict allKeys] containsObject:dateStr])
                {
                    dateDict = [reSetResentDict objectForKey:dateStr];
                    
                    introStr = [self checkDateDict:dateDict] ;
                    dispArr = [dateDict objectForKey:introStr];
                    
                    if(dispArr == nil)
                    {
                        continue;//如果日期中没有待处理的照片则再查找后面的日期
                    }
                    else
                    {
                        break;
                    }
                    
                }
                else
                {
                    continue;
                }
            }
            if(dispArr == nil)
                return;
            
            [dispArr[0] setObject:@"YES" forKey:@"show"];
            
            [dateDict setObject:dispArr forKey:introStr];
            [reSetResentDict setObject:dateDict forKey:dateStr];
            
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            
            [tempDict setObject:dateStr forKey:@"date"];
            [tempDict setObject:introStr forKey:@"intro"];
            [tempDict setObject:[dispArr[0] objectForKey:@"addtime"] forKey:@"ctime"];//用于排序
            [tempDict setObject:[dispArr[0] objectForKey:@"aid"] forKey:@"aid"];
            NSMutableArray *imgArr = [NSMutableArray array];
            for(int i = 0;i<dispArr.count;i++)
            {
                if(i == 4)//最多只保存四张
                    break;
                [imgArr addObject:[dispArr[i] objectForKey:@"imgsrc"]];
                
                // [tempDict setObject:[dispArr[i] objectForKey:@"imgsrc"] forKey:[NSString stringWithFormat:@"imgsrc%d",i]];
            }
            [tempDict setObject:imgArr forKey:@"imgs"];
            [arrForCellDisp addObject:tempDict];//设置至cell显示用
            
            
           
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
        }
    }
    
     [self bubble_sort:arrForCellDisp];//按时间重新排序
    
}
//字符串转时间戳
-(NSTimeInterval)timeconvert:(NSString*)str andFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:str];
    NSTimeInterval dis = [date timeIntervalSince1970];
    
    return dis;
}


-(void)bubble_sort:(NSMutableArray *)Arr
{
    int i, j;
    NSTimeInterval a,b;
    NSDictionary *temp;
    for (j = 0; j < Arr.count - 1; j++)
        for (i = 0; i < Arr.count - 1 - j; i++)
        {
            
            temp = Arr[i];
            a = [self timeconvert:[Arr[i] objectForKey:@"ctime"] andFormat:@"yyyy-MM-dd HH:mm:ss"];
            b = [self timeconvert:[Arr[i+1] objectForKey:@"ctime"] andFormat:@"yyyy-MM-dd HH:mm:ss"];
            if(a < b)
            {
                temp = Arr[i];
                Arr[i] = Arr[i + 1];
                Arr[i + 1] = temp;
            }
        }
}
#pragma mark - 获取相册列表
-(void)getAlbumList:(NSString *)fid andNowPage:(NSString *)nowPage andPerPage:(NSString *)perPage
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getAlbumListCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    [dataprovider GetAlbumList:fid andUid:userID andNowPage:nowPage andPerPage:perPage];
}


-(void)getAlbumListCallBack:(id)dict
{

    NSInteger code;
    NSMutableDictionary *albumDict;
    NSInteger resultAll;
    [SVProgressHUD dismiss];
#if DEBUG
    NSLog(@"[%s] prm = %@",__FUNCTION__,dict);
#endif
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]);
        _cellCountAlbum = 0;
        [_albumView reloadData];
        
        TempBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -100)/2, (SCREEN_HEIGHT- ZY_HEADVIEW_HEIGHT)/2, 100, 44)];
        
        TempBtn .backgroundColor = ZY_UIBASECOLOR;
        [TempBtn setTitle:@"新建相册" forState:UIControlStateNormal];
        [TempBtn addTarget:self action:@selector(createAlbumBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:TempBtn];
        
        if(code!=400)  //= 400 不弹框
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"相册获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        return;
    }
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        albumDict = [dict objectForKey:@"datas"];
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    resultAll = [[albumDict objectForKey:@"resultAll"] integerValue];
    NSLog(@"resultAll = %ld",resultAll);
    @try {
      //  albumArray = [albumDict objectForKey:@"list"];
        
        [albumArray addObjectsFromArray:[albumDict objectForKey:@"list"]];
        
        if(resultAll > albumArray.count)
        {
            albumPage++;
            
            [self getAlbumList:[self getUserID] andNowPage:[NSString stringWithFormat:@"%ld",albumPage] andPerPage:nil];
            return;
        }
        
        if(albumArray.count !=0)
        {
            _cellCountAlbum = albumArray.count;
            [TempBtn removeFromSuperview];
        }
        [_albumView reloadData];
        
    }
    @catch (NSException *exception) {
        
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"数据解析错误"]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];

    
        return;
    }
    @finally {
        
    }

}


-(void)createAlbumBtn
{
    CreateAlbumViewController *_createAlbum;
    _createAlbum = [[CreateAlbumViewController alloc] init];
    _createAlbum.navTitle = @"新建相册";
    [self presentViewController:_createAlbum animated:YES completion:^{}];
}

#pragma  mark - 获取图片列表


-(void)getAlbumPicList:(NSString *)aid andNowPage:(NSString *)nowpage andPerPage:(NSString *)perpage
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getAlbumPicListCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    [dataprovider GetPictureList:[self getUserID] andAid:aid andNowPage:nowpage andPerPage:perpage];
}


-(void)getAlbumPicListCallBack:(id)dict
{
    
    NSInteger code;
    NSMutableDictionary *albumDict;
    NSInteger resultAll;
    [SVProgressHUD dismiss];

    DLog(@"[%s] prm = %@",__FUNCTION__,dict);

    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]);
        
        if(code!=400)  //= 400 不弹框
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"相册获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        return;
    }
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        albumDict = [dict objectForKey:@"datas"];
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    
    resultAll = [[albumDict objectForKey:@"resultAll"] integerValue];
    NSLog(@"resultAll = %ld",resultAll);
    
    @try {
        
 
        NSArray *tempArr = [albumDict objectForKey:@"list"];
        for (int i =0; i< tempArr.count; i++) {
            [picListArr addObject:[tempArr objectAtIndex:i]];
        }

        if(resultAll > picListArr.count)
        {
            picPage++;
            [self getAlbumPicList:selectAlbumID andNowPage:[NSString stringWithFormat:@"%ld",picPage] andPerPage:nil];
            
            return;
        }
        DLog(@"picListArr count = %ld",picListArr.count);
        AlbumShowViewController *albumViewCtl  = [AlbumShowViewController alloc];
        albumViewCtl.navTitle = albumStr;
        albumViewCtl.aid = selectAlbumID;
        if(picListArr != nil)
            albumViewCtl.picArr = picListArr;
        [self presentViewController:albumViewCtl animated:YES completion:^{}];
        
    }
    @catch (NSException *exception) {
        
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"数据解析错误"]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        
        
        return;
    }
    @finally {
        
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    switch (tableView.tag) {
        case 0:
            return _cellCountRecentPic;
            break;
        case 1:
            return _cellCountAlbum;
            break;
        default:
            break;
    }
    
    return _cellCount;
}

#pragma mark - setting for cell



//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AlbumTableViewCell *cell;
   
    if(tableView.tag == 0)
    {
        cell = [[AlbumTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _reCentCellHeight)];
        cell.cellType = CellTypePicRecent;
        
        if(indexPath.row > resentArray.count - 1)
            return cell;
        
        PicPath *picPath = [[PicPath alloc] init];
        
        
        @try {
            
            if(arrForCellDisp.count - 1< indexPath.row)
                return cell;
            
           // NSDictionary *tempDict = [resentArray objectAtIndex:indexPath.row];
          //  picPath.picName =  [tempDict objectForKey:@"imgsrc"] ;
            picPath.picDateStr = [(NSString *)[arrForCellDisp[indexPath.row] objectForKey:@"date"] substringToIndex:10];
            picPath.picDescribe = [arrForCellDisp[indexPath.row] objectForKey:@"intro"];
            cell.picPath = picPath;
           // cell.picView.backgroundColor = [UIColor blackColor];
            NSArray *imgs = [arrForCellDisp[indexPath.row] objectForKey:@"imgs"];
            switch (imgs.count) {
                case 1:
                {
                    NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,imgs[0]];
                    NSLog(@"img url = [%@]",url);
                    [cell.picView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
                }
                    
                    break;
                case 2:
                {
                    
                    for(int i=0;i<2;i++)
                    {
                        UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(cell.picView.frame.size.width/2 + 1), 0, cell.picView.frame.size.width/2 -1, cell.picView.frame.size.height)];
                        
                        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,imgs[i]];
                        [tempView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
                        
                        [cell.picView addSubview:tempView];
                    }
                    
                }
                    break;
                case 3:
                {
                    for(int i=0;i<3;i++)
                    {
                        UIImageView *tempView;
                        if(i == 0)
                        {
                          tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.picView.frame.size.width/2-1, cell.picView.frame.size.height)];
                        }
                        else
                        {
                            tempView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.picView.frame.size.width/2+1, (i-1)*(cell.picView.frame.size.height/2 +1), cell.picView.frame.size.width/2-1, cell.picView.frame.size.height/2-1)];
                        }
                        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,imgs[i]];
                        [tempView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
                        
                        [cell.picView addSubview:tempView];
                    }
                }
                    break;
                case 4:
                {
                    
                    for(int i=0;i<4;i++)
                    {
                        UIImageView *tempView;
                        if(i == 0||i==2)
                        {
                            tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0,(i/2)* (cell.picView.frame.size.height/2 + 1), cell.picView.frame.size.width/2-1, cell.picView.frame.size.height/2 -1)];
                        }
                        else
                        {
                            tempView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.picView.frame.size.width/2+1, (i/2)*(cell.picView.frame.size.height/2+1), cell.picView.frame.size.width/2-1, cell.picView.frame.size.height/2-1)];
                        }
                        
                        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,imgs[i]];
                        [tempView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
                        
                        [cell.picView addSubview:tempView];
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
           // cell.picView

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
    else if(tableView.tag == 1)
    {
        cell = [[AlbumTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _cellHeight)];
        cell.cellType = CellTypeDefault;
        AlbumPath *albumPath = [[AlbumPath alloc] init];
        NSDictionary *tempDict;
        
        if(indexPath.row > albumArray.count-1 || albumArray.count == 0)
        {
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
        }
        
        
        @try {
            tempDict = [albumArray objectAtIndex:indexPath.row];
            
            
            if([[tempDict objectForKey:@"addtime"] isEqual:[NSNull null]])
            {
                albumPath.albumChangeDateStr = nil;
            }
            else
            {
                albumPath.albumChangeDateStr = [[tempDict objectForKey:@"addtime"] substringToIndex:10];
            }
            
            albumPath.fristPicName =[tempDict objectForKey:@"imgsrc"];//@"fristPic";
            albumPath.albumName = [tempDict objectForKey:@"title"];
            albumPath.picNum = [[tempDict objectForKey:@"photos"] integerValue];
            cell.albumPath = albumPath;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
        }
        
        
        
       
        
        
        //return cell;
    }
    else
    {
        cell = [[AlbumTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _cellHeight)];
    }
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}

-(void)setOptionCell:(BaseTableViewCell *)cell andTitleLabels:(NSString *)title
{
    NSMutableArray *Labels = [NSMutableArray array];
    
    if([title isEqualToString:@"nil"])
    {
        title = nil;
    }
    if(title != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame =CGRectMake(20, _cellHeight/3 , 150, _cellHeight/3);
        titleLabel.text =title;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        //     titleLabel.textColor = ZY_UIBASECOLOR;//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
        titleLabel.textColor = [UIColor grayColor];
        [Labels addObject:titleLabel];
    }
    
    
    if(cell != nil)
    {
        cell.contentLabels = Labels;
    }
}



//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 0:
            return _reCentCellHeight;
        case 1:
            return _cellHeight;
        default:
            break;
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if(tableView.tag == 0)
    {
       // picPath.picDateStr = [(NSString *)[arrForCellDisp[indexPath.row] objectForKey:@"date"] substringToIndex:10];
        
        NSDictionary *tempDict;
        tempDict = [arrForCellDisp objectAtIndex:indexPath.row];
       // albumStr = [tempDict objectForKey:@"title"];
        selectAlbumID =[tempDict objectForKey:@"aid"];
        
        AlbumShowViewController *albumViewCtl  = [AlbumShowViewController alloc];
        //albumViewCtl.navTitle = albumStr;
        albumViewCtl.aid = selectAlbumID;
        albumViewCtl.albumUserId = [self getUserID];
        [self presentViewController:albumViewCtl animated:YES completion:^{}];
        
    }
    else if(tableView.tag == 1)
    {
        NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
        NSDictionary *tempDict;
        tempDict = [albumArray objectAtIndex:indexPath.row];
        albumStr = [tempDict objectForKey:@"title"];
        selectAlbumID =[tempDict objectForKey:@"id"];
        picPage = 1;
      
        if(picListArr!=nil&&picListArr.count>0)
           [picListArr removeAllObjects];
     //   [self getAlbumPicList:selectAlbumID andNowPage:[NSString stringWithFormat:@"%ld",picPage] andPerPage:nil];
        
        
        AlbumShowViewController *albumViewCtl  = [AlbumShowViewController alloc];
        albumViewCtl.navTitle = albumStr;
        albumViewCtl.aid = selectAlbumID;
        albumViewCtl.albumUserId = [self getUserID];
        [self presentViewController:albumViewCtl animated:YES completion:^{}];
        
    
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
    
    if(tableView.tag == 1)
        return YES;
    else
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
    if(tableView.tag == 0)
        return;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
        
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"删除" message:[NSString stringWithFormat:@"是否删除?"]];
        
        alert.alertType = AlertType_Alert;
        [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item){
            NSLog(@"Click ok");
            
            NSDictionary *tempDict = [albumArray objectAtIndex:indexPath.row];
            
            [self delAlbum:[tempDict objectForKey:@"id"]];
            
            
        }];
        
        //    typedef void(^JKAlertDialogHandler)(JKAlertDialogItem *item);
        [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item){
            NSLog(@"Click canel");
            
        }];
        [alert show];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - 删除相册
-(void) delAlbum:(NSString *)albumID
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"delAlbumCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    [dataprovider DelAlbum:albumID];
}
-(void)delAlbumCallBack:(id)dict
{
    NSInteger code;
    [SVProgressHUD dismiss];
    
    DLog(@"%@",dict);
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    
    if(code!=200)
    {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"删除失败"]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        return;
    }
    
    [_taskPageSeg setCurrentPage:_taskPageSeg.currentPage];//刷新数据
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
//    if(tableView.tag == 0)
//    {
//        if(section == 0)
//        {
//            tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
//            UILabel *titleLabel = [[UILabel alloc] init];
//            titleLabel.frame = CGRectMake(10,0 , 150, 30);
//            titleLabel.text = @"2015-8-15";
//            titleLabel.font = [UIFont boldSystemFontOfSize:18];
//            titleLabel.textColor  = ZY_UIBASECOLOR;
//            [tempView addSubview:titleLabel];
//        }
//    }
//    else if(tableView.tag == 1)
//    {
//        if(section == 0)
//        {
//            tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
//            UILabel *titleLabel = [[UILabel alloc] init];
//            titleLabel.frame = CGRectMake(10,0 , 150, 30);
//            titleLabel.text = @"2015-8-16";
//            titleLabel.font = [UIFont boldSystemFontOfSize:18];
//            titleLabel.textColor  = ZY_UIBASECOLOR;
//            [tempView addSubview:titleLabel];
//        }
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
