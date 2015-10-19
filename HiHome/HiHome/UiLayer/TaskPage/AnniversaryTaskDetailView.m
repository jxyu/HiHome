//
//  AnniversaryTaskDetailView.m
//  HiHome
//
//  Created by Rain on 15/10/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AnniversaryTaskDetailView.h"
#import "AnniversaryTaskCell.h"

@interface AnniversaryTaskDetailView (){
    NSString *contentTxt;
    AnniversaryTaskCell * anniversaryTask;
}

@end

@implementation AnniversaryTaskDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)initData{
    contentTxt = @"元旦，即世界多数国家通称的“新年”，是公历新一年的第一天。元，谓“首”；旦，谓“日”；“元旦”意即“首日”。“元旦”一词最早出现于《晋书》，但其含义已经沿用4000多年。[1]  中国古代曾以腊月、十月等的月首为元旦，汉武帝起为农历1月1日";
}

- (void)initView{
    
    //UIImageView
    UIImageView *mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 70, 70)];
    mImageView.image = [UIImage imageNamed:@"xueren.png"];
    mImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:mImageView];
    
    //UILabel
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(mImageView.frame.size.width + 20, 80, 50, 21)];
    name.text = @"元旦";
    [self.view addSubview:name];
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(mImageView.frame.size.width + 20, 110, 120, 21)];
    date.font = [UIFont systemFontOfSize:15];
    date.text = @"2015年10月17日";
    [self.view addSubview:date];
    
    //横线
    UILabel *henxian = [[UILabel alloc] initWithFrame:CGRectMake(0, mImageView.frame.size.height + 80, SCREEN_WIDTH, 1)];
    henxian.backgroundColor = [UIColor colorWithRed:0.95 green:0.52 blue:0.09 alpha:1];
    [self.view addSubview:henxian];
    
    //UITextView
    CGSize mSize = [contentTxt sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH, 2500) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"高度%f",mSize.height);
    UITextView *mTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, mImageView.frame.size.height + 91, SCREEN_WIDTH - 20, mSize.height + 10)];
    mTextView.font = [UIFont systemFontOfSize:15];
    mTextView.editable = NO;
    mTextView.text = contentTxt;
    [self.view addSubview:mTextView];
    
    //UIImageView
    NSLog(@"%f",mTextView.frame.size.height);
    UIImageView *mShowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, mTextView.frame.size.height + 171, SCREEN_WIDTH, 200)];
    mShowImageView.image = [UIImage imageNamed:@"jinianri_img.png"];
    [self.view addSubview:mShowImageView];
}

-(void)quitView{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}

@end
