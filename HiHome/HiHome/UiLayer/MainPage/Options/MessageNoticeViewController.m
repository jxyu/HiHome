//
//  MessageNoticeViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MessageNoticeViewController.h"
#import "UIDefine.h"
#import "BaseTableViewCell.h"


#define CELL_TITLE(section,row)     ([(NSArray *)[(NSArray *)[_cellInfo objectAtIndex:section] objectAtIndex:row] objectAtIndex:0])

@interface MessageNoticeViewController ()

@end

@implementation MessageNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellInfo = [[NSMutableArray alloc] initWithArray: @[@[/*第0个section*/
                                                             /*最右侧图标，标题，内容*/
                                                             @[@"消息推送"],
                                                             @[@"通知时指示灯闪烁开关"],
                                                             @[@"任务接受开关"],
                                                             ],
                                                         
                                                         ]];
    
    _cellHeight = self.view.frame.size.height/11;
    [self initViews];
    // Do any additional setup after loading the view from its nib.
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
  //  [self.view addSubview:_mainTableView];
    self.view.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    UILabel *messageLab = [[UILabel alloc]initWithFrame:CGRectMake(10, ZY_HEADVIEW_HEIGHT, SCREEN_WIDTH-20 , 100)];
    messageLab.text = @"如果您要关闭或开启HiHome的通知功能，请在iphone的\"设置\"－\"通知中心\"功能中，找到应用程序\"HiHome\"更改";
    messageLab.numberOfLines = 0;
    messageLab.textAlignment = NSTextAlignmentNatural;
    messageLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:messageLab];
    
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
    
    NSInteger switchTag ;
    switchTag = ZY_UISWITCH_TAG_BASE + indexPath.section*10+indexPath.row;
    
    
    [self setOptionCell:cell andTitleLabels:CELL_TITLE(indexPath.section,indexPath.row) andOtherViews:switchTag];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}

-(void)setOptionCell:(BaseTableViewCell *)cell andTitleLabels:(NSString *)title andOtherViews:(NSInteger)switchTag
{
    NSMutableArray *Labels = [NSMutableArray array];
    NSMutableArray *OtherViews = [NSMutableArray array];
    
    
    if([title isEqualToString:@"nil"])
    {
        title = nil;
    }
    if(title != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame =CGRectMake(20, _cellHeight/3 , 200, _cellHeight/3);
        titleLabel.text =title;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        //     titleLabel.textColor = ZY_UIBASECOLOR;//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
        titleLabel.textColor = [UIColor grayColor];
        [Labels addObject:titleLabel];
    }
    
    if(switchTag!=0)
    {
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(20+50), _cellHeight/3, 50, _cellHeight/3)];
        switchBtn.tag = switchTag;
        [OtherViews addObject:switchBtn];
    }
    
    if(cell != nil)
    {
        if (Labels.count != 0) {
            cell.contentLabels = Labels;
        }
        if (OtherViews.count != 0) {
            cell.contentOtherViews = OtherViews;
        }
        
    }
}



//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,indexPath.row);
    
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
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,indexPath.row);
    
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
