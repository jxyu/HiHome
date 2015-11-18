//
//  AlbumShowViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/30.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AlbumShowViewController.h"
#import "MyCollectionFooterView.h"
#import "MYCollectionHeadView.h"
#define _CELL @ "acell"
@interface AlbumShowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *mainCollectionView;
    CGFloat _cellwidth;
    NSInteger _sectionCount;
    NSMutableDictionary *_picDateDict;
//    {
//    date = (
//        {
//        
//        }
//    )
//    
//    }
    NSInteger picPage;
    NSMutableArray *picListArr;
    UIView *showImgView;
    BOOL showImgViewState;
    
    UILabel *TempLab;
    
}
@end

@implementation AlbumShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellwidth = SCREEN_WIDTH /4 -10;
    [self initViews];
    showImgViewState = false;
    _sectionCount = 2+1;
    picPage = 1;
    picListArr = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
}

-(void)initViews
{
    
  
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置collection
    
  //  layout.itemSize = CGSizeMake(318, 286);
    
   // layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    layout.headerReferenceSize = CGSizeMake(320, 200);
    
    
    
    mainCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, SCREEN_WIDTH , SCREEN_HEIGHT-ZY_HEADVIEW_HEIGHT) collectionViewLayout:layout];
    
    [layout setHeaderReferenceSize:CGSizeMake(mainCollectionView.frame.size.width, 0)];//暂不现实时间
    
    [mainCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : _CELL ];

    mainCollectionView.delegate= self;
    mainCollectionView.dataSource =self;
    mainCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    mainCollectionView.showsHorizontalScrollIndicator = YES;
    mainCollectionView.showsVerticalScrollIndicator = NO;
    mainCollectionView.backgroundColor = [UIColor whiteColor];
    
    
    [mainCollectionView registerClass:[MYCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
//#pragma mark -- 注册尾部视图
//    [mainCollectionView registerClass:[MyCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    showImgView = [[UIView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - ZY_HEADVIEW_HEIGHT)];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
    [self.view addGestureRecognizer:tapGesture];
    [self.view addSubview:mainCollectionView];
}


-(void)setPicArr:(NSArray *)picArr
{
    _picArr = picArr;
    
    NSLog(@"_picArr = %ld",_picArr.count);
    //按下面格式重构数据
    //    {
    //    date = (
    //        {
    //
    //        }
    //    )
    //    
    //    }
    if(_picDateDict == nil)
        _picDateDict = [NSMutableDictionary dictionary];
    else
        [_picDateDict removeAllObjects];
    
    for(int i;i<picArr.count;i++)
    {
        NSDictionary *tempDict;
        NSString *dateStr;
        tempDict = [_picArr objectAtIndex:i];
        dateStr = [tempDict objectForKey:@"addtime"];
        
        @try {
            if([[_picDateDict allKeys] containsObject:dateStr])//如果字典存在改日期则添加
            {
                NSMutableArray *tempArr;
                tempArr = [_picDateDict objectForKey:dateStr];
                [tempArr addObject:tempDict];
            }
            else//否则新建该日期key
            {
                NSMutableArray *tempArr;
                tempArr = [NSMutableArray array];
                
                [tempArr addObject:tempDict];
                
                [_picDateDict setObject:tempArr forKey:dateStr];
            }

        }
        @catch (NSException *exception) {
            return;
        }
        @finally {
            
        }
        
    }
   // _sectionCount = _picDateDict.count + 2;
    DLog(@"re set date = %@",_picDateDict);
    
    [mainCollectionView reloadData];
    
    
    
}

-(void)tapViewAction:(id)sender{
    
    if(showImgViewState == true)
    {
        showImgViewState = false;
        
        [showImgView removeFromSuperview];
        [[self.view.subviews objectAtIndex:(self.view.subviews.count-1)] removeFromSuperview];//移除图片展示view
    }
    //    [startTimeField resignFirstResponder];
    //    [endTimeField resignFirstResponder];
}


#pragma mark - UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    switch (section) {
        case 0:
            return 1 ;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return _picArr.count/*加四个cell 站位让最后一行的显示完整*/;
            break;
        default:
            return  1;
            break;
    }
    
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;

    if (kind == UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        MYCollectionHeadView *headerV = (MYCollectionHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        //headerV.titleLab.text = @"头部视图";
        headerV.titleLab.textAlignment = NSTextAlignmentLeft;
        reusableView = headerV;
    }


    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section < 2)
        return CGSizeMake(self.view.frame.size.width, 0);
    else
        return CGSizeMake(self.view.frame.size.width, 30);
}

