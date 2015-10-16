//
//  RepeatViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"

@interface RepeatViewController : BackPageViewController
{
@private
    CGFloat _btnWidth;
    
//    NSString *_remindStr;
    UILabel *_textLab;
    UILabel *_repeatTimeLab;
}
@property(nonatomic)NSMutableArray *dateArr;
@end
