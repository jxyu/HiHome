//
//  TaskLimitViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TaskLimitViewController.h"
#import "BaseTableViewCell.h"
#import "UIDefine.h"

#define CELL_TITLE(section,row)     ([(NSArray *)[(NSArray *)[_cellInfo objectAtIndex:section] objectAtIndex:row] objectAtIndex:0])


@interface TaskLimitViewController ()
{
    NSUserDefaults *taskLimitDefault;
    NSString *limitStr;
    
    NSString *tasklimitID;
    NSString *tasklimitName;
    BOOL selectCellState[2];
}
@end

@implementation TaskLimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellInfo = [[NSMutableArray alloc] initWithArray: @[@[/*第0个section*/
                                                             /*最右侧图标，标题，内容*/
                                                             @[@"只对家庭圈"],
                                                             @[@"对所有人"],
                                                             @[@"对好友"],
                                                             ],
                                                         
                                                         ]];
    
    _cellHeight = self.view.frame.size.height/11;
    
    memset(selectCellState, 0, sizeof(selectCellState));
    
    [self initViews];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(rightSwip)];
        
    }
    

   // self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}



-(void)rightSwip
{
printf("\r\n@@[%s]----\r\n",__FUNCTION__);
}

-(void)viewWillDisappear:(BOOL)animated
{
     printf("\r\n+[%s]----\r\n",__FUNCTION__);
}

-(void)viewDidDisappear:(BOOL)animated
{
    printf("\r\n+[%s]----\r\n",__FUNCTION__);
}


-(void)viewWillAppear:(BOOL)animated
{
    printf("\r\n+[%s]----\r\n",__FUNCTION__);
}

-(void) viewDidAppear:(BOOL)animated
{
   printf("\r\n[+%s]----\r\n",__FUNCTION__);
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
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, self.view.frame.size.width,self.view.frame.size.height - ZY_HEADVIEW_HEIGHT )];
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
    _cellCount = 3;
    [self.view addSubview:_mainTableView];
    
}

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
    
    
    [self setOptionCell:cell andTitleLabels:CELL_TITLE(indexPath.section,indexPath.row)];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if(indexPath.row>=2)
    {
        
        UIButton *btn3 = [[UIButton alloc ]initWithFrame:CGRectMake(cell.frame.size.width - 20 -10, 0, 20  , cell.frame.size.height)];
        
        btn3.imageView.contentMode = UIViewContentModeCenter;
        [btn3 setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
        [cell addSubview:btn3];
        
        UILabel *userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 150,  cell.frame.size.height)];
        
        userNameLab.text = tasklimitName;
        userNameLab.textAlignment = NSTextAlignmentLeft;
        userNameLab.font = [UIFont systemFontOfSize:14];
        [cell addSubview:userNameLab];
        return cell;
    }
    if(selectCellState[indexPath.row] == YES)
    {
        UIImageView *imgSelect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
        imgSelect.frame = CGRectMake(cell.frame.size.width - 40 -10, 0, 40, cell.frame.size.height);
        imgSelect.contentMode = UIViewContentModeCenter;
        [cell addSubview:imgSelect];
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
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    memset(selectCellState, NO, sizeof(selectCellState));
    if(indexPath.row<2)
    {
        selectCellState[indexPath.row] = YES;
        [_mainTableView reloadData];
    }
    else
    {
        SelectContacterViewController *selectContacterViewCtl = [[SelectContacterViewController alloc] init];
        selectContacterViewCtl.navTitle = @"选择好友";
        selectContacterViewCtl.pageChangeMode = Mode_dis;
        selectContacterViewCtl.delegate = self;
        [self presentViewController:selectContacterViewCtl animated:YES completion:^{}];
    }
    
    

}
#pragma mark - 选择好友代理
-(void)setContacterInfo:(NSArray *)selectContacterArrayID andName:(NSArray *)selectContacterArrayName
{
    
    if(selectContacterArrayID!=nil)
    {
        NSString *str = @"";
        for (int i = 0; i < selectContacterArrayID.count; i++) {
            str = [NSString stringWithFormat:@"%@ %@",str,[selectContacterArrayID objectAtIndex:i]];
        }
        
        tasklimitID = str;
        NSLog(@"tasklimitID = [%@]",tasklimitID);
    }
    if(selectContacterArrayName!=nil)
    {
        NSString *str = @"";
        for (int i = 0; i < selectContacterArrayName.count; i++) {
            str = [NSString stringWithFormat:@"%@ %@",str,[selectContacterArrayName objectAtIndex:i]];
        }
        
        tasklimitName = str;
        NSLog(@"tasklimitName = [%@]",tasklimitName);
        [_mainTableView reloadData];

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




-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSUInteger row = [indexPath row];
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    if(section == 0)
    {
        tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(20,0 , 150, 30);
        titleLabel.text = @"权限选择";
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor  = ZY_UIBASECOLOR;
        [tempView addSubview:titleLabel];
    }
    
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

    return 30;
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
