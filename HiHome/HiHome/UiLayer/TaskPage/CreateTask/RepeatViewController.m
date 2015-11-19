//
//  RepeatViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "RepeatViewController.h"
#import "UIDefine.h"


#define YEAR_INDEX       0
#define MONTH_INDEX       1
#define DAY_INDEX       2
#define HOUR_INDEX       3
#define MIN_INDEX       4
#define WEEK_INDEX       5

@interface RepeatViewController ()
{
    NSMutableArray *_arrayBtn;
    BOOL _defaultFlag;
    NSArray *repeatMode;
    
    NSString * repeat;
    NSString * repeatName;
}
@end

@implementation RepeatViewController

-(id)init
{
    
    self = [super init];
    if (self) {
     _dateArr = [NSMutableArray array];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _defaultFlag = true;
    _arrayBtn = [NSMutableArray array];
    _btnWidth = ([UIScreen mainScreen].bounds.size.width-10)/4;
    self.view.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    [self initViews];
    [self setDefault];
    // Do any additional setup after loading the view from its nib.
}
-(void) setDateArr:(NSMutableArray *)dateArr
{
    [_dateArr removeAllObjects];
    for (int i = 0; i<dateArr.count; i++) {
        [_dateArr addObject:[dateArr objectAtIndex:i]];
    }
    
    
    
    NSLog(@"date : %@",[NSString stringWithFormat:@"%@-%@-%@  %@:%@  %@",[_dateArr objectAtIndex:0] ,[_dateArr objectAtIndex:1] ,[_dateArr objectAtIndex:2] ,[_dateArr objectAtIndex:3] ,[_dateArr objectAtIndex:4] ,[_dateArr objectAtIndex:5] ]
          );
}



-(void) initViews
{
    [self.mBtnRight setTitle:@"完成" forState:UIControlStateNormal];
    
    repeatMode = @[@"不重复",@"每天",@"每周",@"每月",@"每年"];
    NSInteger rownum  = 0;
    for (int i = 0; i<repeatMode.count; i++) {
        // if(rownum)
        rownum = i/4;
        
        //        UIButtonTypeSystem NS_ENUM_AVAILABLE_IOS(7_0),  // standard system button
        //
        //        UIButtonTypeDetailDisclosure,
        //        UIButtonTypeInfoLight,
        //        UIButtonTypeInfoDark,
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =  CGRectMake( 10+(i%4)*_btnWidth, ZY_HEADVIEW_HEIGHT + rownum*_btnWidth+10, _btnWidth-10, _btnWidth-10);
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = [[UIColor grayColor] CGColor];
        //     btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor whiteColor];
        btn.alpha = 0.5;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.tag = ZY_UIBUTTON_TAG_BASE + i;
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [btn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:[repeatMode objectAtIndex:i] forState:UIControlStateNormal];
        [_arrayBtn addObject:btn];
        [self.view addSubview:btn];
    }
    
    
//    UIButton *finishBtn = [[UIButton alloc] init];
//    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
//    finishBtn.frame = CGRectMake(self.view.frame.size.width-ZY_VIEWHEIGHT_IN_HEADVIEW-10, 20, ZY_VIEWHEIGHT_IN_HEADVIEW, ZY_VIEWHEIGHT_IN_HEADVIEW);
//    finishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//    [self->_tableHeaderView addSubview:finishBtn];
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT + (rownum+1)*_btnWidth+10+20, self.view.frame.size.width, 60)];
    customView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:customView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, customView.frame.size.height, customView.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"repeat_2"];
    imgView.contentMode = UIViewContentModeCenter;
    [customView addSubview:imgView];
    
    _textLab = [[UILabel alloc] initWithFrame:CGRectMake(customView.frame.size.height, 0, SCREEN_WIDTH - customView.frame.size.height, customView.frame.size.height)];
    _textLab.textAlignment = NSTextAlignmentCenter;
    _repeatTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(customView.frame.size.height + 100, 0, 150, customView.frame.size.height)];
    _repeatTimeLab.textAlignment = NSTextAlignmentLeft;
    _repeatTimeLab.font = [UIFont systemFontOfSize:14];
    _textLab.font = [UIFont systemFontOfSize:14];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,customView.frame.size.height, self.view.frame.size.width, 1)];
