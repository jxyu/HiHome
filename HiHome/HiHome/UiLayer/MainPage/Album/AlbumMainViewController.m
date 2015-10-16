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

#define CELL_TITLE(section,row)     ([(NSArray *)[(NSArray *)[_cellInfo objectAtIndex:section] objectAtIndex:row] objectAtIndex:0])


@interface AlbumMainViewController ()

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
    
    _cellHeight = self.view.frame.size.height/8;
    _reCentCellHeight = self.view.frame.size.height/4;
    _pullDownBtnsTabFlag  = false;
    [self initViews];
    [self initTaskPage];
    
    
    // self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view from its nib.
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
    UIButton *upLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - ZY_VIEWHEIGHT_IN_HEADVIEW -10, 20, ZY_VIEWHEIGHT_IN_HEADVIEW, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    [upLoadBtn setImage:[UIImage imageNamed:@"addtask"] forState:UIControlStateNormal];
    [upLoadBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self->_tableHeaderView addSubview:upLoadBtn];
    _pullDownBtnTab = [[PullDownButtonsTab alloc] init];
    _pullDownBtnTab.delegate = self;
    /*上传照片各view*/
    _uploadPicViewCtl = [[UploadPicViewController alloc] init];
    
   
}
/*响应三个相片上传相关的按键*/
-(void)respondBtns:(NSInteger)btnIndex
{
    switch (btnIndex) {
        case ZY_UIBUTTON_TAG_BASE+1:
            _uploadPicViewCtl.navTitle = @"上传照片";
            [self presentViewController:_uploadPicViewCtl animated:YES completion:^{}];
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
    
    
    _cellCount = 3;
    _cellCountMyTask = 5;
    _cellCountGetTask = 6;
    
    _myTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT + 60, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -60-ZY_HEADVIEW_HEIGHT)];
    [self setPageIndexPath:_myTaskView indexPage:0];
    
    _getTaskView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT + 60, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -60-ZY_HEADVIEW_HEIGHT)];
    [self setPageIndexPath:_getTaskView indexPage:1];
    
    
    _myTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountMyTask*50);
    _getTaskView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountGetTask*50);
    
    _tableViews = [NSMutableArray array];
    [_tableViews addObject:_myTaskView];
    [_tableViews addObject:_getTaskView];
    
    
    
    [_taskPageSeg setItemTitle:title];
    
    [self.view  addSubview:_taskPageSeg];
    [self.view  addSubview:_myTaskView];
    [self.view  addSubview:_getTaskView];
    
    
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
    NSLog(@"Page = %ld",page);
    if(_tableViews.count>0)
        [self.view bringSubviewToFront:[_tableViews objectAtIndex:page]];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    switch (tableView.tag) {
        case 0:
            return _cellCountMyTask;
            break;
        case 1:
            return _cellCountGetTask;
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
        
        PicPath *picPath = [[PicPath alloc] init];
        
        NSDate* now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
        
        NSDateComponents *changeAlbumDate;
        @try {
            changeAlbumDate= [cal components:unitFlags fromDate:now];
        }
        
        @catch (NSException *exception) {
            return cell;
        }
        @finally {
        }
        
        picPath.picName = @"recentPic";
        picPath.picDate = changeAlbumDate;
        picPath.picDescribe = @"今天一起走红毯，很开心幸福";
        cell.picPath = picPath;
        
    }
    else if(tableView.tag == 1)
    {
        cell = [[AlbumTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _cellHeight)];
        cell.cellType = CellTypeDefault;
        AlbumPath *albumPath = [[AlbumPath alloc] init];
        
        NSDate* now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];

        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
        
        NSDateComponents *changeAlbumDate;
        @try {
            changeAlbumDate= [cal components:unitFlags fromDate:now];
        }
        
        @catch (NSException *exception) {
            return cell;
        }
        @finally {
        }
        
        albumPath.albumChangeDate =changeAlbumDate;
        albumPath.fristPicName =@"fristPic";
        albumPath.albumName = @"我的相册";
        albumPath.picNum = 100;
        
        cell.albumPath = albumPath;
        
        
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
    NSLog(@"click cell section : %ld row : %ld",indexPath.section,indexPath.row);
    
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
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",indexPath.section,indexPath.row);
    
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
