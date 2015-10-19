//
//  MainPageViewController.m
//  HiHome
//
//  Created by 王建成 on 15/9/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MainPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIDefine.h"

@interface MainPageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MainPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];

     // Do any additional setup after loading the view from its nib.

}

-(void) initViews
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT +50 )];
//    _mainTableView.backgroundColor =[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    UIView *tableHeaderView = [[UIView alloc] init];
    tableHeaderView.backgroundColor = ZY_UIBASECOLOR;
    tableHeaderView.frame = CGRectMake(0, 0, 10, 20);
    _mainTableView.tableHeaderView = tableHeaderView;
    
    
 //   _mainTableView.scrollEnabled  = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabelForTimer) userInfo:nil repeats:YES];
    [self.view addSubview:_mainTableView];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






//
////设置每个section显示的Title
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    return @"";
//    
//}

//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}






//
//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSMutableArray *Label_Views = [NSMutableArray array];
    NSMutableArray *Img_Views = [NSMutableArray array];
    
    cell.backgroundColor = [UIColor whiteColor];
    switch (indexPath.section) {
        case 0:
        {
            Img_Views = [self addImgViewsForCell0];
            Label_Views = [self addLabelViewsForCell0];
            break;
        }
        case 1:
        {
            Img_Views = [self addImgViewsForCell1];
            Label_Views = [self addLabelViewsForCell1];
            break;
        }
        case 2:
        {
            Img_Views = [self addImgViewsForCell2];
            Label_Views = [self addLabelViewsForCell2];
            break;
        }
        case 3:
        {
            Img_Views = [self addImgViewsForCell3];
            Label_Views = [self addLabelViewsForCell3];
            break;
        }
        case 4:
        {
            Img_Views = [self addImgViewsForCell4];
            Label_Views = [self addLabelViewsForCell4];
            break;
        }
        default:
            break;
    }
    
    if(Img_Views != Nil)
    {
        for(int i = 0;i < [Img_Views count];i++)
        {
            [cell addSubview:[Img_Views objectAtIndex:i]];
        }
    }
    if(Label_Views != nil)
    {
        for(int i = 0;i < [Label_Views count];i++)
        {
            [cell addSubview:[Label_Views objectAtIndex:i]];
        }
    }
    return cell;
    
}


//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return ZY_MAINCELL0_HEIGHT;
        case 1:
            return ZY_MAINCELL1_HEIGHT;
        case 2:
            return ZY_MAINCELL2_HEIGHT;
        case 3:
            return ZY_MAINCELL3_HEIGHT;
        case 4:
            return ZY_MAINCELL4_HEIGHT;
        default:
            break;
    }
    return 0;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIScrollView *tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 0, 100, 100)];
    //  tempView.backgroundColor = [UIColor redColor];
    
    //    if(indexPath.section == 0)
    //        cell.backgroundView =_recommendImg;
    //    else
    

    cell.backgroundView = tempView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
      [tableView deselectRowAtIndexPath:indexPath animated:NO];//选中后的反显颜色即刻消失
    
}


//-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath


//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    
    return indexPath;
    
}

//第0个cell添加views
-(NSMutableArray *) addImgViewsForCell0
{
    NSMutableArray *imgViews = [NSMutableArray array];
    return imgViews;
}


-(void)updateLabelForTimer {
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
    
    
    @try {
        NSDateComponents *dd = [cal components:unitFlags fromDate:now];
        
        //        NSInteger y = [dd year];
        NSInteger m = [dd month];
        NSInteger d = [dd day];
        
        NSInteger hour = [dd hour];
        NSInteger min = [dd minute];
        //  NSInteger sec = [dd second];
        NSInteger week = [dd weekday];
        NSInteger week2 = [dd weekdayOrdinal];
        NSString *weekStr;
        switch (week) {
            case 1:
                weekStr = @"星期日";
                break;
            case 2:
                weekStr = @"星期一";
                break;
            case 3:
                weekStr = @"星期二";
                break;
            case 4:
                weekStr = @"星期三";
                break;
            case 5:
                weekStr = @"星期四";
                break;
            case 6:
                weekStr = @"星期五";
                break;
            case 7:
                weekStr = @"星期六";
                break;
                
            default:
                break;
        }
        
        _dateLabel.text = [NSString stringWithFormat:@"%2ld月%2ld日(%@)",m,d,weekStr];
        _timeLabel.text =[NSString stringWithFormat:@"%02ld:%02ld",hour,min];
        
    }
    @catch (NSException *exception) {
        return ;
    }
    @finally {
        
    }
    
}


