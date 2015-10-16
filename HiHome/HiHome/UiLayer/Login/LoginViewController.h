//
//  LoginViewController.h
//  HiHome
//
//  Created by 王建成 on 15/9/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDefine.h"
#import "UIDefine.h"

#pragma mark - define frame

#define     ZY_UIPART_SCREEN_WIDTH      (self.view.frame.size.width/100)
#define     ZY_UIPART_SCREEN_HEIGHT      (self.view.frame.size.height/100)
#define     ZY_UISTART_X                ((self.view.frame.size.height/100)*5)


#pragma  mark - define tags

#define USER_TEXT_TAG       (TEXT_TAG_BASE + 1)
#define PASSWORD_TEXT_TAG   (TEXT_TAG_BASE + 2)

typedef struct _zyColor
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
}zyColor;


@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    @private
    DataDefine *_userData;
    UIAlertView *myAlert;
}

@end
