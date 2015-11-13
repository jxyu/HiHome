//
//  MySearchDisplayController.m
//  HiHome
//
//  Created by 王建成 on 15/11/11.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "MySearchDisplayController.h"

@implementation MySearchDisplayController
-(void)setActive:(BOOL)visible animated:(BOOL)animated
{
    [super setActive: visible animated: animated];
    
    [self.searchContentsController.navigationController setNavigationBarHidden: NO animated: NO];
}
@end
