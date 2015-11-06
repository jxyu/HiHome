//
//  OptionsViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "OptionsViewController.h"
#import "UIDefine.h"
#import "BaseTableViewCell.h"


#define CELL_TITLE(section,row)     ([(NSArray *)[(NSArray *)[_cellInfo objectAtIndex:section] objectAtIndex:row] objectAtIndex:1])

@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellInfo = [[NSMutableArray alloc] initWithArray: @[@[/*第0个section*/
                                                                            /*最右侧图标，标题，内容*/
                                                                            @[@"set",@"任务权限",@"nil"],
                                                                            @[@"set",@"消息通知",@"nil"],
                                                                            @[@"set",@"声音通知",@"nil"],
                                                                            ],
                                                                        /*第一个section*/
                                                                        @[
                                                                            @[@"set",@"聊天记录",@"nil"],
                                                                            @[@"nil",@"版本更新",@"V2.0"],
                                                                            ],
                                                                        /*第二个section*/
                                                                        @[
                                                                            @[@"set",@"功能介绍",@"nil"],
                                                                            @[@"set",@"帮助与反馈",@"nil"],
                                                                            ],
                                                                        /*第三个section*/
                                                                        @[
                                                                            @[@"nil",@"注销登录",@"nil"],
                                                                            @[@"nil",@"退出账号",@"nil"],
                                                                            ],
                                                                        
                                                                        ]];
    

    _taskLimitViewCtl = [[TaskLimitViewController alloc] init];
//    _taskLimitViewCtl = [[TextViewController alloc] init];

    _messageNoticeViewCtl = [[MessageNoticeViewController alloc] init];
    _soundsetViewCtl = [[SoundSetViewController alloc] init];
    _chatLogViewCtl = [[ChatLogViewController alloc] init];
    _helpAndFeedBackViewCtl =[[HelpAndFeedbackViewController alloc] init];
  

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(rightSwip)];
        
    }
    
//
//    __weak UINavigationController *weakSelf = self;
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//    {
//        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
//        self.navigationController.delegate = weakSelf;
//    }

    [self initViews];
    _cellHeight = (self.view.frame.size.height-ZY_HEADVIEW_HEIGHT)/11;
    // Do any additional setup after loading the view from its nib.
}

//-(void)quiView
//{
//    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
//    {
//        [self popoverPresentationController];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}


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
    _cellCount = 3;
    [self.view addSubview:_mainTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
        switch (section) {
            case 0:
                return 3;
                break;
            case 1:
                return 2;
                break;
            case 2:
                return 2;
                break;
            case 3:
                return 2;
                break;
            default:
                break;
        }
    
    return _cellCount;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];

    
    [self setOptionCell:cell andBtnImg:[(NSArray *)[(NSArray *)[_cellInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:0]
                            andTitleLabels:CELL_TITLE(indexPath.section,indexPath.row)
                            andContentLabel:[(NSArray *)[(NSArray *)[_cellInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:2]];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}

-(void)setOptionCell:(BaseTableViewCell *)cell andBtnImg:(NSString *)imgName andTitleLabels:(NSString *)title andContentLabel:(NSString *)Content
{
    NSMutableArray *Imgs = [NSMutableArray array];
    NSMutableArray *Btns = [NSMutableArray array];
    NSMutableArray *Labels = [NSMutableArray array];
    
    if([imgName isEqualToString:@"nil"])
    {
        imgName = nil;
    }
    if([title isEqualToString:@"nil"])
    {
        title = nil;
    }
    if([Content isEqualToString:@"nil"])
    {
        Content = nil;
    }
    
    if(imgName != nil)
    {
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30-15, _cellHeight/3, 15, _cellHeight/3)];
        [titleBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [Btns addObject:titleBtn];
    }
    if(title != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame =CGRectMake(20, _cellHeight/3 , 150, _cellHeight/3);
        titleLabel.text =title;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
   //     titleLabel.textColor = ZY_UIBASECOLOR;//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
        titleLabel.textColor = [UIColor grayColor];
        [Labels addObject:titleLabel];
        
    }
    if(Content != nil)
    {
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.frame =CGRectMake(150+40+40, _cellHeight/3, 100, _cellHeight/3);
        dateLabel.text = Content;
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont boldSystemFontOfSize:14];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [Labels addObject:dateLabel];
    }
    
    
    if(cell != nil)
    {
        if(Labels.count > 0)
            cell.contentLabels = Labels;
        if(Imgs.count > 0)
            cell.contentImgs = Imgs;
        if(Btns.count > 0)
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
    
    BackPageViewController *optionsViewCtls;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    
                    optionsViewCtls = (BackPageViewController *)_taskLimitViewCtl;
                }
                break;
                case 1:
                {
                    optionsViewCtls = (BackPageViewController *)_messageNoticeViewCtl;
                }
                break;
                case 2:
                {
                    optionsViewCtls = (BackPageViewController *)_soundsetViewCtl;
                }
                    break;
            
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    optionsViewCtls = (BackPageViewController *)_chatLogViewCtl;
                }
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 1:
                    optionsViewCtls = (BackPageViewController *)_helpAndFeedBackViewCtl;
                    break;
                    
                default:
                    break;
            }
            break;
        case 3:{
            switch (indexPath.row) {
                case 0:
                {
                    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                              NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
                    NSDictionary *mDic = [[NSDictionary alloc] init];
                    
                    
                    //NSArray * itemdict=[[NSArray alloc] initWithArray:dict[@"datas"]];
                    BOOL result= [mDic writeToFile:plistPath atomically:YES];
                    if (result) {
                        [self dismissViewControllerAnimated:NO completion:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:nil userInfo:[NSDictionary dictionaryWithObject:@"loginpage" forKey:@"rootView"]];
                        //[NSNotificationCenter defaultCenter] postNotificationName:@"Login_success" object:nil];
                        //            [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
        default:
            break;
    }
    if(optionsViewCtls!=nil)
    {
        optionsViewCtls.navTitle = CELL_TITLE(indexPath.section,indexPath.row);
        optionsViewCtls.hidesBottomBarWhenPushed = YES;

//        UIModalTransitionStyleFlipHorizontal,
//        UIModalTransitionStyleCrossDissolve,
        optionsViewCtls.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
        [self presentViewController:optionsViewCtls animated:YES completion:^{}];
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


//重写返回按钮
-(void)quitView{

    [self dismissViewControllerAnimated:YES completion:^{}];
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backFrom" object:nil userInfo:[NSDictionary dictionaryWithObject:@"slideTabView" forKey:@"backFrom"]];
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
    if(section == 0)
        return 0;
    return 20;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == 3)
        return 1;
    
    return 0;
    
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
