//
//  TempCustomButton.m
//  HiHome
//
//  Created by 王建成 on 15/10/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TempCustomButton.h"

@implementation TempCustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, self.frame.size.width/10*8, self.frame.size.height);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.frame.size.width/10*7, 0, self.frame.size.width/10*1, self.frame.size.height);
}

@end
