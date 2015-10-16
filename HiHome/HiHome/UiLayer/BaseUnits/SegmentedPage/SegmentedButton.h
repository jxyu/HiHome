//
//  SegmentedButton.h
//  HiHome
//
//  Created by 王建成 on 15/9/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentedButton : UIButton
{
    @private
    CALayer *_selectLayer;
}
@property(nonatomic)BOOL selectLayerEnable;
@end
