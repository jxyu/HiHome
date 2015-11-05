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


-(id)init
{
    self = [super init];
    if (self) {
        _btnWidthScale = 10;
        
        _titleWidthScale = 8;
        _titleXScale =0;
        _imgWidthScale = 1;
        _imgXScale =7;
    }
    
    return  self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _btnWidthScale = 10;
        
        _titleWidthScale = 8;
        _titleXScale =0;
        _imgWidthScale = 1;
        _imgXScale =7;
    }
    
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.frame.size.width/_btnWidthScale * _titleXScale, 0, self.frame.size.width/_btnWidthScale*_titleWidthScale, self.frame.size.height);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.frame.size.width/_btnWidthScale*_imgXScale, 0, self.frame.size.width/_btnWidthScale*_imgWidthScale, self.frame.size.height);
}

@end
