//
//  MYCollectionHeadView.m
//  HiHome
//
//  Created by 王建成 on 15/10/30.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MYCollectionHeadView.h"

@implementation MYCollectionHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _titleLab.textAlignment = NSTextAlignmentCenter;
  //      _titleLab.backgroundColor = [UIColor redColor];
        [self addSubview:_titleLab];
        
    }
    return self;
}

@end
