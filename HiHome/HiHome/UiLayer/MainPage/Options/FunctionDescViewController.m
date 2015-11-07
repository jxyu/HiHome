//
//  FunctionDescViewController.m
//  HiHome
//
//  Created by Rain on 15/11/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "FunctionDescViewController.h"
#import "DataProvider.h"
#import "GTMBase64.h"

@interface FunctionDescViewController (){
    DataProvider *mDataProvider;
    NSString *mTitle;
    NSString *mContent;
}

@end

@implementation FunctionDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

-(void)initData{
    mDataProvider = [[DataProvider alloc] init];
    [mDataProvider setDelegateObject:self setBackFunctionName:@"getFunctionDesc:"];
    [mDataProvider getFunctionDesc];
}

-(void)getFunctionDesc:(id)dict{
    NSLog(@"%@",dict);
    mTitle = [[dict valueForKey:@"datas"] valueForKey:@"title"];
    mContent = [[dict valueForKey:@"datas"] valueForKey:@"content"];
    [self initView];
}

-(void)initView{
    
    //标题
    UILabel *title_lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 20, SCREEN_WIDTH - 20, 50)];
    title_lbl.textAlignment = NSTextAlignmentCenter;
    title_lbl.font = [UIFont systemFontOfSize:24];
    title_lbl.text = mTitle;
    [self.view addSubview:title_lbl];
    
    //内容
    UITextView *content_tv = [[UITextView alloc] initWithFrame:CGRectMake(10, title_lbl.frame.origin.y + 50 + 20, SCREEN_WIDTH - 20, SCREEN_HEIGHT - title_lbl.frame.origin.y + 50 + 20)];
    content_tv.editable = NO;
    content_tv.font = [UIFont systemFontOfSize:17];
    NSData *data = [GTMBase64 decodeString:mContent];
    [content_tv setText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    [self.view addSubview:content_tv];
}

@end
