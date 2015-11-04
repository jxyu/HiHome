//
//  SelectLimitViewController.m
//  HiHome
//
//  Created by 王建成 on 15/11/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SelectLimitViewController.h"
#import "TempCustomButton.h"

@interface SelectLimitViewController ()
{
    NSMutableArray *btnArr;
    NSMutableDictionary *limitUserInfo;
    PermissionMode permissionMode;
    UILabel *textLab;
}
@end

@implementation SelectLimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    limitUserInfo = [NSMutableDictionary dictionary];
    self.navTitle = @"谁能看见";
    self.mBtnRight.hidden = NO;
    [self.mBtnRight setTitle:@"完成" forState:UIControlStateNormal];
    self.view.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    
    btnArr = [NSMutableArray array];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, ZY_HEADVIEW_HEIGHT+20, SCREEN_WIDTH - 20, 44)];
    view1.backgroundColor = [UIColor whiteColor];

    view1.layer.masksToBounds=YES;
    view1.layer.borderWidth=0.5;
    view1.layer.borderColor=[UIColor grayColor].CGColor;
    
    TempCustomButton *btn1 = [[TempCustomButton alloc ]initWithFrame:CGRectMake(0, 0, view1.frame.size.width, view1.frame.size.height)];
    
    btn1.btnWidthScale = 100;
    btn1.titleWidthScale = 80;
    btn1.imgXScale = 93;
    btn1.imgWidthScale = 5;
    btn1.imageView.contentMode = UIViewContentModeCenter;
    
    [btn1 setTitle:@"   所有人" forState:UIControlStateNormal];
    [btn1 setTitleColor:ZY_UIBASE_FONT_COLOR forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = ZY_UIBUTTON_TAG_BASE +Mode_all;
    [view1 addSubview:btn1];
    [btn1 setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [btnArr addObject:btn1];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, ZY_HEADVIEW_HEIGHT+20+44, SCREEN_WIDTH - 20, 44)];
    
    view2.layer.masksToBounds=YES;
    view2.layer.borderWidth=0.5;
    view2.layer.borderColor=[UIColor grayColor].CGColor;
    view2.backgroundColor = [UIColor whiteColor];
    TempCustomButton *btn2 = [[TempCustomButton alloc ]initWithFrame:CGRectMake(0, 0, view2.frame.size.width, view2.frame.size.height)];
    
    btn2.btnWidthScale = 100;
    btn2.titleWidthScale = 80;
    btn2.imgXScale = 93;
    btn2.imgWidthScale = 5;
    btn2.imageView.contentMode = UIViewContentModeCenter;
    
    
    [btn2 setTitle:@"   自己" forState:UIControlStateNormal];
    [btn2 setTitleColor:ZY_UIBASE_FONT_COLOR forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn2 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    btn2.tag = ZY_UIBUTTON_TAG_BASE +Mode_mine;
    [view2 addSubview:btn2];
    [btnArr addObject:btn2];
    [self.view addSubview:view2];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10, ZY_HEADVIEW_HEIGHT+20+44*2, SCREEN_WIDTH - 20, 44)];
    view3.backgroundColor = [UIColor whiteColor];
    
    view3.layer.masksToBounds=YES;
    view3.layer.borderWidth=0.5;
    view3.layer.borderColor=[UIColor grayColor].CGColor;
    TempCustomButton *btn3 = [[TempCustomButton alloc ]initWithFrame:CGRectMake(0, 0, view3.frame.size.width, view3.frame.size.height)];
    btn3.btnWidthScale = 100;
    btn3.titleWidthScale = 80;
    btn3.imgXScale = 93;
    btn3.imgWidthScale = 5;
    btn3.imageView.contentMode = UIViewContentModeCenter;
    btn3.tag = ZY_UIBUTTON_TAG_BASE +Mode_friends;
    [btn3 setTitle:@"   指定好友" forState:UIControlStateNormal];
    [btn3 setTitleColor:ZY_UIBASE_FONT_COLOR forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btn3 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    textLab = [[UILabel alloc] initWithFrame:CGRectMake(btn3.frame.size.width/4, 0, btn3.frame.size.width/4*3 - 30, btn3.frame.size.height)];
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.textAlignment = NSTextAlignmentLeft;
    [btn3 addSubview:textLab];
    [view3 addSubview:btn3];
    [btnArr addObject:btn3];
    [self.view addSubview:view3];
    
    // Do any additional setup after loading the view.
}
-(void) selectBtn:(UIButton*)sender
{
    sender.selected = YES;
    
    permissionMode = (PermissionMode)(sender.tag - ZY_UIBUTTON_TAG_BASE);
    
    [limitUserInfo setObject:[NSString stringWithFormat:@"%d",permissionMode] forKey:@"mode"];
    
    for(int i = 0;i<btnArr.count ;i++)
    {
        UIButton *tempBtn = [btnArr objectAtIndex:i];
        if(tempBtn.tag == sender.tag)
            continue;
        tempBtn.selected = NO;
    }
    if(sender.tag == ZY_UIBUTTON_TAG_BASE + 2)
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
        [limitUserInfo setObject:selectContacterArrayID forKey:@"userID"];
    if(selectContacterArrayName!=nil)
    {
        NSString *str = @"";
        for (int i = 0; i < selectContacterArrayName.count; i++) {
            str = [NSString stringWithFormat:@"%@ %@",str,[selectContacterArrayName objectAtIndex:i]];
        }
        textLab.text = str;
        
        [limitUserInfo setObject:selectContacterArrayName forKey:@"userName"];
    }
}

-(void)quitView
{
    
    if([self.delegate respondsToSelector:@selector(setLimitDict:)])
    {
        if(limitUserInfo != nil)
            [self.delegate setLimitDict:limitUserInfo];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{}];
    
}

-(void)btnRightClick:(id)sender
{
    [self quitView];
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