-(NSMutableArray *) addLabelViewsForCell0
{
    NSMutableArray *LabelViews = [NSMutableArray array];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100-20, 10, 100, ZY_MAINCELL0_HEIGHT/10*3)];
    _timeLabel.textColor = ZY_UIBASECOLOR;
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    //  _timeLabel.font = [UIFont systemFontOfSize:30 weight:5];
    _timeLabel.font = [UIFont boldSystemFontOfSize:34];
    //    _timeLabel.font  =[UIFont fontWithName:@"Impact" size:(36.0)];//直接调用系统字体
    
    
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100-20, ZY_MAINCELL0_HEIGHT/10*3+10, 100, ZY_MAINCELL0_HEIGHT/10*2)];
    _dateLabel.textColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.font = [UIFont boldSystemFontOfSize:12];
    
    [LabelViews addObject:_timeLabel];
    [LabelViews addObject:_dateLabel];
    return LabelViews;
}


//第1个cell添加views


-(NSMutableArray *) addImgViewsForCell1
{
    NSMutableArray *imgViews = [NSMutableArray array];
    
    UIImageView *backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, _mainTableView.frame.size.width-20*2, ZY_MAINCELL1_HEIGHT/10*4)];
    backgroundImg.image = [UIImage imageNamed:@"HelloHome"];
    backgroundImg.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeCenter
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake((_mainTableView.frame.size.width-20*2)/3+20, 10, (_mainTableView.frame.size.width-20*2)/3, ZY_MAINCELL1_HEIGHT/10*6)];
    headImg.image = [UIImage imageNamed:@"headwoman"];
    headImg.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, ZY_MAINCELL1_HEIGHT/10*7, ZY_MAINCELL1_HEIGHT/10*2, ZY_MAINCELL1_HEIGHT/10*2)];
    logoImg.image = [UIImage imageNamed:@"bugle"];
    logoImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [imgViews addObject:backgroundImg];
    [imgViews addObject:headImg];
    [imgViews addObject:logoImg];
    return imgViews;
}

-(NSMutableArray *) addLabelViewsForCell1
{
    NSMutableArray *LabelViews = [NSMutableArray array];
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, ZY_MAINCELL1_HEIGHT/10*6, 80, ZY_MAINCELL1_HEIGHT/10*2)];
    mainLabel.textColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    mainLabel.text = @"消息提醒";
    
    UILabel *detail1 = [[UILabel alloc] initWithFrame:CGRectMake(60, mainLabel.frame.size.height + mainLabel.frame.origin.y - 3, 150, 13)];
    detail1.textColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
    detail1.font = [UIFont systemFontOfSize:10];
    detail1.text = @"您有10条信息未查看";
    
    UILabel *detail2 = [[UILabel alloc] initWithFrame:CGRectMake(60, detail1.frame.size.height + detail1.frame.origin.y, 150, 13)];
    detail2.textColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
    detail2.font = [UIFont systemFontOfSize:10];
    detail2.text = @"今天19:00";
    
    [LabelViews addObject:mainLabel];
    [LabelViews addObject:detail1];
    [LabelViews addObject:detail2];
    return LabelViews;
}

//第2个cell添加views

-(NSMutableArray *) addImgViewsForCell2
{
    NSMutableArray *imgViews = [NSMutableArray array];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, ZY_MAINCELL2_HEIGHT/10*3.5, 30, 30)];
    logoImg.image = [UIImage imageNamed:@"chat"];
    logoImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [imgViews addObject:logoImg];
    
    return imgViews;
}

-(NSMutableArray *) addLabelViewsForCell2
{
    NSMutableArray *LabelViews = [NSMutableArray array];
    
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, ZY_MAINCELL2_HEIGHT/10*2, 80, ZY_MAINCELL2_HEIGHT/10*3)];
    mainLabel.textColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    mainLabel.text = @"聊天提醒";
    
    UILabel *detail1 = [[UILabel alloc] initWithFrame:CGRectMake(60, mainLabel.frame.size.height + mainLabel.frame.origin.y, 150, 13)];
    detail1.textColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
    detail1.font = [UIFont systemFontOfSize:10];
    detail1.text = @"您有10条信息未查看";
    
    UILabel *detail2 = [[UILabel alloc] initWithFrame:CGRectMake(60, detail1.frame.size.height + detail1.frame.origin.y, 150, 13)];
    detail2.textColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
    detail2.font = [UIFont systemFontOfSize:10];
    detail2.text = @"今天19:00";
    
    [LabelViews addObject:mainLabel];
    [LabelViews addObject:detail1];
    [LabelViews addObject:detail2];
    return LabelViews;
}
//第3个cell添加views
-(NSMutableArray *) addImgViewsForCell3
{
    NSMutableArray *imgViews = [NSMutableArray array];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, ZY_MAINCELL3_HEIGHT/10*3.5, 30, 30)];
    logoImg.image = [UIImage imageNamed:@"task"];
    logoImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [imgViews addObject:logoImg];
    return imgViews;
}

