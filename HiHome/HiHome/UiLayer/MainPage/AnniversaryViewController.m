//
//  AnniversaryViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/6.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AnniversaryViewController.h"
#import "UIDefine.h"
#import "BaseTableViewCell.h"
#import "UIImage+WM.h"
#import "UIImage+NSBundle.h"
#import "JKAlertDialog.h"
#import "DataProvider.h"
#import "SVProgressHUD.h"
#import "TaskPath.h"
@interface AnniversaryViewController ()
{
    NSDictionary *_AnniversaryDict;
    
    NSMutableArray *_myAnniversaryData;
   
}
@end

@implementation AnniversaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeight = self.view.frame.size.height/11;
    if(_myAnniversaryData==nil)
        _myAnniversaryData = [NSMutableArray array];
    else{
        [_myAnniversaryData removeAllObjects];
    }
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    DLog(@" anniversary apper");
    [self loadAnniversaryDatas:nil andPerPage:nil];
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
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

#pragma mark - 纪念日
-(void) loadAnniversaryDatas:(NSString *)nowPage andPerPage:(NSString *)perPage
{
    NSLog(@"load anniversary datas");
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getAnniversaryCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    [dataprovider getAnniversaryList:userID andNowPage:nowPage andPerPage:perPage];
}



-(void)getAnniversaryCallBack:(id)dict
{
    NSString *resultAll;
    NSInteger code;
    [SVProgressHUD dismiss];
    NSLog(@"in function [%s]",__FUNCTION__);
    
    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    if(code!=200)
    {
        if(code != 400)
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"纪念日获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        
        [_mainTableView reloadData];//重新载入数据
        return;
    }
    
    
    NSLog(@"anniversary dict = [%@]",dict);
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        _AnniversaryDict = [dict objectForKey:@"datas"];
        resultAll = [_AnniversaryDict objectForKey:@"resultAll"];//获取的任务数
        
        NSLog(@"result all = %@",resultAll);
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    _cellCount = [resultAll integerValue];
    
    DLog(@"_cellCountMyTask = %ld",(long)_cellCount);
    
    [self setAnniversaryDatas];

    [_mainTableView reloadData];//重新载入数据
    
    
}


-(void) setAnniversaryDatas
{
    if(_AnniversaryDict == nil)
        return;
    
    
    NSArray *anniversaryList = [_AnniversaryDict objectForKey:@"list"];
    NSString *resultAll = [_AnniversaryDict objectForKey:@"resultAll"];
    
    for (int i = 0; i < [resultAll integerValue]; i++) {
        
        NSDictionary *tempDict = [anniversaryList objectAtIndex:i];
        
        anniversaryPath *anniversary = [[anniversaryPath alloc] init];
        
        
        NSLog(@"title = %@",[tempDict objectForKey:@"title"]);
        anniversary.title = [tempDict objectForKey:@"title"];
        anniversary.date = [tempDict objectForKey:@"mdate"];
        anniversary.anniversaryID =[tempDict objectForKey:@"id"];
        [_myAnniversaryData addObject:anniversary];
    }
    
    DLog(@"++++++++++++_myAnniversaryData count  = [%ld]",(unsigned long)_myAnniversaryData.count);
    
}


#pragma mark - 获取纪念日详情

-(void)loadAnniversaryDetails:(NSString *)anniversaryID
{
    NSLog(@"load Anniversary Details");
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"AnniversaryDetailCallBack:"];
    
    [dataprovider getAnniversaryInfo:anniversaryID];
}


