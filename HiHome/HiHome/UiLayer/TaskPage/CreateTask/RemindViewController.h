//
//  RepeatViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/14.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"


@interface  remindLineInfo: NSObject
{
    @public
    BOOL existState;
    NSString *title;
    NSString *remindTime;
}
@end

@interface RemindViewController : BackPageViewController
{
@private
    CGFloat _btnWidth;

}
@property(nonatomic)NSMutableArray *dateArr;
@end
