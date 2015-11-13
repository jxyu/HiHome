//
//  CoupleViewController.h
//  HiHome
//
//  Created by 王建成 on 15/10/9.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "BackPageViewController.h"

@interface CoupleViewController : BackPageViewController<UIAlertViewDelegate>
{
    @private
    UIButton *_okBtn;
    UITextField *_phoneNumField;
    UILabel *_tapLabel;
    
}
@end
