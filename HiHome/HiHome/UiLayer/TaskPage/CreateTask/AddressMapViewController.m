//
//  AddressMapViewController.m
//  HiHome
//
//  Created by Rain on 15/10/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AddressMapViewController.h"
#import <MAMapKit/MAPointAnnotation.h>

@interface AddressMapViewController (){
    MAPointAnnotation *pointAnnotation;
    CGFloat _lat;
    CGFloat _long;
    NSString * address;
}

@end

@implementation AddressMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)quitView{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