-(void)AnniversaryDetailCallBack:(id)dict
{
    
    NSInteger code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    NSDictionary *taskDetailDict;
    [SVProgressHUD dismiss];
    
    if(code!=200)
    {
        if(code != 400)
        {
            
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }
        return;
    }
    
    NSLog(@"task detail dict = [%@]",dict);
    
    if(![[dict objectForKey:@"datas"] isEqual:[NSNull null]])
    {
        taskDetailDict = [(NSArray *)[dict objectForKey:@"datas"] objectAtIndex:0];
    }
    else
    {
        NSLog(@"datas = NULL");
        return;
    }
    
    
    NSLog(@"taskDetailDict = %@",taskDetailDict);
    
    anniversaryPath *anniversaryDetailPath;
    anniversaryDetailPath = [[anniversaryPath alloc] init];
    
    anniversaryDetailPath.title = [taskDetailDict objectForKey:@"title"];
    anniversaryDetailPath.content = [taskDetailDict objectForKey:@"content"];
    anniversaryDetailPath.date =[taskDetailDict objectForKey:@"mdate"];
    
    
    if(anniversaryDetailPath.imgSrc.count > 0)
    {
        [anniversaryDetailPath.imgSrc removeAllObjects];
    }
    if((![[taskDetailDict objectForKey:@"imgsrc"] isEqual:[NSNull null]]))
    {
        if(![[taskDetailDict objectForKey:@"imgsrc"] isEqualToString:@""])//头像
        {
            anniversaryDetailPath.headImgSrc = [taskDetailDict objectForKey:@"imgsrc"];
        }
    }
    
    
    if((![[taskDetailDict objectForKey:@"imgsrc1"] isEqual:[NSNull null]]))
    {
        if(![[taskDetailDict objectForKey:@"imgsrc1"] isEqualToString:@""])
        {
            [anniversaryDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc1"]];
        }
    }
    if((![[taskDetailDict objectForKey:@"imgsrc2"] isEqual:[NSNull null]]))
    {
        if(![[taskDetailDict objectForKey:@"imgsrc2"] isEqualToString:@""])
        {
            [anniversaryDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc2"]];
        }
    }
    if((![[taskDetailDict objectForKey:@"imgsrc3"] isEqual:[NSNull null]]))
    {
        if(![[taskDetailDict objectForKey:@"imgsrc3"] isEqualToString:@""])
        {
            [anniversaryDetailPath.imgSrc addObject:[taskDetailDict objectForKey:@"imgsrc3"]];
        }
    }
    NSLog(@"img = [%@]",[taskDetailDict objectForKey:@"imgsrc"]);
    NSLog(@"img1 = [%@]",[taskDetailDict objectForKey:@"imgsrc1"]);
    NSLog(@"img2 = [%@]",[taskDetailDict objectForKey:@"imgsrc2"]);
    NSLog(@"img3 = [%@]",[taskDetailDict objectForKey:@"imgsrc3"]);
    
    
    AnniversaryTaskDetailView* _anniversaryTaskDetailCtl = [[AnniversaryTaskDetailView alloc] init];
    
    [_anniversaryTaskDetailCtl setDatas:anniversaryDetailPath];
    _anniversaryTaskDetailCtl.navTitle = @"纪念日详情";
    _anniversaryTaskDetailCtl.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:_anniversaryTaskDetailCtl animated:NO];
    [self presentViewController:_anniversaryTaskDetailCtl animated:YES completion:^{}];
}


-(TaskPath *)setAnniversaryDetails
{
    TaskPath *tempPath = [[TaskPath alloc] init];
    
    
    return tempPath;
}



-(void) initViews
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, self.view.frame.size.width,self.view.frame.size.height -ZY_HEADVIEW_HEIGHT )];
    _mainTableView.backgroundColor =ZY_UIBASE_BACKGROUND_COLOR;
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    _mainTableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    //_mainTableView.separatorEffect = ;
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        //设置cell分割线从最左边开始
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
    
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    _cellCount = 0;
    [self.view addSubview:_mainTableView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _cellCount;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    if(indexPath.row > _myAnniversaryData.count - 1)
    {
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        return cell;
    }
    
    @try {
        anniversaryPath *anniversaryValue = [_myAnniversaryData objectAtIndex:indexPath.row];
        // cell.mImage = anniversaryValue.mImage;
        NSLog(@"name = [%@]",anniversaryValue.title);
        NSString *imgSrcStr;
        NSDictionary *tempDict ;
        NSArray *anniversaryList = [_AnniversaryDict objectForKey:@"list"];
        tempDict = [anniversaryList objectAtIndex:indexPath.row];
        
        if(![[tempDict objectForKey:@"imgsrc"] isEqual:[NSNull null]])
        {
            imgSrcStr = [tempDict objectForKey:@"imgsrc"];
        }
        else
        {
            imgSrcStr = @"";
        }
        
        [self setAnniversaryCell:cell andBtnImg:imgSrcStr andTitleLabels:anniversaryValue.title andDateLabel:anniversaryValue.date];
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

//重写 退出方法
//-(void)quiView
//{
//    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
//    {
//        [self popoverPresentationController];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}


-(void)setAnniversaryCell:(BaseTableViewCell *)cell andBtnImg:(NSString *)imgName andTitleLabels:(NSString *)title andDateLabel:(NSString *)date
{
    NSMutableArray *Imgs = [NSMutableArray array];
    NSMutableArray *Btns = [NSMutableArray array];
    NSMutableArray *Labels = [NSMutableArray array];
    
    if(imgName != nil)
    {
//        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, _cellHeight-10, _cellHeight-10)];
//        [titleBtn setImage:[[UIImage imageNamed:imgName] getRoundImage] forState:UIControlStateNormal];
//        titleBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [Btns addObject:titleBtn];
        
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,imgName];
        NSLog(@"img url = [%@]",url);
        UIImageView * img_avatar=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, _cellHeight-10, _cellHeight-10)];
        [img_avatar sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
        
        [Imgs addObject:img_avatar];
        
    }
    if(title != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame =CGRectMake((_cellHeight-10)+10+20+20/*图片直径＋左＋右＋文字左*/, _cellHeight/2-30+7, 150, 30);
        titleLabel.text =title;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = ZY_UIBASECOLOR;//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
        [Labels addObject:titleLabel];

    }
    if(date != nil)
    {
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.frame =CGRectMake((_cellHeight-10)+10+20+20, _cellHeight/2+5, 150, _cellHeight/2-5);
        dateLabel.text = [date substringToIndex:10];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont boldSystemFontOfSize:14];
        [Labels addObject:dateLabel];
    }
    
    UIImageView *lineImgView = [[UIImageView alloc] init];
    lineImgView.frame = CGRectMake((_cellHeight-10)+10+20, 5, 1, _cellHeight-10);
    lineImgView.backgroundColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];;
    [Imgs addObject:lineImgView];
    
    
    if(cell != nil)
    {
        cell.contentLabels = Labels;
        cell.contentImgs = Imgs;
        cell.contentBtns = Btns;
    }
}



//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return _cellHeight;
}


//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIScrollView *tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 0, 100, 100)];
//
//
//    cell.backgroundView = tempView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    anniversaryPath *tempPath;
    tempPath = [_myAnniversaryData objectAtIndex:indexPath.row];
    
    [self loadAnniversaryDetails:tempPath.anniversaryID];
    
    
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
