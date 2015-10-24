//
//  HelpAndFeedbackViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "HelpAndFeedbackViewController.h"
#import "UIDefine.h"
#import "BaseTableViewCell.h"


@interface HelpAndFeedbackViewController ()

@end

@implementation HelpAndFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellHeight = 50;//self.view.frame.size.height/11;
    _keyShow = false;
    [self initViews];
    
    //添加键盘的监听事件
    
//    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    
//    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}


// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    _keyShow = true;
    [keyboardObject getValue:&keyboardRect];
    
    
    _keyHeight = keyboardRect.size.height;
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:0.5];
   //               CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-kViewHeight, 320, kViewHeight)]
    //设置view的frame，往上平移
    [_mainTableView setFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, self.view.frame.size.width,self.view.frame.size.height -ZY_HEADVIEW_HEIGHT -keyboardRect.size.height)];
    _cellTextViewHeight = _mainTableView.frame.size.height - 2*_cellHeight;
    //[_mainTableView reloadData];
    [UIView commitAnimations];
    
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _keyShow = false;
    //设置view的frame，往下平移
    [_mainTableView setFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, self.view.frame.size.width,self.view.frame.size.height - ZY_HEADVIEW_HEIGHT)];
    _cellTextViewHeight = _mainTableView.frame.size.height - 2*_cellHeight;
    //[_mainTableView reloadData];
    [UIView commitAnimations];
    
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
    _cellCount = 3;
    _cellTextViewHeight = SCREEN_HEIGHT - 2*_cellHeight - 64;
    
    _keyHeight = 216;//default
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    
    _titleField = [[UITextField alloc]init];
    
    _textView = [[UITextView alloc] init];
 //   _textView.text = @"发帖内容";
    
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(self.view.frame.size.width-ZY_VIEWHEIGHT_IN_HEADVIEW-10, 20, ZY_VIEWHEIGHT_IN_HEADVIEW, ZY_VIEWHEIGHT_IN_HEADVIEW);
    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self->_tableHeaderView addSubview:sendBtn];
    
    [self.view addSubview:_mainTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


-(void)tapViewAction:(id)sender
{
    NSLog(@"tap view---");
    
    if(_keyShow == true)
    {
        _keyShow = false;
        [_textView resignFirstResponder];//关闭textview的键盘
        [_titleField resignFirstResponder];//关闭titleField的键盘
        [self setViewMove];
        
    }
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
#pragma mark -textField
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//
//    if(!_keyShow)
//    {
//        _keyShow =true;
//        [self setViewMove];
//    }
//}
//
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
        if(!_keyShow)
        {
            _keyShow =true;
            [self setViewMove];
        }
    
    return YES;
}

#pragma mark - TextView
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(!_keyShow)
    {
        _keyShow =true;
        [self setViewMove];
    }
    return YES;
}

//根据键盘是否出现调整高度
-(void)setViewMove
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    
    CGRect rect = _mainTableView.frame;
    
    if(_keyShow)
    {
        NSLog(@"move up");
        rect.size.height = self.view.frame.size.height -ZY_HEADVIEW_HEIGHT -_keyHeight;
        _mainTableView.frame = rect;
        
    }
    else{
        NSLog(@"move down");
        rect.size.height = self.view.frame.size.height -ZY_HEADVIEW_HEIGHT;
        _mainTableView.frame = rect;
    }
    _cellTextViewHeight = _mainTableView.frame.size.height - 2*_cellHeight;
    [_mainTableView reloadData];
    [UIView commitAnimations];
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
    
    switch (indexPath.row) {
        case 0:
        {
            _titleField.frame = CGRectMake(10, 0, cell.frame.size.width, _cellHeight);
            _titleField.placeholder = @"标题";
            _titleField.delegate = self;
            [cell addSubview:_titleField];

        }
            break;
        case 1:
        {
            _textView.frame = CGRectMake(10, 0, cell.frame.size.width, _mainTableView.frame.size.height - 2*_cellHeight);
            _textView.font = [UIFont systemFontOfSize:15];
            _textView.delegate = self;
            _textView.returnKeyType = UIReturnKeyDefault;
            _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
            [cell addSubview:_textView];
        }
            break;
        case 2:
        {
            UIButton *picBtns = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height)];
            [picBtns setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
            
            UIButton *photoBtns = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.height, 0, cell.frame.size.height, cell.frame.size.height)];
            [photoBtns setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
            
            UIButton *otherBtns = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width - cell.frame.size.height, 0, cell.frame.size.height, cell.frame.size.height)];
            [otherBtns setImage:[UIImage imageNamed:@"other"] forState:UIControlStateNormal];
            
            [cell addSubview:picBtns];
            [cell addSubview:photoBtns];
            [cell addSubview:otherBtns];
        }
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



//-(void)setOptionCell:(BaseTableViewCell *)cell andTitleLabels:(NSString *)title
//{
//    NSMutableArray *Labels = [NSMutableArray array];
//    
//    if([title isEqualToString:@"nil"])
//    {
//        title = nil;
//    }
//    if(title != nil)
//    {
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.frame =CGRectMake(20, _cellHeight/3 , 200, _cellHeight/3);
//        titleLabel.text =title;
//        titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//        
//        //     titleLabel.textColor = ZY_UIBASECOLOR;//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
//        titleLabel.textColor = [UIColor grayColor];
//        [Labels addObject:titleLabel];
//    }
//    
//    if(cell != nil && Labels.count>0)
//    {
//        cell.contentLabels = Labels;
//    }
//}
//
//
//
//-(void)setOptionCell:(BaseTableViewCell *)cell andTitleField:(NSString *)title andFieldTag:(NSInteger)fieldtag
//{
//    
//    NSMutableArray *Others = [NSMutableArray array];
//    
//    if([title isEqualToString:@"nil"])
//    {
//        title = nil;
//    }
//    
//    if(title != nil)
//    {
//        CGFloat fieldHeight = _cellHeight;
//        
//        if(fieldtag == ZY_UIFIELD_TAG_BASE + 1)
//            fieldHeight = _mainTableView.frame.size.height - 2*_cellHeight;
//        
//        UITextField *cellField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, fieldHeight)];
//        cellField.placeholder = title;
//     //   cellField.backgroundColor = [UIColor blueColor];
//        
//        [Others addObject:cellField];
//    
//    }
//    
//    if(cell != nil && Others.count>0)
//    {
//        cell.contentOtherViews = Others;
//    }
//    
//}



//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%f-%f",SCREEN_HEIGHT,self.view.frame.size.height);
    if(indexPath.row==1)
        return _cellTextViewHeight;
    return _cellHeight;
    
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
