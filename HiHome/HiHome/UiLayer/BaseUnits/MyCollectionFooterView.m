//
//  MyFooterCollectionReusableView.m
//  HiHome
//
//  Created by 王建成 on 15/10/30.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MyCollectionFooterView.h"

@implementation MyCollectionFooterView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _titleLab = [[UILabel alloc]init];
        _titleLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    //    _titleLab.backgroundColor = [UIColor yellowColor];
        [self addSubview:_titleLab];
        
    }
    return self;
}
@end
