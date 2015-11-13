//
//  AnniversaryTaskDetailView.m
//  HiHome
//
//  Created by Rain on 15/10/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AnniversaryTaskDetailView.h"
#import "AnniversaryTaskCell.h"
#import "TaskPath.h"
#import "UIImageView+WebCache.h"


@interface AnniversaryTaskDetailView (){
    NSString *anniversaryTitle;
    NSString *dateStr;
    NSString *contentTxt;
    AnniversaryTaskCell * anniversaryTask;
    
    //Views
    UIImageView *mImageView;
    
    NSMutableArray *imgSrc;
    NSString *headImgSrc;
    NSInteger imgCount;
    
    NSInteger rowHeight;
    
    UIScrollView *mainScrolView;
}

@end

@implementation AnniversaryTaskDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initData];
    [self initView];
}

- (void)initData{
   // contentTxt = @"元旦，即世界多数国家通称的“新年”，是公历新一年的第一天。元，谓“首”；旦，谓“日”；“元旦”意即“首日”。“元旦”一词最早出现于《晋书》，但其含义已经沿用4000多年。[1]  中国古代曾以腊月、十月等的月首为元旦，汉武帝起为农历1月1日";
    
    rowHeight = (SCREEN_HEIGHT -ZY_HEADVIEW_HEIGHT)/11;
}


-(void) setDatas:(anniversaryPath *)annPath
{

    if(annPath == nil)
        return;
    
    contentTxt = annPath.content;
    dateStr = [annPath.date substringToIndex:10];
    anniversaryTitle = annPath.title;
    
    headImgSrc = annPath.headImgSrc;
    
    if(imgSrc ==nil)
        imgSrc = [NSMutableArray array];
    else
    {
        if(imgSrc.count!=0)
            [imgSrc removeAllObjects];
    }
    for (int i = 0; i < annPath.imgSrc.count; i++) {
        
        NSLog(@"i = %d [%@]",i,[annPath.imgSrc objectAtIndex:i]);
        
        [imgSrc addObject:[annPath.imgSrc objectAtIndex:i]];
    }
    
    imgCount = imgSrc.count;
    
}


- (void)initView{
    
    mainScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ZY_HEADVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-ZY_HEADVIEW_HEIGHT)];
    mainScrolView.contentSize = CGSizeMake(0, rowHeight*15);
    mainScrolView.scrollEnabled = YES;
    [self.view addSubview:mainScrolView];
    
    //UIImageView
    mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, rowHeight*2 -20, rowHeight*2-20)];
    NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,headImgSrc];
    [mImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xueren.png"]];
    
    mImageView.layer.masksToBounds=YES;
    mImageView.layer.cornerRadius=(rowHeight*2 -20)/2;
    mImageView.layer.borderWidth=0.5;
    mImageView.layer.borderColor=ZY_UIBASECOLOR.CGColor;
    
    
  //  mImageView.contentMode =UIViewContentModeScaleAspectFit;
    
//    mImageView.image = [UIImage imageNamed:@"xueren.png"];
//    mImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mainScrolView addSubview:mImageView];
    
    //UILabel
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(mImageView.frame.size.width + 20, 15, 200, (mImageView.frame.size.height)/3)];
    name.text =anniversaryTitle;
    [mainScrolView addSubview:name];
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(mImageView.frame.size.width + 20, name.frame.origin.y+name.frame.size.height, 200, (mImageView.frame.size.height)/3)];
    date.font = [UIFont systemFontOfSize:15];
    date.text = dateStr;
    [mainScrolView addSubview:date];
    
    //横线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,rowHeight*2, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.95 green:0.52 blue:0.09 alpha:1];
    [mainScrolView addSubview:line];
    
    //UITextView
   // CGSize mSize = [contentTxt sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH, 2500) lineBreakMode:UILineBreakModeWordWrap];
    
    //NSLog(@"高度%f",mSize.height);
   // UITextView *mTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, mImageView.frame.size.height + 91, SCREEN_WIDTH - 20, mSize.height + 10)];
    UITextView *mTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, line.frame.origin.y+1, SCREEN_WIDTH, rowHeight*3)];
    mTextView.font = [UIFont systemFontOfSize:15];
    mTextView.editable = NO;
    mTextView.text = contentTxt;
    [mainScrolView addSubview:mTextView];
    
    //UIImageView
    if(imgSrc.count == 0)
    {
        NSLog(@"%f",mTextView.frame.size.height);
        UIImageView *mShowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, mTextView.frame.size.height +mTextView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - ( mTextView.frame.size.height +mTextView.frame.origin.y))];
        mShowImageView.image = [UIImage imageNamed:@"jinianri_img.png"];
        
        mShowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [mainScrolView addSubview:mShowImageView];
    }
    else
    {
        for (int i=0; i<imgCount; i++)
        {
            UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, mTextView.frame.size.height +mTextView.frame.origin.y+(rowHeight *3)*i + i*10, SCREEN_WIDTH-20, rowHeight* 3)];
            
            NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[imgSrc objectAtIndex:i]];
            NSLog(@"img url = [%@]",url);
            UIImageView * img_avatar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, rowHeight* 3)];
            [img_avatar sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"jinianri_img.png"]];
            img_avatar.contentMode = UIViewContentModeScaleAspectFit;
            //            img_avatar.layer.masksToBounds=YES;
            //            img_avatar.layer.cornerRadius=_cellHeight - 3/2;
            //            img_avatar.layer.borderWidth=0.5;
            //            img_avatar.layer.borderColor=ZY_UIBASECOLOR.CGColor;
            //            [btn_selectImg addSubview:img_avatar];
            
            imgBtn.tag = ZY_UIBUTTON_TAG_BASE + i;
            [imgBtn addTarget:self action:@selector(clickImgBtns:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addSubview:img_avatar];
            
            [mainScrolView addSubview:imgBtn];
            
        }
    }
   
}

-(void)clickImgBtns:(UIButton *)sender
{
    PictureShowView *picShowViewCtl = [[PictureShowView alloc] initWithTitle:nil message:nil];
    
    NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[imgSrc objectAtIndex:(sender.tag - ZY_UIBUTTON_TAG_BASE)]];
    
    picShowViewCtl.ImgUrl = url;
    [picShowViewCtl show];
    
   // [self presentViewController:picShowViewCtl animated:YES completion:^{}];
    
}

-(void)quitView{
    if(self.pageChangeMode == Mode_nav)
    {
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
        {
            [self popoverPresentationController];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setleftbtn" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbar" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"hide"]];
}

@end
