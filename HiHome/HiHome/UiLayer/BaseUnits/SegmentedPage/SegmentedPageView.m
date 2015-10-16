//
//  SegmentedPageView.m
//  HiHome
//
//  Created by 王建成 on 15/9/24.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SegmentedPageView.h"
#import <QuartzCore/QuartzCore.h>
#import "SegmentedButton.h"
#import "UIDefine.h"

@implementation SegmentedPageView

- (id)initWithFrame:(CGRect)frame
{
    _heightButton = frame.size.height;

    self = [super initWithFrame:frame];

    _arrayBtn = [NSMutableArray array];
    self.currentPage = 0;
    _segType = SegTypeDefault;
    
  //  _titleFont = [[UIFont alloc] init];
    
    return self;
}

-(void)setItemTitle:(NSArray *)itemTitle
{
    for(int i=0 ;i < itemTitle.count;i++)
    {
        if(i>=_numOfPages)
            break;
        UIButton *tempBtn = [_arrayBtn objectAtIndex:i];
        
        NSLog(@"%@",[itemTitle objectAtIndex:i]);
        [tempBtn setTitle:[itemTitle objectAtIndex:i] forState:UIControlStateNormal];
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempBtn setTitleColor:ZY_UIBASECOLOR forState:UIControlStateSelected];
        if(_titleFont!=nil)
            tempBtn.titleLabel.font = _titleFont;
    }
    
}
-(void)setNumOfPages:(NSInteger)numOfPages
{
    
    if(numOfPages > 0)
        _numOfPages = numOfPages;
    else
        _numOfPages = 1;
    
//    for(int i = 0;i<_arrayBtn.count ;i++)
//    {
//        if(i>=_numOfPages)
//            break;
//        SegmentedButton *internalBtn = (SegmentedButton *)[_arrayBtn objectAtIndex:i];
//        [internalBtn removeFromSuperview];
//    }
//
    //只支持设置一次page
    if(_arrayBtn.count > 0)
        return;
    for(int i = 0;i<_numOfPages ;i++)
    {
        UIButton *internalBtn;
        
        if(_segType == SegTypeTitleOnly)
        {
             internalBtn = [[UIButton alloc] init];
        }
        else
        {
            internalBtn = [[SegmentedButton alloc] init];
        }
        
        internalBtn.frame = CGRectMake(0+(self.frame.size.width/_numOfPages)*i, 0, self.frame.size.width/_numOfPages, _heightButton);
        internalBtn.tag = i;
        internalBtn.adjustsImageWhenHighlighted = NO;
        [internalBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [internalBtn.layer setBorderWidth:1];
        internalBtn.layer.borderColor = [[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:235/255.0] CGColor];
        [_arrayBtn addObject:internalBtn];
        [self addSubview:internalBtn];
        
        internalBtn.imageView.contentMode = UIViewContentModeCenter;
        internalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        internalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    
}

//
//
//-(void)setContentViews:(NSArray *)contentViews
//{
//    
////    NSLog(@"contentViews.count= %ld",contentViews.count);
////    UIView *tempView = [_arrayViews objectAtIndex:2];
////    [tempView addSubview:(UIView *)[contentViews objectAtIndex:0]];
//    
//    for(int i=0 ;i < contentViews.count;i++)
//    {
//        if(i>=_numOfPages)
//            break;
//        
//        UIView *tempView = [_arrayViews objectAtIndex:i];
//        [tempView addSubview:(UIView *)[contentViews objectAtIndex:i]];
//        //[tempBtn]
//    }
//}

-(void)setImgTitle:(NSArray *)imgTitle
{
    printf("in fun :%s",__FUNCTION__);
    for(int i=0 ;i < imgTitle.count;i++)
    {
        if(i>=_numOfPages)
            break;
        
        UIButton *tempBtn = [_arrayBtn objectAtIndex:i];
        [tempBtn setImage:[UIImage imageNamed:(NSString *)([imgTitle objectAtIndex:i])] forState:UIControlStateNormal];
     //[tempBtn]
    }
}


-(void)setImgSelectTitle:(NSArray *)imgSelectTitle
{
    printf("in fun :%s",__FUNCTION__);
    for(int i=0 ;i < imgSelectTitle.count;i++)
    {
        if(i>=_numOfPages)
            break;
        
        UIButton *tempBtn = [_arrayBtn objectAtIndex:i];
        [tempBtn setImage:[UIImage imageNamed:(NSString *)([imgSelectTitle objectAtIndex:i])] forState:UIControlStateSelected];
    }
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    SegmentedButton *btnForArray;
    if(currentPage >= _numOfPages)
        return;
    for (int i = 0; i<_arrayBtn.count; i++) {
        btnForArray = [_arrayBtn objectAtIndex:i];
        if(i == currentPage)
        {
            btnForArray.selected = YES;
            if (_segType != SegTypeTitleOnly)
            {
                 btnForArray.selectLayerEnable = YES;
            }
        }
        else
        {
            btnForArray.selected = NO;
            if (_segType != SegTypeTitleOnly)
            {
                btnForArray.selectLayerEnable=NO;
            }
        }
    }
    _currentPage = currentPage;
    
    if ([self.delegate respondsToSelector:@selector(setPageIndex:)]) {
        [self.delegate setPageIndex:_currentPage];
    }
}

-(void) btnClick:(id)sender
{
    SegmentedButton *tempBtn = (SegmentedButton *)sender;
    SegmentedButton *btnForArray;
    _currentPage = tempBtn.tag;
    for (int i = 0; i<_arrayBtn.count; i++) {
        
        if(i>=_numOfPages)
            break;
        
        btnForArray = [_arrayBtn objectAtIndex:i];
        if(i == tempBtn.tag)
        {
            btnForArray.selected = YES;
            if (_segType != SegTypeTitleOnly)
                btnForArray.selectLayerEnable = YES;
        }
        else
        {
            btnForArray.selected = NO;
            if (_segType != SegTypeTitleOnly)
                btnForArray.selectLayerEnable=NO;
        }
    }
    
//    [self bringSubviewToFront:[_arrayViews objectAtIndex:_currentPage]];
    
    if ([self.delegate respondsToSelector:@selector(setPageIndex:)]) {
        [self.delegate setPageIndex:_currentPage];
    }

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
