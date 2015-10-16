//
//  OptionTextViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "OptionTextViewController.h"

@interface OptionTextViewController ()

@end

@implementation OptionTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    _tempViewCtl = [[TextViewController alloc] init];
    UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    tempBtn.backgroundColor = [UIColor blueColor];
    [tempBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempBtn];
    // Do any additional setup after loading the view.
}

-(void)clickBtn
{
 //   [self.navigationController pushViewController:_tempViewCtl animated:YES];
    //presentViewController:animated:completion
    [self presentViewController:_tempViewCtl animated:YES completion:^{}];
    
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