//定义展示的Section的个数

-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return _sectionCount ;
}

//每个UICollectionView展示的内容

-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : _CELL forIndexPath :indexPath];
    
  // UICollectionViewCell * cell = [[UICollectionViewCell alloc] init];
    switch (indexPath.section) {
        case 0:
        {
            
            if(cell != nil)
            {
                for (int i =0 ; i<cell.subviews.count; i++) {
                    [ [cell.subviews objectAtIndex:i] removeFromSuperview];//清空一下原来cell上面的view'防止cell的重用影响到后面section的显示
                }
                
            }
          //  UIImageView *backGroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, SCREEN_WIDTH, (SCREEN_HEIGHT/2 -ZY_HEADVIEW_HEIGHT)/4 * 3)];
            UIImageView *backGroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.frame.size.height)];
            // backGroundImgView.backgroundColor = [UIColor yellowColor];
            // backGroundImgView.contentMode = UIViewContentModeScaleAspectFit;
            backGroundImgView.image = [UIImage imageNamed:@"albumbackground"];
            [cell addSubview:backGroundImgView];

        }
            break;
        case 1:
        {
            if(cell != nil)
            {
                for (int i =0 ; i<cell.subviews.count; i++) {
                    [ [cell.subviews objectAtIndex:i] removeFromSuperview];//
                }
                
            }
         //   UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3,  ZY_HEADVIEW_HEIGHT +backGroundImgView.frame.size.height+20, SCREEN_WIDTH/3, (SCREEN_HEIGHT/2 -ZY_HEADVIEW_HEIGHT)/4 - 40)];
            UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            
            uploadBtn .backgroundColor = ZY_UIBASECOLOR;
            [uploadBtn setTitle:@"上传照片" forState:UIControlStateNormal];
            [uploadBtn addTarget:self action:@selector(btnUploadPic:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:uploadBtn];
            
        }
        break;
            
        case 2:
        {
            
            if(cell != nil)
            {
                for (int i =0 ; i<cell.subviews.count; i++) {
                    [ [cell.subviews objectAtIndex:i] removeFromSuperview];
                }
               
            }
            NSDictionary *tempDict;
            
            if(indexPath.row > _picArr.count -1 )
                return cell;
            @try {
                
                UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _cellwidth, _cellwidth)];
                tempDict = [_picArr objectAtIndex:indexPath.row];
                
                UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _cellwidth, _cellwidth)];
                imgBtn.tag = indexPath.row;
                NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[tempDict objectForKey:@"imgsrc"]];
                NSLog(@"img url = [%@]",url);
                [picView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
                [imgBtn addTarget:self action:@selector(clickImgBtns:) forControlEvents:UIControlEventTouchUpInside];
                [imgBtn addSubview:picView];
                [cell addSubview:imgBtn];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                return cell;
            }
            
           
        }
            break;
        default:
            break;
    }

   
    return cell;
 
    
}

-(void)btnUploadPic:(UIButton *)sender
{

        
    UploadPicViewController *_uploadPicViewCtl = [[UploadPicViewController alloc] init];
    _uploadPicViewCtl.navTitle = @"上传照片";
    
    _uploadPicViewCtl.aid = self.aid;
    _uploadPicViewCtl.albumName = self.navTitle;
    [self presentViewController:_uploadPicViewCtl animated:YES completion:^{}];
   

}
-(void)clickImgBtns:(UIButton *)sender
{
 
//    if(showImgViewState == false)
//    {
////        showImgView.alpha = 0.5;
////        showImgView.backgroundColor = [UIColor blackColor];
////        
////        if(sender.tag > _picArr.count-1)
////            return;
////        NSDictionary *tempDict ;
////        tempDict = [_picArr objectAtIndex:sender.tag];
////        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[tempDict objectForKey:@"imgsrc"]];
////        UIImageView * img_avatar=[[UIImageView alloc] initWithFrame:CGRectMake(50, ZY_HEADVIEW_HEIGHT+50, SCREEN_WIDTH - 100, SCREEN_HEIGHT - ZY_HEADVIEW_HEIGHT -100)];
////        [img_avatar sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
////        img_avatar.contentMode =UIViewContentModeScaleAspectFit;
////        
////        [self.view addSubview:showImgView];
////        [self.view addSubview:img_avatar];
////        [self.view bringSubviewToFront:img_avatar];
////        showImgViewState = true;
//    }

    if(sender.tag > _picArr.count-1)
        return;
    
    PictureShowView *picShowViewCtl = [[PictureShowView alloc] initWithTitle:nil message:nil];
    NSDictionary *tempDict ;
    tempDict = [_picArr objectAtIndex:sender.tag];
    NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[tempDict objectForKey:@"imgsrc"]];
    picShowViewCtl.picIndex = sender.tag;
    picShowViewCtl.ImgUrl = url;
    picShowViewCtl.delegate = self;
    [picShowViewCtl show];
    
