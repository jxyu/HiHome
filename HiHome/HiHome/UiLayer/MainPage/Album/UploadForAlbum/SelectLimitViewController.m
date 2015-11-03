//
//  SelectLimitViewController.m
//  HiHome
//
//  Created by 王建成 on 15/11/3.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SelectLimitViewController.h"

@interface SelectLimitViewController ()

@end

@implementation SelectLimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, ZY_HEADVIEW_HEIGHT+10, SCREEN_WIDTH - 20, 44)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, ZY_HEADVIEW_HEIGHT+10+44, SCREEN_WIDTH - 20, 44)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10, ZY_HEADVIEW_HEIGHT+10+44*2, SCREEN_WIDTH - 20, 44)];
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
    
    
    // Do any additional setup after loading the view.
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
