//
//  RepeatViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"
#import "TaskPath.h"
@interface RepeatViewController : BackPageViewController
{
@private
    CGFloat _btnWidth;
    
//    NSString *_remindStr;
    UILabel *_textLab;
    UILabel *_repeatTimeLab;
    id CallBackObject;
    NSString * callBackFunctionName;
}
@property(nonatomic)NSMutableArray *dateArr;

/**
 *  设置回调函数
 *
 *  @param cbobject     回调对象
 *  @param selectorName 回调函数
 */
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

@end
