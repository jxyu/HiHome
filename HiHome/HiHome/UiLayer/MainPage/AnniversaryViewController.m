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

@interface AnniversaryViewController ()

@end

@implementation AnniversaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeight = self.view.frame.size.height/11;
    
    [self initViews];
    // Do any additional setup after loading the view.
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
    _cellCount = 3;
    [self.view addSubview:_mainTableView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    
//    switch (section) {
//        case 0:
//            return  1;
//            break;
//        case 1:
//            return _mateCellCount;
//            break;
//        case 2:
//            return _starFriendCellCount;
//            break;
//        case 3:
//            return _normalFriendcellCount;
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
    switch (indexPath.row) {
        case 0:
            [self setAnniversaryCell:cell andBtnImg:@"me" andTitleLabels:@"元旦" andDateLabel:@"2016年1月1日"];
            break;
        case 1:
            [self setAnniversaryCell:cell andBtnImg:@"me" andTitleLabels:@"小寒" andDateLabel:@"2016年1月6日"];
            break;
        case 2:
            [self setAnniversaryCell:cell andBtnImg:@"me" andTitleLabels:@"腊八" andDateLabel:@"2016年1月17日"];
            break;
        default:
            break;
    }
    
     if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
     {
         [cell setSeparatorInset:UIEdgeInsetsZero];
         [cell setLayoutMargins:UIEdgeInsetsZero];
     }
    return cell;
    
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
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, _cellHeight-10, _cellHeight-10)];
        [titleBtn setImage:[[UIImage imageNamed:imgName] getRoundImage] forState:UIControlStateNormal];
        [Btns addObject:titleBtn];
    }
    if(title != nil)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame =CGRectMake((_cellHeight-10)+10+20+20/*图片直径＋左＋右＋文字左*/, _cellHeight/2-30+7, 150, 30);
        titleLabel.text =title;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = ZY_UIBASECOLOR;//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
        [Labels addObject:titleLabel];

    }
    if(date != nil)
    {
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.frame =CGRectMake((_cellHeight-10)+10+20+20, _cellHeight/2+5, 150, _cellHeight/2-5);
        dateLabel.text = date;
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
    
    NSUInteger row = [indexPath row];
    
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
