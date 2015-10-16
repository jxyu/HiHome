//
//  SegmentedPageView.h
//  HiHome
//
//  Created by 王建成 on 15/9/24.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  ZY_SEGMENTEDPAGEVIEW_BUTTON_HEIGHT (slef.frame.size.height)


typedef enum _segType
{
    SegTypeDefault = 0,//图片加文字
    SegTypeTitleOnly,//只有文字
    SegTypeReserve  = 0xFFFF
    
}SegType;


@protocol SegmentedPageViewDelegate <NSObject>

-(void) setPageIndex:(NSInteger)page;

@end

@interface SegmentedPageView : UIView
{
    @private
    NSMutableArray *_arrayBtn;
//    NSMutableArray *_arrayViews;
    CGFloat _heightButton;
}
@property(strong,nonatomic) UIFont *titleFont;
@property(nonatomic) SegType segType;
@property(strong,nonatomic) NSArray *itemTitle;
@property(strong,nonatomic) NSArray *imgTitle;
@property(strong,nonatomic) NSArray *imgSelectTitle;
//@property(strong,nonatomic) NSArray *contentViews;

@property(strong,nonatomic) id<SegmentedPageViewDelegate> delegate;

@property(nonatomic) NSInteger numOfPages;
@property(nonatomic) NSInteger currentPage;

- (id)initWithFrame:(CGRect)frame;

@end
