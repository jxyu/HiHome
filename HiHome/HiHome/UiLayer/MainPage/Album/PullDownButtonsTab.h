//
//  PullDownButtons.h
//  HiHome
//
//  Created by 王建成 on 15/10/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullDownButtonsTabDelegate <NSObject>

-(void) respondBtns:(NSInteger)btnIndex;

@end
@interface PullDownButtonsTab : UIView
{
    UIView *_coverView;
    UIView *_pullBtnsTab;
    
    NSInteger _btnNum;
}
@property(strong,nonatomic) id<PullDownButtonsTabDelegate> delegate;
//将要显示在alert上的自定义view
@property(strong,nonatomic)UIView *contentView;

- (void)show;
- (void)dismiss;
@end