//    lineView.backgroundColor = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
//    
//    [customView addSubview:lineView];
    //阴影设置
//    customView.layer.shadowOffset=CGSizeMake(1, 1);
//    customView.layer.shadowOpacity=.9;
//    customView.layer.borderWidth = 1.0;
//    customView.layer.borderColor = [[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0] CGColor];
//    customView.layer.shadowColor = [[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0] CGColor];
    
    [customView addSubview:_textLab];
 //   [customView addSubview:_repeatTimeLab];
}

-(void) setDefault
{
    UIButton *tempBtn;
 
    if(_defaultFlag != true)
        return;
    if(_arrayBtn.count>0)//不重复
       tempBtn = [_arrayBtn objectAtIndex:0];
    
    tempBtn.selected = YES;
    tempBtn.backgroundColor = [UIColor blueColor];
    _textLab.text =tempBtn.titleLabel.text;
    _defaultFlag = false;
}

-(void) clickBtns:(UIButton *)sender
{
    UIButton *tempBtn;
    NSString  *str;
    NSString *startDate = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",[_dateArr objectAtIndex:0] ,[_dateArr objectAtIndex:1] ,[_dateArr objectAtIndex:2] ,[_dateArr objectAtIndex:3] ,[_dateArr objectAtIndex:4] ];
    
    
    
    for(int i =0;i <_arrayBtn.count;i++)
    {
        tempBtn = [_arrayBtn objectAtIndex:i];
        tempBtn.selected = NO;
        tempBtn.backgroundColor = [UIColor whiteColor];
//        if(sender.tag ==i)
//            tempBtn.selected = YES;
//        else
        
    }
    sender.selected = YES;
    sender.backgroundColor = [UIColor blueColor];

    
    if([sender.titleLabel.text isEqualToString:@"不重复"])
    {
         _repeatTimeLab.text = @"  ";
    }
    else if([sender.titleLabel.text isEqualToString:@"每天"])
    {
      //  str = [NSString stringWithFormat:@"%@:%@重复",[_dateArr objectAtIndex:HOUR_INDEX],[_dateArr objectAtIndex:MIN_INDEX]];
        str = [NSString stringWithFormat:@"重复"];
        _repeatTimeLab.text = str;
    }
    else if([sender.titleLabel.text isEqualToString:@"每周"])
    {
        str = [NSString stringWithFormat:@"%@重复",[_dateArr objectAtIndex:WEEK_INDEX]];
        _repeatTimeLab.text = str;
    }
    else if([sender.titleLabel.text isEqualToString:@"每月"])
    {
        str = [NSString stringWithFormat:@"%@日重复",[_dateArr objectAtIndex:DAY_INDEX]];
        _repeatTimeLab.text = str;
    }
    else if([sender.titleLabel.text isEqualToString:@"每年"])
    {
        str = [NSString stringWithFormat:@"%@月%@日重复",[_dateArr objectAtIndex:MONTH_INDEX],[_dateArr objectAtIndex:DAY_INDEX]];
        _repeatTimeLab.text = str;
    }
    
//    NSLog(@"%ld%@",(long)sender.tag,sender.currentTitle);
    
    if([sender.titleLabel.text isEqualToString:@"不重复"])
    {
        _textLab.text =@"不重复";
    }
    else
    {
        _textLab.text = [NSString stringWithFormat:@"从%@起%@%@",[startDate substringToIndex:10] ,sender.titleLabel.text,str];
    }
    repeat=[NSString stringWithFormat:@"%ld",sender.tag-2315];
    repeatName=sender.currentTitle;
    
    
}

//重写退出页面方法
-(void)quitView
{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)btnRightClick:(id)sender{
    NSLog(@"repeat done");
    SEL func_selector = NSSelectorFromString(callBackFunctionName);
    if ([CallBackObject respondsToSelector:func_selector]) {
        NSDictionary * dict=[[NSDictionary alloc] initWithObjectsAndKeys:repeat,@"repeat",repeatName,@"repeatname", nil];
        [CallBackObject performSelector:func_selector withObject:dict];
        [self quitView];
    }else{
        NSLog(@"回调失败...");
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
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}

@end
