//
//  SegmentedButton.m
//  HiHome
//
//  Created by 王建成 on 15/9/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SegmentedButton.h"
#import "UIDefine.h"
@implementation SegmentedButton

-(id)init
{
    self = [super init];
    
    _selectLayer = [CALayer layer];
    _selectLayer.backgroundColor = [ZY_UIBASECOLOR CGColor];
    [self.layer addSublayer:_selectLayer];
    
    self.selectLayerEnable = NO;
    
    return  self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _selectLayer = [CALayer layer];
    _selectLayer.backgroundColor = [[UIColor redColor] CGColor];
    _selectLayer.frame = CGRectMake(0, (frame.size.height/16)*15, frame.size.width, (frame.size.height/16));
    [self.layer addSublayer:_selectLayer];
    
     self.selectLayerEnable = NO;
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    super.frame = frame;
    _selectLayer.frame = CGRectMake(0, (frame.size.height/16)*15, frame.size.width, (frame.size.height/16));
}

-(void)setSelectLayerEnable:(BOOL)selectLayerEnable
{
    if(selectLayerEnable == YES)
        _selectLayer.hidden =NO;
    else
        _selectLayer.hidden =YES;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.frame.size.height/3*2, self.frame.size.width, self.frame.size.height/3);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/3*2);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
