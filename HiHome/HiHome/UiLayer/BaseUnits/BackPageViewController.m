//
//  BackPageViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/6.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "UIDefine.h"

@interface BackPageViewController ()

@end

@implementation BackPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, ([[UIScreen mainScreen] bounds].size.width - 100*2), ZY_VIEWHEIGHT_IN_HEADVIEW)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.text =self.navTitle;
   // self.label.text = self.navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self headerView]];
    // Do any additional setup after loading the view.
}

-(void) setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    
    _titleLabel.text = navTitle;
}


-(void)setContentHeadView:(NSMutableArray *)contentHeadView
{
    if(_contentHeadView == nil)
    {
        _contentHeadView = [[NSMutableArray alloc]initWithArray:contentHeadView];
    }
    NSMutableArray *tempArray = _contentHeadView;
    
    //移除之前的控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [(UIButton *)[tempArray objectAtIndex:i] removeFromSuperview];
    }
    //清空数组
    [tempArray removeAllObjects];
    //重新赋值
    for (int i = 0;i<_contentHeadView.count ; i++) {
        [tempArray addObject:[_contentHeadView objectAtIndex:i]];
    }
    //添加控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [_tableHeaderView addSubview:[tempArray objectAtIndex:i]];
    }
    
}


-(UIView *)headerView
{
    _tableHeaderView = [[UIView alloc] init];
    _tableHeaderView.backgroundColor = ZY_UIBASECOLOR;
    _tableHeaderView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, ZY_HEADVIEW_HEIGHT);
    
     // titleLabel.text = self.navTitle;
  
  

    [_tableHeaderView addSubview:_titleLabel];

  //  _titleLabel.backgroundColor = [UIColor blueColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 20, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    [backBtn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeCenter;
    [backBtn addTarget:self action:@selector(backMainPage:) forControlEvents:UIControlEventTouchUpInside];                            
    
    _tableHeaderView.contentMode = UIViewContentModeCenter;

    [_tableHeaderView addSubview:backBtn];
    
    //创建右边按钮
    _mBtnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 20, 50, ZY_VIEWHEIGHT_IN_HEADVIEW)];
    _mBtnRight.imageView.contentMode = UIViewContentModeCenter;
    [_mBtnRight addTarget:self action:@selector(btnRightClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tableHeaderView addSubview:_mBtnRight];
    
    return _tableHeaderView;
}


-(void)quitView
{
    [self dismissViewControllerAnimated:NO completion:^{}];

}

-(void)backMainPage:(id)sender
{
//    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
//    {
//        [self popoverPresentationController];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self quitView];
}

-(void)btnRightClick:(id)sender{
    NSLog(@"click right button");
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
