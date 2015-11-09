//
//  NoticePageView.h
//  HiHome
//
//  Created by 王建成 on 15/11/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

#define AlertPadding 10

#define AlertPaddingHeight 30

#define MenuHeight 44

typedef enum _ButtonType
{
    NoticeButton_OK,
    NoticeButton_CANCEL,
    NoticeButton_OTHER
    
}NoticeButtonType;

@protocol NoticePageViewDelegate <NSObject>

-(void)clickTaskDetailBtnAction;

@end

@class NoticePageItem;
typedef void(^NoticePageHandler)(NoticePageItem *item);

@interface NoticePageView : UIView
{
    NSMutableArray *_items;
    
    
    UIScrollView *_buttonScrollView;
    UIScrollView *_contentScrollView;
    UIScrollView *_messageScrollView;
    UILabel *_labelTitle;
    UILabel *_labelmessage;
    UIButton *checkTaskBtn;

}
@property(assign,nonatomic)NSString *HeadImgUrl;
//按钮宽度,如果赋值,菜单按钮宽之和,超过alert宽,菜单会滚动
@property(assign,nonatomic)CGFloat buttonHeight;
@property(assign,nonatomic)CGFloat buttonPaddingH;
@property(assign,nonatomic)CGFloat buttonWidth;
//将要显示在alert上的自定义view
@property(strong,nonatomic)UIView *contentView;
@property(nonatomic )id<NoticePageViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
- (NSInteger)addButtonWithTitle:(NSString *)title;
- (void)addButton:(NoticeButtonType)type withTitle:(NSString *)title handler:(NoticePageHandler)handler;
- (void)show;
- (void)dismiss;
@end



@interface NoticePageItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NoticeButtonType type;
@property (nonatomic) NSUInteger tag;
@property (nonatomic, copy) NoticePageHandler action;
@end