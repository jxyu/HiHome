//
//  TaskPath.m
//  HiHome
//
//  Created by 王建成 on 15/9/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "TaskPath.h"

@implementation TaskPath

-(id)init
{
    self = [super init];
    if (self) {
        
        if (_imgSrc ==nil) {
            _imgSrc = [NSMutableArray array];
        }
        else
        {
            [_imgSrc removeAllObjects];
        }
        if (_taskPerformerDetails ==nil) {
            _taskPerformerDetails = [NSMutableArray array];
        }
        else
        {
            [_taskPerformerDetails removeAllObjects];
        }
        
    }
    return self;
}


-(void)resetDatas
{
    if (_imgSrc ==nil) {
        _imgSrc = [NSMutableArray array];
    }
    else
    {
        [_imgSrc removeAllObjects];
    }
    if (_taskPerformerDetails ==nil) {
        _taskPerformerDetails = [NSMutableArray array];
    }
    else
    {
        [_taskPerformerDetails removeAllObjects];
    }

}

@end


@implementation anniversaryPath


-(id)init
{
    self = [super init];
    if (self) {
        
        _imgSrc = [NSMutableArray array];
    }
    return self;
}

@end
