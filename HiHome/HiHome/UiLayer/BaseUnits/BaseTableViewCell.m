//
//  BaseTableViewCell.m
//  HiHome
//
//  Created by 王建成 on 15/10/6.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)init
{
    if(self == nil)
        self = [super init];
    return self;
}


-(void)setContentBtns:(NSMutableArray *)contentBtns
{
    if(_contentBtns == nil)
    {

        _contentBtns = [[NSMutableArray alloc]initWithArray:contentBtns];
    }
    NSMutableArray *tempArray = _contentBtns;
    
    //移除之前的控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [(UIButton *)[tempArray objectAtIndex:i] removeFromSuperview];
    }
    //清空数组
    [tempArray removeAllObjects];
    //重新赋值
    for (int i = 0;i<contentBtns.count ; i++) {
        [tempArray addObject:[contentBtns objectAtIndex:i]];
    }
    //添加控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [self addSubview:[tempArray objectAtIndex:i]];
    }
        
}

-(void)setContentImgs:(NSMutableArray *)contentImgs
{
    if(_contentImgs == nil)
    {
        _contentImgs = [[NSMutableArray alloc]initWithArray:contentImgs];
    }
    NSMutableArray *tempArray = _contentImgs;

    //移除之前的控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [(UIButton *)[tempArray objectAtIndex:i] removeFromSuperview];
    }
    //清空数组
    
    [tempArray removeAllObjects];
    //重新赋值
    for (int i = 0;i<contentImgs.count ; i++) {
        [tempArray addObject:[contentImgs objectAtIndex:i]];
    }
    //添加控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [self addSubview:[tempArray objectAtIndex:i]];
    }

    
}
-(void)setContentLabels:(NSMutableArray *)contentLabels
{
    if(_contentLabels == nil)
    {
        _contentLabels = [[NSMutableArray alloc]initWithArray:contentLabels];
    }
    NSMutableArray *tempArray = _contentLabels;
    
    //移除之前的控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [(UIButton *)[tempArray objectAtIndex:i] removeFromSuperview];
    }
    //清空数组
    [tempArray removeAllObjects];
    //重新赋值
    for (int i = 0;i<contentLabels.count ; i++) {
        [tempArray addObject:[contentLabels objectAtIndex:i]];
    }
    //添加控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [self addSubview:[tempArray objectAtIndex:i]];
    }
    
}

-(void)setContentOtherViews:(NSMutableArray *)contentOtherViews
{
    if(_contentOtherViews == nil)
    {
        _contentOtherViews = [[NSMutableArray alloc]initWithArray:contentOtherViews];
    }
    NSMutableArray *tempArray = _contentOtherViews;
    
    //移除之前的控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [(UIButton *)[tempArray objectAtIndex:i] removeFromSuperview];
    }
    //清空数组
    [tempArray removeAllObjects];
    //重新赋值
    for (int i = 0;i<contentOtherViews.count ; i++) {
        [tempArray addObject:[contentOtherViews objectAtIndex:i]];
    }
    //添加控件
    for(int i = 0;i<tempArray.count;i++)
    {
        [self addSubview:[tempArray objectAtIndex:i]];
    }
    
}



@end