//    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:image];
//    photoView.autoresizingMask = (1 << 6) -1;
    
//    [self.view addSubview:photoView];
    
}

#pragma mark - picture show delegate

-(void)didClickDelPicBtn:(NSInteger)index
{
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"删除" message:[NSString stringWithFormat:@"是否删除?"]];
    
    alert.alertType = AlertType_Alert;
    [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item){
        NSDictionary *tempDict ;
        tempDict = [_picArr objectAtIndex:index];
        [self delpic:[tempDict objectForKey:@"id"]];
        
    }];
    
    //    typedef void(^JKAlertDialogHandler)(JKAlertDialogItem *item);
    [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item){
        NSLog(@"Click canel");
        
    }];
    [alert show];
    
}


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
        return _albumUserId;
    }
    
}
#pragma mark - 删除照片接口

-(void)delpic:(NSString *)picId
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"delPicCallBack:"];
    
    [dataprovider DelPicture:picId];
}

-(void)delPicCallBack:(id)dict
{
    NSInteger code;
    [SVProgressHUD dismiss];
    
    DLog(@"[%s] prm = %@",__FUNCTION__,dict);
    
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"照片删除失败:%ld",(long)code]);
        
        if(code!=400)  //= 400 不弹框
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[dict objectForKey:@"message"]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        return;
    }

    picPage = 1;
    [self getAlbumPicList:_aid andNowPage:[NSString stringWithFormat:@"%ld",picPage] andPerPage:nil];
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
        NSLog(@"%@",[NSString stringWithFormat:@"任务获取失败:%@",[dict objectForKey:@"message"]]);
        
    
        TempLab = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2 -ZY_HEADVIEW_HEIGHT+50, SCREEN_WIDTH, 200)];
        TempLab.text = @"暂无照片";
        TempLab.textAlignment = NSTextAlignmentCenter;
        TempLab.textColor = [UIColor grayColor];
        TempLab.font = [UIFont boldSystemFontOfSize:20];
        [self.view addSubview:TempLab];
    
        
        if(code!=400)  //= 400 不弹框z
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[dict objectForKey:@"message"]];
            
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
            [self getAlbumPicList:_aid andNowPage:[NSString stringWithFormat:@"%ld",picPage] andPerPage:nil];
            
            return;
        }
        DLog(@"picListArr count = %ld",picListArr.count);
        self.picArr = picListArr;
        
        if(picListArr.count > 0)
        {
            [TempLab removeFromSuperview ];
        }
        
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
-(void)viewDidAppear:(BOOL)animated
{
    picPage = 1;
    if(picListArr !=nil)
       [picListArr removeAllObjects];
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    [self getAlbumPicList:_aid andNowPage:[NSString stringWithFormat:@"%ld",picPage] andPerPage:nil];
}

#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    NSLog(@"click cell");
    
    
}

//返回这个UICollectionViewCell是否可以被选择

-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    return YES ;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return CGSizeMake ( SCREEN_WIDTH , (SCREEN_HEIGHT/2 -ZY_HEADVIEW_HEIGHT)/4 * 3);
            break;
        case 1:
            return CGSizeMake ( SCREEN_WIDTH/2 , (SCREEN_HEIGHT/2 -ZY_HEADVIEW_HEIGHT)/4);
            break;
        case 2:
            return CGSizeMake ( _cellwidth , _cellwidth);
            break;
        default:
            return CGSizeMake ( _cellwidth , _cellwidth);
            break;
    }
    
    
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    //if()
    switch (section) {
        case 0:
            return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
            break;
        case 1:
            return UIEdgeInsetsMake ( 20 , SCREEN_WIDTH/4 , 20 , SCREEN_WIDTH/4 );
            break;
        case 2:
            return UIEdgeInsetsMake ( 5 , 5 , 5 , 5 );
            break;
        default:
            return UIEdgeInsetsMake ( 10 , 10 , 10 , 10 );
            break;
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