-(NSMutableArray *) addLabelViewsForCell3
{
    NSMutableArray *LabelViews = [NSMutableArray array];
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, ZY_MAINCELL3_HEIGHT/10*2, 80, ZY_MAINCELL3_HEIGHT/10*3)];
    mainLabel.textColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    mainLabel.text = @"任务提醒";
    
    UILabel *detail1 = [[UILabel alloc] initWithFrame:CGRectMake(60, mainLabel.frame.size.height + mainLabel.frame.origin.y, 150, 13)];
    detail1.textColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
    detail1.font = [UIFont systemFontOfSize:10];
    detail1.text = @"您有10条信息未查看";
    
    UILabel *detail2 = [[UILabel alloc] initWithFrame:CGRectMake(60, detail1.frame.size.height + detail1.frame.origin.y, 150, 13)];
    detail2.textColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
    detail2.font = [UIFont systemFontOfSize:10];
    detail2.text = @"今天19:00";
    
    [LabelViews addObject:mainLabel];
    [LabelViews addObject:detail1];
    [LabelViews addObject:detail2];
    return LabelViews;
}

//第4个cell添加views
-(NSMutableArray *) addImgViewsForCell4
{
    NSMutableArray *imgViews = [NSMutableArray array];
    
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, ZY_MAINCELL4_HEIGHT/10*2, ((self.view.frame.size.width-10*2)/100)*30, ZY_MAINCELL4_HEIGHT/10*6)];
    headImg.image = [UIImage imageNamed:@"headman"];
    headImg.contentMode = UIViewContentModeScaleAspectFit;
//    
//    CGFloat maxNum = ((self.view.frame.size.width-20)/100)*20+20>ZY_MAINCELL4_HEIGHT/10*6?((self.view.frame.size.width-20)/100)*20+20:ZY_MAINCELL4_HEIGHT/10*6;
    
    
    CGFloat maxNum = ((self.view.frame.size.width-20)/100)*20+20>ZY_MAINCELL4_HEIGHT/10*6?((self.view.frame.size.width-20)/100)*20+20:ZY_MAINCELL4_HEIGHT/10*6;
    
    UIImageView *chatImg = [[UIImageView alloc] initWithFrame:CGRectMake(maxNum+10+20,ZY_MAINCELL4_HEIGHT/10*2,((self.view.frame.size.width-20)/100)*60 , ZY_MAINCELL4_HEIGHT/10*8)];
    
    chatImg.image = [UIImage imageNamed:@"bigChat"];
    chatImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [imgViews addObject:headImg];
    [imgViews addObject:chatImg];
    return imgViews;
}

-(NSMutableArray *) addLabelViewsForCell4
{
    NSMutableArray *LabelViews = [NSMutableArray array];
    
    
    CGFloat maxNum = ((self.view.frame.size.width-20)/100)*20+20>ZY_MAINCELL4_HEIGHT/10*6?((self.view.frame.size.width-20)/100)*20+20:ZY_MAINCELL4_HEIGHT/10*6;
    
    UILabel *sayHiLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxNum+10+20+10, ZY_MAINCELL4_HEIGHT/10*2-5, ((self.view.frame.size.width-20)/100)*60-20, ZY_MAINCELL4_HEIGHT/10*8)];
    sayHiLabel.text = @"老婆今天早晨吃饭了吗？几点上班呀路上注意安全！";
    sayHiLabel.textColor =[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    sayHiLabel.font = [UIFont systemFontOfSize:12];//iphone6->14
    sayHiLabel.numberOfLines = 0;//设置行数限制为无限制
    
    sayHiLabel.transform = CGAffineTransformRotate(sayHiLabel.transform, 0.09);
    
    [LabelViews addObject:sayHiLabel];
    return LabelViews;
}



#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    switch (section) {
        case 0:
            break;
        case 1:
        {
            tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
            tempView.backgroundColor =ZY_UIBASECOLOR;//[UIColor colorWithRed:223/255.0 green:168/255.0 blue:158/255.0 alpha:1.0]
            
            break;
        }
        case 2:
        {
            tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
            tempView.backgroundColor =[UIColor colorWithRed:209/255.0 green:206/255.0 blue:205/255.0 alpha:1.0];
            
            break;
        }
        case 3:
        {
            tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
            tempView.backgroundColor =[UIColor colorWithRed:209/255.0 green:206/255.0 blue:205/255.0 alpha:1.0];
            
            break;
        }
        case 4:
        {
            tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
            tempView.backgroundColor =[UIColor colorWithRed:209/255.0 green:206/255.0 blue:205/255.0 alpha:1.0];
            
            break;
        }
        default:
            break;
    }
   
    return tempView;
}

//设置section的footer view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    tempView.backgroundColor =[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    return tempView;
    
}



//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
        case 1:
            return 1;
        case 2:
            return 10;
        case 3:
            return 10;
        case 4:
            return 10;
        default:
            break;
    }
    return 0;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 0;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return 1;
        case 4:
            return 1;
        default:
            break;
    }
    return 0;
    
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
